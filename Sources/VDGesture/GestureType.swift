//
//  GestureType.swift
//  VDKitFix
//
//  Created by Данил Войдилов on 27.07.2021.
//

import UIKit

public protocol GestureType {
    associatedtype State
    associatedtype Property = Void
    var initialState: State { get }
    var config: GestureConfig { get }
    func recognize(context: GestureContext, state: inout State) -> GestureState
    func property(context: GestureContext, state: State) -> Property
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

extension GestureType where Property == Void {
    public func property(context: GestureContext, state: State) -> Property {
        ()
    }
}

public protocol ComposedGesture: GestureType {
    associatedtype Body: GestureType
    override associatedtype State = Body.State
    override associatedtype Property = Body.Property
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
