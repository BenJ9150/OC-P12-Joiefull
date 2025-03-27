//
//  CGFloat+PictureWidth.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 02/03/2025.
//

import SwiftUI

extension CGFloat {

    static let originalPictureWidth: CGFloat = UIDevice.isPad ? 212 : 186
    static let originalPictureHeight: CGFloat = UIDevice.isPad ? 244 : 186

    static let detailPictureWidth: CGFloat = UIScreen.main.bounds.width / 2
    static let detailPictureHeight: CGFloat = UIScreen.main.bounds.height / 2

    static let minButtonSize: CGFloat = 44
}
