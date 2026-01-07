import SwiftUI
import SwiftData

@Model
class Notebook {
    var id: UUID
    var title: String
    var colorHex: String
    var creationDate: Date
    @Relationship(deleteRule: .cascade) var pages: [Page] = []
    
    init(title: String, colorHex: String = "4A90E2") {
        self.id = UUID()
        self.title = title
        self.colorHex = colorHex
        self.creationDate = Date()
    }
}

@Model
class Page {
    var id: UUID
    var title: String
    var drawingData: Data
    var creationDate: Date
    var notebook: Notebook?
    
    init(title: String, notebook: Notebook) {
        self.id = UUID()
        self.title = title
        self.drawingData = Data()
        self.creationDate = Date()
        self.notebook = notebook
    }
}
