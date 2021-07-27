//
//  Press.swift
//  VDKitFix
//
//  Created by Данил Войдилов on 27.07.2021.
//

import Foundation

public enum Gestures {
    
    public struct Press: GestureType {
        public var initialState: State { State() }
        public var config: GestureConfig { .init() }
        
        public init() {}
        
        public func recognize(gesture: GestureContext, state: inout State) -> GestureState {
            if gesture.state == .began || gesture.state == .changed {
                state.wasValid = true
            }
            if gesture.state == .ended && !state.wasValid || gesture.state == .cancelled || gesture.state == .failed {
                return .failed
            }
            if gesture.state == .ended, state.wasValid {
                return .finished
            }
            return .valid
        }
        
        public struct State {
            public var wasValid: Bool = false
        }
    }
}
