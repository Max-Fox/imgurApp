//
//  Image.swift
//  imgurApp
//
//  Created by Максим Лисица on 04/10/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import Foundation

/// Файл получаемый через API, может быть фото, видео, gif
struct File: Decodable {
    /// Сслыка
    var link: String?
    /// Тип
    var type: String?
}
