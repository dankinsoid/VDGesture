//
//  File.swift
//  
//
//  Created by Данил Войдилов on 10.08.2021.
//

import Foundation

extension GestureType {
    public func multitouch(_ count: Int) -> Gestures.Multitouch {
        Gestures.Multitouch(self, count: count)
    }
}

extension Gestures {
    
    public struct Multitouch: GestureType {
        public var initialState: State { State(children: children.map { $0.initialState }) }
        public var config: GestureConfig { children.first?.config ?? .init() }
        public let children: [AnyGesture]
        
        public init(children: [AnyGesture]) {
            self.children = children
        }
        
        public init<G: GestureType>(_ gesture: G, count: Int) {
            self.children = .init(repeating: gesture.any(), count: count)
        }
        
        public init<G: GestureType>(_ count: Int, gesture: () -> G) {
            self = .init(count, gesture: gesture())
        }
        
        public init<G: GestureType>(_ count: Int, gesture: G) {
            self.children = .init(repeating: gesture.any(), count: count)
        }
        
        public init(@GesturesBuilder _ gestures: () -> [AnyGesture]) {
            children = gestures()
        }
        
        public func recognize(context: GestureContext, state: inout State) -> GestureState {
            let contexts = context.children
            if state.touches.count < children.count {
                var i = state.touches.map { $0.value }.sorted().max() ?? -1
                contexts
                    .filter { state.touches[$0.beginTimestamp] == nil }
                    .prefix(children.count - state.touches.count)
                    .forEach {
                        i += 1
                        state.touches[$0.beginTimestamp] = i
                    }
            }
            let states = contexts.compactMap { context in
                state.touches[context.beginTimestamp].map {
                    (context, children[$0].recognize(context: context, state: &state.children[$0]))
                }
            }
            state.started = state.started.union(states.filter({ $0.1 == .valid }).map { $0.0.beginTimestamp })
            state.completed = state.completed.union(states.filter({ $0.1 == .finished }).map { $0.0.beginTimestamp })
            state.failed = state.failed.union(states.filter({ $0.1 == .failed }).map { $0.0.beginTimestamp })
            if !state.failed.isEmpty {
                return .failed
            }
            if !state.completed.isEmpty, state.started.count < children.count {
                return .failed
            }
            if state.completed.count >= children.count {
                return .finished
            }
            return state.started.count >= children.count ? .valid : .none
        }
        
        public struct State {
            public var children: [Any]
            public var touches: [Double: Int] = [:]
            public var completed: Set<Double> = []
            public var failed: Set<Double> = []
            public var started: Set<Double> = []
        }
    }
}
