//
//  NotificationsVC.swift
//  Instargram-Clone
//
//  Created by Jae kwon Choi on 2022/09/30.
//

import UIKit
import Firebase

private let resueIdentifer = "NotificationCell"

class NotificationsVC: UITableViewController, NotificationCellDelegate {
    
    // MARK: - Properties
    
    var notifiations = [Notification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // clear separator lines
        tableView.separatorColor = .clear
        
        // nav title
        navigationItem.title = "Notifications"
        
        // register cell class
        tableView.register(NotificationCell.self, forCellReuseIdentifier: resueIdentifer)
        
        // fetch Notifications
        fetchNotifications()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifiations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: resueIdentifer, for: indexPath) as! NotificationCell
        cell.notification = notifiations[indexPath.row]
        
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifiations[indexPath.row]
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        
        userProfileVC.user = notification.user
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    // MARK: - NotificationCellDelegate Protocol
    
    // 알람에서 팔로우버튼
    func handleFollowTapped(for cell: NotificationCell) {
        
        guard let user = cell.notification?.user else { return }
        
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
    
    // 알람에서 사진을 누르면 그 포스트로 이동
    func handlePostTapped(for cell: NotificationCell) {
            
        guard let post = cell.notification?.post else { return }
        
        let feedController = FeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        feedController.viewSinglePost = true
        feedController.post = post
        navigationController?.pushViewController(feedController, animated: true)
    }

    
    // MARK: - API
    
    func fetchNotifications() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        NOTIFICATIONS_REF.child(currentUid).observe(.childAdded) { snapshot in
            
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            Database.fetchUser(with: uid) { user in
                
                // if norification is for post
                if let postId = dictionary["postId"] as? String {
                    Database.fetchPost(with: postId) { post in
                        
                        let norification = Notification(user: user, post: post, dictionary: dictionary)
                        self.notifiations.append(norification)
                        self.tableView.reloadData()
                    }
                } else {
                    let notification = Notification(user: user, dictionary: dictionary)
                    self.notifiations.append(notification)
                    self.tableView.reloadData()
                }
                
            }
            
        }
        
    }

    
}
