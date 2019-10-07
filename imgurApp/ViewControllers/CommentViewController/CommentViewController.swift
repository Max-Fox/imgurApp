//
//  DetailViewController.swift
//  imgurApp
//
//  Created by Максим Лисица on 05/10/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit

/// Экран с описанием фотографии и комментариями
class CommentViewController: UIViewController {
    
    /// Идентификатор ячейки
    let reuseIdentifier = "commentCell"
    /// Через этот объект проиходит вся загрузка комментариев
    var commentsDownloader: CommentsDownloader?
    /// Список комментариев
    var comments: Comments?
    /// Изображение
    var image: UIImage? {
        didSet {
            self.pictureImageView.image = self.image
            self.imageActivityIndicator.stopAnimating()
        }
    }
    /// Количество просмотров записи
    var viewsPictures: Int?
    
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {
            self.comments = self.commentsDownloader?.loadComments()
            DispatchQueue.main.async {
                self.commentsTableView.reloadData()
            }
        }
        
        viewsLabel.text = "Views: \(viewsPictures ?? 0)"
        
        commentsTableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
    }
}

extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CommentTableViewCell
        let commentItem = comments?.data?[indexPath.row]
        
        cell.commentLabel.text = commentItem?.comment
        cell.authorLabel.text = commentItem?.author
        cell.platformLabel.text = commentItem?.platform
        
        return cell
    } 
}
