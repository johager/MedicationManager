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
    
    // MARK: - Actions
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }    

    @IBAction func emojiTapped(_ sender: UIButton) {
        guard let emojiString = sender.titleLabel?.text else  { return }
        delegate?.setTodaysMoodState(to: emojiString)
        dismiss(animated: true)
    }
}
