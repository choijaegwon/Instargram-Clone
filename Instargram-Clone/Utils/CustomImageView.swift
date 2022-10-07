//
//  CustomImageView.swift
//  Instargram-Clone
//
//  Created by Jae kwon Choi on 2022/10/08.
//

import UIKit

// 캐쉬이미지 여부
var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastImgUrlUsedToLoadImage: String?
    
    func loadImage(with urlString: String) {
        
        // set image to nil
        // 깜박임을 발생하지 않게 하기 위한 설정
        self.image = nil
        
        // set lastImgUrlUsedToLoadImage
        lastImgUrlUsedToLoadImage = urlString
        
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
            
            // 이미지를 로드하는데 사용되는 이미지와 실제로 로드되는 포스트이미지와 동일하게 설정
            if self.lastImgUrlUsedToLoadImage != url.absoluteString {
                return
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
