import SwiftUI
import CoreData

@main
struct MongrotRecipesApp: App {
    let persistence = PersistenceController.shared

    @AppStorage("accentColorName") private var accentColorName: String = AccentColorOption.defaultOption.rawValue

    private var accentColor: Color {
        AccentColorOption(rawValue: accentColorName)?.color ?? AccentColorOption.defaultOption.color
    }

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(\.managedObjectContext, persistence.container.viewContext)
                .environment(\.appAccentColor, accentColor)
                .tint(accentColor)
                .preferredColorScheme(.dark)
        }
    }
}
