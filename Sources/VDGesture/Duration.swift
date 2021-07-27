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
            guard let date = state.startDate, wrappedResult != .failed else { return .failed }
            switch gesture.state {
            case .changed:
                if range.contains(Date().timeIntervalSince(date)) {
                    state.wasValid = true
                    return wrappedResult
                } else if !state.wasValid {
                    return wrappedResult == .finished ? .failed : wrappedResult
                } else if !finishOnTouchUp {
                    return .finished
                } else {
                    return .failed
                }
            case .ended:
                if range.contains(Date().timeIntervalSince(date)) {
                    return .finished
                } else {
                    return .failed
                }
            case .failed:
                return .failed
            default:
                return wrappedResult
            }
        }
        
        private func updateLater(context: GestureContext) {
            if let lower = range.min {
                startTimer(interval: lower, context: context)
            }
            if let upper = range.max {
                startTimer(interval: upper, context: context)
            }
        }
        
        private func startTimer(interval: TimeInterval, context: GestureContext) {
            Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
                context.update()
            }
        }
        
        public struct State {
            public var wrapped: Wrapped.State
            public var startDate: Date?
            public var wasValid: Bool = false
        }
    }
}
