//
//  GestureType.swift
//  VDKitFix
//
//  Created by Данил Войдилов on 27.07.2021.
//

import UIKit

public protocol GestureType {
    associatedtype State
    var initialState: State { get }
    var config: GestureConfig { get }
    func recognize(context: GestureContext, state: inout State) -> GestureState
    func any() -> AnyGesture
}

extension GestureType {
    
    public func reduce(context: GestureContext, state: inout State) -> GestureState {
        let result = recognize(context: context, state: &state)
        if result == .finished || result == .failed {
            state = initialState
        }
        return result
    }
    
    public func any() -> AnyGesture {
        AnyGesture(self)
    }
}

public protocol ComposedGesture: GestureType {
    associatedtype Body: GestureType
    override associatedtype State = Body.State
    var body: Body { get }
}

extension GestureType where Self: ComposedGesture {
    public func any() -> AnyGesture {
        body.any()
    }
}

extension GestureType where Self: ComposedGesture {
    public var config: GestureConfig { body.config }
}

extension GestureType where Self: ComposedGesture, State == Body.State {
    
    public var initialState: State {
        body.initialState
    }
    
    public func recognize(context: GestureContext, state: inout State) -> GestureState {
        body.recognize(context: context, state: &state)
    }
}
