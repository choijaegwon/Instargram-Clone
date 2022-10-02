//
//  Extensions.swift
//  Instargram-Clone
//
//  Created by Jae kwon Choi on 2022/09/27.
//

import UIKit

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottm: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        // 위에서 얼마나 떨어졌는지
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        // 왼쪽에서 얼마나 떨어졌는지
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        // 아래서 얼마나 떨어졌는지
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottm).isActive = true
        }
        
        // 오른쪽에서  얼마나 떨어졌는지
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        // 넓이
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        // 높이
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }
}

// 캐쉬이미지 여부
var imageCache = [String: UIImage]()

extension UIImageView {
    
    func loadImage(with urlString: String) {
        
        // 캐쉬이미지가 존재하는 경우
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        
        // 캐쉬이미지가 존재하지 않는 경우
        
        // url for image location
        guard let url = URL(string: urlString) else { return }
        
        // fetch contents of URL
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // handle error
            if let error = error {
                print("Failed to lad image with error", error.localizedDescription)
            }
            
            // image data
            guard let imageData = data else { return }
            
            // create image using image data
            let photoImage = UIImage(data: imageData)
            
            // set key and value for image cache
            imageCache[url.absoluteString] = photoImage
            
            // set image
            DispatchQueue.main.async {
                self.image = photoImage
            }
        }.resume()
    }
    
}
