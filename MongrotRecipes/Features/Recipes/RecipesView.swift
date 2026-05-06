import SwiftUI
import CoreData

struct RecipesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.appAccentColor) private var accentColor

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.updatedAt, ascending: false)],
        animation: .default
    )
    private var recipes: FetchedResults<Recipe>

    /// Search text driven from outside (RootTabView's inline search bar).
    var searchText: String = ""

    @State private var sortOrder: RecipeSortOrder = .recentlyUpdated

    private var filteredRecipes: [Recipe] {
        let all = Array(recipes)
        let searched: [Recipe]
        if searchText.isEmpty {
            searched = all
        } else {
            searched = all.filter {
                $0.titleDisplay.localizedCaseInsensitiveContains(searchText) ||
                ($0.summary ?? "").localizedCaseInsensitiveContains(searchText)
            }
        }
        switch sortOrder {
        case .recentlyUpdated:
            return searched
        case .alphabetical:
            return searched.sorted { $0.titleDisplay < $1.titleDisplay }
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                sortBar

                if filteredRecipes.isEmpty {
                    emptyState
                } else {
                    ForEach(filteredRecipes) { recipe in
                        NavigationLink(value: recipe) {
                            RecipeRowView(recipe: recipe)
                        }
                        .buttonStyle(.plain)
                    }
                }

                Color.clear.frame(height: 100)
            }
            .padding(.top, 8)
        }
        .scrollDismissesKeyboard(.immediately)
        .navigationDestination(for: Recipe.self) { recipe in
            RecipeDetailView(recipe: recipe)
        }
        .background(Color.black.ignoresSafeArea())
    }

    // MARK: - Sub-views

    private var sortBar: some View {
        HStack(spacing: 0) {
            ForEach(RecipeSortOrder.allCases) { order in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { sortOrder = order }
                } label: {
                    Text(order.label)
                        .font(.system(size: 13, weight: sortOrder == order ? .semibold : .regular))
                        .foregroundStyle(sortOrder == order ? accentColor : .secondary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(
                            sortOrder == order
                                ? RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(accentColor.opacity(0.15))
                                : nil
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "fork.knife")
                .font(.system(size: 44, weight: .light))
                .foregroundStyle(.white.opacity(0.15))
            Text(searchText.isEmpty ? "No recipes yet" : "No results")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(.secondary)
            if searchText.isEmpty {
                Text("Tap + to add your first recipe")
                    .font(.system(size: 14))
                    .foregroundStyle(.tertiary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }
}

// MARK: - Sort order

enum RecipeSortOrder: String, CaseIterable, Identifiable {
    case recentlyUpdated
    case alphabetical

    var id: String { rawValue }

    var label: String {
        switch self {
        case .recentlyUpdated: return "Recently Updated"
        case .alphabetical:    return "A–Z"
        }
    }
}

#Preview {
    NavigationStack {
        RecipesView()
    }
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    .preferredColorScheme(.dark)
}
