//
//  File.swift
//  
//
//  Created by Данил Войдилов on 28.07.2021.
//

import Foundation

public struct AnyGesture: GestureType {
    public var initialState: Any
    public var config: GestureConfig
    private var _recognize: (GestureContext, inout Any) -> GestureState
    
    public init<G: GestureType>(_ gesture: G) {
        config = gesture.config
        initialState = gesture.initialState
        _recognize = {
            guard var state = $1 as? G.State else {
                $0.debugFail(of: Self.self, reason: "Incorrect state")
                return .failed
            }
            let result = gesture.recognize(context: $0, state: &state)
            $1 = state
            return result
        }
    }
    
    public func recognize(context: GestureContext, state: inout Any) -> GestureState {
        _recognize(context, &state)
    }
    
    public func any() -> AnyGesture {
        self
    }
}
