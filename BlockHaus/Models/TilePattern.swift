import Foundation

enum PatternCategory: String, CaseIterable {
    case circles
    case triangles
    case geometric
}

enum TilePattern: Int, CaseIterable {
    case fullCircle
    case halfCircleTop
    case halfCircleBottom
    case halfCircleLeft
    case halfCircleRight
    case quarterCircleTL
    case quarterCircleTR
    case quarterCircleBL
    case quarterCircleBR
    case triangleUp
    case triangleDown
    case triangleLeft
    case triangleRight
    case diagonalSplit
    case horizontalStripes
    case verticalStripes
    case concentricCircles
    case dotGrid
    case cross
    case nestedSquares

    var category: PatternCategory {
        switch self {
        case .fullCircle, .halfCircleTop, .halfCircleBottom, .halfCircleLeft, .halfCircleRight,
             .quarterCircleTL, .quarterCircleTR, .quarterCircleBL, .quarterCircleBR:
            return .circles
        case .triangleUp, .triangleDown, .triangleLeft, .triangleRight:
            return .triangles
        case .diagonalSplit, .horizontalStripes, .verticalStripes, .concentricCircles,
             .dotGrid, .cross, .nestedSquares:
            return .geometric
        }
    }

    func next() -> TilePattern {
        let all = Self.allCases
        let nextIndex = (self.rawValue + 1) % all.count
        return all[nextIndex]
    }

    static func random(from patterns: [TilePattern]? = nil) -> TilePattern {
        let pool = patterns ?? Array(allCases)
        return pool.randomElement() ?? allCases.randomElement()!
    }
}
