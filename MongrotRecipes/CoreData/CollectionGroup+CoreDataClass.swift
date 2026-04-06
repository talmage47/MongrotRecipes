import Foundation
import CoreData

/// Internal name: CollectionGroup / Group.
/// UI label: "Categories" — kept separate intentionally so future features
/// (shared groups, featured collections) don't require renaming.
///
/// TODO: CloudKit sharing will likely require splitting this into a separate
/// persistent store container (CKContainer with shared database) and
/// restructuring the many-to-many relationship. Plan accordingly.
@objc(CollectionGroup)
public class CollectionGroup: NSManagedObject {}
