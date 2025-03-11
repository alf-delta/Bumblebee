import SwiftUI

enum AppColors {
    // Main brand colors
    static let primary = Color.hex("2D140D")  // Deep coffee brown
    static let secondary = Color.hex("FF9500") // Vibrant orange
    static let accent = Color.hex("FFB800")    // Warm yellow
    
    // Background colors
    static let background = Color.hex("F5F3F0") // Warm light background
    static let surface = Color.hex("FFFFFF")    // Pure white
    static let card = Color.hex("FFFFFF").opacity(0.95) // Semi-transparent white
    
    // UI element colors
    static let lightBrown = Color.hex("FFF4E6") // Very light warm background
    static let darkBrown = Color.hex("8B4513")  // Dark coffee brown
    static let cream = Color.hex("FFF8DC")      // Creamy color
    
    // Text colors
    static let textPrimary = Color.hex("2D140D")   // Same as primary
    static let textSecondary = Color.hex("6B4F4F") // Muted brown
    static let textTertiary = Color.hex("9B8579")  // Light brown
    
    // Status colors
    static let success = Color.hex("4CAF50") // Green
    static let warning = Color.hex("FF9800") // Orange
    static let error = Color.hex("F44336")   // Red
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 