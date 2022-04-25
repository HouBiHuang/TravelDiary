//
//  FriendsBirthdayTableViewController.swift
//  TravelDiary
//
//  Created by 黃侯弼 on 2022/1/3.
//

import UIKit
import CoreData
import UserNotifications

class FriendsBirthdayTableViewController: UITableViewController {

    var fetchResultController: NSFetchedResultsController<FriendsBirthday>! //讀取結果控制器
    
    var friendsBirthday:[FriendsBirthday] = []
    
    lazy var dataSource = configureDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UserDefaults.standard.set(true, forKey: "pushedNotification")
//        if UserDefaults.standard.bool(forKey: "pushedNotification") {
//            return
//        } else {
//            pushNotification
//        }
        navigationController?.navigationBar.prefersLargeTitles = true //大標題
        
        if let appearance = navigationController?.navigationBar.standardAppearance {
            appearance.configureWithTransparentBackground() //設定導覽列為透明＆無陰影
            
            if let customFont = UIFont(name: "Pacifico-Regular", size: 35.0) {
                appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!]
                
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!, .font: customFont]
            }
            
            navigationController?.navigationBar.standardAppearance = appearance //標準尺寸
            navigationController?.navigationBar.compactAppearance = appearance //小尺寸
            navigationController?.navigationBar.scrollEdgeAppearance = appearance //捲動上去導覽列時，導覽列變動外觀
        }
        
        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        
        fetchRestaurantData()
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
    }

    // MARK: - UITableView Diffable Data Source
    
    func configureDataSource() -> UITableViewDiffableDataSource<FriendsBirthdaySection, FriendsBirthday> {
        
        let cellIdentifier = "FriendDataCell"
        
        let dataSource = FriendsBirthdayTableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, friendsBirthday in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FriendsBirthdayTableViewCell
                
                //設定姓名
                cell.nameLabel.text = friendsBirthday.name
                
                //日期顯示(先把日期轉成字串格式，再顯示)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let dateString = dateFormatter.string(from: friendsBirthday.date as Date)
                cell.dateLabel.text = dateString
                
                //設定照片
                guard
                    let friendImage = UIImage(data: friendsBirthday.image),
                    let friendCGImage = friendImage.cgImage
                else { return cell}
                cell.friendImageView.image = UIImage(cgImage: friendCGImage, scale: friendImage.scale, orientation: .right)
                
                return cell
            }
        )
        
        return dataSource
    }
    //MARK: -- 左滑選項
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Get the selected restaurant
        guard let friendsBirthday = self.dataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
        
        // Delete action
        let deleteAction = UIContextualAction(style: .destructive, title: NSLocalizedString("Delete", comment: "Delete")) { (action, sourceView, completionHandler) in
            
            let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to delete?", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    let context = appDelegate.persistentContainer.viewContext

                    //取消通知
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [friendsBirthday.notificationIdentifier])

                    context.delete(friendsBirthday)
                    appDelegate.saveContext()

                    self.updateSnapshot(animatingChange: true)
                }
            }
            alertController.addAction(okAction)
            
            let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            // Call completion handler to dismiss the action button
            completionHandler(true)
        }
        
        // Change the button's color
        deleteAction.backgroundColor = UIColor.systemRed
        deleteAction.image = UIImage(systemName: "trash")
        
        // Configure both actions as swipe action
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeConfiguration
    }
    // MARK: - 資料項目取回
    func fetchRestaurantData(searchText: String = "") {
        //從資料庫取得資料
        let fetchRequest: NSFetchRequest<FriendsBirthday> = FriendsBirthday.fetchRequest() //取得fetchRequest物件
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true) //用name做排序
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch() //執行讀取結果
                updateSnapshot()
            } catch {
                print(error)
            }
        }
    }
    
    //更新TableView的好友資訊
    func updateSnapshot(animatingChange: Bool = false) {
        if let fetchedObjects = fetchResultController.fetchedObjects {
            friendsBirthday = fetchedObjects
        }
        
        //建立快照後填入資料
        var snapshot = NSDiffableDataSourceSnapshot<FriendsBirthdaySection, FriendsBirthday>()
        snapshot.appendSections([.all])
        snapshot.appendItems(friendsBirthday, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: animatingChange)
        tableView.backgroundView?.isHidden = friendsBirthday.count == 0 ? false : true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

//core data被更改時呼叫
extension FriendsBirthdayTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateSnapshot()
    }
}
