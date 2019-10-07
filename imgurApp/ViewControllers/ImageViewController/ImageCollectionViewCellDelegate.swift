//
//  ImageCollectionViewCellDelegate.swift
//  imgurApp
//
//  Created by Максим Лисица on 05/10/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import Foundation

protocol ImageCollectionViewCellDelegate: AnyObject {
    /// Обработка нажатия на картинку
    /// - Parameter indexPathCurrentItem: передается IndexPath записи
    func didPressPicture(indexPathCurrentItem: IndexPath)
}
