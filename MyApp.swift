import SwiftUI
import SwiftData

@main
struct NoteApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some Scene {
        WindowGroup {
            ContentView(isDarkMode: $isDarkMode)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
        .modelContainer(for: [Notebook.self, Page.self])
    }
}