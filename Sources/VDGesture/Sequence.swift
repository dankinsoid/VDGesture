//
//  File.swift
//  
//
//  Created by Данил Войдилов on 28.07.2021.
//

import Foundation

extension Gestures {
    
    public struct Sequence<Base: PareGestureType>: PareGestureBuildable where Base.State.Substate == SequenceSubstate {
        public static var initialSubstate: SequenceSubstate { SequenceSubstate(interval: .init()) }
        
        private var base: Base
        public var config: GestureConfig { base.config }
        public var initialState: Base.State { base.initialState }
        var interval: AnyRange<TimeInterval>
        
        public init<R: RangeExpression>(_ base: Base, interval: R) where R.Bound == TimeInterval {
            self.base = base
            self.interval = AnyRange(interval)
        }
        
        public init<R: RangeExpression>(interval: R, @PareGestureBuilder<Self> _ build: () -> Base) where R.Bound == TimeInterval {
            base = build()
            self.interval = AnyRange(interval)
        }
        
        public init(@PareGestureBuilder<Self> _ build: () -> Base) {
            base = build()
            self.interval = AnyRange()
        }
        
        public func recognize(context: GestureContext, state: inout Base.State) -> GestureState {
            state.substate.interval = interval
            return base.recognize(context: context, state: &state)
        }
        
        public func property(context: GestureContext, state: Base.State) -> Base.Property {
            base.property(context: context, state: state)
        }
        
        public static func recognize<First: GestureType, Second: GestureType>(_ first: First, _ second: Second, context: GestureContext, state: inout Gestures.Pare<First, Second, SequenceSubstate>.State) -> GestureState {
            switch state.substate.firstTime {
            case nil:
                let result = first.reduce(context: context, state: &state.first)
                if result == .finished {
                    state.substate.firstTime = Date()
                    if let maxInterval = state.substate.interval.max {
                        context.update(after: maxInterval)
                    }
                    return .valid
                }
                return result
            case .some(let time):
                let result = second.reduce(context: context, state: &state.second)
                if result != .failed, result != .finished, !state.substate.secondStarted {
                    let interval = Date().timeIntervalSince(time)
                    if result == .valid {
                        if !state.substate.interval.contains(interval) {
                            context.debugFail(of: Self.self, reason: "Incorrect interval \(interval)")
                            return .failed
                        }
                    } else if result == .none, let max = state.substate.interval.max, interval > max {
                        context.debugFail(of: Self.self, reason: "Too long \(interval)")
                        return .failed
                    }
                }
                if result == .valid {
                    state.substate.secondStarted = true
                }
                return result
            }
        }
    }
    
    public struct SequenceSubstate {
        var interval = AnyRange<TimeInterval>()
        public var firstTime: Date?
        public var secondStarted: Bool = false
    }
}
