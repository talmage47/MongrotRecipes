import SwiftUI
import CoreData

/// The "Categories" tab. Internally all types are named CollectionGroup / Groups.
///
/// Layout inspired by Apple Photos Collections tab:
/// vertical scroll, bold section headers, horizontal card rows.
struct CollectionsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.appAccentColor) private var accentColor

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CollectionGroup.sortOrder, ascending: true)],
        animation: .default
    )
    private var allGroups: FetchedResults<CollectionGroup>

    @State private var showingSettings = false

    private var pinnedGroups: [CollectionGroup] {
        allGroups.filter { $0.isPinnedBool }
    }

    private var regularGroups: [CollectionGroup] {
        allGroups.filter { !$0.isPinnedBool }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 36) {
                    // MARK: Pinned section
                    if !pinnedGroups.isEmpty {
                        HorizontalScrollSection(title: "Pinned", showSeeAll: false) {
                            ForEach(pinnedGroups) { group in
                                PinnedItemCard(group: group)
                            }
                        }
                    }

                    // MARK: Groups section
                    if !regularGroups.isEmpty {
                        HorizontalScrollSection(
                            title: "Groups",
                            subtitle: "\(regularGroups.count) collections",
                            showSeeAll: false
                        ) {
                            ForEach(regularGroups) { group in
                                CollectionCardView(group: group)
                            }
                        }
                    }

                    // TODO: Shared Groups section
                    // When CloudKit sharing is implemented, add a "Shared with You"
                    // horizontal section here, sourced from a separate shared store.

                    // TODO: Featured section
                    // Curated or algorithmic featured collections.

                    // TODO: Recently Added section
                    // Show groups with most recently created recipes.

                    if allGroups.isEmpty {
                        emptyState
                    }

                    // Pad above tab bar
                    Color.clear.frame(height: 90)
                }
                .padding(.top, 8)
            }
            .navigationTitle("Categories")
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .topBarTrailing) { settingsButton }
                #else
                ToolbarItem(placement: .automatic) { settingsButton }
                #endif
                // TODO: Add a "+" toolbar button to create a new group.
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .background(Color.black.ignoresSafeArea())
        }
    }

    private var settingsButton: some View {
        Button { showingSettings = true } label: {
            Image(systemName: "gearshape").foregroundStyle(.white)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "square.grid.2x2")
                .font(.system(size: 44, weight: .light))
                .foregroundStyle(.white.opacity(0.15))
            Text("No categories yet")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(.secondary)
            Text("Organize your recipes into groups")
                .font(.system(size: 14))
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }
}

#Preview {
    CollectionsView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .preferredColorScheme(.dark)
}
