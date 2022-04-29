//
//  LocationItem+CoreDataProperties.swift
//  
//
//  Created by Simekani Mabambi on 2022/04/28.
//
//

import Foundation
import CoreData

extension LocationItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationItem> {
        return NSFetchRequest<LocationItem>(entityName: "LocationItem")
    }

    @NSManaged public var locationName: String?
    @NSManaged public var longitude: String?
    @NSManaged public var latitude: String?
    @NSManaged public var temprature: String?

}
