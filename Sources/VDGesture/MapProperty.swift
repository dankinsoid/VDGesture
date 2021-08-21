//
//  File.swift
//  
//
//  Created by Данил Войдилов on 11.08.2021.
//

import Foundation

extension GestureType {
    
    public func map<P>(_ mapper: @escaping (GestureContext, Property, State) -> P) -> Gestures.MapProperty<Self, P> {
        Gestures.MapProperty(wrapped: self, map: mapper)
    }
}

extension Gestures {
   
    public struct MapProperty<Wrapped: GestureType, Property>: GestureType {
        public var wrapped: Wrapped
        public var map: (GestureContext, Wrapped.Property, Wrapped.State) -> Property
        public var config: GestureConfig { wrapped.config }
        public var initialState: Wrapped.State { wrapped.initialState }
        
        public func recognize(context: GestureContext, state: inout Wrapped.State) -> GestureState {
            wrapped.recognize(context: context, state: &state)
        }
        
        public func property(context: GestureContext, state: Wrapped.State) -> Property {
            map(context, wrapped.property(context: context, state: state), state)
        }
    }
}
