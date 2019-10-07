//
//  ViewController.swift
//  imgurApp
//
//  Created by Максим Лисица on 04/10/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.

import UIKit


/// Главный контроллер с изображением и названием фотографии
class ImageViewController: UIViewController {
    
    @IBOutlet weak var backBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var forwardBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    /// Идентификатор ячейки
    let reuseIdentifire = "ImageCell"
    /// Объект галереи
    var gallery: Gallery?
    /// Через этот объект происходит вся загрузка изображений
    var imageDownloader: ImageDownloader?
    /// Текущая страница популярных изображений
    var currentPage = 0 {
        didSet {
            self.imageDownloader?.page = self.currentPage
            self.title = "Most popular. Page \(self.currentPage + 1)" // + 1 потому что не корректно "Page 0"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gallery = self.imageDownloader?.loadImageFromImgur() ?? nil
        
        title = "Most popular. Page \(self.currentPage + 1)" // + 1 потому что не корректно "Page 0"
        
        self.imageCollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifire)
        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
        self.backBarButtonItem.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "commentSegue" {
            let commentViewController = segue.destination as! CommentViewController
            let item = gallery?.data?[sender as! Int]
            commentViewController.commentsDownloader = CommentsDownloader(idImage: item?.id ?? "")
            DispatchQueue.global().async {
                guard let url = URL(string: item?.images?.first?.link ?? "") else { return }
                
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        commentViewController.image = UIImage(data: data)
                    }
                }
            }
            commentViewController.viewsPictures = item?.views
        }
    }
    
    @IBAction func pushForwardBarButtonItem(_ sender: UIBarButtonItem) {
        self.forwardBarButtonItem.isEnabled = false
        self.backBarButtonItem.isEnabled = false
        self.currentPage += 1
        
        DispatchQueue.global().async {
            self.gallery = self.imageDownloader?.loadImageFromImgur() ?? nil
            DispatchQueue.main.async {
                self.imageCollectionView.reloadData()
                self.forwardBarButtonItem.isEnabled = true
                self.backBarButtonItem.isEnabled = true
            }
        }
    }
    
    @IBAction func pushBackBarButtonItem(_ sender: UIBarButtonItem) {
        self.forwardBarButtonItem.isEnabled = false
        self.backBarButtonItem.isEnabled = false
        self.currentPage -= 1
        
        DispatchQueue.global().async {
            self.gallery = self.imageDownloader?.loadImageFromImgur() ?? nil
            DispatchQueue.main.async {
                self.imageCollectionView.reloadData()
                self.forwardBarButtonItem.isEnabled = true
                if self.currentPage == 0 { self.backBarButtonItem.isEnabled = false }
                else { self.backBarButtonItem.isEnabled = true }
            }
        }
    }
}

extension ImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery?.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifire, for: indexPath) as! ImageCollectionViewCell
        
        guard let item = self.gallery?.data?[indexPath.row] else { return cell }
        
        cell.titlePictureLabel.text = item.title
        cell.indexPath = indexPath
        cell.delegate = self
        imageDownloader?.loadImageByUrl(stringUrl: item.images?.first?.link ?? "") { (image, succes) in
            guard succes else { return }
            cell.imageViewPicture.image = image
            cell.imageActivityIndicator.stopAnimating()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        return size
    }
}

extension ImageViewController: ImageCollectionViewCellDelegate {
    func didPressPicture(indexPathCurrentItem: IndexPath) {
        performSegue(withIdentifier: "commentSegue", sender: indexPathCurrentItem.row)
    }
}
