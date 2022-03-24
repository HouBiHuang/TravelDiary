//
//  FriendsBirthday.swift
//  TravelDiary
//
//  Created by 黃侯弼 on 2022/1/3.
//

import Foundation
import CoreData

class FriendsBirthday: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FriendsBirthday> {
        return NSFetchRequest<FriendsBirthday>(entityName: "FriendsBirthday")
    }
    
    @NSManaged public var notificationIdentifier: String
    @NSManaged public var name: String
    @NSManaged public var image: Data
    @NSManaged public var date: Date
}
