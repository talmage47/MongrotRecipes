import Foundation
import CoreData

extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var amount: NSNumber?
    @NSManaged public var unit: String?
    @NSManaged public var notes: String?
    @NSManaged public var sortOrder: NSNumber?
    /// Stores the original amount before scaling. Used to compute scaled amounts.
    @NSManaged public var baseAmount: NSNumber?
    @NSManaged public var recipe: Recipe?
}

extension Ingredient: Identifiable {
    var nameDisplay: String { name ?? "" }
    var amountDouble: Double { amount?.doubleValue ?? 0 }
    var baseAmountDouble: Double { baseAmount?.doubleValue ?? amountDouble }

    /// Returns a formatted display string for the scaled amount and unit.
    func scaledAmountString(scaleFactor: Double) -> String {
        let scaled = baseAmountDouble * scaleFactor
        let formatted = scaled.truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", scaled)
            : String(format: "%.1f", scaled)
        let unitStr = unit.map { " \($0)" } ?? ""
        return "\(formatted)\(unitStr)"
    }
}
