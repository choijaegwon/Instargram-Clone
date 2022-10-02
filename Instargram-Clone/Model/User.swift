//
//  User.swift
//  Instargram-Clone
//
//  Created by Jae kwon Choi on 2022/10/02.
//

import Foundation

class User {
    
    // attributes
    var username: String!
    var name: String!
    var profileImageUrl: String!
    var uid: String!
    
    init(uid: String, dictionary: Dictionary<String, AnyObject>) {
    
        self.uid = uid
        
        if let username = dictionary["username"] as? String {
            self.username = username
        }
        
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        
        if let profileImageUrl = dictionary["profileImageUrl"] as? String {
            self.profileImageUrl = profileImageUrl
        }
    }
    
}
