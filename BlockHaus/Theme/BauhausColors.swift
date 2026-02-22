import SwiftUI

enum BauhausColors {
    static let red = Color(red: 230/255, green: 57/255, blue: 70/255)
    static let yellow = Color(red: 244/255, green: 208/255, blue: 63/255)
    static let blue = Color(red: 36/255, green: 113/255, blue: 163/255)
    static let black = Color(red: 28/255, green: 28/255, blue: 28/255)
    static let white = Color(red: 250/255, green: 250/255, blue: 250/255)

    static let palette: [Color] = [red, yellow, blue, black, white]

    static func randomPair(from colors: [Color]? = nil) -> (foreground: Color, background: Color) {
        var pool = (colors ?? palette).shuffled()
        let foreground = pool.removeFirst()
        let background = pool.first!
        return (foreground, background)
    }
}
