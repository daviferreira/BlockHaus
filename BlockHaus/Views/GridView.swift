import SwiftUI

struct GridView: View {
    @Bindable var model: GridModel

    private let columns = [GridItem(.adaptive(minimum: 80), spacing: 6)]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(Array(model.tiles.enumerated()), id: \.element.id) { index, tile in
                    TileView(
                        tile: tile,
                        onTap: { model.cycleTile(id: tile.id) },
                        onLongPress: { model.toggleLock(id: tile.id) }
                    )
                    .id("\(tile.id)-\(model.rollTrigger)")
                    .transition(.scale.combined(with: .opacity))
                    .animation(
                        .spring(duration: 0.4, bounce: 0.3).delay(Double(index) * 0.03),
                        value: model.rollTrigger
                    )
                }
            }
            .padding(10)
        }
    }
}
