import SwiftUI
import CoreData

enum AppTab: String, CaseIterable, Identifiable {
    case recipes
    case collections

    var id: String { rawValue }

    var label: String {
        switch self {
        case .recipes:     return "Recipes"
        case .collections: return "Categories"  // UI label differs from internal name
        }
    }

    var icon: String {
        switch self {
        case .recipes:     return "fork.knife"
        case .collections: return "square.grid.2x2"
        }
    }
}

struct RootTabView: View {
    @State private var selectedTab: AppTab = .recipes

    var body: some View {
        ZStack(alignment: .bottom) {
            // Content area — full bleed, ignores safe area at bottom so
            // content can scroll under the floating tab bar.
            Group {
                switch selectedTab {
                case .recipes:
                    RecipesView()
                case .collections:
                    CollectionsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Floating tab bar sits above content.
            FloatingTabBar(selectedTab: $selectedTab)
                .padding(.bottom, 12)
        }
        .background(Color.black)
        #if os(iOS)
        .ignoresSafeArea(.keyboard)
        #endif
    }
}

#Preview {
    RootTabView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .preferredColorScheme(.dark)
}
