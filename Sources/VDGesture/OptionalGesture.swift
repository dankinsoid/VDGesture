//
//  File.swift
//  
//
//  Created by Данил Войдилов on 28.07.2021.
//

import Foundation

public struct OptionalGesture<Wrapped: GestureType, Substate>: PareGestureType {
    public var wrapped: Wrapped?
    public var config: GestureConfig { wrapped?.config ?? .init() }
    public var initialState: State { State(wrapped: wrapped?.initialState, substate: initialSubstate) }
    public var initialSubstate: Substate
    
    public init(wrapped: Wrapped?, initialSubstate: Substate) {
        self.wrapped = wrapped
        self.initialSubstate = initialSubstate
    }
    
    public func recognize(gesture: GestureContext, state: inout State) -> GestureState {
        guard var wrappedState = state.wrapped else {
            return .none
        }
        let result = wrapped?.recognize(gesture: gesture, state: &wrappedState) ?? .none
        state.wrapped = wrappedState
        return result
    }
    
    public struct State: StateWithSubstate {
        public var wrapped: Wrapped.State?
        public var substate: Substate
    }
}
