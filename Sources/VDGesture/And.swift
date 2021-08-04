//
//  File.swift
//  
//
//  Created by Данил Войдилов on 04.08.2021.
//

import Foundation

public func &&<L: GestureType, R: GestureType>(_ lhs: L, _ rhs: R) -> Gestures.And<Gestures.Pare<L, R, Gestures.AndState>> {
    Gestures.And {
        lhs
        rhs
    }
}

extension Gestures {
    
    public struct And<Base: PareGestureType>: PareGestureBuildable where Base.State.Substate == AndState {
        public static var initialSubstate: AndState { AndState() }
        
        private var base: Base
        public var config: GestureConfig { base.config }
        public var initialState: Base.State { base.initialState }
        
        public init(_ base: Base) {
            self.base = base
        }
        
        public init(@PareGestureBuilder<Self> _ build: () -> Base) {
            base = build()
        }
        
        public func recognize(context: GestureContext, state: inout Base.State) -> GestureState {
            base.recognize(context: context, state: &state)
        }
        
        public static func recognize<First: GestureType, Second: GestureType>(_ first: First, _ second: Second, context: GestureContext, state: inout Gestures.Pare<First, Second, AndState>.State) -> GestureState {
            switch (first.reduce(context: context, state: &state.first), second.reduce(context: context, state: &state.second)) {
            case (.valid, .valid):
                return .valid
            case (.failed, _), (_, .failed):
                return .failed
            case (.finished, let other), (let other, .finished):
                if state.substate.oneFinished {
                    return .finished
                }
                state.substate.oneFinished = true
                return other
            default:
                return .none
            }
        }
    }
    
    public struct AndState {
        public var oneFinished = false
    }
}
