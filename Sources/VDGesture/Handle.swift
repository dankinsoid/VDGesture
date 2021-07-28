//
//  Handle.swift
//  VDKitFix
//
//  Created by Данил Войдилов on 27.07.2021.
//

import Foundation

extension GestureType {
    
    public func onBegin(_ action: @escaping (GestureContext) -> Void) -> Gestures.Handler<Self> {
        Gestures.Handler(wrapped: self, onBegin: action)
    }
    
    public func onFail(_ action: @escaping (GestureContext) -> Void) -> Gestures.Handler<Self> {
        Gestures.Handler(wrapped: self, onFail: action)
    }
    
    public func onChange(_ action: @escaping (GestureContext) -> Void) -> Gestures.Handler<Self> {
        Gestures.Handler(wrapped: self, onChange: action)
    }
    
    public func onRecognise(_ action: @escaping (GestureContext) -> Void) -> Gestures.Handler<Self> {
        Gestures.Handler(wrapped: self, onRecognise: action)
    }
    
    public func onBegin(_ action: @escaping () -> Void) -> Gestures.Handler<Self> {
        Gestures.Handler(wrapped: self, onBegin: { _ in action() })
    }
    
    public func onFail(_ action: @escaping () -> Void) -> Gestures.Handler<Self> {
        Gestures.Handler(wrapped: self, onFail: { _ in action() })
    }
    
    public func onChange(_ action: @escaping () -> Void) -> Gestures.Handler<Self> {
        Gestures.Handler(wrapped: self, onChange: { _ in action() })
    }
    
    public func onRecognise(_ action: @escaping () -> Void) -> Gestures.Handler<Self> {
        Gestures.Handler(wrapped: self, onRecognise: { _ in action() })
    }
}

extension Gestures {
    
    public struct Handler<Wrapped: GestureType>: GestureType {
        public typealias Clojure = (GestureContext) -> Void
        var wrapped: Wrapped
        var onBegin: Clojure?
        var onChange: Clojure?
        var onFail: Clojure?
        var onRecognise: Clojure?
        public var config: GestureConfig { wrapped.config }
        public var initialState: State { State(wrapped: wrapped.initialState) }
        
        public func recognize(gesture: GestureContext, state: inout State) -> GestureState {
            let result = wrapped.recognize(gesture: gesture, state: &state.wrapped)
            switch result {
            case .failed:
                onFail?(gesture)
            case .finished:
                onRecognise?(gesture)
            case .valid:
                if !state.wasBegun, onBegin != nil {
                    onBegin?(gesture)
                } else {
                    onChange?(gesture)
                }
                state.wasBegun = true
            case .none:
                return .none
            }
            return result
        }
        
        public struct State {
            public var wrapped: Wrapped.State
            public var wasBegun = false
        }
    }
}
