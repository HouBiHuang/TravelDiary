//
//  NewDiaryTableView.swift
//  TravelDiary
//
//  Created by 黃侯弼 on 2023/1/10.
//

import UIKit

class NewDiaryTableView: UITableView {
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var contentTextView: UITextView!
    
    @IBOutlet var photoImageView: UIImageView! {
        didSet {
            photoImageView.layer.cornerRadius = 20.0
            photoImageView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet var datePicker: UIDatePicker!
}
