import SwiftUI
import CoreData

enum AppTab: String, CaseIterable, Identifiable {
    case collections
    case groups

    var id: String { rawValue }

    var label: String {
        switch self {
        case .collections: return "Collections"
        case .groups:      return "Groups"
        }
    }

    var icon: String {
        switch self {
        case .collections: return "square.grid.2x2"
        case .groups:      return "person.3"
        }
    }
}

struct RootTabView: View {
    @State private var selectedTab: AppTab = .collections
    @State private var showingSettings = false
    @State private var showingSearch = false
    @State private var searchText = ""

    var body: some View {
        VStack(spacing: 0) {
            // Top buttons — in the layout flow so they are never overlapped by content.
            HStack {
                glassCircleButton("gearshape") { showingSettings = true }
                Spacer()
                glassCircleButton("plus") { /* TODO: add recipe */ }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 4)

            // Content + bottom overlay
            ZStack {
                Group {
                    if showingSearch {
                        NavigationStack {
                            RecipesView(searchText: searchText)
                                .toolbar(.hidden, for: .navigationBar)
                        }
                    } else {
                        switch selectedTab {
                        case .collections: CollectionsView()
                        case .groups:      GroupsView()
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Bottom overlay: tab bar ↔ search expansion
                VStack {
                    Spacer()
                    bottomRow
                        .padding(.bottom, 12)
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showingSearch)
                }
            }
        }
        .background(Color.black.ignoresSafeArea())
        #if os(iOS)
        .ignoresSafeArea(.keyboard)
        #endif
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }

    // MARK: - Bottom row

    @ViewBuilder
    private var bottomRow: some View {
        HStack(alignment: .bottom, spacing: 12) {
            // Left: full tab bar OR collapsed circle
            if showingSearch {
                collapsedTabButton
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.5).combined(with: .opacity),
                        removal:   .scale(scale: 0.5).combined(with: .opacity)
                    ))
            } else {
                FloatingTabBar(selectedTab: $selectedTab)
                    .transition(.asymmetric(
                        insertion: .move(edge: .leading).combined(with: .opacity),
                        removal:   .move(edge: .leading).combined(with: .opacity)
                    ))
            }

            // Right: expanded search bar OR search circle
            if showingSearch {
                expandedSearchBar
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal:   .move(edge: .trailing).combined(with: .opacity)
                    ))
            } else {
                Spacer()
                glassCircleButton("magnifyingglass") {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        showingSearch = true
                    }
                }
                .padding(.trailing, 16)
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.5).combined(with: .opacity),
                    removal:   .scale(scale: 0.5).combined(with: .opacity)
                ))
            }
        }
        .padding(.leading, 16)
    }

    // MARK: - Bottom controls

    /// Single circle shown while search is active; shows the selected tab icon.
    /// Tapping it collapses search and returns to CollectionsView.
    private var collapsedTabButton: some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                showingSearch = false
                searchText = ""
                selectedTab = .collections
            }
        } label: {
            Image(systemName: selectedTab.icon + ".fill")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.primary)
                .frame(width: 44, height: 44)
                .glassEffect(in: Circle())
        }
        .buttonStyle(.plain)
    }

    /// Inline glass search bar that fills available width when search is active.
    private var expandedSearchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)

            TextField("Search recipes…", text: $searchText)
                .foregroundStyle(.primary)
                .submitLabel(.search)

            if !searchText.isEmpty {
                Button { searchText = "" } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 44)
        .frame(maxWidth: .infinity)
        .glassEffect(in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .padding(.trailing, 16)
    }

    // MARK: - Shared helper

    private func glassCircleButton(_ icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.primary)
                .frame(width: 44, height: 44)
                .glassEffect(in: Circle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    RootTabView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .preferredColorScheme(.dark)
}
