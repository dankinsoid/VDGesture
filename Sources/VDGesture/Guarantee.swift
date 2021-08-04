//
//  File.swift
//  
//
//  Created by Данил Войдилов on 04.08.2021.
//

import Foundation

extension GestureType {
    
    public func guarantee() -> Gestures.Guarantee<Self> {
        Gestures.Guarantee(wrapped: self)
    }
}

extension Gestures {
    
    public struct Guarantee<Wrapped: GestureType>: GestureType {
        var wrapped: Wrapped
        public var config: GestureConfig { wrapped.config }
        public var initialState: Wrapped.State { wrapped.initialState }
        
        public func recognize(context: GestureContext, state: inout Wrapped.State) -> GestureState {
            let result = wrapped.recognize(context: context, state: &state)
            switch result {
            case .failed, .finished:    return .finished
            case .valid:                return .valid
            case .none:                 return .none
            }
        }
    }
}
