import SwiftUI

@Observable
class GridModel {
    var tiles: [TileModel]
    private(set) var rollTrigger: Int = 0

    init(count: Int = 20) {
        tiles = (0..<count).map { _ in TileModel.random() }
    }

    func roll() {
        rollTrigger += 1
        for index in tiles.indices where !tiles[index].isLocked {
            let colors = BauhausColors.randomPair()
            tiles[index].pattern = .random()
            tiles[index].foreground = colors.foreground
            tiles[index].background = colors.background
        }
    }

    func cycleTile(id: UUID) {
        guard let index = tiles.firstIndex(where: { $0.id == id }) else { return }
        tiles[index].pattern = tiles[index].pattern.next()
    }

    func toggleLock(id: UUID) {
        guard let index = tiles.firstIndex(where: { $0.id == id }) else { return }
        tiles[index].isLocked.toggle()
    }
}
