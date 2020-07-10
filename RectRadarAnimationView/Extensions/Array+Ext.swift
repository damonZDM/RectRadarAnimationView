//
//  Array+Ext.swift
//  RectRadarAnimationView
//
//  Created by damon on 2020/7/10.
//  Copyright © 2020 damon. All rights reserved.
//

import Foundation

extension Array {
    
    mutating func safeRemoveFirst() -> Element? {
        if isEmpty { return nil }
        return removeFirst()
    }
}
