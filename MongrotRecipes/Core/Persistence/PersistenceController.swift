import CoreData

/// Central persistence layer.
///
/// Currently uses `NSPersistentContainer` (local-only).
///
/// TODO (CloudKit sync): To enable iCloud sync, follow these steps:
///   1. In Xcode: select the target → Signing & Capabilities → "+" → iCloud
///   2. Check "CloudKit" and create/select a container (e.g. iCloud.com.yourname.MongrotRecipes)
///   3. Replace `NSPersistentContainer` below with `NSPersistentCloudKitContainer`
///   4. Update the `container` property type to `NSPersistentCloudKitContainer`
///   5. Re-enable the history tracking options that are commented out below
///
/// TODO (Shared Groups): CloudKit sharing will additionally require a second persistent
/// store configured with the shared CKDatabase scope.
struct PersistenceController {

    static let shared = PersistenceController()

    /// In-memory store used exclusively in SwiftUI previews.
    static let preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        SeedData.populate(in: controller.container.viewContext)
        return controller
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MongrotRecipes")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        // TODO (CloudKit): Uncomment when switching to NSPersistentCloudKitContainer.
        // container.persistentStoreDescriptions.first?.setOption(
        //     true as NSNumber, forKey: NSPersistentHistoryTrackingKey
        // )
        // container.persistentStoreDescriptions.first?.setOption(
        //     true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey
        // )

        container.loadPersistentStores { _, error in
            if let error {
                // This should only fail if the model file is missing or corrupted.
                // It is safe to crash here during development; handle gracefully in production.
                assertionFailure("Core Data store failed to load: \(error)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    // MARK: - Save

    func save() {
        let context = container.viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Core Data save error: \(error)")
        }
    }
}
