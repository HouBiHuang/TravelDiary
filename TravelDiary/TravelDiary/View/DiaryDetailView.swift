//
//  DiaryDetailView.swift
//  TravelDiary
//
//  Created by 黃侯弼 on 2022/7/22.
//

import UIKit

class DiaryDetailView: UIView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var diaryImage: UIImageView! {
        didSet {
            diaryImage.layer.cornerRadius = 20.0
            diaryImage.clipsToBounds = true
        }
    }
}
