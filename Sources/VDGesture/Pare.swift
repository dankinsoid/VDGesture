//
//  File.swift
//  
//
//  Created by Данил Войдилов on 28.07.2021.
//

import Foundation

public protocol StateWithSubstate {
    associatedtype Substate
    var substate: Substate { get set }
}

public protocol PareGestureType: GestureType {
    override associatedtype State: StateWithSubstate
}

public protocol PareGestureBuildable: GestureType {
    associatedtype Substate
    static var initialSubstate: Substate { get }
    static func recognize<First: GestureType, Second: GestureType>(_ first: First, _ second: Second, context: GestureContext, state: inout Gestures.Pare<First, Second, Substate>.State) -> GestureState
}

extension Gestures {
    
    public struct Pare<First: GestureType, Second: GestureType, Substate>: PareGestureType {
        public var first: First
        public var second: Second
        private var _recognize: (First, Second, GestureContext, inout State) -> GestureState
        public var config: GestureConfig { first.config }
        public var initialState: State {
            State(first: first.initialState, second: second.initialState, substate: initialSubstate)
        }
        public var initialSubstate: Substate
        
        public init(_ first: First, _ second: Second, initialState: Substate, recognize: @escaping (First, Second, GestureContext, inout State) -> GestureState) {
            self.first = first
            self.second = second
            self.initialSubstate = initialState
            _recognize = recognize
        }
        
        public init<P: PareGestureBuildable>(_ first: First, _ second: Second, pareGesture: P.Type) where P.Substate == Substate {
            self = .init(first, second, initialState: P.initialSubstate) {
                P.recognize($0, $1, context: $2, state: &$3)
            }
        }
        
        public func recognize(context: GestureContext, state: inout State) -> GestureState {
            _recognize(first, second, context, &state)
        }
        
        public func property(context: GestureContext, state: State) -> (First.Property, Second.Property) {
            (first.property(context: context, state: state.first), second.property(context: context, state: state.second))
        }
        
        public struct State: StateWithSubstate {
            public var first: First.State
            public var second: Second.State
            public var substate: Substate
        }
    }
}
