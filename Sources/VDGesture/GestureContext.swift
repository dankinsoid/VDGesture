//
//  GestureContext.swift
//  VDKitFix
//
//  Created by Данил Войдилов on 27.07.2021.
//

import UIKit

public struct GestureContext {
    var recognizer: UpdatableRecognizer
    
    public var state: UIGestureRecognizer.State { recognizer.state }
    
    public func update(after interval: TimeInterval) {
        recognizer.update(after: interval)
    }
    
    public func location(of touch: Int, in view: UIView? = nil) -> CGPoint {
        recognizer.location(ofTouch: touch, in: view ?? recognizer.view)
    }
    
    public func location(in view: UIView? = nil) -> CGPoint {
        recognizer.location(in: view ?? recognizer.view)
    }
    
    public func locationInWindow(of touch: Int) -> CGPoint {
        recognizer.location(ofTouch: touch, in: nil)
    }
    
    public var locationInWindow: CGPoint {
        recognizer.location(in: nil)
    }
    
    public func velocity(of touch: Int) -> CGPoint {
        recognizer.velocity(of: touch)
    }
    
    public var force: CGFloat {
        recognizer.touches.first?.force ?? 0
    }
    
    public var velocity: CGPoint {
        recognizer.velocity()
    }
    
    public func set(debugRemark: String) {
        recognizer.set(debugRemark: debugRemark)
    }
    
    public func debugFail<G: GestureType>(of type: G.Type, reason: String) {
        set(debugRemark: "\(type): '\(reason)'")
    }
}
