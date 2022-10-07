//
//  Constants.swift
//  Instargram-Clone
//
//  Created by Jae kwon Choi on 2022/10/03.
//

import Firebase

// MARK: - Root References

let DB_REF = Database.database().reference()


// MARK: - Database References

let USER_REF = DB_REF.child("users")

let USER_FOLLOWER_REF = DB_REF.child("user-followers")
let USER_FOLLOWING_REF = DB_REF.child("user-following")

let POSTS_REF = DB_REF.child("posts")
let USER_POSTS_REF = DB_REF.child("user-posts")
