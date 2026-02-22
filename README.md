<p align="center">
  <img src="icon-rounded.png" width="200" height="200" alt="BlockHaus app icon">
</p>

<h1 align="center">BlockHaus</h1>

<p align="center">A digital "Roll a Bauhaus" — randomize a grid of geometric tiles for creative relaxation.</p>

<p align="center">
  <img src="https://img.shields.io/badge/platform-iOS_17+-blue" alt="iOS 17+">
  <img src="https://img.shields.io/badge/swift-5.9+-orange" alt="Swift 5.9+">
  <img src="https://img.shields.io/badge/swiftui-Canvas-green" alt="SwiftUI Canvas">
</p>

---

Inspired by the classic Bauhaus dice charts where random combinations of simple geometric forms create surprisingly pleasing compositions.

## Features

- **20 geometric tile patterns** — circles, half-circles, quarter-circles, triangles, stripes, dots, crosses, nested squares, and more
- **Roll** — tap the dice button to randomize all unlocked tiles
- **Tap** a tile to cycle through patterns
- **Long-press** a tile to lock/unlock it (locked tiles survive rolls)
- **Shake** your device to re-roll
- **Staggered spring animations** on every roll
- **Adaptive grid** — 4 columns on iPhone, 6+ on iPad, reflows on rotation
- **Bauhaus color palette** — red, yellow, blue, black, white

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

Minimal — 8 Swift files, no external dependencies.

```
BlockHaus/
├── BlockHausApp.swift
├── Models/
│   ├── TilePattern.swift        # 20 pattern cases
│   ├── TileModel.swift          # Tile state
│   └── GridModel.swift          # @Observable grid + roll logic
├── Views/
│   ├── ContentView.swift        # Root + toolbar + shake detection
│   ├── GridView.swift           # LazyVGrid adaptive layout
│   ├── TileView.swift           # Canvas-based tile rendering
│   └── TilePatternRenderer.swift # All 20 pattern draw functions
└── Theme/
    └── BauhausColors.swift      # Bauhaus palette constants
```

## License

MIT
