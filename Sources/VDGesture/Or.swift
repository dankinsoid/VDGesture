//
//  File.swift
//  
//
//  Created by Данил Войдилов on 04.08.2021.
//

import Foundation

public func ||<L: GestureType, R: GestureType>(_ lhs: L, _ rhs: R) -> Gestures.Or<Gestures.Pare<L, R, Void>> {
    Gestures.Or {
        lhs
        rhs
    }
}

extension Gestures {
    
    public struct Or<Base: PareGestureType>: PareGestureBuildable where Base.State.Substate == Void {
        public static var initialSubstate: Void { () }
        
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
        
        public static func recognize<First: GestureType, Second: GestureType>(_ first: First, _ second: Second, context: GestureContext, state: inout Gestures.Pare<First, Second, Void>.State) -> GestureState {
            let (firstState, secondState) = (
                first.reduce(context: context, state: &state.first),
                second.reduce(context: context, state: &state.second)
            )
            switch (firstState, secondState) {
            case (.finished, _), (_, .finished):        return .finished
            case (.valid, _), (_, .valid):              return .valid
            case (.failed, .none), (.none, .failed), (.failed, .failed):    return .failed
            default:                                    return .none
            }
        }
    }
}
