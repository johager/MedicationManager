//
//  MedicationController.swift
//  MedicationManager
//
//  Created by James Hager on 3/28/22.
//

import CoreData

class MedicationController {
    
    static let shared = MedicationController()
    
    var medications: [[Medication]] { [notTakenMeds, takenMeds] }
    
    private var notTakenMeds = [Medication]()
    private var takenMeds = [Medication]()
    
    private lazy var fetchRequest: NSFetchRequest<Medication> = {
        let request = NSFetchRequest<Medication>(entityName: "Medication")
        return request
    }()
    
    private init() {   // restricts init to be accessible only w/in the class, so forces the singleton
        fetchMedication()
    }
    
    // MARK: - CRUD
    
    func create(name: String, timeOfDay: Date) {
        notTakenMeds.append(Medication(name: name, timeOfDay: timeOfDay))
        CoreDataStack.saveContext()
    }
    
    func fetchMedication() {
        let medications = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
        notTakenMeds = medications.filter { !$0.wasTakenToday }
        takenMeds = medications.filter { $0.wasTakenToday }
    }
    
    func updateMedication(_ medication: Medication, name: String, timeOfDay: Date) {
        medication.name = name
        medication.timeOfDay = timeOfDay
        CoreDataStack.saveContext()
    }
    
    func setMedication(atIndex index: Int, wasTakenTo wasTaken: Bool) {
        if wasTaken {
            TakenDate(date: Date(), medication: notTakenMeds[index])
            takenMeds.append(notTakenMeds[index])
            notTakenMeds.remove(at: index)
            CoreDataStack.saveContext()
            
        } else {
            let mutableTakenDates = takenMeds[index].mutableSetValue(forKeyPath: "takenDates")
            let today = Date()
            
            notTakenMeds.append(takenMeds[index])
            takenMeds.remove(at: index)
            
            if let takenDate = (mutableTakenDates as? Set<TakenDate>)?.first(where: { Calendar.current.isDate($0.date, inSameDayAs: today)}) {
                mutableTakenDates.remove(takenDate)
                CoreDataStack.saveContext()
            }
        }
    }
    
    func deleteMedication() {
        
    }
}
