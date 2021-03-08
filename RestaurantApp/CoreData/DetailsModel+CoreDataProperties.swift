//create
import Foundation
import CoreData


extension DetailsModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DetailsModel> {
        return NSFetchRequest<DetailsModel>(entityName: "DetailsModel")
    }

    @NSManaged public var isOpen: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var photos: [URL]?
    @NSManaged public var price: String?
    @NSManaged public var rating: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var list: SavedList?

}
