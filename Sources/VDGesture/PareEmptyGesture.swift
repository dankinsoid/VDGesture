//
//  File.swift
//  
//
//  Created by Данил Войдилов on 28.07.2021.
//

import Foundation

public struct PareEmptyGesture<Substate>: PareGestureType {
    public var config = GestureConfig()
    public var initialState: State { State(substate: initialSubstate) }
    public var initialSubstate: Substate
    
    public init(initialSubstate: Substate) {
        self.initialSubstate = initialSubstate
    }
    
    public func recognize(gesture: GestureContext, state: inout State) -> GestureState {
        .finished
    }
    
    public struct State: StateWithSubstate {
        public var substate: Substate
    }
}
