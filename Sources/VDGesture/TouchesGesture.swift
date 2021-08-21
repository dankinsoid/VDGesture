//
//  File.swift
//  
//
//  Created by Данил Войдилов on 11.08.2021.
//

import Foundation

extension GestureType {
    public func map<P>(initial: P, mapper: @escaping (GestureContext, State, inout P) -> Void) -> Gestures.Property<Self, P> {
        Gestures.Property(wrapped: self, initialValue: initial, getter: mapper)
    }
}

extension Gestures {
    
    public struct Property<Wrapped: GestureType, P>: GestureType {
        public var wrapped: Wrapped
        public var initialValue: P
        public var getter: (GestureContext, Wrapped.State, inout P) -> Void
        public var initialState: State { State(wrapped: wrapped.initialState, property: initialValue) }
        public var config: GestureConfig { wrapped.config }
        
        public func recognize(context: GestureContext, state: inout State) -> GestureState {
            let result = wrapped.recognize(context: context, state: &state.wrapped)
            getter(context, state.wrapped, &state.property)
            return result
        }
        
        public func property(context: GestureContext, state: State) -> P {
            state.property
        }
        
        public struct State {
            public var wrapped: Wrapped.State
            public var property: P
        }
    }
}
