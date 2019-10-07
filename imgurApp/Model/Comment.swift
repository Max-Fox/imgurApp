//
//  Comment.swift
//  imgurApp
//
//  Created by Максим Лисица on 05/10/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import Foundation

/// Комментарий
struct Comment: Decodable {
    /// Текст комментария
    var comment: String?
    /// Имя автора
    var author: String?
    /// Платформа, с которой был оставлен комментарий
    var platform: String?
}
