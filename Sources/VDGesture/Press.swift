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
        
        public var body: Gestures.Length<Gestures.Or<Gestures.Pare<Gestures.Duration<Gestures.Drag, ClosedRange<TimeInterval>>, OptionalGesture<PareSingleGesture<Gestures.Instant<Gestures.Force<Gestures.Drag, PartialRangeFrom<CGFloat>>>, Void>, Void>, Void>>> {
            Gestures.Or {
                Gestures.Drag()
                    .duration(minDuration...minDuration, finish: true)
                
                if let force = force {
                    Gestures.Drag()
                        .force(force...)
                        .instant()
                }
            }
            .maxLength(CGPoint(x: maxLength, y: maxLength))
        }
        
        public func property(context: GestureContext, state: Body.State) -> (Void, Void?) {
            ((), nil)
        }
        
        public init(minDuration: TimeInterval = 0.5, minForce: CGFloat? = 4.5, maxLength: CGFloat = 20) {
            self.minDuration = minDuration
            self.maxLength = maxLength
            self.force = minForce
        }
    }
}
