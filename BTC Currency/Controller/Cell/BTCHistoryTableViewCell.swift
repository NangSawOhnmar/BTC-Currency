//
//  BTCHistoryTableViewCell.swift
//  BTC Currency
//
//  Created by nang saw on 23/09/2022.
//

import UIKit

class BTCHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var priceRateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    static let IDENTIFIER: String = "BTCHistoryTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupView(){
        self.contentView.layer.cornerRadius = 8.0
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.1
        self.layer.masksToBounds = false
    }
}
