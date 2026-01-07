import SwiftUI
import PencilKit

struct CanvasView: UIViewRepresentable {
    @Binding var drawingData: Data
    @Binding var pencilOnly: Bool
    var backgroundType: Int
    let size: CGSize
    var onSaved: (Data) -> Void
    @Environment(\.colorScheme) var colorScheme

    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        canvasView.isScrollEnabled = false 
        
        canvasView.drawingPolicy = pencilOnly ? .pencilOnly : .anyInput
        canvasView.delegate = context.coordinator
        
        let picker = context.coordinator.toolPicker
        picker.addObserver(canvasView)
        picker.setVisible(true, forFirstResponder: canvasView)
        canvasView.becomeFirstResponder()
        
        if let drawing = try? PKDrawing(data: drawingData) {
            canvasView.drawing = drawing
        }
        
        context.coordinator.updateBackground(for: canvasView, type: backgroundType, size: size, scheme: colorScheme)
        
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.drawingPolicy = pencilOnly ? .pencilOnly : .anyInput
        uiView.overrideUserInterfaceStyle = (colorScheme == .dark) ? .dark : .light
        uiView.backgroundColor = .clear
        
        if uiView.frame.size != size {
            context.coordinator.updateBackground(for: uiView, type: backgroundType, size: size, scheme: colorScheme)
        }
        
        context.coordinator.toolPicker.setVisible(true, forFirstResponder: uiView)
        
        if context.coordinator.lastBgType != backgroundType || context.coordinator.lastColorScheme != colorScheme {
            context.coordinator.updateBackground(for: uiView, type: backgroundType, size: size, scheme: colorScheme)
        }
        
        if context.coordinator.lastLoadedData != drawingData {
            if drawingData.isEmpty {
                uiView.drawing = PKDrawing()
            } else if let drawing = try? PKDrawing(data: drawingData) {
                uiView.drawing = drawing
            }
            context.coordinator.lastLoadedData = drawingData
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: CanvasView
        var lastLoadedData: Data = Data()
        var lastBgType: Int = -1
        var lastColorScheme: ColorScheme?
        let toolPicker = PKToolPicker()

        init(_ parent: CanvasView) { self.parent = parent }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            let newData = canvasView.drawing.dataRepresentation()
            if parent.drawingData != newData {
                parent.drawingData = newData
                parent.onSaved(newData)
                lastLoadedData = newData
            }
        }
        
        func updateBackground(for canvasView: PKCanvasView, type: Int, size: CGSize, scheme: ColorScheme) {
            canvasView.subviews.filter { $0.tag == 999 }.forEach { $0.removeFromSuperview() }
            
            let paperController = UIHostingController(rootView: PaperView(type: type, size: size).environment(\.colorScheme, scheme))
            paperController.view.backgroundColor = .clear
            paperController.view.frame = CGRect(origin: .zero, size: size)
            paperController.view.tag = 999
            
            canvasView.insertSubview(paperController.view, at: 0)
            canvasView.sendSubviewToBack(paperController.view)
            
            lastBgType = type
            lastColorScheme = scheme
        }
    }
}
