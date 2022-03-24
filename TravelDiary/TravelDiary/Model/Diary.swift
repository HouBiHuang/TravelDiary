//
//  Diary.swift
//  TravelDiary
//
//  Created by 黃侯弼 on 2021/12/13.
//

import Foundation
import CoreData

public class Diary: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }
    
    @NSManaged public var content: String
    @NSManaged public var image: Data
    @NSManaged public var date: Date
}

