//
//  DiaryTableViewController.swift
//  TravelDiary
//
//  Created by 黃侯弼 on 2021/12/13.
//

import UIKit
import CoreData

class DiaryTableViewController: UITableViewController {
    
    var fetchResultController: NSFetchedResultsController<Diary>! //讀取結果控制器
    
    var diary:[Diary] = []
    
    lazy var dataSource = configureDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func configureDataSource() -> UITableViewDiffableDataSource<DiarySection, Diary> {
        
        let cellIdentifier = "datacell2"
        
        let dataSource = DiaryTableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, diary in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DiaryTableViewCell
                
                cell.contentLabel.text = diary.content
                cell.travelImageView.image = UIImage(data: diary.image)
                
                //日期顯示(先把日期轉成字串格式，再顯示)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let dateString = dateFormatter.string(from: diary.date as Date)
                cell.dateLabel.text = dateString
                
                return cell
            }
        )
        
        return dataSource
    }
    //MARK: -- 左滑選項
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Get the selected restaurant
        guard let diary = self.dataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
        
        // Delete action
        let deleteAction = UIContextualAction(style: .destructive, title: NSLocalizedString("Delete", comment: "Delete")) { (action, sourceView, completionHandler) in
            
            let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to delete?", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    let context = appDelegate.persistentContainer.viewContext
                    context.delete(diary)
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
        let fetchRequest: NSFetchRequest<Diary> = Diary.fetchRequest() //取得fetchRequest物件
        
        //檢查搜尋內容是否為空
        /*if !searchText.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText)
        }*/
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false) //用date做排序
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
    //更新TableView的日記
    func updateSnapshot(animatingChange: Bool = false) {
        if let fetchedObjects = fetchResultController.fetchedObjects {
            diary = fetchedObjects
        }
        
        //建立快照後填入資料
        var snapshot = NSDiffableDataSourceSnapshot<DiarySection, Diary>()
        snapshot.appendSections([.all])
        snapshot.appendItems(diary, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: animatingChange)
        tableView.backgroundView?.isHidden = diary.count == 0 ? false : true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

//core data被更改時呼叫
extension DiaryTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateSnapshot()
    }
}
