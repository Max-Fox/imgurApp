//
//  Comments.swift
//  imgurApp
//
//  Created by Максим Лисица on 05/10/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import Foundation

/// Загружаемые через API комментарии
struct Comments: Decodable {
    /// Необходима для корректного парсинга JSON. Именно в таком формате приходят данные.
    var data: [Comment]?
}
