import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe
    @Environment(\.appAccentColor) private var accentColor

    var body: some View {
        HStack(spacing: 14) {
            // Thumbnail / placeholder
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.white.opacity(0.06))
                    .frame(width: 64, height: 64)

                if let data = recipe.imageData,
                   let image = Image(platformImageData: data) {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 64, height: 64)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                } else {
                    Image(systemName: "fork.knife")
                        .font(.system(size: 22, weight: .light))
                        .foregroundStyle(.white.opacity(0.25))
                }
            }

            // Text content
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.titleDisplay)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                if let summary = recipe.summary, !summary.isEmpty {
                    Text(summary)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                HStack(spacing: 8) {
                    if let group = recipe.firstGroupTitle {
                        Label(group, systemImage: "square.grid.2x2")
                            .font(.system(size: 11))
                            .foregroundStyle(accentColor.opacity(0.8))
                    }

                    if recipe.totalTime > 0 {
                        Label("\(recipe.totalTime) min", systemImage: "clock")
                            .font(.system(size: 11))
                            .foregroundStyle(.secondary)
                    }

                    if recipe.servingsInt > 0 {
                        Label("\(recipe.servingsInt)", systemImage: "person.2")
                            .font(.system(size: 11))
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.white.opacity(0.2))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.04))
        )
        .padding(.horizontal, 16)
    }
}
