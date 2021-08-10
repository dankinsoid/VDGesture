//
//  Handle.swift
//  VDKitFix
//
//  Created by Данил Войдилов on 27.07.2021.
//

import Foundation

extension GestureType {
    
    public func onBegin(_ action: @escaping (GestureContext) -> Void) -> Gestures.Handler<Self> {
        Gestures.Handler(wrapped: self, onBegin: { context, _ in action(context) })
    }
    
    public func onFail(_ action: @escaping (GestureContext) -> Void) -> Gestures.Handler<Self> {
        Gestures.Handler(wrapped: self, onFail: { context, _ in action(context) })
    }
    
    public func onChange(_ action: @escaping (GestureContext, Property) -> Void) -> Gestures.Handler<Self> {
        Gestures.Handler(wrapped: self, onChange: { context, state in action(context, property(context: context, state: state)) })
    }
    
    public func onFinish(_ action: @escaping (GestureContext) -> Void) -> Gestures.Handler<Self> {
        Gestures.Handler(wrapped: self, onFinish: { context, _ in action(context) })
    }
    
    public func onAny(_ action: @escaping (GestureContext) -> Void) -> Gestures.Handler<Self> {
        Gestures.Handler(wrapped: self, onAny: { context, _ in action(context) })
    }
    
    public func onBegin(_ action: @escaping () -> Void) -> Gestures.Handler<Self> {
        Gestures.Handler(wrapped: self, onBegin: { _, _ in action() })
    }
    
    public func onFail(_ action: @escaping () -> Void) -> Gestures.Handler<Self> {
        Gestures.Handler(wrapped: self, onFail: { _, _ in action() })
    }
    
    public func onChange(_ action: @escaping () -> Void) -> Gestures.Handler<Self> {
        Gestures.Handler(wrapped: self, onChange: { _, _ in action() })
    }
    
    public func onFinish(_ action: @escaping () -> Void) -> Gestures.Handler<Self> {
        Gestures.Handler(wrapped: self, onFinish: { _, _ in action() })
    }
    
    public func onAny(_ action: @escaping () -> Void) -> Gestures.Handler<Self> {
        Gestures.Handler(wrapped: self, onAny: { _, _ in action() })
    }
    
    public func on(if condition: @escaping (GestureContext) -> Bool, then trueAction: @escaping () -> Void, else falseAction: @escaping () -> Void) -> Gestures.Handler<Self> {
        Gestures.Handler(wrapped: self, onChange: { context, _ in
            if condition(context) { trueAction() } else { falseAction() }
        })
    }
}

extension GestureType where Property == Void {
    
    public func onChange(_ action: @escaping (GestureContext) -> Void) -> Gestures.Handler<Self> {
        Gestures.Handler(wrapped: self, onChange: { context, _ in action(context) })
    }
}

extension Gestures {
    
    public struct Handler<Wrapped: GestureType>: GestureType {
        public typealias Clojure = (GestureContext, Wrapped.State) -> Void
        var wrapped: Wrapped
        var onBegin: Clojure?
        var onChange: Clojure?
        var onFail: Clojure?
        var onFinish: Clojure?
        var onAny: Clojure?
        public var config: GestureConfig { wrapped.config }
        public var initialState: State { State(wrapped: wrapped.initialState) }
        
        public func recognize(context: GestureContext, state: inout State) -> GestureState {
            let result = wrapped.recognize(context: context, state: &state.wrapped)
            switch result {
            case .failed:
                onFail?(context, state.wrapped)
            case .finished:
                onFinish?(context, state.wrapped)
            case .valid:
                let wasBegun = state.wasBegun
                state.wasBegun = true
                if !wasBegun, onBegin != nil {
                    onBegin?(context, state.wrapped)
                }
                onChange?(context, state.wrapped)
            case .none:
                break
            }
            onAny?(context, state.wrapped)
            return result
        }
        
        public func property(context: GestureContext, state: State) -> Wrapped.Property {
            wrapped.property(context: context, state: state.wrapped)
        }
        
        public struct State {
            public var wrapped: Wrapped.State
            public var wasBegun = false
        }
    }
}
