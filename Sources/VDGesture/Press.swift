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
            switch gesture.state {
            case .began, .changed:
                state.wasValid = true
                return .valid
            case .possible:
                return .none
            case .ended:
                return .finished
            case .cancelled, .failed:
                gesture.debugFail(of: Self.self, reason: "Failed")
                return .failed
            @unknown default:
                return .failed
            }
        }
        
        public struct State {
            public var wasValid: Bool = false
        }
    }
}
