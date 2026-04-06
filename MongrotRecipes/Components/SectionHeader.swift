import SwiftUI

struct SectionHeader: View {
    let title: String
    var subtitle: String? = nil
    var actionLabel: String? = nil
    var action: (() -> Void)? = nil

    @Environment(\.appAccentColor) private var accentColor

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                if let subtitle {
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            if let actionLabel, let action {
                Button(actionLabel, action: action)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(accentColor)
            }
        }
        .padding(.horizontal, 20)
    }
}
