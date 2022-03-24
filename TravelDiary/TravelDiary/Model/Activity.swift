//
//  Activity.swift
//  TravelDiary
//
//  Created by 黃侯弼 on 2021/12/31.
//

import Foundation

enum ActivitySection: CaseIterable {
    case Tainan
    case Kaohsiung
    case Chiayi
}

struct Activity: Hashable {
    var activityImages: String = ""
    var activityDestination: String = ""
}
