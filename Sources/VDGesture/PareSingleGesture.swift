//
//  File.swift
//  
//
//  Created by Данил Войдилов on 28.07.2021.
//

import Foundation

public struct PareSingleGesture<Wrapped: GestureType, Substate>: PareGestureType {
    public var wrapped: Wrapped
    public var config: GestureConfig { wrapped.config }
    public var initialState: State { State(wrapped: wrapped.initialState, substate: initialSubstate) }
    public var initialSubstate: Substate
    
    public init(wrapped: Wrapped, initialSubstate: Substate) {
        self.wrapped = wrapped
        self.initialSubstate = initialSubstate
    }
    
    public func recognize(context: GestureContext, state: inout State) -> GestureState {
        wrapped.recognize(context: context, state: &state.wrapped)
    }
    
    public func property(context: GestureContext, state: State) -> Wrapped.Property {
        wrapped.property(context: context, state: state.wrapped)
    }
    
    public struct State: StateWithSubstate {
        public var wrapped: Wrapped.State
        public var substate: Substate
    }
}
