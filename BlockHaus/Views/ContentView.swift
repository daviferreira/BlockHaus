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
    @State private var settings = SettingsModel()
    @State private var gridModel: GridModel
    @State private var shareItem: ShareableImage?
    @State private var showSettings = false

    init() {
        let settings = SettingsModel()
        _settings = State(initialValue: settings)
        _gridModel = State(initialValue: GridModel(settings: settings))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TileStripView(model: gridModel)

                PatternCanvasView(
                    selectedTiles: gridModel.selectedTiles,
                    gridSize: settings.gridSize
                ) {
                    withAnimation(.spring(duration: 0.3)) {
                        gridModel.shuffleSelection()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle("BlockHaus")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showSettings = true
                    } label: {
                        Label("Settings", systemImage: "gearshape")
                    }
                }
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
            }
            .safeAreaInset(edge: .bottom) {
                if !gridModel.selectedTiles.isEmpty {
                    Button {
                        if let image = renderGridImage(tiles: gridModel.selectedTiles) {
                            shareItem = ShareableImage(image: image)
                        }
                    } label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(BauhausColors.blue)
                    .padding(.bottom, 8)
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
            .sheet(isPresented: $showSettings) {
                SettingsView(settings: settings)
            }
            .onChange(of: settings.gridSize) {
                gridModel.clearSelection()
            }
            .onChange(of: settings.paletteId) {
                withAnimation { gridModel.roll() }
            }
            .onChange(of: settings.colorCount) {
                withAnimation { gridModel.roll() }
            }
            .onChange(of: settings.circlesEnabled) {
                withAnimation { gridModel.roll() }
            }
            .onChange(of: settings.trianglesEnabled) {
                withAnimation { gridModel.roll() }
            }
            .onChange(of: settings.geometricEnabled) {
                withAnimation { gridModel.roll() }
            }
        }
    }

    private func renderGridImage(tiles: [TileModel], size: CGFloat = 1024) -> UIImage? {
        guard !tiles.isEmpty else { return nil }
        let gridSize = settings.gridSize
        let cellSize = size / CGFloat(gridSize)
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        return renderer.image { ctx in
            let gc = ctx.cgContext
            for row in 0..<gridSize {
                for col in 0..<gridSize {
                    let index = (row * gridSize + col) % tiles.count
                    let tile = tiles[index]
                    let rect = CGRect(
                        x: CGFloat(col) * cellSize,
                        y: CGFloat(row) * cellSize,
                        width: cellSize,
                        height: cellSize
                    )
                    gc.setFillColor(UIColor(tile.background).cgColor)
                    gc.fill(rect)
                    let tileRenderer = ImageRenderer(content:
                        Canvas { context, canvasSize in
                            let r = CGRect(origin: .zero, size: canvasSize)
                            TilePatternRenderer.draw(tile.pattern, in: r, context: context, foreground: tile.foreground, background: tile.background)
                        }
                        .frame(width: cellSize, height: cellSize)
                    )
                    tileRenderer.scale = 1.0
                    tileRenderer.uiImage?.draw(in: rect)
                }
            }
        }
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
