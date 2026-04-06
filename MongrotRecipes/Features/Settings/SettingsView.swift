import SwiftUI

struct SettingsView: View {
    @AppStorage("accentColorName") private var accentColorName: String = AccentColorOption.defaultOption.rawValue
    @Environment(\.dismiss) private var dismiss

    private var selectedOption: AccentColorOption {
        AccentColorOption(rawValue: accentColorName) ?? AccentColorOption.defaultOption
    }

    var body: some View {
        NavigationStack {
            List {
                // MARK: Accent color
                Section {
                    ForEach(AccentColorOption.allCases) { option in
                        colorRow(option)
                    }
                } header: {
                    Text("Accent Color")
                }

                // TODO: App icon selection
                // TODO: Default serving size preference
                // TODO: Import / Export recipes (JSON)
                // TODO: iCloud sync status
                // TODO: About / version info
            }
            #if os(iOS)
            .listStyle(.insetGrouped)
            #else
            .listStyle(.inset)
            #endif
            .scrollContentBackground(.hidden)
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Settings")
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .topBarTrailing) { doneButton }
                #else
                ToolbarItem(placement: .automatic) { doneButton }
                #endif
            }
        }
        .preferredColorScheme(.dark)
        .tint(selectedOption.color)
    }

    private var doneButton: some View {
        Button("Done") { dismiss() }
            .foregroundStyle(selectedOption.color)
    }

    private func colorRow(_ option: AccentColorOption) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                accentColorName = option.rawValue
            }
        } label: {
            HStack(spacing: 14) {
                Circle()
                    .fill(option.color)
                    .frame(width: 28, height: 28)
                    .shadow(color: option.color.opacity(0.4), radius: 4)

                Text(option.label)
                    .foregroundStyle(.white)

                Spacer()

                if option == selectedOption {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(option.color)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .listRowBackground(Color.white.opacity(0.05))
    }
}

#Preview {
    SettingsView()
        .preferredColorScheme(.dark)
}
