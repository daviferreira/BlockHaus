import SwiftUI

struct PatternCanvasView: View {
    let selectedTiles: [TileModel]
    private let tileSize: CGFloat = 80
    private let spacing: CGFloat = 0

    var body: some View {
        if selectedTiles.isEmpty {
            ContentUnavailableView(
                "No Tiles Selected",
                systemImage: "square.grid.3x3",
                description: Text("Select up to 4 tiles to create a pattern")
            )
        } else {
            GeometryReader { geometry in
                let columns = max(1, Int(geometry.size.width / tileSize))
                let rows = max(1, Int(geometry.size.height / tileSize))
                let cellWidth = geometry.size.width / CGFloat(columns)
                let cellHeight = cellWidth

                Canvas { context, size in
                    var rng = SeededRandomNumberGenerator(seed: 42)
                    for row in 0..<rows {
                        for col in 0..<columns {
                            let index = Int.random(in: 0..<selectedTiles.count, using: &rng)
                            let tile = selectedTiles[index]
                            let rect = CGRect(
                                x: CGFloat(col) * cellWidth,
                                y: CGFloat(row) * cellHeight,
                                width: cellWidth,
                                height: cellHeight
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
                .frame(width: geometry.size.width, height: CGFloat(rows) * cellHeight)
            }
        }
    }
}

private struct SeededRandomNumberGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        state = seed
    }

    mutating func next() -> UInt64 {
        // xorshift64
        state ^= state << 13
        state ^= state >> 7
        state ^= state << 17
        return state
    }
}
