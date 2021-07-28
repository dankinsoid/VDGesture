//
//  File.swift
//  
//
//  Created by Данил Войдилов on 28.07.2021.
//

import UIKit

extension UIGestureRecognizer.State: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .possible: return "possible"
        case .began: return "begin"
        case .changed: return "changed"
        case .ended: return "ended"
        case .failed: return "failed"
        case .cancelled: return "cancelled"
        @unknown default: return "unknown default"
        }
    }
}
