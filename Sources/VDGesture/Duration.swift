//
//  Duration.swift
//  VDKitFix
//
//  Created by Данил Войдилов on 27.07.2021.
//

import Foundation

extension GestureType {
    
    public func duration<R: RangeExpression>(_ range: R, finish: Bool = false) -> Gestures.Duration<Self, R> where R.Bound == TimeInterval {
        Gestures.Duration(self, in: range, finish: finish)
    }
}

extension Gestures {
    
    public struct Duration<Wrapped: GestureType, R: RangeExpression>: GestureType where R.Bound == TimeInterval {
        public var range: R
        public var wrapped: Wrapped
        public var initialState: State { State(wrapped: wrapped.initialState) }
        public var config: GestureConfig { wrapped.config }
        public var finish: Bool
        
        public init(_ wrapped: Wrapped, in range: R, finish: Bool) {
            self.range = range
            self.wrapped = wrapped
            self.finish = finish
        }
        
        public func recognize(context: GestureContext, state: inout State) -> GestureState {
            let wrappedResult = wrapped.recognize(context: context, state: &state.wrapped)
            if wrappedResult == .valid && state.startDate == nil {
                state.startDate = Date()
                updateLater(context: context)
            }
            guard let date = state.startDate else {
                return .none
            }
            switch wrappedResult {
            case .failed:
                return .failed
            case .finished:
                let interval = Date().timeIntervalSince(date)
                if range.contains(interval) {
                    return .finished
                } else {
                    context.debugFail(of: Self.self, reason: "Incorrect interval \(interval)")
                    return .failed
                }
            case .valid:
                let interval = Date().timeIntervalSince(date)
                if let max = range.max, max <= interval {
                    if finish {
                        return .finished
                    } else {
                        context.debugFail(of: Self.self, reason: "Too slow: \(interval)")
                        return .failed
                    }
                }
                state.wasValid = true
                return .valid
            case .none:
                state.startDate = nil
                return .none
            }
        }
        
        private func updateLater(context: GestureContext) {
            if let lower = range.min, lower > 0 {
                context.update(after: lower)
            }
            if let upper = range.max, upper != range.min, upper > 0 {
                context.update(after: upper)
            }
        }
        
        public struct State {
            public var wrapped: Wrapped.State
            public var startDate: Date?
            public var wasValid: Bool = false
        }
    }
}
