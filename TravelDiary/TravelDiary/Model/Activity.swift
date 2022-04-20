//
//  Activity.swift
//  TravelDiary
//
//  Created by 黃侯弼 on 2021/12/31.
//

import Foundation

enum ActivitySection: CaseIterable {
    case Pingtung
    case Kaohsiung
    case Tainan
    case ChiayiCity
    case ChiayiCountry
    case Yunlin
    case Nantou
    case Changhua
    case Miaoli
    case Taichung
    case Yilan
    case HsinchuCountry
    case HsinchuCity
    case Taoyuan
    case Keelung
    case NewTaipei
    case Taipei
    case Taitung
    case Hualien
}

struct Activity: Hashable {
    var activityImages: String = ""
    var activityDestination: String = ""
}
