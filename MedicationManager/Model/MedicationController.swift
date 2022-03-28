//
//  MedicationController.swift
//  MedicationManager
//
//  Created by James Hager on 3/28/22.
//

import CoreData

class MedicationController {
    
    static let shared = MedicationController()
    
    var medications = [Medication]()
    
    private lazy var fetchRequest: NSFetchRequest<Medication> = {
        let request = NSFetchRequest<Medication>(entityName: "Medication")
        return request
    }()
    
    private init() {   // restricts init to be accessible only w/in the class, so forces the singleton
        fetchMedication()
    }
    
    // MARK: - CRUD
    
    func create(name: String, timeOfDay: Date) {
        Medication(name: name, timeOfDay: timeOfDay)
        CoreDataStack.saveContext()
        fetchMedication()
    }
    
    func fetchMedication() {
        medications = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
        //print("medications.count: \(medications.count)")
    }
    
    func updateMedication(_ medication: Medication, name: String, timeOfDay: Date) {
        medication.name = name
        medication.timeOfDay = timeOfDay
        CoreDataStack.saveContext()
    }
    
    func deleteMedication() {
        
    }
}