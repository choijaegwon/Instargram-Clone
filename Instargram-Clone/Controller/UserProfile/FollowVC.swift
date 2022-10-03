//
//  FollowVC.swift
//  Instargram-Clone
//
//  Created by Jae kwon Choi on 2022/10/03.
//

import UIKit

private let reuseIdentifer = "FollowCell"

class FollowVC: UITableViewController {
    
    // MARK: - Properties
    
    var viewFollowers = false
    var viewFollowing = false
    
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
    }
    
    // MARK: - UITableView
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! FollowCell
        cell.contentView.isUserInteractionEnabled = false
        return cell
    }
}
