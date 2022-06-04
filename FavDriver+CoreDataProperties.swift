//
//  FavDriver+CoreDataProperties.swift
//  AplMobile
//
//  Created by Claudia Apostol on 17.05.2022.
//
//

import Foundation
import CoreData


extension FavDriver {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavDriver> {
        return NSFetchRequest<FavDriver>(entityName: "FavDriver")
    }

    @NSManaged public var code: String?
    @NSManaged public var dateOfBirth: String?
    @NSManaged public var driverId: String?
    @NSManaged public var name: String
    @NSManaged public var nationality: String?
    @NSManaged public var permanentNumber: String?
    @NSManaged public var url: String?
    @NSManaged public var displayPic: String?
    @NSManaged public var slideshowPics: [String]?
    @NSManaged public var priority: Int16
    

}

extension FavDriver : Identifiable {

}
