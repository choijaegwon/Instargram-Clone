//
//  FeedVC.swift
//  Instargram-Clone
//
//  Created by Jae kwon Choi on 2022/09/30.
//

import UIKit
import FirebaseAuth

private let reuseIdentifier = "Cell"

class FeedVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    // MARK: - Properties
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 배경을 흰색으로 바꾸기
        collectionView.backgroundColor = .white
        
        // register cell classes
        self.collectionView!.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // configure logout button
        configureNavigationBar()

        // fetch posts
        fetchPosts()
        
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
        // #warning Incomplete implementation, return the number of items
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.post = posts[indexPath.row]
        return cell
    }

    // MARK: - Handlers
    
    @objc func handleShowMessages() {
        print("Handle show messages")
    }
    
    func configureNavigationBar() {
        
        // 로그아웃 버튼
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
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
    
    func fetchPosts() {
        POSTS_REF.observe(.childAdded) { snapshot in
            
            let postId = snapshot.key
            
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            let post = Post(postId: postId, dictionary: dictionary)
            
            self.posts.append(post)
            self.posts.sort { post1, post2 in
                return post1.creationDate > post2.creationDate
            }
            self.collectionView.reloadData()
        }
    }



    
}
