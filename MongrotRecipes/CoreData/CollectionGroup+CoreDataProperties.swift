import Foundation
import CoreData

extension CollectionGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CollectionGroup> {
        return NSFetchRequest<CollectionGroup>(entityName: "CollectionGroup")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var isPinned: NSNumber?
    @NSManaged public var sortOrder: NSNumber?
    @NSManaged public var coverImageData: Data?
    @NSManaged public var recipes: NSSet?
}

extension CollectionGroup: Identifiable {
    var titleDisplay: String { title ?? "Untitled" }
    var isPinnedBool: Bool { isPinned?.boolValue ?? false }
    var sortOrderInt: Int { sortOrder?.intValue ?? 0 }

    var recipesArray: [Recipe] {
        (recipes as? Set<Recipe> ?? [])
            .sorted { ($0.title ?? "") < ($1.title ?? "") }
    }

    var recipeCount: Int { recipes?.count ?? 0 }
}

// MARK: - Generated relationship accessors
extension CollectionGroup {
    @objc(addRecipesObject:) @NSManaged public func addToRecipes(_ value: Recipe)
    @objc(removeRecipesObject:) @NSManaged public func removeFromRecipes(_ value: Recipe)
    @objc(addRecipes:) @NSManaged public func addToRecipes(_ values: NSSet)
    @objc(removeRecipes:) @NSManaged public func removeFromRecipes(_ values: NSSet)
}
