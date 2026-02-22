import SwiftUI

struct TileStripView: View {
    @Bindable var model: GridModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(model.tiles) { tile in
                    TileView(
                        tile: tile,
                        selectionNumber: model.selectionIndex(for: tile.id).map { $0 + 1 },
                        onTap: { model.toggleSelection(id: tile.id) }
                    )
                    .frame(width: 60, height: 60)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .background(.ultraThinMaterial)
    }
}
