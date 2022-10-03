//
//  UserProfileVC.swift
//  Instargram-Clone
//
//  Created by Jae kwon Choi on 2022/09/30.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"
private let headerIdentifier = "UserProfileHeader"

class UserProfileVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate {

    // MARK: - Properties
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)

        // background color
        self.collectionView.backgroundColor = .white
        
        // fetch user data
        if self.user == nil {
            fetchCurrentUserData()
        }
        
        
        
    }
   
    // MARK: -  UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }
    
    // 지정된 섹션의 헤더뷰의 크기를 반환하는 메서드.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    // 컬렉션의 헤더 요소를 컬렉션에 선언
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // declare header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! UserProfileHeader
        
        // set delegate
        header.delegate = self
        
        // set the user in header
        header.user = self.user
        navigationItem.title = user?.username
        
        // return header
        return header
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

    // MARK: - UserProfileHeader Protocol
    
    func handleFollowersTapped(for header: UserProfileHeader) {
        let followVC = FollowVC()
        followVC.viewFollowers = true
        followVC.uid = user?.uid
        navigationController?.pushViewController(followVC, animated: true)
    }
    
    func handleFollowingTapped(for header: UserProfileHeader) {
        let followVC = FollowVC()
        followVC.viewFollowing = true
        followVC.uid = user?.uid
        navigationController?.pushViewController(followVC, animated: true)
    }
    
    
    func handleEditFollowTapped(for header: UserProfileHeader) {
        guard let user = header.user else { return }

        if header.editProfileFollowButton.titleLabel?.text == "Edit Profile" {
            print("handle edit profile")
        } else {
            if header.editProfileFollowButton.titleLabel?.text == "Follow" {
                header.editProfileFollowButton.setTitle("Following", for: .normal)
                user.follow()
            } else {
                header.editProfileFollowButton.setTitle("Follow", for: .normal)
                user.unfollow()
            }
        }
    }
    
    func setUserStats(for header: UserProfileHeader) {
        guard let uid = header.user?.uid else { return }
        
        var numberOfFollwers: Int!
        var numberOfFollowing: Int!
        
        // get number of followers
        // observe(.value) -> 데이터베이스에서 변경되는 모든 이벤트를 수신함
        USER_FOLLOWER_REF.child(uid).observe(.value) { (snapshot) in
            
            if let snapshot = snapshot.value as? Dictionary<String, AnyObject> {
                numberOfFollwers = snapshot.count
            } else {
                numberOfFollwers = 0
            }
            
            let attributedText = NSMutableAttributedString(string: "\(numberOfFollwers!)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
            
            header.followersLabel.attributedText = attributedText
        }
        
        // get number of following
        USER_FOLLOWING_REF.child(uid).observe(.value) { (snapshot) in
            
            if let snapshot = snapshot.value as? Dictionary<String, AnyObject> {
                numberOfFollowing = snapshot.count
            } else {
                numberOfFollowing = 0
            }
            
            
            
            let attributedText = NSMutableAttributedString(string: "\(numberOfFollowing!)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "followering", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
            
            header.followingLabel.attributedText = attributedText
        }    }

    
    // MARK: - API
    
    func fetchCurrentUserData() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("users").child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            self.user = user
            self.navigationItem.title = user.username
            self.collectionView.reloadData()
            
        }
    }



}
