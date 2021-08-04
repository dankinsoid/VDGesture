//
//  File.swift
//  
//
//  Created by Данил Войдилов on 28.07.2021.
//

import UIKit

extension GestureType {
    
    public func when(_ condition: @escaping (GestureContext) -> Bool) -> Gestures.When<Self> {
        Gestures.When(wrapped: self, condition: condition)
    }
    
    
    public func when(in view: UIView?) -> Gestures.When<Self> {
        when {[weak view] in
            guard let view = view else { return false }
            return view.bounds.contains($0.location(in: view))
        }
    }
}

extension Gestures {
    
    public struct When<Wrapped: GestureType>: GestureType {
        public var condition: (GestureContext) -> Bool
        public var wrapped: Wrapped
        public var initialState: Wrapped.State { wrapped.initialState }
        public var config: GestureConfig { wrapped.config }
        
        public init(wrapped: Wrapped, condition: @escaping (GestureContext) -> Bool) {
            self.wrapped = wrapped
            self.condition = condition
        }
        
        public func recognize(context: GestureContext, state: inout Wrapped.State) -> GestureState {
            let result = wrapped.reduce(context: context, state: &state)
            switch result {
            case .finished, .valid:
                if condition(context) {
                    return result
                } else  {
                    return .none
                }
            case .none, .failed:
                return result
            }
        }
    }
}
