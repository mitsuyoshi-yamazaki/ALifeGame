//
//  UIViewExtension.swift
//  ALifeGame
//
//  Created by Yamazaki Mitsuyoshi on 2019/11/24.
//  Copyright © 2019 Yamazaki Mitsuyoshi. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
