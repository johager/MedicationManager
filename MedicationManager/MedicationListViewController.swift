//
//  MedicationListViewController.swift
//  MedicationManager
//
//  Created by James Hager on 3/28/22.
//

import UIKit

class MedicationListViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showMedicationDetails",
              let destination = segue.destination as? MedicationDetailViewController,
              let indexPath = tableView.indexPathForSelectedRow
        else { return }
        destination.medication = MedicationController.shared.medications[indexPath.row]
    }
}

// MARK: - UITableViewDataSource

extension MedicationListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MedicationController.shared.medications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "medicationCell", for: indexPath) as? MedicationTableViewCell else { return UITableViewCell() }
        cell.configure(with: MedicationController.shared.medications[indexPath.row], andDelegate: self)
        return cell
    }
}

// MARK: - MedicationTableViewCellDelegate

extension MedicationListViewController: MedicationTableViewCellDelegate {
    
    func setMedication(for cell: MedicationTableViewCell, wasTakenTo wasTaken: Bool) {
        print("\(#function) - wasTaken: \(wasTaken)")
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        MedicationController.shared.setMedication(atIndex: indexPath.row, wasTakenTo: wasTaken)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
