//
//  Duration.swift
//  VDKitFix
//
//  Created by Данил Войдилов on 27.07.2021.
//

import Foundation

extension GestureType {
    
    public func duration<R: RangeExpression>(_ range: R, finishOnTouchUp: Bool = false) -> Gestures.Duration<Self, R> where R.Bound == TimeInterval {
        Gestures.Duration(self, in: range, finishOnTouchUp: finishOnTouchUp)
    }
}

extension Gestures {
    
    public struct Duration<Wrapped: GestureType, R: RangeExpression>: GestureType where R.Bound == TimeInterval {
        public var range: R
        public var wrapped: Wrapped
        public var finishOnTouchUp: Bool
        public var initialState: State { State(wrapped: wrapped.initialState) }
        public var config: GestureConfig { wrapped.config }
        
        public init(_ wrapped: Wrapped, in range: R, finishOnTouchUp: Bool = false) {
            self.range = range
            self.wrapped = wrapped
            self.finishOnTouchUp = finishOnTouchUp
        }
        
        public func recognize(gesture: GestureContext, state: inout State) -> GestureState {
            let wrappedResult = wrapped.recognize(gesture: gesture, state: &state.wrapped)
            if wrappedResult == .valid && state.startDate == nil {
                state.startDate = Date()
                updateLater(context: gesture)
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
                    gesture.debugFail(of: Self.self, reason: "Incorrect interval \(interval)")
                    return .failed
                }
            case .valid:
                let interval = Date().timeIntervalSince(date)
                if range.contains(interval) {
                    state.wasValid = true
                    return .valid
                } else if let max = range.max, max <= interval {
                    if finishOnTouchUp {
                        gesture.debugFail(of: Self.self, reason: "Too slow: \(interval)")
                        return .failed
                    } else {
                        return .finished
                    }
                } else {
                    state.wasValid = true
                    return .valid
                }
            case .none:
                return .none
            }
        }
        
        private func updateLater(context: GestureContext) {
            if let lower = range.min {
                context.update(after: lower)
            }
            if let upper = range.max {
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
