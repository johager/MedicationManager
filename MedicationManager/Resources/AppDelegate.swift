//
//  AppDelegate.swift
//  MedicationManager
//
//  Created by James Hager on 3/28/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { authorized, error in
            if let error = error {
                print("There was an error requesting notification authorization: \(error)")
            }
            
            if authorized {
                print("received notification authorization")
                UNUserNotificationCenter.current().delegate = self
                self.setNotificationCategories()
            } else {
                print("Did not authorize notifications")
            }
        }
        
        return true
    }
    
    func setNotificationCategories() {
        let markTaken = UNNotificationAction(identifier: Strings.markTakenActionIdentifier, title: Strings.markTakenActionTitle, options: UNNotificationActionOptions(rawValue: 0))
        
        let ignore = UNNotificationAction(identifier: Strings.ignoreActionIdentifier, title: Strings.ignoreActionTitle, options: UNNotificationActionOptions(rawValue: 0))
        
        let category = UNNotificationCategory(identifier: Strings.notificationCategoryIdentifier, actions: [markTaken, ignore], intentIdentifiers: [], options: .customDismissAction)
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        NotificationCenter.default.post(name: NotificationNames.medicationReminderReceived, object: nil)
        completionHandler([.sound, .badge, .banner])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        defer {
            completionHandler()
        }
        
        guard response.actionIdentifier == Strings.markTakenActionIdentifier,
              let id = response.notification.request.content.userInfo[Strings.medicationIdKey] as? String
        else { return }
        
        MedicationController.shared.setWasTakenForMedication(withID: id)
    }
}
