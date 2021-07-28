//
//  Configs.swift
//  VDKitFix
//
//  Created by Данил Войдилов on 27.07.2021.
//

import Foundation

public struct GestureConfig {
    public var ignoreSubviews = false
    public var recognizeSimultaneously = false
    public var enableDebug = false
    
    public init() {}
    
    public func apply(_ action: (inout GestureConfig) -> Void) -> GestureConfig {
        var result = self
        action(&result)
        return result
    }
}

extension GestureType {
    
    public func config(_ apply: @escaping (inout GestureConfig) -> Void) -> Gestures.Config<Self> {
        Gestures.Config(self, apply: apply)
    }
    
    public func recognizeSimultaneously(_ recognize: Bool) -> Gestures.Config<Self> {
        config {
            $0.recognizeSimultaneously = recognize
        }
    }
    
    public func ignoreSubviews(_ ignore: Bool) -> Gestures.Config<Self> {
        config {
            $0.ignoreSubviews = ignore
        }
    }
    
    public func enableDebug(_ enable: Bool) -> Gestures.Config<Self> {
        config {
            $0.enableDebug = enable
        }
    }
}

extension Gestures {
    
    public struct Config<Wrapped: GestureType>: GestureType {
        
        public var wrapped: Wrapped
        public var initialState: Wrapped.State { wrapped.initialState }
        public var config: GestureConfig { wrapped.config.apply(apply) }
        public var apply: (inout GestureConfig) -> Void
        
        public init(_ wrapped: Wrapped, apply: @escaping (inout GestureConfig) -> Void) {
            self.apply = apply
            self.wrapped = wrapped
        }
        
        public func recognize(gesture: GestureContext, state: inout Wrapped.State) -> GestureState {
            wrapped.recognize(gesture: gesture, state: &state)
        }
    }
}
