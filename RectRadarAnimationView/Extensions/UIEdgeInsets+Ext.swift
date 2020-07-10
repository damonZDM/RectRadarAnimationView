//
//  UIEdges.swift
//  RectRadarAnimationView
//
//  Created by damon on 2020/7/10.
//  Copyright © 2020 damon. All rights reserved.
//

import Foundation
import UIKit

extension UIEdgeInsets {
    
    init(_ increment: CGFloat) {
        self.init(top: increment, left: increment, bottom: increment, right: increment)
    }
}
