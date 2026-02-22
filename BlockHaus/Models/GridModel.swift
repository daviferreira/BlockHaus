import SwiftUI

@Observable
class GridModel {
    var tiles: [TileModel]
    private(set) var rollTrigger: Int = 0
    private var selectionOrder: [UUID] = []
    let settings: SettingsModel

    init(settings: SettingsModel, count: Int = 20) {
        self.settings = settings
        tiles = (0..<count).map { _ in
            TileModel.random(colors: settings.activeColors, patterns: settings.activePatterns)
        }
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
            guard selectionOrder.count < settings.maxSelection else { return }
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

    func clearSelection() {
        selectionOrder.removeAll()
        for index in tiles.indices {
            tiles[index].isSelected = false
        }
    }

    func randomSelection() {
        clearSelection()
        let count = min(settings.maxSelection, tiles.count)
        let picked = tiles.shuffled().prefix(count)
        for tile in picked {
            toggleSelection(id: tile.id)
        }
    }

    func refresh() {
        let colors = settings.activeColors
        let patterns = settings.activePatterns
        for index in tiles.indices {
            let pair = BauhausColors.randomPair(from: colors)
            tiles[index].pattern = TilePattern.random(from: patterns)
            tiles[index].foreground = pair.foreground
            tiles[index].background = pair.background
        }
    }

    func roll() {
        rollTrigger += 1
        selectionOrder.removeAll()
        refresh()
        for index in tiles.indices {
            tiles[index].isSelected = false
        }
    }
}
