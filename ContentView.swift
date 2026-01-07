import SwiftUI
import SwiftData

struct ContentView: View {
    @Binding var isDarkMode: Bool
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Notebook.creationDate, order: .reverse) private var notebooks: [Notebook]
    @State private var navPath = NavigationPath()
    let columns = [GridItem(.adaptive(minimum: 150), spacing: 25)]
    let colors = ["264653", "2A9D8F", "E9C46A", "F4A261", "E76F51", "457B9D", "D4A373", "EF476F"]
    
    @State private var showRenameAlert = false
    @State private var notebookToRename: Notebook?
    @State private var newName = ""
    @State private var showDeleteNotebookAlert = false
    @State private var notebookToDelete: Notebook?
    
    var body: some View {
        NavigationStack(path: $navPath) {
            ScrollView {
                if notebooks.isEmpty {
                    ContentUnavailableView("Kütüphane Boş", systemImage: "books.vertical", description: Text("+ ile başla."))
                        .padding(.top, 50)
                } else {
                    LazyVGrid(columns: columns, spacing: 30) {
                        ForEach(notebooks) { notebook in
                            NavigationLink(value: notebook) {
                                VStack {
                                    ZStack(alignment: .bottomLeading) {
                                        RoundedRectangle(cornerRadius: 12).fill(Color(hex: notebook.colorHex))
                                            .shadow(radius: 4, y: 2)
                                            .frame(height: 170)
                                        Rectangle().fill(.black.opacity(0.15)).frame(width: 24).padding(.leading, 12)
                                        Image(systemName: "book.closed.fill")
                                            .resizable().scaledToFit().frame(width: 40)
                                            .foregroundColor(.white.opacity(0.5))
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    }
                                    Text(notebook.title).font(.headline).lineLimit(1).foregroundColor(.primary)
                                }
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button("İsim Değiştir") {
                                    notebookToRename = notebook
                                    newName = notebook.title
                                    showRenameAlert = true
                                }
                                Button("Sil", role: .destructive) {
                                    notebookToDelete = notebook
                                    showDeleteNotebookAlert = true
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Kütüphanem")
            .background(Color(uiColor: .systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { withAnimation { isDarkMode.toggle() } }) {
                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                            .font(.title3).foregroundColor(isDarkMode ? .yellow : .purple)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: addNotebook) { Image(systemName: "plus.circle.fill").font(.system(size: 34)) }
                }
            }
            .navigationDestination(for: Notebook.self) { notebook in
                NotebookDetailView(notebook: notebook, navPath: $navPath)
            }
            .alert("Defter İsmini Değiştir", isPresented: $showRenameAlert) {
                TextField("Yeni İsim", text: $newName)
                Button("Kaydet") {
                    if let nb = notebookToRename { nb.title = newName }
                }
                Button("İptal", role: .cancel) { }
            }
            .alert("Defteri Sil", isPresented: $showDeleteNotebookAlert) {
                Button("İptal", role: .cancel) { }
                Button("Sil", role: .destructive) {
                    if let notebook = notebookToDelete {
                        modelContext.delete(notebook)
                        notebookToDelete = nil
                    }
                }
            } message: {
                Text("Bu defteri ve içindeki tüm sayfaları silmek istediğinizden emin misiniz?")
            }
        }
    }
    
    func addNotebook() {
        let nb = Notebook(title: "Defter \(notebooks.count + 1)", colorHex: colors.randomElement() ?? "4A90E2")
        modelContext.insert(nb)
        let page = Page(title: "Giriş", notebook: nb)
        modelContext.insert(page); nb.pages.append(page)
    }
}