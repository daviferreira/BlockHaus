import SwiftUI

struct PatternCanvasView: View {
    let selectedTiles: [TileModel]
    let gridSize: Int
    var onTap: () -> Void

    var body: some View {
        if selectedTiles.isEmpty {
            ContentUnavailableView(
                "No Tiles Selected",
                systemImage: "square.grid.3x3",
                description: Text("Select up to \(gridSize * gridSize) tiles to create a pattern")
            )
        } else {
            GeometryReader { geometry in
                let side = min(geometry.size.width, geometry.size.height) * 0.65
                let cellSize = side / CGFloat(gridSize)

                Canvas { context, size in
                    for row in 0..<gridSize {
                        for col in 0..<gridSize {
                            let index = (row * gridSize + col) % selectedTiles.count
                            let tile = selectedTiles[index]
                            let rect = CGRect(
                                x: CGFloat(col) * cellSize,
                                y: CGFloat(row) * cellSize,
                                width: cellSize,
                                height: cellSize
                            )
                            TilePatternRenderer.draw(
                                tile.pattern,
                                in: rect,
                                context: context,
                                foreground: tile.foreground,
                                background: tile.background
                            )
                        }
                    }
                }
                .frame(width: side, height: side)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture {
                    onTap()
                }
            }
        }
    }
}
