//
//  UIKit + SubViews.swift
//  AppCar
//
//  Created by Car mudi on 12/03/24.
//

import UIKit

public extension UIView {

    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }

}
