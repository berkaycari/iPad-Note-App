import SwiftUI

struct PaperView: View {
    let type: Int
    let size: CGSize
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        let w = size.width
        let h = size.height
        let lineColor = colorScheme == .dark ? Color.white.opacity(0.15) : Color.black.opacity(0.1)
        
        ZStack {
            Color.clear
            Path { path in
                if type != 0 {
                    let horizontalCellCount: CGFloat = 28
                    let verticalCellCount: CGFloat = 40
                    
                    let horizontalSpacing = h / verticalCellCount
                    let verticalSpacing = w / horizontalCellCount
                    
                    let startY: CGFloat = (type == 2) ? 0 : 60
                    if type == 2 {
                        for i in 0...Int(verticalCellCount) {
                            let y = CGFloat(i) * horizontalSpacing
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: w, y: y))
                        }
                    } else {
                        var y: CGFloat = startY
                        while y <= h {
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: w, y: y))
                            y += horizontalSpacing
                        }
                    }
                    
                    if type == 2 {
                        for i in 0...Int(horizontalCellCount) {
                            let x = CGFloat(i) * verticalSpacing
                            path.move(to: CGPoint(x: x, y: 0))
                            path.addLine(to: CGPoint(x: x, y: h))
                        }
                    }
                }
            }
            .stroke(lineColor, lineWidth: 1)
        }
        .frame(width: w, height: h)
        .clipShape(Rectangle())
    }
}
