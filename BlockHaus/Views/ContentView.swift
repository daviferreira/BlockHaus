import SwiftUI

// MARK: - Shake Detection

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        if motion == .motionShake {
            NotificationCenter.default.post(name: .deviceDidShake, object: nil)
        }
    }
}

extension Notification.Name {
    static let deviceDidShake = Notification.Name("deviceDidShake")
}

// MARK: - Content View

struct ContentView: View {
    @State private var gridModel = GridModel()
    @State private var shareItem: ShareableImage?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TileStripView(model: gridModel)

                PatternCanvasView(selectedTiles: gridModel.selectedTiles) {
                    withAnimation(.spring(duration: 0.3)) {
                        gridModel.shuffleSelection()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle("BlockHaus")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.spring(duration: 0.4, bounce: 0.3)) {
                            gridModel.roll()
                        }
                    } label: {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }
                    .tint(BauhausColors.red)
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        let image = renderGridImage(tiles: gridModel.selectedTiles)
                        shareItem = ShareableImage(image: image)
                    } label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .font(.headline)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(BauhausColors.blue)
                    .disabled(gridModel.selectedTiles.isEmpty)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .deviceDidShake)) { _ in
                withAnimation(.spring(duration: 0.4, bounce: 0.3)) {
                    gridModel.roll()
                }
            }
            .sheet(item: $shareItem) { item in
                ShareSheet(items: [item.image])
            }
        }
    }

    private func renderGridImage(tiles: [TileModel], size: CGFloat = 1024) -> UIImage {
        let cellSize = size / 2
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        return renderer.image { ctx in
            let gc = ctx.cgContext
            for row in 0..<2 {
                for col in 0..<2 {
                    let index = (row * 2 + col) % tiles.count
                    let tile = tiles[index]
                    let rect = CGRect(
                        x: CGFloat(col) * cellSize,
                        y: CGFloat(row) * cellSize,
                        width: cellSize,
                        height: cellSize
                    )
                    // Draw background
                    gc.setFillColor(UIColor(tile.background).cgColor)
                    gc.fill(rect)
                    // Use ImageRenderer with a Canvas for each tile
                    let tileImage = renderTileImage(tile: tile, size: cellSize)
                    tileImage.draw(in: rect)
                }
            }
        }
    }

    private func renderTileImage(tile: TileModel, size: CGFloat) -> UIImage {
        let renderer = ImageRenderer(content:
            Canvas { context, canvasSize in
                let rect = CGRect(origin: .zero, size: canvasSize)
                TilePatternRenderer.draw(
                    tile.pattern,
                    in: rect,
                    context: context,
                    foreground: tile.foreground,
                    background: tile.background
                )
            }
            .frame(width: size, height: size)
        )
        renderer.scale = 1.0
        return renderer.uiImage ?? UIImage()
    }
}

struct ShareableImage: Identifiable {
    let id = UUID()
    let image: UIImage
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ContentView()
}
