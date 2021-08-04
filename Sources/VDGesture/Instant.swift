//
//  File.swift
//  
//
//  Created by Данил Войдилов on 04.08.2021.
//

import Foundation

extension GestureType {
    
    public func instant() -> Gestures.Instant<Self> {
        Gestures.Instant(wrapped: self)
    }
}

extension Gestures {
    
    public struct Instant<Wrapped: GestureType>: GestureType {
        var wrapped: Wrapped
        public var config: GestureConfig { wrapped.config }
        public var initialState: Wrapped.State { wrapped.initialState }
        
        public func recognize(context: GestureContext, state: inout Wrapped.State) -> GestureState {
            let result = wrapped.recognize(context: context, state: &state)
            switch result {
            case .failed:           return .failed
            case .finished, .valid: return .finished
            case .none:             return .none
            }
        }
    }
}
