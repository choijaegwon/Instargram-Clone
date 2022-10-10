//
//  FeedVC.swift
//  Instargram-Clone
//
//  Created by Jae kwon Choi on 2022/09/30.
//

import UIKit
import Firebase
import FirebaseAuth

private let reuseIdentifier = "Cell"

class FeedVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, FeedCellDelegate {

    // MARK: - Properties
    
    var posts = [Post]()
    var viewSinglePost = false
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 배경을 흰색으로 바꾸기
        collectionView.backgroundColor = .white
        
        // register cell classes
        self.collectionView!.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // 리플레쉬 기능 추가
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        // configure logout button
        configureNavigationBar()

        // 단일 게시물이 아니면 전체를 가져오기
        if !viewSinglePost {
            fetchPosts()
        }
        
        updateuserFeeds()
    }
    
    // MARK: - UICollectionViewFlowLayout
    
    // 높이설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 50
        height += 60
        
        return CGSize(width: width, height: height)
    }

    
    // MARK: -  UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if viewSinglePost {
            return 1
        } else {
            return posts.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.delegate = self
        
        if viewSinglePost {
            if let post = self.post {
                cell.post = post
            }
        } else {
            cell.post = posts[indexPath.item]
        }
        
        return cell
    }
    
    // MARK: - FeedCellDelegate Protocol
    
    func handleUsernameTapped(for cell: FeedCell) {
        
        guard let post = cell.post else { return }
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileVC.user = post.user
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    func handleOptionsTapped(for cell: FeedCell) {
        print(#function)
    }
    
    func handleLikeTapped(for cell: FeedCell) {
        print(#function)
    }
    
    func handleCommentTapped(for cell: FeedCell) {
        print(#function)
    }

    // MARK: - Handlers
    
    @objc func handleRefresh() {
        posts.removeAll(keepingCapacity: false)
        fetchPosts()
        collectionView.reloadData()
    }
    
    @objc func handleShowMessages() {
        print("Handle show messages")
    }
    
    func configureNavigationBar() {
        
        // 단일 게시물이 아닐때만 로그아웃버튼을 보여줌. 단일 게시물이면 로그아웃을 숨긴다.
        if !viewSinglePost {
            // 로그아웃 버튼
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        }
        
        // 메시지 버튼
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "send2"), style: .plain, target: self, action: #selector(handleShowMessages))
        
        // 가운에 이름
        self.navigationItem.title = "Feed"
    }
    
    // MARK: - objc 함수
    
    @objc func handleLogout() {
        
        // declare alert controller
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // add alert logout action
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            
            do {
                // attempt sign out
                try Auth.auth().signOut()
                
                // present login controller
                let loginVC = LoginVC()
                let navController = UINavigationController(rootViewController: loginVC)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
                
                print("로그아웃 성공")
            
            } catch {
                // handle error
                print("Falied to sign out")
            }
        }))
        
        // add cancel action
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: - API
    
    func updateuserFeeds() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        USER_FOLLOWING_REF.child(currentUid).observe(.childAdded) { snapshot in
            
            let followingUserId = snapshot.key
            
            USER_POSTS_REF.child(followingUserId).observe(.childAdded) { snapshot in
                
                let postId = snapshot.key
                
                USER_FEED_REF.child(currentUid).updateChildValues([postId: 1])
            }
        }
        
        USER_POSTS_REF.child(currentUid).observe(.childAdded) { snapshot in
            
            let postId = snapshot.key
            
            USER_FEED_REF.child(currentUid).updateChildValues([postId: 1])
        }
    }
    
    func fetchPosts() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        USER_FEED_REF.child(currentUid).observe(.childAdded) { snapshot in
            
            let postId = snapshot.key
            
            Database.fetchPost(with: postId) { post in
                self.posts.append(post)
                self.posts.sort { post1, post2 in
                    return post1.creationDate > post2.creationDate
                }
                
                // 리플레쉬 멈추기
                self.collectionView.refreshControl?.endRefreshing()
                
                self.collectionView.reloadData()
            }
        }
    }
}
