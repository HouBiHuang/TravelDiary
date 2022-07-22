//
//  DiaryDetailViewController.swift
//  TravelDiary
//
//  Created by 黃侯弼 on 2022/7/22.
//

import UIKit

class DiaryDetailViewController: UIViewController {
    
    var diary:Diary!
    @IBOutlet var diaryDetailView: DiaryDetailView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        diaryDetailView.titleLabel?.text = diary.title
        diaryDetailView.contentTextView?.text = diary.content
        diaryDetailView.diaryImage?.image = UIImage(data: diary.image)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
