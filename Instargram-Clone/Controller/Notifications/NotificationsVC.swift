//
//  NotificationsVC.swift
//  Instargram-Clone
//
//  Created by Jae kwon Choi on 2022/09/30.
//

import UIKit
import Firebase

private let resueIdentifer = "NotificationCell"

class NotificationsVC: UITableViewController {
    
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
        return cell
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
