//
//  UIButton+Extension.swift
//  Pi Media
//
//  Created by Chris on 05/04/2020.
//  Copyright © 2020 chris. All rights reserved.
//

import UIKit

extension UIView {
  func applyCornerRadius(_ radius: CGFloat) {
    self.layer.cornerRadius = radius
    self.clipsToBounds = true
  }
}
