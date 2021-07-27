//
//  Tap.swift
//  VDKitFix
//
//  Created by Данил Войдилов on 28.07.2021.
//

import UIKit

extension Gestures {
    
    @available(iOS 13.0.0, *)
    public struct Tap: ComposedGesture {
        
        public var body: some GestureType {
            Press()
                .maxLength(CGPoint(x: 20, y: 20))
                .duration(...0.3, finishOnTouchUp: true)
        }
        
        public init() {}
    }
}
