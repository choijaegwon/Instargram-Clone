//
//  EditProfileController.swift
//  Instargram-Clone
//
//  Created by Jae kwon Choi on 2022/10/15.
//

import UIKit
import Firebase

class EditProfileController: UIViewController {
        
    // MARK: - Properties
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Profile Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleChangeProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .left
        tf.borderStyle = .none
        return tf
    }()
    
    let fullnameTextField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .left
        tf.borderStyle = .none
        return tf
    }()
    
    let fullnameLabel: UILabel = {
        let label = UILabel()
        label.text = "Full Name"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let fullnameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let usernameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureNavigationBar()
        
        configureViewComponents()
    }
    
    // MARK: - Handlers
    
    @objc func handleChangeProfilePhoto() {
        print(#function)
    }
    
    @objc func handleCancel() {
        print(#function)
    }
    
    @objc func handleDone() {
        print(#function)
    }
    
    func configureViewComponents() {
        
        view.backgroundColor = .white
        
        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 150)
        let containerView = UIView(frame: frame)
        containerView.backgroundColor = UIColor.systemGroupedBackground
        view.addSubview(containerView)
        
        containerView.addSubview(profileImageView)
        profileImageView.anchor(top: containerView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 0, paddingBottm: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        profileImageView.layer.cornerRadius = 80 / 2
        
        containerView.addSubview(changePhotoButton)
        changePhotoButton.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottm: 0, paddingRight: 0, width: 0, height: 0)
        changePhotoButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        containerView.addSubview(separatorView)
        separatorView.anchor(top: nil, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottm: 0, paddingRight: 0, width: 0, height: 0.5)
        
        view.addSubview(fullnameLabel)
        fullnameLabel.anchor(top: containerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 12, paddingBottm: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(usernameLabel)
        usernameLabel.anchor(top: fullnameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 12, paddingBottm: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(fullnameTextField)
        fullnameTextField.anchor(top: containerView.bottomAnchor, left: fullnameLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 12, paddingBottm: 0, paddingRight: 12, width: (view.frame.width / 1.6), height: 0)
        
        view.addSubview(usernameTextField)
        usernameTextField.anchor(top: fullnameTextField.bottomAnchor, left: usernameLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 12, paddingBottm: 0, paddingRight: 12, width: (view.frame.width / 1.6), height: 0)
        
        view.addSubview(fullnameSeparatorView)
        fullnameSeparatorView.anchor(top: nil, left: fullnameTextField.leftAnchor, bottom: fullnameTextField.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottm: -8, paddingRight: 12, width: 0, height: 0.5)
        
        view.addSubview(usernameSeparatorView)
        usernameSeparatorView.anchor(top: nil, left: usernameTextField.leftAnchor, bottom: usernameTextField.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottm: -8, paddingRight: 12, width: 0, height: 0.5)
        
    }
    
    func configureNavigationBar() {
        
        navigationItem.title = "Edit Profile"
        
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleDone))
    }
    
    // MARK: - API




}
