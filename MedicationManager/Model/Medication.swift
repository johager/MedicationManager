//
//  Medication.swift
//  MedicationManager
//
//  Created by James Hager on 3/28/22.
//

import CoreData

@objc(Medication)
class Medication: NSManagedObject {
    
    @discardableResult convenience init(name: String, timeOfDay: Date, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.timeOfDay = timeOfDay
    }
}

// MARK: - CoreData Properties

extension Medication {
    @NSManaged var name: String
    @NSManaged var timeOfDay: Date
}
