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
    
    var timer: Timer?
    var currentKey: String?
    
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if notifiations.count > 9 {
            if indexPath.item == notifiations.count - 1 {
                fetchNotifications()
            }
        }
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
            
            // handle unfollow user
            user.unfollow()
            cell.followButton.configure(didFollow: false)
        } else {
            
            // hnadle follow user
            user.follow()
            cell.followButton.configure(didFollow: true)
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
    
    // MARK: - Handlers
    
    func handleReloadTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleSortNotifications), userInfo: nil, repeats: false)
    }
    
    @objc func handleSortNotifications() {
        self.notifiations.sort { notification1, notification2 in
            return notification1.creationDate > notification2.creationDate
        }
        self.tableView.reloadData()
    }
    
    // MARK: - API
    
    func fetchNotifications(withNotificationId notificationId: String, dataSnapshot snapshot: DataSnapshot) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
        guard let uid = dictionary["uid"] as? String else { return }
        
        Database.fetchUser(with: uid) { user in
            // if norification is for post
            if let postId = dictionary["postId"] as? String {
                Database.fetchPost(with: postId) { post in
                    
                    let norification = Notification(user: user, post: post, dictionary: dictionary)
                    self.notifiations.append(norification)
                    self.handleReloadTable()
                }
            } else {
                let notification = Notification(user: user, dictionary: dictionary)
                self.notifiations.append(notification)
                self.handleReloadTable()
            }
        }
        NOTIFICATIONS_REF.child(currentUid).child(notificationId).child("checked").setValue(1)
    }

    
    func fetchNotifications() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        if currentKey == nil {
            NOTIFICATIONS_REF.child(currentUid).queryLimited(toLast: 10).observeSingleEvent(of: .value) { snapshot in
            
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach { snapshot in
                    let notificationId = snapshot.key
                    self.fetchNotifications(withNotificationId: notificationId, dataSnapshot: snapshot)
                }
                self.currentKey = first.key
            }
        } else {
            
            NOTIFICATIONS_REF.child(currentUid).queryOrderedByKey().queryEnding(atValue: self.currentKey).queryLimited(toLast: 9).observeSingleEvent(of: .value) { snapshot in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach { snapshot in
                    let notificationId = snapshot.key

                    if notificationId != self.currentKey {
                        self.fetchNotifications(withNotificationId: notificationId, dataSnapshot: snapshot)
                    }
                }
                self.currentKey = first.key
            }
        }
    }
}
