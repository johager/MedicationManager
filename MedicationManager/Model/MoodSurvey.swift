//
//  MoodSurvey.swift
//  MedicationManager
//
//  Created by James Hager on 3/29/22.
//

import CoreData

@objc(MoodSurvey)
class MoodSurvey: NSManagedObject {
    
    // MARK: - CoreData Properties
    
    @NSManaged var date: Date
    @NSManaged var moodState: String
    
    // MARK: - Init
    
    @discardableResult convenience init(moodState: String, date: Date = Date(), context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.moodState = moodState
        self.date = date
    }
}
