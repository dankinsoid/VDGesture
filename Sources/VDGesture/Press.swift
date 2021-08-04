//
//  File.swift
//  
//
//  Created by Данил Войдилов on 03.08.2021.
//

import UIKit

extension Gestures {
    
    public struct Press: ComposedGesture {
        public var minDuration: TimeInterval
        public var maxLength: CGFloat
        public var force: CGFloat?
        
        public var body: Gestures.Length<Gestures.Or<Gestures.Pare<Gestures.Duration<Gestures.Pan, ClosedRange<TimeInterval>>, OptionalGesture<PareSingleGesture<Gestures.Instant<Gestures.Force<Gestures.Pan, PartialRangeFrom<CGFloat>>>, Void>, Void>, Void>>> {
            Gestures.Or {
                Gestures.Pan()
                    .duration(minDuration...minDuration, finish: true)
                
                if let force = force {
                    Gestures.Pan()
                        .force(force...)
                        .instant()
                }
            }
            .maxLength(CGPoint(x: maxLength, y: maxLength))
        }
        
        public init(minDuration: TimeInterval = 0.5, minForce: CGFloat? = 4.5, maxLength: CGFloat = 20) {
            self.minDuration = minDuration
            self.maxLength = maxLength
            self.force = minForce
        }
    }
}
