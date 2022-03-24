//
//  ActivityTableViewController.swift
//  TravelDiary
//
//  Created by 黃侯弼 on 2021/12/14.
//

import UIKit

class ActivityTableViewController: UITableViewController {
    
    var sectionContent = [
        [Activity(activityImages: "Tainan1"),
         Activity(activityImages: "Tainan2"),
         Activity(activityImages: "Tainan3")
        ],
        [Activity(activityImages: "Kaohsiung1"),
         Activity(activityImages: "Kaohsiung2"),
         Activity(activityImages: "Kaohsiung3")
        ],
        [Activity(activityImages: "Chiayi1"),
         Activity(activityImages: "Chiayi2"),
         Activity(activityImages: "Chiayi3")
        ],
    ]
    
    lazy var dataSource = configureDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        
//        var snapshot = NSDiffableDataSourceSnapshot<ActivitySection, Activity>()
//        snapshot.appendSections([.Tainan , .Kaohsiung, .Chiayi])
//        snapshot.appendItems(sectionContent[0], toSection: .Tainan)
//        snapshot.appendItems(sectionContent[1], toSection: .Kaohsiung)
//        snapshot.appendItems(sectionContent[2], toSection: .Chiayi)
//
//        dataSource.apply(snapshot, animatingDifferences: false)
        outputCity(min: 0, max: 2)
    }

    func configureDataSource() -> UITableViewDiffableDataSource<ActivitySection, Activity> {
        
        let cellIdentifier = "ActivityDatacell"
        
        let dataSource = UITableViewDiffableDataSource<ActivitySection, Activity>(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, activity in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ActivityTableViewCell
                
                cell.activityImageView.image = UIImage(named: activity.activityImages)
                
                return cell
            }
        )
        
        return dataSource
    }
    
    //輸出對應到的城市
    func outputCity(min: Int, max: Int) {
        var snapshot = NSDiffableDataSourceSnapshot<ActivitySection, Activity>()
        
        for i in min...max {
            snapshot.appendSections([ActivitySection.allCases[i]])
            snapshot.appendItems(sectionContent[i], toSection: ActivitySection.allCases[i])
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
        
    }
    
    //MARK: -- 每個section標題
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 35))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 38, y: 7, width: headerView.frame.width, height: headerView.frame.height)

        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.frame = CGRect.init(x: 5, y: 5, width: 30, height: 30)
        
        if section == 0 {
            label.text = "Tainan"
            image.image = UIImage(named: "Tainan_logo")
        } else if section == 1 {
            label.text = "Kaohsiung"
            image.image = UIImage(named: "Kaohsiung_logo")
        } else {
            label.text = "Chiayi"
            image.image = UIImage(named: "Chiayi_logo")
        }

        label.font = .systemFont(ofSize: 25)
        label.textColor = .black

        
        headerView.addSubview(image)
        headerView.addSubview(label)
        return headerView

    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    //MARK: -- 放大圖片
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        openZoomImageViewController(indexPath: indexPath)
//        switch indexPath.section {
//        case 0: openZoomImageViewController(indexPath: indexPath)
//
//        case 1: openZoomImageViewController(indexPath: indexPath)
//
//        case 2: openZoomImageViewController(indexPath: indexPath)
//        default: break
//        }
//
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func openZoomImageViewController(indexPath: IndexPath) {
        guard let activity = self.dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ZoomImageView") as! ZoomImageViewController
        vc.modalPresentationStyle = .fullScreen
        vc.imageName = activity.activityImages
        present(vc, animated: true)
    }
    
}
