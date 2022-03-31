//
//  MoodSurveyViewController.swift
//  MedicationManager
//
//  Created by James Hager on 3/29/22.
//

import UIKit

protocol MoodSurveyViewControllerDelegate: AnyObject {
    func setTodaysMoodState(to moodState: String)
}

class MoodSurveyViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: MoodSurveyViewControllerDelegate?
    
    // MARK: - Init
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reminderFired), name: NotificationNames.medicationReminderReceived, object: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }    

    @IBAction func emojiTapped(_ sender: UIButton) {
        guard let emojiString = sender.titleLabel?.text else  { return }
        delegate?.setTodaysMoodState(to: emojiString)
        dismiss(animated: true)
    }
    
    @objc private func reminderFired() {
        let originalColor = view.backgroundColor
        view.backgroundColor = .systemRed
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.view.backgroundColor = originalColor
        }
    }
}
