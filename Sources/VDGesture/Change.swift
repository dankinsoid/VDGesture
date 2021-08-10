//
//  File.swift
//  
//
//  Created by Данил Войдилов on 09.08.2021.
//

import UIKit

extension GestureType {
    
    public func when<R: RangeExpression>(rangeOf keyPath: KeyPath<GestureContext, R.Bound>, in range: R, onFalse executionType: Gestures.ExecutionType = .fail) -> Gestures.PropertyChange<Self, R.Bound> {
        when(rangeOf: { $0[keyPath: keyPath] }, in: range, onFalse: executionType)
    }
    
    public func when<R: RangeExpression>(rangeOf getter: @escaping (GestureContext) -> R.Bound, in range: R, onFalse executionType: Gestures.ExecutionType = .fail) -> Gestures.PropertyChange<Self, R.Bound> {
        Gestures.PropertyChange(self, executionType: executionType, getter: getter) {
            range.contains($0.lowerBound) && range.contains($0.upperBound)
        }
    }
    
    public func when<R: RangeExpression>(changeOf keyPath: KeyPath<GestureContext, R.Bound>, in range: R, onFalse executionType: Gestures.ExecutionType = .fail) -> Gestures.PropertyChange<Self, R.Bound> where R.Bound: AdditiveArithmetic {
        when(changeOf: { $0[keyPath: keyPath] }, in: range, onFalse: executionType)
    }
    
    public func when<R: RangeExpression>(changeOf getter: @escaping (GestureContext) -> R.Bound, in range: R, onFalse executionType: Gestures.ExecutionType = .fail) -> Gestures.PropertyChange<Self, R.Bound> where R.Bound: AdditiveArithmetic {
        Gestures.PropertyChange(self, executionType: executionType, getter: getter) {
            range.contains($0.upperBound - $0.lowerBound)
        }
    }
    
    public func when<Value: Comparable>(changeOf getter: @escaping (GestureContext) -> Value, onFalse executionType: Gestures.ExecutionType = .fail, _ condition: @escaping (ClosedRange<Value>) -> Bool) -> Gestures.PropertyChange<Self, Value> {
        Gestures.PropertyChange(self, executionType: executionType, getter: getter, condition: condition)
    }
}

extension Gestures {
    
    public struct PropertyChange<Wrapped: GestureType, Value: Comparable>: GestureType {
        public var wrapped: Wrapped
        public var initialState: State { State(wrapped: wrapped.initialState) }
        public var config: GestureConfig { wrapped.config }
        public var getter: (GestureContext) -> Value
        public var condition: (ClosedRange<Value>) -> Bool
        public var executionType: ExecutionType
        
        public init(_ wrapped: Wrapped, executionType: ExecutionType, getter: @escaping (GestureContext) -> Value, condition: @escaping (ClosedRange<Value>) -> Bool) {
            self.wrapped = wrapped
            self.getter = getter
            self.executionType = executionType
            self.condition = condition
        }
        
        public func recognize(context: GestureContext, state: inout State) -> GestureState {
            let result = wrapped.reduce(context: context, state: &state.wrapped)
            switch result {
            case .finished:
                return state.wasValidCounter > 0 ? .finished : .failed
            case .valid:
                let value = getter(context)
                if let range = state.range {
                    state.range = min(range.lowerBound, value)...max(range.upperBound, value)
                } else {
                    state.range = value...value
                }
                let range = state.range ?? value...value
                if condition(range) {
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
            public var range: ClosedRange<Value>?
        }
    }
}
