import SwiftUI
import SwiftData
import PencilKit
import PDFKit

struct NotebookDetailView: View {
    @Bindable var notebook: Notebook
    @Binding var navPath: NavigationPath
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    
    @State private var pdfURL: URL?
    @State private var showShareSheet = false
    @State private var isGeneratingPDF = false
    @State private var showDeleteAlert = false
    @State private var pageToDelete: Page?
    let columns = [GridItem(.adaptive(minimum: 120), spacing: 20)]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                let pages = notebook.pages.sorted { $0.creationDate < $1.creationDate }
                ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                    NavigationLink(destination: PageEditorView(page: page, allPages: pages, initialIndex: index)) {
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
                                    .shadow(radius: 2)
                                
                                if let drawing = try? PKDrawing(data: page.drawingData), !drawing.bounds.isEmpty {
                                    Image(uiImage: drawing.image(from: drawing.bounds, scale: 0.5))
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 120, maxHeight: 140)
                                        .opacity(0.8)
                                } else {
                                    Text("\(index + 1)")
                                        .font(.largeTitle)
                                        .foregroundColor(.gray.opacity(0.2))
                                }
                            }
                            .frame(height: 140)
                            Text(page.title).font(.caption).lineLimit(1)
                        }
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button("Sil", role: .destructive) {
                            pageToDelete = page
                            showDeleteAlert = true
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(notebook.title)
        .background(Color(uiColor: .systemGroupedBackground))
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button(action: {
                    let p = Page(title: "Sayfa \(notebook.pages.count + 1)", notebook: notebook)
                    modelContext.insert(p)
                }) { Image(systemName: "doc.badge.plus") }
                
                Button(action: generateAndExportPDF) {
                    if isGeneratingPDF { ProgressView() } else { Image(systemName: "square.and.arrow.up") }
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let url = pdfURL { ShareSheet(activityItems: [url]) }
        }
        .alert("Sayfayı Sil", isPresented: $showDeleteAlert) {
            Button("İptal", role: .cancel) { }
            Button("Sil", role: .destructive) {
                if let page = pageToDelete {
                    modelContext.delete(page)
                    pageToDelete = nil
                }
            }
        } message: {
            Text("Bu sayfayı silmek istediğinizden emin misiniz?")
        }
    }
    
    func generateAndExportPDF() {
        isGeneratingPDF = true
        
        let pages = notebook.pages.sorted { $0.creationDate < $1.creationDate }
        let isDarkModeActive = (colorScheme == .dark)
        let notebookTitle = notebook.title
        
        let screenWidth = UIScreen.main.bounds.width
        
        DispatchQueue.global(qos: .userInitiated).async {
            let pdfWidth: CGFloat = 595.2
            let pdfHeight: CGFloat = 841.8
            let pdfRect = CGRect(x: 0, y: 0, width: pdfWidth, height: pdfHeight)
            
            let renderer = UIGraphicsPDFRenderer(bounds: pdfRect)
            
            let data = renderer.pdfData { context in
                for page in pages {
                    context.beginPage()
                    let cgContext = context.cgContext
                    
                    let bgColor = isDarkModeActive ? UIColor.black : UIColor.white
                    let lineColor = isDarkModeActive ? UIColor.white.withAlphaComponent(0.15) : UIColor.black.withAlphaComponent(0.1)
                    
                    bgColor.setFill(); context.fill(pdfRect)
                    
                    cgContext.setStrokeColor(lineColor.cgColor)
                    cgContext.setLineWidth(1)
                    
                    let horizontalCellCount: CGFloat = 28
                    let verticalCellCount: CGFloat = 40
                    
                    let horizontalSpacing = pdfHeight / verticalCellCount
                    let verticalSpacing = pdfWidth / horizontalCellCount
                    
                    for i in 0...Int(verticalCellCount) {
                        let y = CGFloat(i) * horizontalSpacing
                        cgContext.move(to: CGPoint(x: 0, y: y))
                        cgContext.addLine(to: CGPoint(x: pdfWidth, y: y))
                    }
                    
                    for i in 0...Int(horizontalCellCount) {
                        let x = CGFloat(i) * verticalSpacing
                        cgContext.move(to: CGPoint(x: x, y: 0))
                        cgContext.addLine(to: CGPoint(x: x, y: pdfHeight))
                    }
                    
                    cgContext.strokePath()
                    
                    if let drawing = try? PKDrawing(data: page.drawingData) {
                        let drawingBounds = drawing.bounds
                        
                        if !drawingBounds.isEmpty {
                            let image = drawing.image(from: drawingBounds, scale: 1.0)
                            
                            let scaleFactor = (pdfWidth / screenWidth) * 0.9
                            
                            let targetWidth = drawingBounds.width * scaleFactor
                            let targetHeight = drawingBounds.height * scaleFactor
                            
                            let targetRect = CGRect(
                                x: (pdfWidth - targetWidth) / 2,
                                y: drawingBounds.minY * scaleFactor,
                                width: targetWidth,
                                height: targetHeight
                            )
                            
                            image.draw(in: targetRect)
                        }
                    }
                }
            }
            
            let url = FileManager.default.temporaryDirectory.appendingPathComponent("\(notebookTitle).pdf")
            try? data.write(to: url)
            DispatchQueue.main.async {
                self.pdfURL = url; self.isGeneratingPDF = false; self.showShareSheet = true
            }
        }
    }
}
