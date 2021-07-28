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
    func recognize(gesture: GestureContext, state: inout State) -> GestureState
    func any() -> AnyGesture
}

extension GestureType {
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
    
    public func recognize(gesture: GestureContext, state: inout State) -> GestureState {
        body.recognize(gesture: gesture, state: &state)
    }
}
