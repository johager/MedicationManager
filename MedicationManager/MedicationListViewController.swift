//
//  MedicationListViewController.swift
//  MedicationManager
//
//  Created by James Hager on 3/28/22.
//

import UIKit

class MedicationListViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var moodSurveyButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        updateMoodSurveyButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - View Methods
    
    func updateMoodSurveyButton() {
        guard let todayMoodSurvey = MoodSurveyController.shared.todayMoodSurvey else { return }
        moodSurveyButton?.setTitle(todayMoodSurvey.moodState, for: .normal)
    }
    
    // MARK: - Action
    
    @IBAction func surveyButtonTapped(_ sender: UIButton) {
        guard let moodSurveyViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "moodSurveyViewController") as? MoodSurveyViewController else { return }
        moodSurveyViewController.delegate = self
        navigationController?.present(moodSurveyViewController, animated: true)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showMedicationDetails",
              let destination = segue.destination as? MedicationDetailViewController,
              let indexPath = tableView.indexPathForSelectedRow
        else { return }
        destination.medication = MedicationController.shared.medications[indexPath.section][indexPath.row]
    }
}

// MARK: - UITableViewDataSource

extension MedicationListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MedicationController.shared.medications[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "medicationCell", for: indexPath) as? MedicationTableViewCell else { return UITableViewCell() }
        cell.configure(with: MedicationController.shared.medications[indexPath.section][indexPath.row], andDelegate: self)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MedicationListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard MedicationController.shared.medications[section].count > 0 else { return nil }
        
        if section == 0 {
            return "Not Taken"
        } else {
            return "Taken"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(16)
    }
}

// MARK: - MedicationTableViewCellDelegate

extension MedicationListViewController: MedicationTableViewCellDelegate {
    
    func setMedication(for cell: MedicationTableViewCell, wasTakenTo wasTaken: Bool) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        MedicationController.shared.setMedication(atIndex: indexPath.row, wasTakenTo: wasTaken)
        tableView.reloadData()
    }
}

// MARK: - MoodSurveyViewControllerDelegate

extension MedicationListViewController: MoodSurveyViewControllerDelegate {
    
    func setTodaysMoodState(to moodState: String) {
        MoodSurveyController.shared.setTodaysMoodState(to: moodState)
        updateMoodSurveyButton()
    }
}
