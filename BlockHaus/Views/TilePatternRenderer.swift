import SwiftUI

struct TilePatternRenderer {
    static func draw(
        _ pattern: TilePattern,
        in rect: CGRect,
        context: GraphicsContext,
        foreground: Color,
        background: Color
    ) {
        // Fill background
        context.fill(Path(rect), with: .color(background))

        switch pattern {
        case .fullCircle:
            drawFullCircle(in: rect, context: context, color: foreground)
        case .halfCircleTop:
            drawHalfCircle(in: rect, context: context, color: foreground, edge: .top)
        case .halfCircleBottom:
            drawHalfCircle(in: rect, context: context, color: foreground, edge: .bottom)
        case .halfCircleLeft:
            drawHalfCircle(in: rect, context: context, color: foreground, edge: .left)
        case .halfCircleRight:
            drawHalfCircle(in: rect, context: context, color: foreground, edge: .right)
        case .quarterCircleTL:
            drawQuarterCircle(in: rect, context: context, color: foreground, corner: .topLeft)
        case .quarterCircleTR:
            drawQuarterCircle(in: rect, context: context, color: foreground, corner: .topRight)
        case .quarterCircleBL:
            drawQuarterCircle(in: rect, context: context, color: foreground, corner: .bottomLeft)
        case .quarterCircleBR:
            drawQuarterCircle(in: rect, context: context, color: foreground, corner: .bottomRight)
        case .triangleUp:
            drawTriangle(in: rect, context: context, color: foreground, direction: .up)
        case .triangleDown:
            drawTriangle(in: rect, context: context, color: foreground, direction: .down)
        case .triangleLeft:
            drawTriangle(in: rect, context: context, color: foreground, direction: .left)
        case .triangleRight:
            drawTriangle(in: rect, context: context, color: foreground, direction: .right)
        case .diagonalSplit:
            drawDiagonalSplit(in: rect, context: context, color: foreground)
        case .horizontalStripes:
            drawHorizontalStripes(in: rect, context: context, color: foreground)
        case .verticalStripes:
            drawVerticalStripes(in: rect, context: context, color: foreground)
        case .concentricCircles:
            drawConcentricCircles(in: rect, context: context, foreground: foreground, background: background)
        case .dotGrid:
            drawDotGrid(in: rect, context: context, color: foreground)
        case .cross:
            drawCross(in: rect, context: context, color: foreground)
        case .nestedSquares:
            drawNestedSquares(in: rect, context: context, foreground: foreground, background: background)
        }
    }

    // MARK: - Circle Patterns

    private static func drawFullCircle(in rect: CGRect, context: GraphicsContext, color: Color) {
        let inset = rect.width * 0.1
        let ellipseRect = rect.insetBy(dx: inset, dy: inset)
        context.fill(Path(ellipseIn: ellipseRect), with: .color(color))
    }

    private enum Edge { case top, bottom, left, right }

    private static func drawHalfCircle(in rect: CGRect, context: GraphicsContext, color: Color, edge: Edge) {
        var path = Path()
        let w = rect.width
        let h = rect.height

        switch edge {
        case .top:
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                        radius: w / 2, startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
            path.closeSubpath()
        case .bottom:
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                        radius: w / 2, startAngle: .degrees(180), endAngle: .degrees(360), clockwise: true)
            path.closeSubpath()
        case .left:
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                        radius: h / 2, startAngle: .degrees(270), endAngle: .degrees(90), clockwise: true)
            path.closeSubpath()
        case .right:
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                        radius: h / 2, startAngle: .degrees(270), endAngle: .degrees(90), clockwise: false)
            path.closeSubpath()
        }
        context.fill(path, with: .color(color))
    }

    private enum Corner { case topLeft, topRight, bottomLeft, bottomRight }

    private static func drawQuarterCircle(in rect: CGRect, context: GraphicsContext, color: Color, corner: Corner) {
        var path = Path()
        let size = rect.width

        switch corner {
        case .topLeft:
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addArc(center: CGPoint(x: rect.minX, y: rect.minY),
                        radius: size, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
            path.closeSubpath()
        case .topRight:
            path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addArc(center: CGPoint(x: rect.maxX, y: rect.minY),
                        radius: size, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
            path.closeSubpath()
        case .bottomLeft:
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addArc(center: CGPoint(x: rect.minX, y: rect.maxY),
                        radius: size, startAngle: .degrees(270), endAngle: .degrees(360), clockwise: false)
            path.closeSubpath()
        case .bottomRight:
            path.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addArc(center: CGPoint(x: rect.maxX, y: rect.maxY),
                        radius: size, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
            path.closeSubpath()
        }
        context.fill(path, with: .color(color))
    }

    // MARK: - Triangle Patterns

    private enum Direction { case up, down, left, right }

    private static func drawTriangle(in rect: CGRect, context: GraphicsContext, color: Color, direction: Direction) {
        var path = Path()

        switch direction {
        case .up:
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        case .down:
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        case .left:
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        case .right:
            path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        }
        path.closeSubpath()
        context.fill(path, with: .color(color))
    }

    // MARK: - Geometric Patterns

    private static func drawDiagonalSplit(in rect: CGRect, context: GraphicsContext, color: Color) {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        context.fill(path, with: .color(color))
    }

    private static func drawHorizontalStripes(in rect: CGRect, context: GraphicsContext, color: Color) {
        let stripeCount = 5
        let stripeHeight = rect.height / CGFloat(stripeCount * 2)
        for i in 0..<stripeCount {
            let y = rect.minY + CGFloat(i * 2) * stripeHeight
            let stripeRect = CGRect(x: rect.minX, y: y, width: rect.width, height: stripeHeight)
            context.fill(Path(stripeRect), with: .color(color))
        }
    }

    private static func drawVerticalStripes(in rect: CGRect, context: GraphicsContext, color: Color) {
        let stripeCount = 5
        let stripeWidth = rect.width / CGFloat(stripeCount * 2)
        for i in 0..<stripeCount {
            let x = rect.minX + CGFloat(i * 2) * stripeWidth
            let stripeRect = CGRect(x: x, y: rect.minY, width: stripeWidth, height: rect.height)
            context.fill(Path(stripeRect), with: .color(color))
        }
    }

    private static func drawConcentricCircles(
        in rect: CGRect, context: GraphicsContext, foreground: Color, background: Color
    ) {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let maxRadius = rect.width / 2
        let ringCount = 3

        for i in 0..<ringCount {
            let radius = maxRadius * CGFloat(ringCount - i) / CGFloat(ringCount)
            let color = i % 2 == 0 ? foreground : background
            let circleRect = CGRect(
                x: center.x - radius, y: center.y - radius,
                width: radius * 2, height: radius * 2
            )
            context.fill(Path(ellipseIn: circleRect), with: .color(color))
        }
    }

    private static func drawDotGrid(in rect: CGRect, context: GraphicsContext, color: Color) {
        let cols = 3
        let rows = 3
        let dotRadius = rect.width * 0.08
        let spacingX = rect.width / CGFloat(cols + 1)
        let spacingY = rect.height / CGFloat(rows + 1)

        for row in 1...rows {
            for col in 1...cols {
                let center = CGPoint(
                    x: rect.minX + spacingX * CGFloat(col),
                    y: rect.minY + spacingY * CGFloat(row)
                )
                let dotRect = CGRect(
                    x: center.x - dotRadius, y: center.y - dotRadius,
                    width: dotRadius * 2, height: dotRadius * 2
                )
                context.fill(Path(ellipseIn: dotRect), with: .color(color))
            }
        }
    }

    private static func drawCross(in rect: CGRect, context: GraphicsContext, color: Color) {
        let armWidth = rect.width * 0.3
        let halfArm = armWidth / 2

        // Horizontal bar
        let hBar = CGRect(
            x: rect.minX, y: rect.midY - halfArm,
            width: rect.width, height: armWidth
        )
        // Vertical bar
        let vBar = CGRect(
            x: rect.midX - halfArm, y: rect.minY,
            width: armWidth, height: rect.height
        )
        context.fill(Path(hBar), with: .color(color))
        context.fill(Path(vBar), with: .color(color))
    }

    private static func drawNestedSquares(
        in rect: CGRect, context: GraphicsContext, foreground: Color, background: Color
    ) {
        let levels = 3
        for i in 0..<levels {
            let inset = rect.width * CGFloat(i) / CGFloat(levels * 2)
            let color = i % 2 == 0 ? foreground : background
            let squareRect = rect.insetBy(dx: inset, dy: inset)
            context.fill(Path(squareRect), with: .color(color))
        }
    }
}
