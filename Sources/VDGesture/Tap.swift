//
//  Tap.swift
//  VDKitFix
//
//  Created by Данил Войдилов on 28.07.2021.
//

import UIKit

extension Gestures {
    
    public struct Tap: ComposedGesture {
        public var duration: TimeInterval
        public var maxLength: CGFloat
        
        public var body: Gestures.Duration<Gestures.Length<Gestures.Pan>, PartialRangeThrough<TimeInterval>> {
            Pan()
                .maxLength(CGPoint(x: maxLength, y: maxLength))
                .duration(...duration)
        }
        
        public init(duration: TimeInterval = 0.3, maxLength: CGFloat = 20) {
            self.duration = duration
            self.maxLength = maxLength
        }
    }
}
