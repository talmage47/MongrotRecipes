import SwiftUI

/// User-selectable accent color presets.
/// Stored as a raw string value in UserDefaults via @AppStorage.
enum AccentColorOption: String, CaseIterable, Identifiable {
    case orange
    case yellow
    case mint
    case cyan
    case blue
    case indigo
    case pink
    case red

    var id: String { rawValue }

    var label: String {
        switch self {
        case .orange: return "Orange"
        case .yellow: return "Yellow"
        case .mint:   return "Mint"
        case .cyan:   return "Cyan"
        case .blue:   return "Blue"
        case .indigo: return "Indigo"
        case .pink:   return "Pink"
        case .red:    return "Red"
        }
    }

    var color: Color {
        switch self {
        case .orange: return .orange
        case .yellow: return .yellow
        case .mint:   return .mint
        case .cyan:   return .cyan
        case .blue:   return .blue
        case .indigo: return .indigo
        case .pink:   return .pink
        case .red:    return .red
        }
    }

    static let defaultOption: AccentColorOption = .blue
}

// MARK: - Environment key for passing accent color down the view tree
private struct AccentColorKey: EnvironmentKey {
    static let defaultValue: Color = AccentColorOption.defaultOption.color
}

extension EnvironmentValues {
    var appAccentColor: Color {
        get { self[AccentColorKey.self] }
        set { self[AccentColorKey.self] = newValue }
    }
}
