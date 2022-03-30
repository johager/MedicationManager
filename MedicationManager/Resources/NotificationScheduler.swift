//
//  NotificationScheduler.swift
//  MedicationManager
//
//  Created by James Hager on 3/30/22.
//

import Foundation
import UserNotifications

enum NotificationScheduler {
    
    static func scheduleNotifications(for medication: Medication) {
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "It's time to take your \(medication.name)."
        content.sound = .default
        content.userInfo = [Strings.medicationIdKey: medication.id]
        content.categoryIdentifier = Strings.notificationCategoryIdentifier
        
        let fireDateComponents = Calendar.current.dateComponents([.hour, .minute], from: medication.timeOfDay)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: medication.id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("There was an error setting up the notification for \(medication.name): \(error.localizedDescription)")
            }
        }
    }
    
    static func cancelNotifictions(for medication: Medication) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [medication.id])
    }
}
