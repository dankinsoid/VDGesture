//
//  File.swift
//  
//
//  Created by Данил Войдилов on 10.08.2021.
//

import UIKit

extension Gestures {
    
    public struct Pinch: ComposedGesture {
        
        public typealias Property = CGFloat
        
        public var body: Gestures.Multitouch {
            Gestures.Drag().multitouch(2)
        }
        
        public init() {}
        
        public func property(context: GestureContext, state: Body.State) -> CGFloat {
            let touches = context.touches
            guard touches.count > 1 else { return 0 }
            return touches[0].location.distance(to: touches[1].location)
        }
    }
}
