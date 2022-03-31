//
//  MedicationTableViewCell.swift
//  MedicationManager
//
//  Created by James Hager on 3/28/22.
//

import UIKit

protocol MedicationTableViewCellDelegate: AnyObject {
    func setMedication(for cell: MedicationTableViewCell, wasTakenTo wasTaken: Bool)
}

// MARK: -

class MedicationTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var wasTakenButton: UIButton!
    
    // MARK: - Properties
    
    var wasTakenToday = false
    
    weak var delegate: MedicationTableViewCellDelegate?
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter
    }
    
    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(reminderFired), name: NotificationNames.medicationReminderReceived, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Methods
    
    func configure(with medication: Medication, andDelegate delegate: MedicationTableViewCellDelegate) {
        nameLabel.text = medication.name
        timeLabel.text = dateFormatter.string(from: medication.timeOfDay)
        wasTakenToday = medication.wasTakenToday
        let image = wasTakenToday ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
        wasTakenButton.setImage(image, for: .normal)
        self.delegate = delegate
    }
    
    // MARK: - Actions
    
    @IBAction func wasTakenButtonTapped(_ sender: UIButton) {
        wasTakenToday.toggle()
        delegate?.setMedication(for: self, wasTakenTo: wasTakenToday)
    }
    
    @objc private func reminderFired() {
        let originalColor = contentView.backgroundColor
        contentView.backgroundColor = .systemRed
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.contentView.backgroundColor = originalColor
        }
    }
}
