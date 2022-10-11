//
//  NotificationCell.swift
//  Instargram-Clone
//
//  Created by Jae kwon Choi on 2022/10/11.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    // MARK: - Properties

    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "joker", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: " commented on your post", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        attributedText.append(NSAttributedString(string: " 2d.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        label.attributedText = attributedText
        label.numberOfLines = 2
        return label
    }()
    
    lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
    }()
    
    let postImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    // MARK: - Handlers
    
    @objc func handleFollowTapped() {
        print("Handle follow tapped")
    }
    
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottm: 0, paddingRight: 0, width: 40, height: 40)
        // 가운데 설정
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 40 / 2
        
        addSubview(followButton)
        followButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottm: 0, paddingRight: 12, width: 90, height: 30)
        // 버튼을 Y축의 가운대로 설정
        followButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        followButton.layer.cornerRadius = 3
        followButton.isHidden = true
        
        addSubview(postImageView)
        postImageView.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottm: 0, paddingRight: 8, width: 40, height: 40)
        postImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        addSubview(notificationLabel)
        notificationLabel.anchor(top: nil, left: profileImageView.rightAnchor, bottom: nil, right: postImageView
            .leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottm: 0, paddingRight: 8, width: 0, height: 0)
        notificationLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
