//
//  DiaryTableViewDiffableDataSource.swift
//  TravelDiary
//
//  Created by 黃侯弼 on 2021/12/13.
//

import UIKit

enum Section {
    case all
}

class DiaryTableViewDiffableDataSource: UITableViewDiffableDataSource<Section, Diary> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
