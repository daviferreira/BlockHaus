import SwiftUI

struct TileModel: Identifiable {
    let id: UUID
    var pattern: TilePattern
    var foreground: Color
    var background: Color
    var isSelected: Bool = false

    static func random(colors: [Color]? = nil, patterns: [TilePattern]? = nil) -> TileModel {
        let pair = BauhausColors.randomPair(from: colors)
        return TileModel(
            id: UUID(),
            pattern: TilePattern.random(from: patterns),
            foreground: pair.foreground,
            background: pair.background
        )
    }
}
