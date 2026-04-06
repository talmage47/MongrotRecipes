import Foundation
import CoreData

extension InstructionStep {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InstructionStep> {
        return NSFetchRequest<InstructionStep>(entityName: "InstructionStep")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var text: String?
    @NSManaged public var sortOrder: NSNumber?
    @NSManaged public var recipe: Recipe?
}

extension InstructionStep: Identifiable {
    var stepNumber: Int { (sortOrder?.intValue ?? 0) + 1 }
    var textDisplay: String { text ?? "" }
}
