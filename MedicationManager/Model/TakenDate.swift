//
//  TakenDate.swift
//  MedicationManager
//
//  Created by James Hager on 3/29/22.
//

import CoreData

@objc(TakenDate)
class TakenDate: NSManagedObject {
    
    // MARK: - CoreData Properties
    
    @NSManaged var date: Date
    
    @NSManaged var medication: Medication?
    
    // MARK: - Init
    
    @discardableResult convenience init(date: Date, medication: Medication, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.date = date
        self.medication = medication
    }
}
