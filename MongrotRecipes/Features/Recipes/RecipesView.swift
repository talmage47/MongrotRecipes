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

    @State private var searchText = ""
    @State private var sortOrder: RecipeSortOrder = .recentlyUpdated
    @State private var showingAddRecipe = false
    @State private var showingSettings = false
    @State private var selectedRecipe: Recipe? = nil

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
            return searched // already sorted by updatedAt desc from FetchRequest
        case .alphabetical:
            return searched.sorted { $0.titleDisplay < $1.titleDisplay }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        // Search bar + sort controls
                        searchAndSortBar

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

                        // Spacer to avoid floating tab bar overlap.
                        Color.clear.frame(height: 90)
                    }
                    .padding(.top, 8)
                }
                .scrollDismissesKeyboard(.immediately)

                // Floating add button
                addButton
                    .padding(.trailing, 24)
                    .padding(.bottom, 90) // above tab bar
            }
            .navigationTitle("Recipes")
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .topBarTrailing) {
                    settingsButton
                }
                #else
                ToolbarItem(placement: .automatic) {
                    settingsButton
                }
                #endif
            }
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeDetailView(recipe: recipe)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .background(Color.black.ignoresSafeArea())
        }
    }

    // MARK: - Sub-views

    private var searchAndSortBar: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search recipes…", text: $searchText)
                    .foregroundStyle(.white)
                if !searchText.isEmpty {
                    Button { searchText = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.white.opacity(0.07))
            )
            .padding(.horizontal, 16)

            // Sort picker
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

    private var addButton: some View {
        // TODO: Wire to AddRecipeView when implemented.
        Button {
            showingAddRecipe = true
        } label: {
            ZStack {
                Circle()
                    .fill(accentColor)
                    .frame(width: 56, height: 56)
                    .shadow(color: accentColor.opacity(0.4), radius: 12, y: 4)
                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
            }
        }
    }

    private var settingsButton: some View {
        Button { showingSettings = true } label: {
            Image(systemName: "gearshape")
                .foregroundStyle(.white)
        }
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
    RecipesView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .preferredColorScheme(.dark)
}
