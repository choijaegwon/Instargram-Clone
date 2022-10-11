//
//  NotificationsVC.swift
//  Instargram-Clone
//
//  Created by Jae kwon Choi on 2022/09/30.
//

import UIKit

private let resueIdentifer = "NotificationCell"

class NotificationsVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // clear separator lines
        tableView.separatorColor = .clear
        
        // nav title
        navigationItem.title = "Notifications"
        
        // register cell class
        tableView.register(NotificationCell.self, forCellReuseIdentifier: resueIdentifer)
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: resueIdentifer, for: indexPath) as! NotificationCell
        
        return cell
    }
}
