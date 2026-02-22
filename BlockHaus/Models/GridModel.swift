import SwiftUI

@Observable
class GridModel {
    var tiles: [TileModel]
    private(set) var rollTrigger: Int = 0
    private var selectionOrder: [UUID] = []

    init(count: Int = 20) {
        tiles = (0..<count).map { _ in TileModel.random() }
    }

    var selectedTiles: [TileModel] {
        selectionOrder.compactMap { id in
            tiles.first(where: { $0.id == id })
        }
    }

    func selectionIndex(for id: UUID) -> Int? {
        selectionOrder.firstIndex(of: id)
    }

    func toggleSelection(id: UUID) {
        if let orderIndex = selectionOrder.firstIndex(of: id) {
            selectionOrder.remove(at: orderIndex)
            if let tileIndex = tiles.firstIndex(where: { $0.id == id }) {
                tiles[tileIndex].isSelected = false
            }
        } else {
            guard selectionOrder.count < 4 else { return }
            selectionOrder.append(id)
            if let tileIndex = tiles.firstIndex(where: { $0.id == id }) {
                tiles[tileIndex].isSelected = true
            }
        }
    }

    func shuffleSelection() {
        guard selectionOrder.count > 1 else { return }
        selectionOrder.shuffle()
    }

    func roll() {
        rollTrigger += 1
        selectionOrder.removeAll()
        for index in tiles.indices {
            let colors = BauhausColors.randomPair()
            tiles[index].pattern = .random()
            tiles[index].foreground = colors.foreground
            tiles[index].background = colors.background
            tiles[index].isSelected = false
        }
    }
}
