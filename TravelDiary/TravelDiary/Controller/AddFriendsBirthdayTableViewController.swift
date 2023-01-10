//
//  AddFriendsBirthdayTableViewController.swift
//  TravelDiary
//
//  Created by 黃侯弼 on 2022/1/3.
//

import UIKit
import CoreData
import UserNotifications
import Foundation

class AddFriendsBirthdayTableViewController: UITableViewController {

    var friendsBirthday: FriendsBirthday!
    @IBOutlet var addFriendsBirthdayTableView: AddFriendsBirthdayTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //按空白處，隱藏鍵盤
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    //MARK: -- 照片選取
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
                (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .camera
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            
            let photoLibraryAction = UIAlertAction(title: "Photo library", style: .default, handler: {
                (action) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)
            
            //For ipad
            if let popoverController = photoSourceRequestController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            
            present(photoSourceRequestController, animated: true, completion: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: false)

    }
    
    @IBAction func saveButtonTapped(segue: UIStoryboardSegue) {
        let nameText = addFriendsBirthdayTableView.nameTextField.text

        if(nameText == "") {
            let blankController = UIAlertController(title: "Oops", message: "Some of fields is blank", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {_ in })
            blankController.addAction(okAction)
            
            present(blankController, animated: true, completion: nil)
        }
        else {
            print("Name: \(nameText ?? "")")

            //取得所選日期
            let currentDate = addFriendsBirthdayTableView.datePicker.date
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) { //取得AppDelegate Object
                friendsBirthday = FriendsBirthday(context: appDelegate.persistentContainer.viewContext)
                friendsBirthday.name = addFriendsBirthdayTableView.nameTextField.text!
                friendsBirthday.date = currentDate
                
                if let imageData = addFriendsBirthdayTableView.photoImageView.image?.pngData() {
                    friendsBirthday.image = imageData
                }
                
                print("Saving data to context...")
                appDelegate.saveContext()
            }
            
            //加入時間通知
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM"
            let month = dateFormatter.string(from: currentDate) //取得所選到的月份
            dateFormatter.dateFormat = "dd"
            let day = dateFormatter.string(from: currentDate) //取得所選到的日

            //設定通知內容
            let content = UNMutableNotificationContent()
            content.title = "您有朋友今天生日"
            content.body = "\(friendsBirthday.name)於\(month)月\(day)日生日，為他慶生吧！"
            content.sound = UNNotificationSound.default
                        
            //取得月、日、時、分
            var date = DateComponents()
            date.month = Int(month)
            date.day = Int(day)
            date.hour = 7
            date.minute = 7

            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true) //行事曆追蹤器
            
            //設定每一個通知的identifier，以便刪除好友資訊時，順便刪除通知
            let notificationIdentfier:String = "freind_\(friendsBirthday.name)_\(friendsBirthday.date)"
            
            friendsBirthday.notificationIdentifier = notificationIdentfier //將識別碼存進資料庫
            
            let request = UNNotificationRequest(identifier: notificationIdentfier, content: content, trigger: trigger) //設定通知要求
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil) //新增通知
            
            dismiss(animated: true, completion: nil)
        }
        
    }
}

//把索取到的照片顯示出來
extension AddFriendsBirthdayTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            addFriendsBirthdayTableView.photoImageView.image = selectedImage
            addFriendsBirthdayTableView.photoImageView.contentMode = .scaleAspectFill
            addFriendsBirthdayTableView.photoImageView.clipsToBounds = true
        }
        
        dismiss(animated: true, completion: nil)
    }
}
