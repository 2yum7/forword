import SwiftUI

struct SettingsView: View {
    @State private var reminderOn = false

    var body: some View {
        Form {
            Toggle("毎日のリマインダー", isOn: $reminderOn)
            Picker("テーマ", selection: .constant(0)) {
                Text("端末に合わせる").tag(0)
                Text("ライト").tag(1)
                Text("ダーク").tag(2)
            }
        }
        .navigationTitle("設定")
    }
}
