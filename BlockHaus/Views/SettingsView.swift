import SwiftUI

struct SettingsView: View {
    @Bindable var settings: SettingsModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Grid Size") {
                    Picker("Grid", selection: $settings.gridSize) {
                        Text("2 x 2").tag(2)
                        Text("3 x 3").tag(3)
                        Text("4 x 4").tag(4)
                    }
                    .pickerStyle(.segmented)
                }

                Section("Color Palette") {
                    ForEach(SettingsModel.paletteOrder, id: \.self) { id in
                        if let palette = SettingsModel.palettes[id] {
                            Button {
                                settings.paletteId = id
                            } label: {
                                HStack {
                                    Text(palette.name)
                                        .foregroundStyle(.primary)
                                    Spacer()
                                    HStack(spacing: 4) {
                                        ForEach(0..<palette.colors.count, id: \.self) { i in
                                            Circle()
                                                .fill(palette.colors[i])
                                                .frame(width: 16, height: 16)
                                        }
                                    }
                                    if settings.paletteId == id {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(.blue)
                                    }
                                }
                            }
                        }
                    }

                    Stepper("Colors: \(settings.colorCount)",
                            value: $settings.colorCount,
                            in: 2...settings.activePalette.count)

                    HStack(spacing: 6) {
                        Text("Active:")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        ForEach(0..<settings.activeColors.count, id: \.self) { i in
                            Circle()
                                .fill(settings.activeColors[i])
                                .frame(width: 20, height: 20)
                        }
                    }
                }

                Section("Geometric Forms") {
                    Toggle("Circles", isOn: $settings.circlesEnabled)
                        .disabled(!settings.circlesEnabled && enabledCategoryCount <= 1)
                    Toggle("Triangles", isOn: $settings.trianglesEnabled)
                        .disabled(!settings.trianglesEnabled && enabledCategoryCount <= 1)
                    Toggle("Geometric", isOn: $settings.geometricEnabled)
                        .disabled(!settings.geometricEnabled && enabledCategoryCount <= 1)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private var enabledCategoryCount: Int {
        [settings.circlesEnabled, settings.trianglesEnabled, settings.geometricEnabled]
            .filter { $0 }.count
    }
}
