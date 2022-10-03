//
//  FollowVC.swift
//  Instargram-Clone
//
//  Created by Jae kwon Choi on 2022/10/03.
//

import UIKit
import Firebase

private let reuseIdentifer = "FollowCell"

class FollowVC: UITableViewController {
    
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
        cell.contentView.isUserInteractionEnabled = false
        return cell
    }
    
    func fetchUsers() {
        
        guard let uid = self.uid else { return }
        var ref: DatabaseReference!
        
        if viewFollowers {
            ref = USER_FOLLOWER_REF
        } else {
            ref = USER_FOLLOWING_REF
        }
        
        ref.child(uid).observe(.childAdded) { (snapshot) in
            
            let userId = snapshot.key
            
            USER_REF.child(userId).observeSingleEvent(of: .value) { (snapshot) in
                
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                
                let user = User(uid: userId, dictionary: dictionary)
                
                self.users.append(user)
                self.tableView.reloadData()
                
            }
        }
        
    }
}
