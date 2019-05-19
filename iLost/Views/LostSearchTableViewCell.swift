//
//  LostSearchTableViewCell.swift
//  iLost
//
//  Created by ak on 19.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit

class LostSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var lostImageView: UIImageView!

    @IBOutlet weak var categoryLabel: UILabel!

    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
