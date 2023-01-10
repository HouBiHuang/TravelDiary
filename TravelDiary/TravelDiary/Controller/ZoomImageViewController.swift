//
//  ZoomImageViewController.swift
//  TravelDiary
//
//  Created by 黃侯弼 on 2021/12/14.
//

import UIKit

class ZoomImageViewController: UIViewController {

    @IBOutlet var zoomImageView: ZoomImageView!
    var imageName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        zoomImageView.scrollView.maximumZoomScale = 4
        zoomImageView.scrollView.minimumZoomScale = 1
        
        zoomImageView.scrollView.delegate = self
        
        zoomImageView.imageView.image = UIImage(named: imageName ?? "")
        
        let scrollViewGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(scrollViewGestureFired(_:))) //宣告滑動手勢辨識器
        scrollViewGestureRecognizer.direction = .down //方向為向下
        scrollViewGestureRecognizer.numberOfTouchesRequired = 1 //滑動1次即觸發
        zoomImageView.scrollView.addGestureRecognizer(scrollViewGestureRecognizer) //將滑動手勢辨識器加在scrollView上
        zoomImageView.scrollView.isUserInteractionEnabled = true //啟用
        
        let imageViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewGestureFired(_:)))
        imageViewGestureRecognizer.numberOfTapsRequired = 1
        zoomImageView.imageView.addGestureRecognizer(imageViewGestureRecognizer)
        zoomImageView.imageView.isUserInteractionEnabled = true
        
    }
    
    @objc func scrollViewGestureFired(_ gesture: UISwipeGestureRecognizer) {
        dismiss(animated: true, completion: nil) //關閉畫面
    }
    
    @objc func imageViewGestureFired(_ gesture: UITapGestureRecognizer) {
        zoomImageView.scrollView.zoomScale = 1 //回到初始狀態
    }
}

extension ZoomImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomImageView.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = zoomImageView.imageView.image {
                let ratioW = zoomImageView.imageView.frame.width / image.size.width
                let ratioH = zoomImageView.imageView.frame.height / image.size.height
                
                let ratio = ratioW < ratioH ? ratioW : ratioH
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                
                let conditionLeft = newWidth * scrollView.zoomScale > zoomImageView.imageView.frame.width
                let left = 0.5 * (conditionLeft ? (newWidth - zoomImageView.imageView.frame.width) : (scrollView.frame.width - scrollView.contentSize.width))
                
                let conditionTop = newHeight * scrollView.zoomScale > zoomImageView.imageView.frame.height
                let top = 0.5 * (conditionTop ? (newHeight - zoomImageView.imageView.frame.height) : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
}
