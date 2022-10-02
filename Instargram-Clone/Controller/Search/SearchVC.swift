//
//  SearchVC.swift
//  Instargram-Clone
//
//  Created by Jae kwon Choi on 2022/09/30.
//

import UIKit

private let reuseIdentifier = "SearchUserCell"

class SearchVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register cell 등록
        tableView.register(SearchUserCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // separator insets
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 64, bottom: 0, right: 0)
        
        configureNavController()
        
    }

    // MARK: - Table view data source
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchUserCell
        return cell
    }
    
    // MARK: - Hanlers
    func configureNavController() {
        navigationItem.title = "Explore"
    }


}
