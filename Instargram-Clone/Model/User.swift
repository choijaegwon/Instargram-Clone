//
//  User.swift
//  Instargram-Clone
//
//  Created by Jae kwon Choi on 2022/10/02.
//

import Foundation
import Firebase

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
    
    func follow() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
    
        // add followed user to current user-following structure
        USER_FOLLOWING_REF.child(currentUid).updateChildValues([uid: 1])
        
        // add current user to followed user-follower structure
        USER_FOLLOWER_REF.child(uid).updateChildValues([currentUid: 1])
    
    }
    
    func unfollow() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
    
        USER_FOLLOWING_REF.child(currentUid).child(uid).removeValue()
        
        USER_FOLLOWER_REF.child(uid).child(currentUid).removeValue()
    
    }
    
}
