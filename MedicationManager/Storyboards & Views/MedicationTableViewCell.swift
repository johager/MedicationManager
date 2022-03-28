//
//  MedicationTableViewCell.swift
//  MedicationManager
//
//  Created by James Hager on 3/28/22.
//

import UIKit

class MedicationTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var wasTakenButton: UIButton!
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter
    }
    
    // MARK: - Methods
    
    func configure(with medication: Medication) {
        nameLabel.text = medication.name
        timeLabel.text = dateFormatter.string(from: medication.timeOfDay)
    }
    
    // MARK: - Actions
    
    @IBAction func wasTakenButtonTapped(_ sender: UIButton) {
        print("wasTakenButtonTapped")
    }
}
