import SwiftUI
import CoreData

struct RecipeDetailView: View {
    let recipe: Recipe

    @Environment(\.dismiss) private var dismiss
    @Environment(\.appAccentColor) private var accentColor

    /// Current serving count (starts at recipe's stored value, scales ingredients).
    @State private var currentServings: Int

    init(recipe: Recipe) {
        self.recipe = recipe
        _currentServings = State(initialValue: recipe.servingsInt)
    }

    private var scaleFactor: Double {
        let base = Double(recipe.servingsInt)
        guard base > 0 else { return 1 }
        return Double(currentServings) / base
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Hero image
                heroImage

                VStack(alignment: .leading, spacing: 24) {
                    // Title + group tag
                    titleSection

                    // Metadata: prep / cook / total
                    metadataRow

                    Divider().background(Color.white.opacity(0.08))

                    // Servings scaler
                    servingsScaler

                    Divider().background(Color.white.opacity(0.08))

                    // Ingredients
                    if !recipe.sortedIngredients.isEmpty {
                        ingredientsSection
                        Divider().background(Color.white.opacity(0.08))
                    }

                    // Steps
                    if !recipe.sortedSteps.isEmpty {
                        stepsSection
                        Divider().background(Color.white.opacity(0.08))
                    }

                    // Nutrition (optional)
                    if recipe.hasNutrition {
                        nutritionSection
                    }

                    // TODO: Shopping list — add ingredients to Reminders.
                    // TODO: Variants — allow spicy/mild or other substitutions.

                    Color.clear.frame(height: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
            }
        }
        .navigationTitle(recipe.titleDisplay)
        .background(Color.black.ignoresSafeArea())
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .topBarTrailing) { overflowMenu }
            #else
            ToolbarItem(placement: .automatic) { overflowMenu }
            #endif
        }
    }

    // MARK: - Toolbar

    private var overflowMenu: some View {
        Menu {
            Button("Edit Recipe", systemImage: "pencil") {
                // TODO: Present edit sheet
            }
            Button("Add to Shopping List", systemImage: "cart") {
                // TODO: Export ingredients to Reminders
            }
            Divider()
            Button("Share", systemImage: "square.and.arrow.up") {
                // TODO: Share recipe
            }
        } label: {
            Image(systemName: "ellipsis.circle")
                .foregroundStyle(.white)
        }
    }

    // MARK: - Hero image

    @ViewBuilder
    private var heroImage: some View {
        if let data = recipe.imageData,
           let image = Image(platformImageData: data) {
            image
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 280)
                .clipped()
        } else {
            ZStack {
                Rectangle()
                    .fill(Color.white.opacity(0.04))
                    .frame(height: 180)
                Image(systemName: "fork.knife")
                    .font(.system(size: 52, weight: .light))
                    .foregroundStyle(.white.opacity(0.12))
            }
        }
    }

    // MARK: - Title

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(recipe.titleDisplay)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)

            if let summary = recipe.summary, !summary.isEmpty {
                Text(summary)
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
            }

            // Group tags
            if !recipe.groupsArray.isEmpty {
                HStack(spacing: 6) {
                    ForEach(recipe.groupsArray) { group in
                        Text(group.titleDisplay)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(accentColor)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(accentColor.opacity(0.12))
                            )
                    }
                }
            }
        }
    }

    // MARK: - Metadata

    private var metadataRow: some View {
        HStack(spacing: 0) {
            if recipe.prepTime > 0 {
                metadataTile(value: "\(recipe.prepTime)", unit: "min", label: "Prep")
                metadataDivider
            }
            if recipe.cookTime > 0 {
                metadataTile(value: "\(recipe.cookTime)", unit: "min", label: "Cook")
                metadataDivider
            }
            metadataTile(value: "\(recipe.servingsInt)", unit: "", label: "Servings")
        }
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.04))
        )
    }

    private func metadataTile(value: String, unit: String, label: String) -> some View {
        VStack(spacing: 2) {
            HStack(alignment: .lastTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                if !unit.isEmpty {
                    Text(unit)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
            }
            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var metadataDivider: some View {
        Rectangle()
            .fill(Color.white.opacity(0.08))
            .frame(width: 1, height: 36)
    }

    // MARK: - Servings scaler

    private var servingsScaler: some View {
        HStack {
            Text("Servings")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)

            Spacer()

            HStack(spacing: 16) {
                Button {
                    if currentServings > 1 { currentServings -= 1 }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(currentServings > 1 ? accentColor : .white.opacity(0.2))
                }
                .buttonStyle(.plain)

                Text("\(currentServings)")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(minWidth: 32)
                    .contentTransition(.numericText())

                Button {
                    currentServings += 1
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(accentColor)
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Ingredients

    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Ingredients")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)

            VStack(spacing: 0) {
                ForEach(recipe.sortedIngredients) { ingredient in
                    HStack(alignment: .top, spacing: 12) {
                        Text(ingredient.scaledAmountString(scaleFactor: scaleFactor))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(accentColor)
                            .frame(minWidth: 56, alignment: .trailing)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(ingredient.nameDisplay)
                                .font(.system(size: 15))
                                .foregroundStyle(.white)
                            if let notes = ingredient.notes, !notes.isEmpty {
                                Text(notes)
                                    .font(.system(size: 12))
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Spacer()
                    }
                    .padding(.vertical, 10)

                    Divider().background(Color.white.opacity(0.06))
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.white.opacity(0.04))
            )
        }
    }

    // MARK: - Steps

    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Instructions")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)

            VStack(alignment: .leading, spacing: 16) {
                ForEach(recipe.sortedSteps) { step in
                    HStack(alignment: .top, spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(accentColor.opacity(0.15))
                                .frame(width: 30, height: 30)
                            Text("\(step.stepNumber)")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(accentColor)
                        }

                        Text(step.textDisplay)
                            .font(.system(size: 15))
                            .foregroundStyle(.white.opacity(0.9))
                            .lineSpacing(4)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
    }

    // MARK: - Nutrition

    private var nutritionSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Nutrition")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)

            // TODO: Nutrition calculation from ingredient data (future feature).
            HStack(spacing: 0) {
                if let cal = recipe.calories {
                    nutritionTile(value: "\(Int(cal.doubleValue * scaleFactor))", unit: "kcal", label: "Calories")
                }
                if let protein = recipe.protein {
                    Divider().background(Color.white.opacity(0.08)).frame(height: 40)
                    nutritionTile(value: String(format: "%.0fg", protein.doubleValue * scaleFactor), unit: "", label: "Protein")
                }
                if let carbs = recipe.carbs {
                    Divider().background(Color.white.opacity(0.08)).frame(height: 40)
                    nutritionTile(value: String(format: "%.0fg", carbs.doubleValue * scaleFactor), unit: "", label: "Carbs")
                }
                if let fat = recipe.fat {
                    Divider().background(Color.white.opacity(0.08)).frame(height: 40)
                    nutritionTile(value: String(format: "%.0fg", fat.doubleValue * scaleFactor), unit: "", label: "Fat")
                }
            }
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.white.opacity(0.04))
            )

            Text("Per serving • estimated")
                .font(.system(size: 11))
                .foregroundStyle(.tertiary)
        }
    }

    private func nutritionTile(value: String, unit: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value + unit)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let recipe = try! context.fetch(Recipe.fetchRequest()).first!
    NavigationStack {
        RecipeDetailView(recipe: recipe)
    }
    .preferredColorScheme(.dark)
}
