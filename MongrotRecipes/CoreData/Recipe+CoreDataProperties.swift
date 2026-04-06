import Foundation
import CoreData

extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    // MARK: - Stored attributes (all optional for CloudKit compatibility)
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var summary: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var servings: NSNumber?
    @NSManaged public var prepTimeMinutes: NSNumber?
    @NSManaged public var cookTimeMinutes: NSNumber?
    @NSManaged public var isFavorite: NSNumber?
    @NSManaged public var isPinned: NSNumber?
    @NSManaged public var imageData: Data?
    @NSManaged public var calories: NSNumber?
    @NSManaged public var protein: NSNumber?
    @NSManaged public var carbs: NSNumber?
    @NSManaged public var fat: NSNumber?

    // MARK: - Relationships
    @NSManaged public var ingredients: NSSet?
    @NSManaged public var steps: NSSet?
    @NSManaged public var groups: NSSet?
}

// MARK: - Convenience accessors
extension Recipe: Identifiable {
    var titleDisplay: String { title ?? "Untitled Recipe" }
    var servingsInt: Int { servings?.intValue ?? 2 }
    var prepTime: Int { prepTimeMinutes?.intValue ?? 0 }
    var cookTime: Int { cookTimeMinutes?.intValue ?? 0 }
    var totalTime: Int { prepTime + cookTime }
    var isFavoriteBool: Bool { isFavorite?.boolValue ?? false }
    var isPinnedBool: Bool { isPinned?.boolValue ?? false }

    var sortedIngredients: [Ingredient] {
        (ingredients as? Set<Ingredient> ?? [])
            .sorted { ($0.sortOrder?.intValue ?? 0) < ($1.sortOrder?.intValue ?? 0) }
    }

    var sortedSteps: [InstructionStep] {
        (steps as? Set<InstructionStep> ?? [])
            .sorted { ($0.sortOrder?.intValue ?? 0) < ($1.sortOrder?.intValue ?? 0) }
    }

    var groupsArray: [CollectionGroup] {
        (groups as? Set<CollectionGroup> ?? [])
            .sorted { ($0.title ?? "") < ($1.title ?? "") }
    }

    var firstGroupTitle: String? { groupsArray.first?.title }

    var hasNutrition: Bool {
        calories != nil || protein != nil || carbs != nil || fat != nil
    }
}

// MARK: - Generated relationship accessors
extension Recipe {
    @objc(addIngredientsObject:) @NSManaged public func addToIngredients(_ value: Ingredient)
    @objc(removeIngredientsObject:) @NSManaged public func removeFromIngredients(_ value: Ingredient)
    @objc(addIngredients:) @NSManaged public func addToIngredients(_ values: NSSet)
    @objc(removeIngredients:) @NSManaged public func removeFromIngredients(_ values: NSSet)

    @objc(addStepsObject:) @NSManaged public func addToSteps(_ value: InstructionStep)
    @objc(removeStepsObject:) @NSManaged public func removeFromSteps(_ value: InstructionStep)
    @objc(addSteps:) @NSManaged public func addToSteps(_ values: NSSet)
    @objc(removeSteps:) @NSManaged public func removeFromSteps(_ values: NSSet)

    @objc(addGroupsObject:) @NSManaged public func addToGroups(_ value: CollectionGroup)
    @objc(removeGroupsObject:) @NSManaged public func removeFromGroups(_ value: CollectionGroup)
    @objc(addGroups:) @NSManaged public func addToGroups(_ values: NSSet)
    @objc(removeGroups:) @NSManaged public func removeFromGroups(_ values: NSSet)
}
