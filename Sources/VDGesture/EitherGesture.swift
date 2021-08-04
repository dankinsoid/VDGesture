//
//  File.swift
//  
//
//  Created by Данил Войдилов on 28.07.2021.
//

import Foundation

public struct EitherGesture<First: GestureType, Second: GestureType, Substate>: PareGestureType {
    public var gesture: Gesture
    public var initialSubstate: Substate
    public var initialState: State {
        switch gesture {
        case .first(let first): return State(substate: initialSubstate, state: .first(first.initialState))
        case .second(let second): return State(substate: initialSubstate, state: .second(second.initialState))
        }
    }
    public var config: GestureConfig {
        switch gesture {
        case .first(let first): return first.config
        case .second(let second): return second.config
        }
    }
    
    public init(gesture: EitherGesture<First, Second, Substate>.Gesture, initialSubstate: Substate) {
        self.gesture = gesture
        self.initialSubstate = initialSubstate
    }
    
    public func recognize(context: GestureContext, state: inout State) -> GestureState {
        switch (self.gesture, state.state) {
        case (.first(let first), .first(var firstState)):
            let result =  first.recognize(context: context, state: &firstState)
            state.state = .first(firstState)
            return result
        case (.second(let second), .second(var secondState)):
            let result =  second.recognize(context: context, state: &secondState)
            state.state = .second(secondState)
            return result
        default:
            context.debugFail(of: Self.self, reason: "Impossible state")
            return .failed
        }
    }
    
    public struct State: StateWithSubstate {
        public var substate: Substate
        public var state: SingleState
    }
    
    public enum SingleState {
        case first(First.State), second(Second.State)
    }
    
    public enum Gesture {
        case first(First), second(Second)
    }
}
