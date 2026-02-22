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

    var body: some View {
        NavigationStack {
            GridView(model: gridModel)
                .navigationTitle("BlockHaus")
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            withAnimation(.spring(duration: 0.4, bounce: 0.3)) {
                                gridModel.roll()
                            }
                        } label: {
                            Label("Roll", systemImage: "dice.fill")
                                .font(.headline)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(BauhausColors.red)
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: .deviceDidShake)) { _ in
                    withAnimation(.spring(duration: 0.4, bounce: 0.3)) {
                        gridModel.roll()
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
