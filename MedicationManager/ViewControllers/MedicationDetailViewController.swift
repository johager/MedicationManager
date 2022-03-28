//
//  MedicationDetailViewController.swift
//  MedicationManager
//
//  Created by James Hager on 3/28/22.
//

import UIKit

class MedicationDetailViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK: - Properties
    
    var medication: Medication?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let medication = medication {
            title = "Medication Details"
            nameTextField.text = medication.name
            datePicker.date = medication.timeOfDay
            
        } else {
            title = "Add Medication"
        }
    }
    
    // MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text,
              !name.isEmpty
        else { return }
        
        let date = datePicker.date
        
        if let medication = medication {
            MedicationController.shared.updateMedication(medication, name: name, timeOfDay: date)
        } else {
            MedicationController.shared.create(name: name, timeOfDay: date)
        }
        
        navigationController?.popViewController(animated: true)
    }
}
