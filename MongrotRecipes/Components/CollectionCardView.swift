import SwiftUI

/// Large horizontal card representing a CollectionGroup.
/// Used in the Groups section of the Collections tab.
struct CollectionCardView: View {
    let group: CollectionGroup
    @Environment(\.appAccentColor) private var accentColor

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Cover image or placeholder
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(gradient)
                    .frame(height: 130)

                Image(systemName: groupIcon)
                    .font(.system(size: 36, weight: .light))
                    .foregroundStyle(.white.opacity(0.6))
            }

            // Label area
            VStack(alignment: .leading, spacing: 2) {
                Text(group.titleDisplay)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Text(recipeCountLabel)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 10)
            .padding(.horizontal, 4)
        }
        .frame(width: 160)
    }

    private var gradient: LinearGradient {
        LinearGradient(
            colors: [accentColor.opacity(0.25), Color.white.opacity(0.04)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var groupIcon: String {
        // Simple icon mapping based on common group names.
        let t = group.title?.lowercased() ?? ""
        if t.contains("breakfast") { return "sunrise" }
        if t.contains("dessert") { return "birthday.cake" }
        if t.contains("grill") || t.contains("bbq") { return "flame" }
        if t.contains("meal prep") || t.contains("prep") { return "clock" }
        if t.contains("family") { return "house" }
        return "fork.knife"
    }

    private var recipeCountLabel: String {
        let count = group.recipeCount
        return count == 1 ? "1 recipe" : "\(count) recipes"
    }
}

// MARK: - Pinned variant (smaller)
struct PinnedItemCard: View {
    let group: CollectionGroup
    @Environment(\.appAccentColor) private var accentColor

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [accentColor.opacity(0.3), Color.white.opacity(0.04)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 90)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(.white.opacity(0.06), lineWidth: 0.5)
                    )

                Image(systemName: "pin.fill")
                    .font(.system(size: 20, weight: .light))
                    .foregroundStyle(.white.opacity(0.5))
            }

            Text(group.titleDisplay)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.white)
                .lineLimit(1)
                .padding(.top, 8)
                .padding(.horizontal, 2)
                .frame(width: 120, alignment: .leading)
        }
        .frame(width: 120)
    }
}
