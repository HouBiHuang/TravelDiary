//
//  FriendsBirthdayTableViewCell.swift
//  TravelDiary
//
//  Created by 黃侯弼 on 2022/1/3.
//

import UIKit

class FriendsBirthdayTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var friendImageView: UIImageView! {
        didSet {
            friendImageView.layer.cornerRadius = friendImageView.frame.height / 2
            friendImageView.clipsToBounds = true
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
