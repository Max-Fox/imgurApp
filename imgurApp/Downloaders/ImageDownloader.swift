//
//  ImageDownloader.swift
//  imgurApp
//
//  Created by Максим Лисица on 05/10/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit

class ImageDownloader {
    
    /// ClientID для доступа к методам API
    private let clientID = "8bb89871e2b795e"
    /// url api
    private var url: String {
        return "https://api.imgur.com/3/gallery/hot/viral/day/\(page)?showViral=true&album_previews=true"
    }
    /// Номер страницы, используется в url
    var page = 0
    
    /// Загрузка изображения из Imgur через API
    func loadImageFromImgur() -> Gallery? {
        guard let url = URL(string: url) else { return nil }
        var request = URLRequest(url: url)
        
        request.addValue("Client-ID \(self.clientID)", forHTTPHeaderField: "Authorization")
        
        var array: Gallery?
        let queueConcurrent = DispatchQueue(label: "Load Image", attributes: .concurrent)
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
                    let allData = try JSONDecoder().decode(Gallery.self, from: data)
                    let filteredArray = allData.data?.filter({ (item) -> Bool in
                        item.images != nil && item.images?.first?.type == Type.image.rawValue
                    })
                    array = Gallery(data: filteredArray ?? nil)
                    group.leave()
                } catch let error {
                    print("Errorr")
                    print(error.localizedDescription)
                }
            }
            dataTask.resume()
        }
        group.wait()
        return array
    }
    
    /// Загрузка изображения через url
    /// - Parameter stringUrl: url
    /// - Parameter completion: замыкание, которое возвращает UIImage -  изображение, Bool - статус выполнения (true/false)
    func loadImageByUrl(stringUrl: String, completion: @escaping (UIImage?, Bool) -> ()) {
        DispatchQueue.global().async {
            guard let url = URL(string: stringUrl) else {
                completion(nil, false)
                return
            }
            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else {
                    completion(nil, false)
                    return
                }
                DispatchQueue.main.async {
                    completion(image, true)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
