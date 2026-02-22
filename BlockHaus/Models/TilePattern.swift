import Foundation

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

    func next() -> TilePattern {
        let all = Self.allCases
        let nextIndex = (self.rawValue + 1) % all.count
        return all[nextIndex]
    }

    static func random() -> TilePattern {
        allCases.randomElement()!
    }
}
