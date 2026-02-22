<p align="center">
  <img src="icon-rounded.png" width="200" height="200" alt="BlockHaus app icon">
</p>

<h1 align="center">BlockHaus</h1>

<p align="center">A Bauhaus-inspired pattern composer — select tiles, create repeating compositions.</p>

<p align="center">
  <img src="https://img.shields.io/badge/platform-iOS_17+-blue" alt="iOS 17+">
  <img src="https://img.shields.io/badge/swift-5.9+-orange" alt="Swift 5.9+">
  <img src="https://img.shields.io/badge/swiftui-Canvas-green" alt="SwiftUI Canvas">
</p>

---

Inspired by classic Bauhaus geometric forms. Pick up to 4 tiles from a randomized strip, and watch them fill a canvas in a repeating pattern.

## Features

- **20 geometric tile patterns** — circles, half-circles, quarter-circles, triangles, stripes, dots, crosses, nested squares, and more
- **Tile strip** — horizontal scrollable row of randomized tiles
- **Tap to select** up to 4 tiles (numbered 1-4 in selection order)
- **Pattern canvas** — fills the viewport with a seeded-random repeat of your selected tiles
- **Roll** — tap the dice button to re-randomize all tiles and reset selections
- **Shake** your device to re-roll
- **Bauhaus color palette** — red, yellow, blue, black, white
- **Adaptive layout** — strip and canvas reflow on rotation and iPad

## Requirements

- iOS 17+
- Xcode 15.4+

## Getting Started

```bash
git clone https://github.com/daviferreira/BlockHaus.git
open BlockHaus/BlockHaus.xcodeproj
```

Build and run on any iPhone or iPad simulator.

## Architecture

Minimal — 9 Swift files, no external dependencies.

```
BlockHaus/
├── BlockHausApp.swift
├── Models/
│   ├── TilePattern.swift          # 20 pattern cases
│   ├── TileModel.swift            # Tile state
│   └── GridModel.swift            # @Observable model + selection logic
├── Views/
│   ├── ContentView.swift          # Root + toolbar + shake detection
│   ├── TileStripView.swift        # Horizontal scrollable tile selector
│   ├── PatternCanvasView.swift    # Canvas-based repeating pattern grid
│   ├── TileView.swift             # Canvas-based tile rendering
│   └── TilePatternRenderer.swift  # All 20 pattern draw functions
└── Theme/
    └── BauhausColors.swift        # Bauhaus palette constants
```

## License

MIT
