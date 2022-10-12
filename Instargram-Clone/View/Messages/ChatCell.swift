//
//  ChatCell.swift
//  Instargram-Clone
//
//  Created by Jae kwon Choi on 2022/10/13.
//

import Foundation
import UIKit

class ChatCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
