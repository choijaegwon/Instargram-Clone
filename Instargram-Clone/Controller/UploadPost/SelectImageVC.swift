//
//  SelectImageVC.swift
//  Instargram-Clone
//
//  Created by Jae kwon Choi on 2022/10/07.
//

import Foundation
import UIKit
import Photos

private let reuseIdentifier = "SelectPhotoCell"
private let headerIdentifier = "SelectPhotoHeader"

class SelectImageVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    var images = [UIImage]()
    var assets = [PHAsset]()
    var selectedImage: UIImage?
    var header: SelectPhotoHeader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // cell 등록
        collectionView.register(SelectPhotoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(SelectPhotoHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.backgroundColor = .white
        
        // configure nav buttons
        configureNavigationButtons()
        
        // fetch photos
        fetchPhotos()
    }
    
    // MARK: - UICollectionViewFlowLayout
    
    // 헤더의 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        
        return CGSize(width: width, height: width)
    }
    
    // 아래 셀에대한 각각의 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    // 옆의 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // 위, 아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! SelectPhotoHeader
        
        self.header = header
        
        if let selectedImage = self.selectedImage {
            
            // 선택한 이미지 사진화질 좋아지게 만듬
            if let index = self.images.firstIndex(of: selectedImage) {
                
                // asset associated with selected image
                let selectedAsses = self.assets[index]
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                
                // request image
                imageManager.requestImage(for: selectedAsses, targetSize: targetSize, contentMode: .default, options: nil) { image, info in
                    
                    header.photoImageView.image = selectedImage
                }
            }
        }
        
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SelectPhotoCell
        cell.photoImageView.image = images[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedImage = images[indexPath.row]
        self.collectionView.reloadData()
        
        // 사진을 선택하면 맨위로 올라가게 설정하기
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    // MARK: - Handlers
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNext() {
        let uploadPostVC = UploadPostVC()
        uploadPostVC.selectedImage = header?.photoImageView.image
        navigationController?.pushViewController(uploadPostVC, animated: true)
    }
    
    func configureNavigationButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
    }
    
    // MARK: - 사진 가져오기
    
    func getAssetFetchOptions() -> PHFetchOptions {
        
        let options = PHFetchOptions()
        
        // 가져오는사진 최대 개수
        options.fetchLimit = 30
        
        // 가져오는사진 정렬순서 날짜로정하기
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        
        // 옵션 설정
        options.sortDescriptors = [sortDescriptor]
        
        return options
    }
    
    func fetchPhotos() {
        
        // 이미지 가져오기
        let allPhotos = PHAsset.fetchAssets(with: .image, options: getAssetFetchOptions())
        
        // fetch images on background thread
        DispatchQueue.global(qos: .background).async {
            
            // enumberate objcets
            allPhotos.enumerateObjects { asset, count, stop in
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                // request image representation for specified asset
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { image, info in
                    
                    if let image = image {
                        
                        // append image to data source
                        self.images.append(image)
                        
                        // append asset to data source
                        self.assets.append(asset)
                        
                        // set selected image with first image
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                        
                        // reload collection view with images once count has completed
                        if count == allPhotos.count - 1 {
                            
                            // reload collection view on main thread
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        }
                    }
                }
            }
            
        }
        
        
    }

    
}
