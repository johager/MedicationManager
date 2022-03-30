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
        let request = NSFetchRequest<Medication>(entityName: Strings.medicationEntityName)
        return request
    }()
    
    private init() {   // restricts init to be accessible only w/in the class, so forces the singleton
        fetchMedication()
    }
    
    // MARK: - CRUD
    
    func create(name: String, timeOfDay: Date) {
        let medication = Medication(name: name, timeOfDay: timeOfDay)
        notTakenMeds.append(medication)
        CoreDataStack.saveContext()
        NotificationScheduler.scheduleNotifications(for: medication)
    }
    
    func fetchMedication() {
        let medications = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
        notTakenMeds = medications.filter { !$0.wasTakenToday }
        takenMeds = medications.filter { $0.wasTakenToday }
    }
    
    func updateMedication(_ medication: Medication, name: String, timeOfDay: Date) {
        
        let previousMedicationTimeOfDay = medication.timeOfDay
        
        medication.name = name
        medication.timeOfDay = timeOfDay
        
        CoreDataStack.saveContext()
        
        if timeOfDay != previousMedicationTimeOfDay {
            NotificationScheduler.cancelNotifictions(for: medication)
            NotificationScheduler.scheduleNotifications(for: medication)
        }
    }
    
    func setMedication(atIndex index: Int, wasTakenTo wasTaken: Bool) {
        if wasTaken {
            TakenDate(date: Date(), medication: notTakenMeds[index])
            takenMeds.append(notTakenMeds[index])
            notTakenMeds.remove(at: index)
            CoreDataStack.saveContext()
            
        } else {
            let mutableTakenDates = takenMeds[index].mutableSetValue(forKeyPath: Strings.takenDatesRelationshipName)
            let today = Date()
            
            notTakenMeds.append(takenMeds[index])
            takenMeds.remove(at: index)
            
            if let takenDate = (mutableTakenDates as? Set<TakenDate>)?.first(where: { Calendar.current.isDate($0.date, inSameDayAs: today)}) {
                mutableTakenDates.remove(takenDate)
                CoreDataStack.saveContext()
            }
        }
    }
    
    func setWasTakenForMedication(withID id: String) {
        guard let index = notTakenMeds.firstIndex(where: { $0.id == id }) else { return }
        
        setMedication(atIndex: index, wasTakenTo: true)
    }
    
    func deleteMedication(atIndexPath indexPath: IndexPath) {
        let medication = medications[indexPath.section][indexPath.row]
        
        if indexPath.section == 0 {
            notTakenMeds.remove(at: indexPath.row)
        } else {
            takenMeds.remove(at: indexPath.row)
        }
        
        NotificationScheduler.cancelNotifictions(for: medication)
        CoreDataStack.context.delete(medication)
        CoreDataStack.saveContext()
    }
}
