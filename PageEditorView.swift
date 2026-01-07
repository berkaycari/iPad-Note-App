import SwiftUI
import SwiftData
import PencilKit

struct PageEditorView: View {
    @State var page: Page
    var allPages: [Page]
    @State var currentIndex: Int
    
    init(page: Page, allPages: [Page], initialIndex: Int) {
        self._page = State(initialValue: page)
        self.allPages = allPages
        self._currentIndex = State(initialValue: initialIndex)
    }
    
    @State private var backgroundType: Int = 2
    @State private var pencilOnly: Bool = false
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            let screenW = geometry.size.width
            let screenH = geometry.size.height
            
            let paperWidth = screenW * 0.95
            let paperHeight = paperWidth * 1.4142
            
            ZStack {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()
                
                ZoomableScrollView {
                    VStack {
                        Spacer().frame(height: 20)
                        
                        ZStack {
                            (colorScheme == .dark ? Color.black : Color.white)
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                            
                            CanvasView(
                                drawingData: $page.drawingData,
                                pencilOnly: $pencilOnly,
                                backgroundType: backgroundType,
                                size: CGSize(width: paperWidth, height: paperHeight)
                            ) { _ in
                                try? modelContext.save()
                            }
                        }
                        .frame(width: paperWidth, height: paperHeight)
                        
                        Spacer().frame(height: 50)
                    }
                    .frame(maxWidth: .infinity) 
                    .frame(minHeight: screenH)
                }
            }
        }
        .navigationTitle("Sayfa \(currentIndex + 1)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button(action: {
                    if let notebook = page.notebook {
                        let newPage = Page(title: "Sayfa \(notebook.pages.count + 1)", notebook: notebook)
                        modelContext.insert(newPage)
                        
                        if let index = notebook.pages.firstIndex(where: { $0.id == newPage.id }) {
                            currentIndex = index
                            page = newPage
                        }
                    }
                }) {
                    Image(systemName: "doc.badge.plus")
                }
                
                Divider()
                
                HStack(spacing: 20) {
                    Button(action: {
                        if currentIndex > 0 { currentIndex -= 1; page = allPages[currentIndex] }
                    }) { Image(systemName: "chevron.left") }.disabled(currentIndex == 0)
                    
                    Button(action: {
                        if currentIndex < allPages.count - 1 { currentIndex += 1; page = allPages[currentIndex] }
                    }) { Image(systemName: "chevron.right") }.disabled(currentIndex == allPages.count - 1)
                }
                
                Divider()
                
                Button(action: { pencilOnly.toggle() }) {
                    Image(systemName: pencilOnly ? "pencil.circle.fill" : "hand.draw.fill")
                }
                
                Menu {
                    Button("Boş") { backgroundType = 0 }
                    Button("Çizgili") { backgroundType = 1 }
                    Button("Kareli") { backgroundType = 2 }
                } label: { Image(systemName: "grid") }
            }
        }
    }
}
