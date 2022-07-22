//
//  ActivityTableViewController.swift
//  TravelDiary
//
//  Created by 黃侯弼 on 2021/12/14.
//

import UIKit

class ActivityTableViewController: UITableViewController {
    
    var sectionContent = [
        [[Activity(activityImages: "Pingtung1"),
          Activity(activityImages: "Pingtung2")
         ],
         [Activity(activityImages: "Kaohsiung1"),
          Activity(activityImages: "Kaohsiung2"),
          Activity(activityImages: "Kaohsiung3")
         ],
         [Activity(activityImages: "Tainan1"),
          Activity(activityImages: "Tainan2"),
          Activity(activityImages: "Tainan3")
         ],
         [Activity(activityImages: "ChiayiCity1")
         ],
         [Activity(activityImages: "ChiayiCountry1")
         ]],
        
        [[Activity(activityImages: "Yunlin1"),
          Activity(activityImages: "Yunlin2")
         ],
         [Activity(activityImages: "Nantou1"),
          Activity(activityImages: "Nantou2"),
          Activity(activityImages: "Kaohsiung3")
         ],
         [Activity(activityImages: "Changhua1"),
          Activity(activityImages: "Changhua2"),
          Activity(activityImages: "Changhua3")
         ],
         [Activity(activityImages: "Taichung1")
         ],
         [Activity(activityImages: "Miaoli1")
         ]],
        
        [[Activity(activityImages: "HsinchuCountry1"),
          Activity(activityImages: "HsinchuCountry2")
         ],
         [Activity(activityImages: "HsinchuCity1"),
         ],
         [Activity(activityImages: "Yilan1"),
          Activity(activityImages: "Yilan2"),
         ],
         [Activity(activityImages: "Taoyuan1"),
          Activity(activityImages: "Taoyuan2")
         ],
         [Activity(activityImages: "NewTaipei1"),
          Activity(activityImages: "NewTaipei2"),
          Activity(activityImages: "NewTaipei3")
         ],
         [Activity(activityImages: "Taipei1"),
          Activity(activityImages: "Taipei2"),
          Activity(activityImages: "Taipei3"),
          Activity(activityImages: "Taipei4"),
          Activity(activityImages: "Taipei5")
         ],
         [Activity(activityImages: "Keelung1")
         ]],
        
        [[Activity(activityImages: "Taitung1"),
          Activity(activityImages: "Taitung2"),
          Activity(activityImages: "Taitung3")
         ],
         [Activity(activityImages: "Hualien1"),
          Activity(activityImages: "Hualien2")
         ]],
    ]
    
    lazy var dataSource = configureDataSource()
    private let floatyButton = UIButton.init(type: .system)
    //private let floatyButton = UIButton(type: UIButton.ButtonType.custom) as UIButton
    var currentArea:String = "南"
    let city:[[String]] = [["Pingtung", "Kaohsiung", "Tainan", "ChiayiCity", "ChiayiCountry"],
                           ["Yunlin", "Nantou", "Changhua", "Taichung", "Miaoli"],
                           ["HsinchuCountry", "HsinchuCity", "Yilan", "Taoyuan", "NewTaipei", "Taipei", "Keelung"],
                           ["Taitung", "Hualien"]
                          ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        
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
        
        addFlotyButton()
        
        var snapshot = NSDiffableDataSourceSnapshot<ActivitySection, Activity>()
        for (index, element) in city[0].enumerated() {
            snapshot.appendSections([ActivitySection.allCases[index]])
            snapshot.appendItems(sectionContent[0][index], toSection: ActivitySection.allCases[index])
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
        
        //移至cell最頂端
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    //MARK: -- OutputPhoto
    func outputPhoto(area: String) {
        var snapshot = NSDiffableDataSourceSnapshot<ActivitySection, Activity>()
        
        if area == "南" {
            currentArea = "中"
            floatyButton.setTitle("中", for: .normal)
            for (index, element) in city[1].enumerated() {
                snapshot.appendSections([ActivitySection.allCases[index + 5]])
                snapshot.appendItems(sectionContent[1][index], toSection: ActivitySection.allCases[index + 5])
            }
        } else if area == "中" {
            currentArea = "北"
            floatyButton.setTitle("北", for: .normal)
            for (index, element) in city[2].enumerated() {
                snapshot.appendSections([ActivitySection.allCases[index + 10]])
                snapshot.appendItems(sectionContent[2][index], toSection: ActivitySection.allCases[index + 10])
            }
        } else if area == "北" {
            currentArea = "東"
            floatyButton.setTitle("東", for: .normal)
            for (index, element) in city[3].enumerated() {
                snapshot.appendSections([ActivitySection.allCases[index + 17]])
                snapshot.appendItems(sectionContent[3][index], toSection: ActivitySection.allCases[index + 17])
            }
        } else if area == "東" {
            currentArea = "南"
            floatyButton.setTitle("南", for: .normal)
            for (index, element) in city[0].enumerated() {
                snapshot.appendSections([ActivitySection.allCases[index]])
                snapshot.appendItems(sectionContent[0][index], toSection: ActivitySection.allCases[index])
            }
        }
                                
        dataSource.apply(snapshot, animatingDifferences: false)
        
        //移至cell最頂端
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    //MARK: -- FloatyButton
    func addFlotyButton() {
        floatyButton.setTitle("南", for: .normal)
        floatyButton.titleLabel?.font =  .systemFont(ofSize: 20)
        floatyButton.setTitleColor(UIColor(named: "NavigationBarTitle"), for: .normal)
        floatyButton.backgroundColor = UIColor(named: "TabBar")
        floatyButton.clipsToBounds = true
        floatyButton.layer.cornerRadius = 25
        floatyButton.addTarget(self, action: #selector(floatyButtonClicked(_:)), for:.touchUpInside)
        
        self.view.addSubview(floatyButton)
        
        //set constrains
        //不要自動建立layout constraints，要自己建立
        floatyButton.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                floatyButton.heightAnchor.constraint(equalToConstant: 50),
                floatyButton.widthAnchor.constraint(equalToConstant: 50),
                floatyButton.rightAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.rightAnchor, constant: -10),
                floatyButton.bottomAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.bottomAnchor, constant: -10)
            ])
        } else {
            NSLayoutConstraint.activate([
                floatyButton.heightAnchor.constraint(equalToConstant: 50),
                floatyButton.widthAnchor.constraint(equalToConstant: 50),
                floatyButton.rightAnchor.constraint(equalTo: tableView.layoutMarginsGuide.rightAnchor, constant: 0),
                floatyButton.bottomAnchor.constraint(equalTo: tableView.layoutMarginsGuide.bottomAnchor, constant: -10)
            ])
        }
    }
    
    @objc private func floatyButtonClicked(_ notification: NSNotification) {
        UIView.transition(with: floatyButton, duration: 0.7, options: .transitionFlipFromRight, animations: nil, completion: nil)

        outputPhoto(area: currentArea) //更改輸出城市
    }
    //MARK: -- configureDataSource
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
    //MARK: -- 每個section標題
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 35))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 38, y: 7, width: headerView.frame.width, height: headerView.frame.height)

        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.frame = CGRect.init(x: 5, y: 5, width: 30, height: 30)
        
        if currentArea == "南" {
            for (index, element) in city[0].enumerated() {
                if section == index {
                    label.text = element
                    image.image = UIImage(named: "\(element)_logo")
                }
            }
        } else if currentArea == "中" {
            for (index, element) in city[1].enumerated() {
                if section == index {
                    label.text = element
                    image.image = UIImage(named: "\(element)_logo")
                }
            }
        } else if currentArea == "北" {
            for (index, element) in city[2].enumerated() {
                if section == index {
                    label.text = element
                    image.image = UIImage(named: "\(element)_logo")
                }
            }
        } else if currentArea == "東" {
            for (index, element) in city[3].enumerated() {
                if section == index {
                    label.text = element
                    image.image = UIImage(named: "\(element)_logo")
                }
            }
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
