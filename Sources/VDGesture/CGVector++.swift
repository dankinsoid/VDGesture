//
//  File.swift
//  
//
//  Created by Данил Войдилов on 11.08.2021.
//

import UIKit

extension CGVector {
    public var length: CGFloat {
        sqrt(dx * dx + dy * dy)
    }
    
    public var angle: CGFloat {
        if dx == 0 {
            return dy > 0 ? .pi / 2 : 3 * .pi / 2
        }
        switch (dy < 0, dx < 0) {
        case (true, true):      return atan(dy / dx) + .pi
        case (true, false):     return atan(dy / dx) + .pi * 2
        case (false, true):     return atan(dy / dx) + .pi
        case (false, false):    return atan(dy / dx)
        }
    }
}

extension CGPoint {
    public func distance(to point: CGPoint) -> CGFloat {
        CGVector(dx: x - point.x, dy: y - point.y).length
    }
}
