//
//  File.swift
//  
//
//  Created by Данил Войдилов on 28.07.2021.
//

import Foundation

extension GestureType {
    
    public func `repeat`<R: RangeExpression>(_ count: Int, interval: R) -> Gestures.Repeat<Self> where R.Bound == TimeInterval {
        Gestures.Repeat(self, count: count, interval: interval)
    }
    
    public func `repeat`(_ count: Int) -> Gestures.Repeat<Self> {
        Gestures.Repeat(self, count: count)
    }
}

extension Gestures {
    
    public struct Repeat<Wrapped: GestureType>: GestureType {
        public var wrapped: Wrapped
        public let count: Int
        var interval: AnyRange<TimeInterval>
        public var initialState: State { State(wrapped: wrapped.initialState) }
        public var config: GestureConfig { wrapped.config }
        
        public init<R: RangeExpression>(_ wrapped: Wrapped, count: Int, interval: R) where R.Bound == TimeInterval {
            self.wrapped = wrapped
            self.interval = .init(interval)
            self.count = count
        }
        
        public init(_ wrapped: Wrapped, count: Int) {
            self.wrapped = wrapped
            self.count = count
            self.interval = .init()
        }
        
        public func recognize(context: GestureContext, state: inout State) -> GestureState {
            let result = wrapped.reduce(context: context, state: &state.wrapped)
            if result == .failed || result == .finished {
                state.wrapped = wrapped.initialState
            }
            switch result {
            case .failed:
                return .failed
            case .finished:
                state.completed += 1
                state.didStart = false
                state.lastTime = Date()
                if let max = interval.max {
                    context.update(after: max)
                }
                if state.completed == count {
                    return .finished
                } else {
                    return .valid
                }
            case .valid:
                if !state.didStart, let time = state.lastTime {
                    let duration = Date().timeIntervalSince(time)
                    if !interval.contains(duration) {
                        context.debugFail(of: Self.self, reason: "Incorrect interval: \(duration)")
                        return .failed
                    } else {
                        return .valid
                    }
                }
                state.didStart = true
                return .valid
            case .none:
                if let time = state.lastTime, !state.didStart, let max = interval.max {
                    let duration = Date().timeIntervalSince(time)
                    if duration > max {
                        context.debugFail(of: Self.self, reason: "Too long wait: \(duration)")
                        return .failed
                    } else {
                        return .valid
                    }
                }
                return .none
            }
        }
        
        public func property(context: GestureContext, state: State) -> (Int, Wrapped.Property) {
            (state.completed, wrapped.property(context: context, state: state.wrapped))
        }
        
        public struct State {
            public var wrapped: Wrapped.State
            public var completed = 0
            public var lastTime: Date?
            public var didStart = false
        }
    }
}
