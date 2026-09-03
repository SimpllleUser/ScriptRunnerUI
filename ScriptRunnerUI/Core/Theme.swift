import SwiftUI
import AppKit

// MARK: - Color Hex Initializer

extension Color {
    /// Initializes a `Color` from a hex string (e.g. `"#6930C3"` or `"6930C3"`).
    init(hex: String) {
        let h = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var int = UInt64(0)
        Scanner(string: h).scanHexInt64(&int)

        let r = Double((int >> 16) & 0xFF) / 255.0
        let g = Double((int >> 8) & 0xFF) / 255.0
        let b = Double(int & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Theme

/// Project color palette, corner radii, and typography.
///
/// Sources:
///   - AccentColor.colorset → `Theme.Brand.brand` (`#6930C3`)
///   - All other colors are defined here in code for easy reuse.
enum Theme {

    // MARK: Surfaces

    /// Background surfaces (light → dark layering).
    enum Surface {
        static let paper: Color = Color(hex: "FBFAFD")
        static let paper2: Color = Color(hex: "F3F1F8")
        static let paper3: Color = Color(hex: "E6E3EF")
        static let paper4: Color = Color(hex: "D3CEE0")
    }

    // MARK: Text

    /// Text / icon colors (high → low emphasis).
    enum Text {
        static let ink: Color = Color(hex: "14102A")
        static let ink2: Color = Color(hex: "2A2546")
        static let ink3: Color = Color(hex: "5A5577")
        static let ink4: Color = Color(hex: "9A96B0")
    }

    // MARK: Brand — accent, highlight, links

    /// Brand / accent colors used for interactive elements and links.
    enum Brand {
        static let brand50: Color = Color(hex: "F1EBFA")
        static let brand: Color = Color(hex: "6930C3")
        static let brandHover: Color = Color(hex: "5524A8")
        static let brandPress: Color = Color(hex: "421B87")
    }

    // MARK: Script statuses

    /// Status colors for script lifecycle states.
    enum Status {
        static let running: Color = Color(hex: "2F9E8E")             // success
        static let stderr: Color = Color(hex: "B9700B")               // warning
        static let failed: Color = Color(hex: "C1366A")               // danger
        static let idle: Color = Color(hex: "9A96B0").opacity(0.45)    // 45 %
    }
}

// MARK: - Corner Radii

/// System corner radii.
enum CornerRadius {
    static let inlineButton: CGFloat = 7                // buttons in rows
    static let toolbarSidebarItem: CGFloat = 8          // toolbar, sidebar items
    static let window: CGFloat = 12                     // windows, cards
    static let badgePill: CGFloat = 999                 // badges, pills
}

// MARK: - Typography

/// Font & typography helpers.
///
/// The design system uses **Inter** (body / UI text) and **JetBrains Mono**
/// (logs / commands / paths).  Both should be bundled as Font assets or
/// registered in the app bundle.  When a custom font is unavailable the
/// helpers fall back to the system font with the same size and weight.
enum Typography {

    // Inter 13 / 600 — script name, sidebar items
    static var sidebarItem: Font {
        inter(size: 13, weight: .semibold)
    }

    // Inter 20 / 600 — project name
    static var projectTitle: Font {
        inter(size: 20, weight: .semibold)
    }

    // Inter 11 / 600 + 0.12 em — eyebrow
    static var eyebrow: Font {
        inter(size: 11, weight: .semibold)
    }

    /// Tracking value (in points) for the `eyebrow` font — `0.12 em`
    /// at 11 pt ≈ 1.2 pt.  Apply as `.tracking(Typography.eyebrowTracking)`.
    static let eyebrowTracking: CGFloat = 1.2

    // JetBrains Mono 11 — logs, commands, paths
    static var mono: Font {
        jetBrainsMono(size: 11)
    }

    // MARK: Private helpers

    /// Tries to load an `Inter-{weight}` custom font, falling back to the
    /// system font when the font is not available.
    private static func inter(size: CGFloat, weight: Font.Weight) -> Font {
        let weightName: String
        switch weight {
        case .ultraLight:  weightName = "UltraLight"
        case .thin:         weightName = "Thin"
        case .light:        weightName = "Light"
        case .regular:      weightName = "Regular"
        case .medium:       weightName = "Medium"
        case .semibold:     weightName = "SemiBold"
        case .bold:         weightName = "Bold"
        case .heavy:        weightName = "Heavy"
        case .black:        weightName = "Black"
        default:            weightName = "Regular"
        }

        let fontName = "Inter-\(weightName)"
        if NSFont(name: fontName, size: size) != nil {
            return Font.custom(fontName, size: size)
        }
        return Font.system(size: size, weight: weight)
    }

    /// Tries to load a `JetBrainsMono-Regular` custom font, falling back to
    /// the system's monospaced font when unavailable.
    private static func jetBrainsMono(size: CGFloat) -> Font {
        let fontName = "JetBrainsMono-Regular"
        if NSFont(name: fontName, size: size) != nil {
            return Font.custom(fontName, size: size)
        }
        return Font.system(size: size, weight: .regular)
    }
}
