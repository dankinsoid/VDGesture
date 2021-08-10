//
//  File.swift
//  
//
//  Created by Данил Войдилов on 28.07.2021.
//

import UIKit

extension GestureType {
    
    public func when(onFalse executionType: Gestures.ExecutionType = .fail, _ condition: @escaping (GestureContext) -> Bool) -> Gestures.When<Self> {
        Gestures.When(self, executionType: executionType, condition: condition)
    }
    
    public func when(in view: UIView?, onFalse executionType: Gestures.ExecutionType = .continue(max: .max)) -> Gestures.When<Self> {
        when(onFalse: executionType) {[weak view] in
            guard let view = view else { return false }
            return view.bounds.contains($0.location(in: view))
        }
    }
    
    public func when<R: RangeExpression>(_ keyPath: KeyPath<GestureContext, R.Bound>, in range: R, onFalse executionType: Gestures.ExecutionType = .fail) ->Gestures.When<Self> {
        when(onFalse: executionType) {
            range.contains($0[keyPath: keyPath])
        }
    }
    
    public func when<R: RangeExpression>(_ value: @escaping (GestureContext) -> R.Bound, in range: R, onFalse executionType: Gestures.ExecutionType = .fail) ->Gestures.When<Self> {
        when(onFalse: executionType) {
            range.contains(value($0))
        }
    }
}

extension Gestures {
    
    public struct When<Wrapped: GestureType>: GestureType {
        public var condition: (GestureContext) -> Bool
        public var wrapped: Wrapped
        public var initialState: State { State(wrapped: wrapped.initialState) }
        public var config: GestureConfig { wrapped.config }
        public var executionType: ExecutionType
        
        public init(_ wrapped: Wrapped, executionType: ExecutionType, condition: @escaping (GestureContext) -> Bool) {
            self.wrapped = wrapped
            self.condition = condition
            self.executionType = executionType
        }
        
        public func recognize(context: GestureContext, state: inout State) -> GestureState {
            let result = wrapped.reduce(context: context, state: &state.wrapped)
            switch result {
            case .finished:
                return state.wasValidCounter > 0 ? .finished : .failed
            case .valid:
                if condition(context) {
                    state.wasValidCounter += 1
                    return result
                } else {
                    switch executionType {
                    case .fail:
                        return .failed
                    case .continue(let count):
                        return state.wasValidCounter >= count ? .finished : .none
                    }
                }
            case .none, .failed:
                return result
            }
        }
        
        public struct State {
            public var wrapped: Wrapped.State
            public var wasValidCounter = 0
        }
    }
    
    public enum ExecutionType {
        case fail, `continue`(max: Int)
    }
}
