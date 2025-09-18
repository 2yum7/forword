import SwiftUI

enum AppTheme: Int, CaseIterable, Identifiable {
    case system, light, dark
    var id: Int { rawValue }

    var labelKey: LocalizedStringKey {
        switch self {
        case .system: return "settings.theme.system"
        case .light:  return "settings.theme.light"
        case .dark:   return "settings.theme.dark"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }
}

extension View {
    @ViewBuilder
    func applyAppTheme(_ theme: AppTheme) -> some View {
        if let cs = theme.colorScheme {
            self.preferredColorScheme(cs)
        } else {
            self
        }
    }
}
