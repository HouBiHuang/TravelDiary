//
//  NewDiaryTableViewController.swift
//  TravelDiary
//
//  Created by 黃侯弼 on 2021/12/13.
//

import UIKit
import CoreData

class NewDiaryTableViewController: UITableViewController {

    var diary: Diary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //按空白處，隱藏鍵盤
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @IBOutlet var contentTextField: UITextField!
    
    @IBOutlet var photoImageView: UIImageView! {
        didSet {
            photoImageView.layer.cornerRadius = 10.0
            photoImageView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet var datePicker: UIDatePicker!
    
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
        let contentText = contentTextField.text

        if(contentText == "") {
            let blankController = UIAlertController(title: "Oops", message: "Some of fields is blank", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {_ in })
            blankController.addAction(okAction)
            
            present(blankController, animated: true, completion: nil)
        }
        else {
            print("Name: \(contentText ?? "")")

            //取得所選日期
            let currentDate = self.datePicker.date
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) { //取得AppDelegate Object
                diary = Diary(context: appDelegate.persistentContainer.viewContext)
                diary.content = contentTextField.text!
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
