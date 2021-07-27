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
    
    public func update() {
        recognizer.update()
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
    
    public var velocity: CGPoint {
        recognizer.velocity()
    }
}
