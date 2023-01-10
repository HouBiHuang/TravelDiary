//
//  AddFriendsBirthdayTableView.swift
//  TravelDiary
//
//  Created by 黃侯弼 on 2023/1/10.
//

import UIKit

class AddFriendsBirthdayTableView: UITableView {
    @IBOutlet var nameTextField: UITextField!
    
    @IBOutlet var photoImageView: UIImageView! {
        didSet {
            photoImageView.layer.cornerRadius = photoImageView.frame.height / 2
            photoImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet var datePicker: UIDatePicker!
}
