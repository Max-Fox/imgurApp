//
//  GalleryItem.swift
//  imgurApp
//
//  Created by Максим Лисица on 04/10/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import Foundation

/// Элемент галареи ( сама запись )
struct GalleryItem: Decodable {
    /// Идентификатор
    var id: String?
    /// Заголовок
    var title: String?
    /// Количество просмотров поста
    var views: Int?
    /// Файл
    var images: [File]?
}
