//
//  FollowVC.swift
//  Instargram-Clone
//
//  Created by Jae kwon Choi on 2022/10/03.
//

import UIKit
import Firebase

private let reuseIdentifer = "FollowCell"

class FollowVC: UITableViewController, FollowCellDelegate {
    
    // MARK: - Properties
    
    var viewFollowers = false
    var viewFollowing = false
    var uid: String?
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FollowCell 등록
        tableView.register(FollowCell.self, forCellReuseIdentifier: reuseIdentifer)
        
        // configure nav controller
        if viewFollowers {
            navigationItem.title = "Followers"
        } else {
            navigationItem.title = "Following"
        }
        
        // 테이블뷰에 구분선 없애기
        tableView.separatorColor = .clear
        
        // fetch users
        fetchUsers()
 
    }
    
    // MARK: - UITableView
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! FollowCell
        cell.user = users[indexPath.row]
        // 셀 안에 버튼이 안눌려서 추가한 코드
        cell.delegate = self
        cell.contentView.isUserInteractionEnabled = false
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = users[indexPath.row]
        
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        
        userProfileVC.user = user
        
        navigationController?.pushViewController(userProfileVC, animated: true)
        
    }
    
    // MARK: - FollowCellDelegate Protocol
    func handleFollowTapped(for cell: FollowCell) {
        
        guard let user = cell.user else { return }
        
        if user.isFollowed {
            user.unfollow()
            
            // configure follow button for non followed user
            cell.followButton.setTitle("Follow", for: .normal)
            cell.followButton.setTitleColor(.white, for: .normal)
            cell.followButton.layer.borderWidth = 0
            cell.followButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
            
        } else {
            user.follow()
            
            // configure follow button for followed user
            cell.followButton.setTitle("Following", for: .normal)
            cell.followButton.setTitleColor(.black, for: .normal)
            cell.followButton.layer.borderWidth = 0.5
            cell.followButton.layer.borderColor = UIColor.lightGray.cgColor
            cell.followButton.backgroundColor = .white
        }
    }

    
    // MARK: - API
    
    func fetchUsers() {
        
        guard let uid = self.uid else { return }
        var ref: DatabaseReference!
        
        if viewFollowers {
            ref = USER_FOLLOWER_REF
        } else {
            ref = USER_FOLLOWING_REF
        }
        
        ref.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            allObjects.forEach { (snapshot) in
                
                let userId = snapshot.key
                
                Database.fetchUser(with: userId) { (user) in
                    
                    self.users.append(user)
                    
                    self.tableView.reloadData()
                }
                
            }
        }
        
    }
}
