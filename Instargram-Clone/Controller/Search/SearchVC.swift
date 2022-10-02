//
//  SearchVC.swift
//  Instargram-Clone
//
//  Created by Jae kwon Choi on 2022/09/30.
//

import UIKit
import Firebase

private let reuseIdentifier = "SearchUserCell"

class SearchVC: UITableViewController {
    
    // MARK: - Properties
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register cell 등록
        tableView.register(SearchUserCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // separator insets
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 64, bottom: 0, right: 0)
        
        // 네비컨트롤러 설정
        configureNavController()
        
        // 유져 정보 가져오기
        fetchUsers()
        
    }

    // MARK: - Table view data source
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchUserCell
        cell.user = users[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        print("Username is \(user.username)")
    }
    
    // MARK: - Hanlers
    func configureNavController() {
        navigationItem.title = "Explore"
    }
    
    // MARK: - API
    func fetchUsers() {
        
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            
            // uid
            let uid = snapshot.key
            
            // snapshot value cast as dictionary
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            // construct user
            let user = User(uid: uid, dictionary: dictionary)
            
            // append user to data soure
            self.users.append(user)
            
            // reload our table view
            self.tableView.reloadData()
           
        }
    }



}
