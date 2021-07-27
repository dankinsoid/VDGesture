//
//  Lenght.swift
//  VDKitFix
//
//  Created by Данил Войдилов on 27.07.2021.
//

import UIKit

extension GestureType {
    
    public func maxLength(_ point: CGPoint) -> Gestures.Length<Self> {
        Gestures.Length(self, max: point, failOnExcess: true)
    }
}

extension Gestures {
    
    public struct Length<Wrapped: GestureType>: GestureType {
        
        public var wrapped: Wrapped
        public var initialState: State { State(wrapped: wrapped.initialState) }
        public var config: GestureConfig { wrapped.config }
        public var min: CGPoint
        public var max: CGPoint
        public var failOnExcess: Bool
        
        public init(_ wrapped: Wrapped, min: CGPoint = .zero, max: CGPoint = CGPoint(x: CGFloat.infinity, y: .infinity), failOnExcess: Bool) {
            self.wrapped = wrapped
            self.min = min
            self.max = max
            self.failOnExcess = failOnExcess
        }
        
        public func recognize(gesture: GestureContext, state: inout State) -> GestureState {
            let result = wrapped.recognize(gesture: gesture, state: &state.wrapped)
            guard result != .failed else { return .failed }
            if result == .valid, state.startLocation == nil {
                state.startLocation = gesture.location()
                return .valid
            }
            guard let startLocation = state.startLocation else {
                return .failed
            }
            let location = gesture.location()
            state.maxDistance = CGPoint(
                x: Swift.max(state.maxDistance.x, abs(startLocation.x - location.x)),
                y: Swift.max(state.maxDistance.y, abs(startLocation.y - location.y))
            )
            if result == .finished {
                if state.maxDistance.x < min.x || state.maxDistance.y < min.y {
                    return .failed
                }
            }
            if state.maxDistance.x > max.x || state.maxDistance.y > max.y {
                return failOnExcess ? .failed : .finished
            }
            return result
        }
        
        public struct State {
            public var wrapped: Wrapped.State
            public var startLocation: CGPoint?
            public var maxDistance: CGPoint = .zero
        }
    }
}
