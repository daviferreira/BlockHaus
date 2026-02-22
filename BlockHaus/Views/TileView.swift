import SwiftUI

struct TileView: View {
    let tile: TileModel
    var selectionNumber: Int?
    var onTap: () -> Void

    var body: some View {
        Canvas { context, size in
            let rect = CGRect(origin: .zero, size: size)
            TilePatternRenderer.draw(
                tile.pattern,
                in: rect,
                context: context,
                foreground: tile.foreground,
                background: tile.background
            )
        }
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(BauhausColors.red, lineWidth: selectionNumber != nil ? 3 : 0)
        )
        .overlay(alignment: .topTrailing) {
            if let number = selectionNumber {
                Text("\(number)")
                    .font(.caption2.bold())
                    .foregroundStyle(.white)
                    .frame(width: 18, height: 18)
                    .background(BauhausColors.red, in: Circle())
                    .padding(2)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .onTapGesture {
            withAnimation(.spring(duration: 0.2)) {
                onTap()
            }
        }
    }
}
