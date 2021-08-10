//
//  File.swift
//  
//
//  Created by Данил Войдилов on 04.08.2021.
//

import UIKit

extension GestureType {
    
    public func force<R: RangeExpression>(_ range: R) -> Gestures.Force<Self, R> where R.Bound == CGFloat {
        Gestures.Force(self, in: range)
    }
}

extension Gestures {
    
    public struct Force<Wrapped: GestureType, R: RangeExpression>: GestureType where R.Bound == CGFloat {
        public var range: R
        public var wrapped: Wrapped
        public var initialState: State { State(wrapped: wrapped.initialState) }
        public var config: GestureConfig { wrapped.config }
        
        public init(_ wrapped: Wrapped, in range: R) {
            self.range = range
            self.wrapped = wrapped
        }
        
        public func recognize(context: GestureContext, state: inout State) -> GestureState {
            let wrappedResult = wrapped.recognize(context: context, state: &state.wrapped)
            switch wrappedResult {
            case .failed:
                return .failed
            case .finished:
                if range.contains(context.force) || state.wasValid {
                    return .finished
                } else {
                    context.debugFail(of: Self.self, reason: "Incorrect force \(context.force)")
                    return .failed
                }
            case .valid:
                if range.contains(context.force) {
                    state.wasValid = true
                    return .valid
                } else {
                    return .none
                }
            case .none:
                return .none
            }
        }
        
        public func property(context: GestureContext, state: State) -> Wrapped.Property {
            wrapped.property(context: context, state: state.wrapped)
        }
        
        public struct State {
            public var wrapped: Wrapped.State
            public var wasValid: Bool = false
        }
    }
}
