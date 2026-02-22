import SwiftUI

struct TileModel: Identifiable {
    let id: UUID
    var pattern: TilePattern
    var foreground: Color
    var background: Color
    var isSelected: Bool = false

    static func random() -> TileModel {
        let colors = BauhausColors.randomPair()
        return TileModel(
            id: UUID(),
            pattern: .random(),
            foreground: colors.foreground,
            background: colors.background
        )
    }
}
