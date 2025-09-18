import SwiftUI


struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    // ユーザー選択を永続化（0:system, 1:light, 2:dark）
    @AppStorage("appTheme") private var themeRaw: Int = AppTheme.system.rawValue

    // enum と AppStorage(Int) を橋渡しするバインディング
    private var themeBinding: Binding<AppTheme> {
        Binding(
            get: { AppTheme(rawValue: themeRaw) ?? .system },
            set: { themeRaw = $0.rawValue }
        )
    }

    var body: some View {
        Form {
            Picker("settings.theme", selection: themeBinding) {
                ForEach(AppTheme.allCases) { theme in
                    Text(theme.labelKey).tag(theme)
                }
            }
        }
        .navigationTitle("settings.theme")
        .toolbar {
            // iOS17+: .topBarLeading / それ以前: .navigationBarLeading
            ToolbarItem(placement: .topBarLeading) {
                Button("common.cancel") { dismiss() } // String Catalog に合わせる
            }
        }
    }
}
