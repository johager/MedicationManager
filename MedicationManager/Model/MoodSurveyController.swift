//
//  MoodSurveyController.swift
//  MedicationManager
//
//  Created by James Hager on 3/29/22.
//

import CoreData

class MoodSurveyController {
    
    static let shared = MoodSurveyController()
    
    var todayMoodSurvey: MoodSurvey?
    
    private lazy var fetchRequest: NSFetchRequest<MoodSurvey> = {
        let request = NSFetchRequest<MoodSurvey>(entityName: "MoodSurvey")
        let today = Date()
        let startOfToday = Calendar.current.startOfDay(for: today)
        let startOfTOmorrow = Calendar.current.date(byAdding: .day, value: 1, to: today) ?? Date()
        request.predicate = NSPredicate(format: "date > %@ AND date < %@", startOfToday as NSDate, startOfTOmorrow as NSDate)
        return request
    }()
    
    // MARK: - Init
    
    private init() {
        fetch()
    }
    
    // MARK: - Methods
    
    func setTodaysMoodState(to moodState: String) {
        if let todayMoodSurvey = todayMoodSurvey {
            update(todayMoodSurvey, toMoodState: moodState)
        } else {
            create(moodState: moodState)
        }
        CoreDataStack.saveContext()
    }
    
    // MARK: - CRUD
    
    private func create(moodState: String) {
        todayMoodSurvey = MoodSurvey(moodState: moodState)
    }
    
    func fetch() {
        guard
            let moodSurveys = (try? CoreDataStack.context.fetch(fetchRequest)),
            moodSurveys.count > 0
        else { return }
        todayMoodSurvey = moodSurveys[0]
    }
                          
    private func update(_ moodSurvey: MoodSurvey, toMoodState moodState: String) {
        moodSurvey.moodState = moodState
    }
}
