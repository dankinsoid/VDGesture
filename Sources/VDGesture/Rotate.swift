//
//  File.swift
//  
//
//  Created by Данил Войдилов on 11.08.2021.
//

import UIKit

extension Gestures {
    
    public struct Rotate: ComposedGesture {
        
        public var body: Gestures.Property<Gestures.Multitouch, Property> {
            Gestures.Drag()
                .multitouch(2)
                .map(initial: Property()) { context, _, property in
                    guard let angle = context.multitouchAngle else { return }
                    property.rotatedInRadians += (angle - (property.currentAngleRadians ?? angle)).truncatingRemainder(dividingBy: .pi)
                    property.currentAngleRadians = angle
                    property.initialAngleRadinas = property.initialAngleRadinas ?? angle
                }
        }
        
        public init() {}
        
        public func property(context: GestureContext, state: Gestures.Property<Gestures.Multitouch, Property>.State) -> Property {
            state.property
        }
        
        public struct Property {
            public var initialAngleRadinas: CGFloat?
            public var currentAngleRadians: CGFloat?
            public var rotatedInRadians: CGFloat = 0
        }
    }
}

extension GestureContext {
    
    public var multitouchAngle: CGFloat? {
        let touches = self.touches
        guard touches.count >= 2 else { return nil }
        let vector = CGVector(dx: touches[1].location.x - touches[0].location.x, dy: touches[1].location.y - touches[0].location.y)
        return vector.angle
    }
}

#if canImport(SwiftUI)
import SwiftUI

extension Gestures.Rotate.Property {
    
    @available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
    public var initialAngle: Angle? { initialAngleRadinas.map { Angle(radians: Double($0)) } }
    @available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
    public var currentAngle: Angle? { currentAngleRadians.map { Angle(radians: Double($0)) } }
    @available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
    public var rotated: Angle { Angle(radians: Double(rotatedInRadians)) }
}
#endif
