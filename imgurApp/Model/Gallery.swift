//
//  Gallery.swift
//  imgurApp
//
//  Created by Максим Лисица on 05/10/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import Foundation

/// Загружаемые через api галерея популярных изображений
struct Gallery: Decodable {
    /// Необходима для корректного парсинга JSON. Именно в таком формате приходят данные.
    var data: [GalleryItem]?
    
    init(data: [GalleryItem]?) {
        self.data = data
    }
}
