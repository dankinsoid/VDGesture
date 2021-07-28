//
//  File.swift
//  
//
//  Created by Данил Войдилов on 28.07.2021.
//

import Foundation

//extension GestureType {
//
//    public func inverted() -> Gestures.Inverted<Self> {
//        Gestures.Inverted(self)
//    }
//}
//
//extension Gestures {
//
//    public struct Inverted<Wrapped: GestureType>: GestureType {
//        public var wrapped: Wrapped
//        public var config: GestureConfig { wrapped.config }
//        public var initialState: State { State(wrapped: wrapped.initialState) }
//
//        public init(_ wrapped: Wrapped) {
//            self.wrapped = wrapped
//        }
//
//        public func recognize(gesture: GestureContext, state: inout State) -> GestureState {
//            switch wrapped.recognize(gesture: gesture, state: &state.wrapped) {
//            case .failed:
//                if state.didStart {
//                    gesture.debugFail(of: Self.self, reason: "Did start")
//                    return .failed
//                } else {
//                    return .finished
//                }
//            case .finished:
//                return .failed
//            case .valid:
//                state.didStart = true
//                return .failed
//            case .none:
//                return .valid
//            }
//        }
//
//        public struct State {
//            public var wrapped: Wrapped.State
//            public var didStart = false
//        }
//    }
//}
