//
//  NewDiaryTableViewController.swift
//  TravelDiary
//
//  Created by 黃侯弼 on 2021/12/13.
//

import UIKit
import CoreData

class NewDiaryTableViewController: UITableViewController, UITextFieldDelegate {

    var diary: Diary!
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var contentTextView: UITextView! {
        didSet {
            if self.traitCollection.userInterfaceStyle == .dark {
                contentTextView.layer.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
                contentTextView.layer.borderColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
                contentTextView.layer.borderWidth = 1.0
                contentTextView.layer.cornerRadius = 5.0
            } else {
                contentTextView.layer.borderColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1).cgColor
                contentTextView.layer.borderWidth = 1.0
                contentTextView.layer.cornerRadius = 5.0
            }
        }
    }
    
    @IBOutlet var photoImageView: UIImageView! {
        didSet {
            photoImageView.layer.cornerRadius = 20.0
            photoImageView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet var datePicker: UIDatePicker!
    
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
        let titleText = titleTextField.text
        
        if(titleText == "") {
            let blankController = UIAlertController(title: "Oops", message: "Some of fields is blank", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {_ in })
            blankController.addAction(okAction)
            
            present(blankController, animated: true, completion: nil)
        }
        else {
            print("Name: \(titleText ?? "")")

            //取得所選日期
            let currentDate = self.datePicker.date
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) { //取得AppDelegate Object
                diary = Diary(context: appDelegate.persistentContainer.viewContext)
                diary.title = titleTextField.text!
                diary.content = contentTextView.text!
                diary.date = currentDate
                
                if let imageData = photoImageView.image?.pngData() {
                    diary.image = imageData
                }
                
                print("Saving data to context...")
                appDelegate.saveContext()
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
}

//把索取到的照片顯示出來
extension NewDiaryTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
        }
        
        dismiss(animated: true, completion: nil)
    }
}
