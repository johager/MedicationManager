//
//  Medication.swift
//  MedicationManager
//
//  Created by James Hager on 3/28/22.
//

import CoreData

@objc(Medication)
class Medication: NSManagedObject {
    
    // MARK: - CoreData Properties
    
    @NSManaged var name: String
    @NSManaged var timeOfDay: Date
    
    @NSManaged var takenDates: NSSet?
    
    // MARK: - Properties
    
    var wasTakenToday: Bool {
        guard let takenDates = takenDates as? Set<TakenDate> else { return false }
        
        let today = Date()
        return takenDates.contains() { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }
    
    // MARK: - Init
    
    @discardableResult convenience init(name: String, timeOfDay: Date, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.timeOfDay = timeOfDay
    }
}
