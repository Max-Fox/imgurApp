//
//  CommentsDownloader.swift
//  imgurApp
//
//  Created by Максим Лисица on 05/10/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import Foundation

/// Класс для загрузки комментариев
class CommentsDownloader {
    
    /// Client ID для доступа к API
    let clientID = "8bb89871e2b795e"
    /// Возвращает url для конкретной фотографии
    var url: String {
        return "https://api.imgur.com/3/gallery/\(idImage)/comments/best"
    }
    /// ID изображения, используется в url
    var idImage: String
    
    /// Загрузка комментариев через API imgur
    func loadComments() -> Comments? {
        guard let url = URL(string: url) else { return nil }
        
        var request = URLRequest(url: url)
        request.addValue("Client-ID \(self.clientID)", forHTTPHeaderField: "Authorization")
        
        var array: Comments?
        let queueConcurrent = DispatchQueue(label: "Load Comments", attributes: .concurrent)
        let group = DispatchGroup()
        
        group.enter()
        queueConcurrent.async {
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    group.leave()
                }
                guard let data = data else { return }
                do {
                    array = try JSONDecoder().decode(Comments.self, from: data)
                    group.leave()
                } catch let error {
                    print("Error")
                    print(error.localizedDescription)
                    group.leave()
                }
            }
            dataTask.resume()
        }
        group.wait()

        return array
    }
    
    init(idImage: String) {
        self.idImage = idImage
    }
}
