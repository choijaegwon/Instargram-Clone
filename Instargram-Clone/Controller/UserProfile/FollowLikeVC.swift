//
//  FollowVC.swift
//  Instargram-Clone
//
//  Created by Jae kwon Choi on 2022/10/03.
//

import UIKit
import Firebase

private let reuseIdentifer = "FollowCell"

class FollowLikeVC: UITableViewController, FollowCellDelegate {
    
    // MARK: - Properties
    
    var followCurrentKey: String?
    var likeCurrentKey: String?
    
    enum ViewingMode: Int {
        
        case Following
        case Followers
        case Likes
        
        init(index: Int) {
            switch index {
            case 0: self = .Following
            case 1: self = .Followers
            case 2: self = .Likes
            default: self = .Following
            }
        }
    }
    
    var postId: String?
    var viewFollowers = false
    var viewFollowing = false
    var viewingMode: ViewingMode!
    var uid: String?
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FollowCell 등록
        tableView.register(FollowLikeCell.self, forCellReuseIdentifier: reuseIdentifer)
        
        // configure nav title
        configureNavigationTitle()
        
        // fetch users
        fetchUsers()
        
        
        // 테이블뷰에 구분선 없애기
        tableView.separatorColor = .clear
        
    }
    
    // MARK: - UITableView
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if users.count > 3 {
            if indexPath.item == users.count - 1{
                fetchUsers()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! FollowLikeCell
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
    func handleFollowTapped(for cell: FollowLikeCell) {
        
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
    
    // MARK: - Handlers
    
    func configureNavigationTitle() {
        
        guard let viewingMode = self.viewingMode else { return }
        
        switch viewingMode {
        case .Followers: navigationItem.title = "Followers"
        case .Following: navigationItem.title = "Following"
        case .Likes: navigationItem.title = "Likes"
        }
        
    }


    
    // MARK: - API
    
    func getDatabaseReference() -> DatabaseReference? {
        
        guard let viewingMode = self.viewingMode else { return nil }
        
        switch viewingMode {
        case .Followers: return USER_FOLLOWER_REF
        case .Following: return USER_FOLLOWING_REF
        case .Likes: return POST_LIKES_REF
        }
    }
    
    func fetchUser(with uid: String) {
        Database.fetchUser(with: uid) { (user) in
            self.users.append(user)
            self.tableView.reloadData()
        }
    }
    
    func fetchUsers() {
        guard let ref = getDatabaseReference() else { return }
        guard let viewingMode = self.viewingMode else { return }
        
        switch viewingMode {
            
        case .Followers, .Following :
            guard let uid = self.uid else { return }
            
            if followCurrentKey == nil {
                ref.child(uid).queryLimited(toLast: 4).observeSingleEvent(of: .value) { snapshot in
                    guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                    guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                    
                    allObjects.forEach { snapshot in
                        let followUid = snapshot.key
                        self.fetchUser(with: followUid)
                    }
                    self.followCurrentKey = first.key
                }
            } else {
                
                ref.child(uid).queryOrderedByKey().queryEnding(atValue: self.followCurrentKey).queryLimited(toLast: 5).observeSingleEvent(of: .value) { snapshot in
                    
                    guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                    guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                    
                    allObjects.forEach { snapshot in
                        let followUid = snapshot.key
                        
                        if followUid != self.followCurrentKey {
                            self.fetchUser(with: followUid)
                        }
                    }
                    self.followCurrentKey = first.key
                }
            }
        
            
        case .Likes:
            guard let postId = self.postId else { return }
            
            if likeCurrentKey == nil {
                ref.child(postId).queryLimited(toLast: 4).observeSingleEvent(of: .value) { snapshot in
                    guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                    guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                    
                    allObjects.forEach { snapshot in
                        let likeUid = snapshot.key
                        self.fetchUser(with: likeUid)
                    }
                    self.likeCurrentKey = first.key
                }
            } else {
                ref.child(postId).queryOrderedByKey().queryEnding(atValue: self.likeCurrentKey).queryLimited(toLast: 5).observeSingleEvent(of: .value) { snapshot in
                    
                    guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                    guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                    
                    allObjects.forEach { snapshot in
                        let likeUid = snapshot.key
                        
                        if likeUid != self.likeCurrentKey {
                            self.fetchUser(with: likeUid)
                        }
                    }
                    self.likeCurrentKey = first.key
                }
            }

        }
    }
}
