//
//  CommentCell.swift
//  Instargram-Clone
//
//  Created by Jae kwon Choi on 2022/10/11.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    var comment: Comment? {
        
        didSet {
            
            guard let user = comment?.user else { return }
            guard let profileImageUrl = user.profileImageUrl else { return }
            guard let username = user.username else { return }
            guard let commentText = comment?.commentText else { return }
            
            profileImageView.loadImage(with: profileImageUrl)
            
            let attributedText = NSMutableAttributedString(string: username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
            attributedText.append(NSAttributedString(string: " \(commentText)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]))
            attributedText.append(NSAttributedString(string: " 2d.", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
            
            commentLabel.attributedText = attributedText
            
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottm: 0, paddingRight: 0, width: 48, height: 48)
        // 가운데 설정
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 48 / 2
        
        addSubview(commentLabel)
        commentLabel.anchor(top: nil, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottm: 0, paddingRight: 8, width: 0, height: 0)
        // 가운데 설정
        commentLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        // 구분선 추가
        addSubview(separatorView)
        separatorView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 60, paddingBottm: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
