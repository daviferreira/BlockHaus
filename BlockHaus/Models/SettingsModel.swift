import SwiftUI

@Observable
class SettingsModel {
    var gridSize: Int {
        didSet { UserDefaults.standard.set(gridSize, forKey: "gridSize") }
    }

    var paletteId: String {
        didSet {
            UserDefaults.standard.set(paletteId, forKey: "paletteId")
            if colorCount > activePalette.count {
                colorCount = activePalette.count
            }
        }
    }

    var colorCount: Int {
        didSet { UserDefaults.standard.set(colorCount, forKey: "colorCount") }
    }

    var circlesEnabled: Bool {
        didSet { UserDefaults.standard.set(circlesEnabled, forKey: "circlesEnabled") }
    }

    var trianglesEnabled: Bool {
        didSet { UserDefaults.standard.set(trianglesEnabled, forKey: "trianglesEnabled") }
    }

    var geometricEnabled: Bool {
        didSet { UserDefaults.standard.set(geometricEnabled, forKey: "geometricEnabled") }
    }

    // MARK: - Computed

    var maxSelection: Int { gridSize * gridSize }

    var activePalette: [Color] {
        Self.palettes[paletteId]?.colors ?? Self.palettes["bauhaus"]!.colors
    }

    var activeColors: [Color] {
        Array(activePalette.prefix(colorCount))
    }

    var activePatterns: [TilePattern] {
        let filtered = TilePattern.allCases.filter { pattern in
            switch pattern.category {
            case .circles: return circlesEnabled
            case .triangles: return trianglesEnabled
            case .geometric: return geometricEnabled
            }
        }
        return filtered.isEmpty ? Array(TilePattern.allCases) : filtered
    }

    // MARK: - Palette Definitions

    struct Palette {
        let name: String
        let colors: [Color]
    }

    static let paletteOrder = ["bauhaus", "fluorescent", "pastel", "monochrome", "earth"]

    static let palettes: [String: Palette] = [
        "bauhaus": Palette(name: "Bauhaus", colors: [
            Color(red: 230/255, green: 57/255, blue: 70/255),
            Color(red: 244/255, green: 208/255, blue: 63/255),
            Color(red: 36/255, green: 113/255, blue: 163/255),
            Color(red: 28/255, green: 28/255, blue: 28/255),
            Color(red: 250/255, green: 250/255, blue: 250/255),
        ]),
        "fluorescent": Palette(name: "Fluorescent", colors: [
            Color(red: 255/255, green: 20/255, blue: 147/255),
            Color(red: 57/255, green: 255/255, blue: 20/255),
            Color(red: 0/255, green: 255/255, blue: 255/255),
            Color(red: 255/255, green: 165/255, blue: 0/255),
            Color(red: 255/255, green: 0/255, blue: 255/255),
        ]),
        "pastel": Palette(name: "Pastel", colors: [
            Color(red: 255/255, green: 182/255, blue: 193/255),
            Color(red: 200/255, green: 162/255, blue: 200/255),
            Color(red: 152/255, green: 224/255, blue: 190/255),
            Color(red: 255/255, green: 218/255, blue: 185/255),
            Color(red: 173/255, green: 216/255, blue: 230/255),
        ]),
        "monochrome": Palette(name: "Monochrome", colors: [
            Color(red: 20/255, green: 20/255, blue: 20/255),
            Color(red: 80/255, green: 80/255, blue: 80/255),
            Color(red: 140/255, green: 140/255, blue: 140/255),
            Color(red: 200/255, green: 200/255, blue: 200/255),
            Color(red: 245/255, green: 245/255, blue: 245/255),
        ]),
        "earth": Palette(name: "Earth", colors: [
            Color(red: 192/255, green: 96/255, blue: 72/255),
            Color(red: 128/255, green: 128/255, blue: 0/255),
            Color(red: 210/255, green: 190/255, blue: 150/255),
            Color(red: 101/255, green: 67/255, blue: 33/255),
            Color(red: 34/255, green: 100/255, blue: 34/255),
        ]),
    ]

    // MARK: - Init

    init() {
        let defaults = UserDefaults.standard
        self.gridSize = defaults.object(forKey: "gridSize") as? Int ?? 2
        self.paletteId = defaults.string(forKey: "paletteId") ?? "bauhaus"
        self.colorCount = defaults.object(forKey: "colorCount") as? Int ?? 5
        self.circlesEnabled = defaults.object(forKey: "circlesEnabled") as? Bool ?? true
        self.trianglesEnabled = defaults.object(forKey: "trianglesEnabled") as? Bool ?? true
        self.geometricEnabled = defaults.object(forKey: "geometricEnabled") as? Bool ?? true
    }
}
