//
//  File.swift
//  
//
//  Created by Данил Войдилов on 28.07.2021.
//

import Foundation

extension GestureType {

    public func inverted() -> Gestures.Inverted<Self> {
        Gestures.Inverted(self)
    }
}

public prefix func !<T: GestureType>(_ rhs: T) -> Gestures.Inverted<T> {
    Gestures.Inverted(rhs)
}

extension Gestures {

    public struct Inverted<Wrapped: GestureType>: GestureType {
        public var wrapped: Wrapped
        public var config: GestureConfig { wrapped.config }
        public var initialState: Wrapped.State { wrapped.initialState }

        public init(_ wrapped: Wrapped) {
            self.wrapped = wrapped
        }

        public func recognize(context: GestureContext, state: inout Wrapped.State) -> GestureState {
            switch wrapped.recognize(context: context, state: &state) {
            case .failed: return .finished
            case .finished: return .failed
            case .valid: return .none
            case .none: return .valid
            }
        }
        
        public func property(context: GestureContext, state: State) -> Wrapped.Property {
            wrapped.property(context: context, state: state)
        }
    }
}
