import SwiftUI

struct TileView: View {
    let tile: TileModel
    var onTap: () -> Void
    var onLongPress: () -> Void

    @State private var flipDegrees: Double = 0

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
        .overlay(alignment: .topTrailing) {
            if tile.isLocked {
                Image(systemName: "lock.fill")
                    .font(.caption2)
                    .foregroundStyle(.white)
                    .padding(4)
                    .background(.black.opacity(0.5), in: Circle())
                    .padding(4)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .rotation3DEffect(.degrees(flipDegrees), axis: (x: 1, y: 0, z: 0))
        .onTapGesture {
            onTap()
        }
        .onLongPressGesture {
            withAnimation(.spring(duration: 0.3)) {
                onLongPress()
            }
        }
    }

    func animateFlip(delay: Double) {
        withAnimation(.spring(duration: 0.4, bounce: 0.3).delay(delay)) {
            flipDegrees = 360
        }
        // Reset after animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + delay + 0.5) {
            flipDegrees = 0
        }
    }
}
