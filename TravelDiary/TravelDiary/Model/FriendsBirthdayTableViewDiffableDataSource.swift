//
//  FriendsBirthdayTableViewDiffableDataSource.swift
//  TravelDiary
//
//  Created by 黃侯弼 on 2022/1/3.
//

import UIKit

enum FriendsBirthdaySection {
    case all
}

class FriendsBirthdayTableViewDiffableDataSource: UITableViewDiffableDataSource<FriendsBirthdaySection, FriendsBirthday> {

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
