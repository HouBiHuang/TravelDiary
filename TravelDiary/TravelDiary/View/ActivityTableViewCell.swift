//
//  ActivityTableViewCell.swift
//  TravelDiary
//
//  Created by 黃侯弼 on 2021/12/14.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet var activityImageView: UIImageView! {
        didSet {
            activityImageView.layer.cornerRadius = 20.0
            activityImageView.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
