//
//  Press.swift
//  VDKitFix
//
//  Created by Данил Войдилов on 27.07.2021.
//

import Foundation

public enum Gestures {
    
    public struct Drag: GestureType {
        public var initialState: State { State() }
        public var config: GestureConfig { .init() }
        
        public init() {}
        
        public func recognize(context: GestureContext, state: inout State) -> GestureState {
            switch context.state {
            case .began, .changed:
                state.wasValid = true
                return .valid
            case .possible:
                return .none
            case .ended:
                return .finished
            case .cancelled, .failed:
                context.debugFail(of: Self.self, reason: "Failed")
                return .failed
            @unknown default:
                return .failed
            }
        }
        
        public struct State {
            public var wasValid: Bool = false
        }
    }
}

//UITapGestureRecognizer
//UIPanGestureRecognizer
//UILongPressGestureRecognizer

//UIPinchGestureRecognizer
//UIRotationGestureRecognizer
//UISwipeGestureRecognizer
//UIScreenEdgePanGestureRecognizer
//UIHoverGestureRecognizer
