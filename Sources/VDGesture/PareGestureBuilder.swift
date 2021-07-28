//
//  File.swift
//  
//
//  Created by Данил Войдилов on 28.07.2021.
//

import Foundation

@resultBuilder
public struct PareGestureBuilder<B: PareGestureBuildable> {
    
    @inlinable
    public static func buildBlock() -> PareEmptyGesture<B.Substate> {
        PareEmptyGesture(initialSubstate: B.initialSubstate)
    }
    
    @inlinable
    public static func buildBlock<C0>(_ c0: C0) -> PareSingleGesture<C0, B.Substate> {
        PareSingleGesture(wrapped: c0, initialSubstate: B.initialSubstate)
    }
    
    @inlinable
    public static func buildBlock<C1, C2>(_ c1: C1, _ c2: C2) -> Gestures.Pare<C1, C2, B.Substate> {
        Gestures.Pare(c1, c2, pareGesture: B.self)
    }
    
    @inlinable
    public static func buildBlock<C1, C2, C3>(_ c1: C1, _ c2: C2, _ c3: C3) -> Gestures.Pare<C1, Gestures.Pare<C2, C3, B.Substate>, B.Substate> {
        Gestures.Pare(c1, Gestures.Pare(c2, c3, pareGesture: B.self), pareGesture: B.self)
    }
    
    @inlinable
    public static func buildBlock<C1, C2, C3, C4>(_ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> Gestures.Pare<C1, Gestures.Pare<C2, Gestures.Pare<C3, C4, B.Substate>, B.Substate>, B.Substate> {
        Gestures.Pare(c1, Gestures.Pare(c2, Gestures.Pare(c3, c4, pareGesture: B.self), pareGesture: B.self), pareGesture: B.self)
    }

    @inlinable
    public static func buildBlock<C1, C2, C3, C4, C5>(_ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> Gestures.Pare<C1, Gestures.Pare<C2, Gestures.Pare<C3, Gestures.Pare<C4, C5, B.Substate>, B.Substate>, B.Substate>, B.Substate> {
        Gestures.Pare(c1, Gestures.Pare(c2, Gestures.Pare(c3, Gestures.Pare(c4, c5, pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self)
    }

    @inlinable
    public static func buildBlock<C1, C2, C3, C4, C5, C6>(_ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> Gestures.Pare<C1, Gestures.Pare<C2, Gestures.Pare<C3, Gestures.Pare<C4, Gestures.Pare<C5, C6, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate> {
        Gestures.Pare(c1, Gestures.Pare(c2, Gestures.Pare(c3, Gestures.Pare(c4, Gestures.Pare(c5, c6, pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self)
    }

    @inlinable
    public static func buildBlock<C1, C2, C3, C4, C5, C6, C7>(_ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> Gestures.Pare<C1, Gestures.Pare<C2, Gestures.Pare<C3, Gestures.Pare<C4, Gestures.Pare<C5, Gestures.Pare<C6, C7, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate> {
        Gestures.Pare(c1, Gestures.Pare(c2, Gestures.Pare(c3, Gestures.Pare(c4, Gestures.Pare(c5, Gestures.Pare(c6, c7, pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self)
    }

    @inlinable
    public static func buildBlock<C1, C2, C3, C4, C5, C6, C7, C8>(_ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> Gestures.Pare<C1, Gestures.Pare<C2, Gestures.Pare<C3, Gestures.Pare<C4, Gestures.Pare<C5, Gestures.Pare<C6, Gestures.Pare<C7, C8, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate> {
        Gestures.Pare(c1, Gestures.Pare(c2, Gestures.Pare(c3, Gestures.Pare(c4, Gestures.Pare(c5, Gestures.Pare(c6, Gestures.Pare(c7, c8, pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self)
    }

    @inlinable
    public static func buildBlock<C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> Gestures.Pare<C1, Gestures.Pare<C2, Gestures.Pare<C3, Gestures.Pare<C4, Gestures.Pare<C5, Gestures.Pare<C6, Gestures.Pare<C7, Gestures.Pare<C8, C9, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate> {
        Gestures.Pare(c1, Gestures.Pare(c2, Gestures.Pare(c3, Gestures.Pare(c4, Gestures.Pare(c5, Gestures.Pare(c6, Gestures.Pare(c7, Gestures.Pare(c8, c9, pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self)
    }

    @inlinable
    public static func buildBlock<C1, C2, C3, C4, C5, C6, C7, C8, C9, C10>(_ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10) -> Gestures.Pare<C1, Gestures.Pare<C2, Gestures.Pare<C3, Gestures.Pare<C4, Gestures.Pare<C5, Gestures.Pare<C6, Gestures.Pare<C7, Gestures.Pare<C8, Gestures.Pare<C9, C10, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate> {
        Gestures.Pare(c1, Gestures.Pare(c2, Gestures.Pare(c3, Gestures.Pare(c4, Gestures.Pare(c5, Gestures.Pare(c6, Gestures.Pare(c7, Gestures.Pare(c8, Gestures.Pare(c9, c10, pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self)
    }

    @inlinable
    public static func buildBlock<C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11>(_ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11) -> Gestures.Pare<C1, Gestures.Pare<C2, Gestures.Pare<C3, Gestures.Pare<C4, Gestures.Pare<C5, Gestures.Pare<C6, Gestures.Pare<C7, Gestures.Pare<C8, Gestures.Pare<C9, Gestures.Pare<C10, C11, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate> {
        Gestures.Pare(c1, Gestures.Pare(c2, Gestures.Pare(c3, Gestures.Pare(c4, Gestures.Pare(c5, Gestures.Pare(c6, Gestures.Pare(c7, Gestures.Pare(c8, Gestures.Pare(c9, Gestures.Pare(c10, c11, pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self)
    }

    @inlinable
    public static func buildBlock<C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12>(_ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12) -> Gestures.Pare<C1, Gestures.Pare<C2, Gestures.Pare<C3, Gestures.Pare<C4, Gestures.Pare<C5, Gestures.Pare<C6, Gestures.Pare<C7, Gestures.Pare<C8, Gestures.Pare<C9, Gestures.Pare<C10, Gestures.Pare<C11, C12, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate> {
        Gestures.Pare(c1, Gestures.Pare(c2, Gestures.Pare(c3, Gestures.Pare(c4, Gestures.Pare(c5, Gestures.Pare(c6, Gestures.Pare(c7, Gestures.Pare(c8, Gestures.Pare(c9, Gestures.Pare(c10, Gestures.Pare(c11, c12, pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self)
    }

    @inlinable
    public static func buildBlock<C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13>(_ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13) -> Gestures.Pare<C1, Gestures.Pare<C2, Gestures.Pare<C3, Gestures.Pare<C4, Gestures.Pare<C5, Gestures.Pare<C6, Gestures.Pare<C7, Gestures.Pare<C8, Gestures.Pare<C9, Gestures.Pare<C10, Gestures.Pare<C11, Gestures.Pare<C12, C13, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate> {
        Gestures.Pare(c1, Gestures.Pare(c2, Gestures.Pare(c3, Gestures.Pare(c4, Gestures.Pare(c5, Gestures.Pare(c6, Gestures.Pare(c7, Gestures.Pare(c8, Gestures.Pare(c9, Gestures.Pare(c10, Gestures.Pare(c11, Gestures.Pare(c12, c13, pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self)
    }

    @inlinable
    public static func buildBlock<C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14>(_ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13, _ c14: C14) -> Gestures.Pare<C1, Gestures.Pare<C2, Gestures.Pare<C3, Gestures.Pare<C4, Gestures.Pare<C5, Gestures.Pare<C6, Gestures.Pare<C7, Gestures.Pare<C8, Gestures.Pare<C9, Gestures.Pare<C10, Gestures.Pare<C11, Gestures.Pare<C12, Gestures.Pare<C13, C14, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate> {
        Gestures.Pare(c1, Gestures.Pare(c2, Gestures.Pare(c3, Gestures.Pare(c4, Gestures.Pare(c5, Gestures.Pare(c6, Gestures.Pare(c7, Gestures.Pare(c8, Gestures.Pare(c9, Gestures.Pare(c10, Gestures.Pare(c11, Gestures.Pare(c12, Gestures.Pare(c13, c14, pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self)
    }

    @inlinable
    public static func buildBlock<C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15>(_ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13, _ c14: C14, _ c15: C15) -> Gestures.Pare<C1, Gestures.Pare<C2, Gestures.Pare<C3, Gestures.Pare<C4, Gestures.Pare<C5, Gestures.Pare<C6, Gestures.Pare<C7, Gestures.Pare<C8, Gestures.Pare<C9, Gestures.Pare<C10, Gestures.Pare<C11, Gestures.Pare<C12, Gestures.Pare<C13, Gestures.Pare<C14, C15, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate> {
        Gestures.Pare(c1, Gestures.Pare(c2, Gestures.Pare(c3, Gestures.Pare(c4, Gestures.Pare(c5, Gestures.Pare(c6, Gestures.Pare(c7, Gestures.Pare(c8, Gestures.Pare(c9, Gestures.Pare(c10, Gestures.Pare(c11, Gestures.Pare(c12, Gestures.Pare(c13, Gestures.Pare(c14, c15, pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self)
    }

    @inlinable
    public static func buildBlock<C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15, C16>(_ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13, _ c14: C14, _ c15: C15, _ c16: C16) -> Gestures.Pare<C1, Gestures.Pare<C2, Gestures.Pare<C3, Gestures.Pare<C4, Gestures.Pare<C5, Gestures.Pare<C6, Gestures.Pare<C7, Gestures.Pare<C8, Gestures.Pare<C9, Gestures.Pare<C10, Gestures.Pare<C11, Gestures.Pare<C12, Gestures.Pare<C13, Gestures.Pare<C14, Gestures.Pare<C15, C16, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate> {
        Gestures.Pare(c1, Gestures.Pare(c2, Gestures.Pare(c3, Gestures.Pare(c4, Gestures.Pare(c5, Gestures.Pare(c6, Gestures.Pare(c7, Gestures.Pare(c8, Gestures.Pare(c9, Gestures.Pare(c10, Gestures.Pare(c11, Gestures.Pare(c12, Gestures.Pare(c13, Gestures.Pare(c14, Gestures.Pare(c15, c16, pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self)
    }

    @inlinable
    public static func buildBlock<C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15, C16, C17>(_ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13, _ c14: C14, _ c15: C15, _ c16: C16, _ c17: C17) -> Gestures.Pare<C1, Gestures.Pare<C2, Gestures.Pare<C3, Gestures.Pare<C4, Gestures.Pare<C5, Gestures.Pare<C6, Gestures.Pare<C7, Gestures.Pare<C8, Gestures.Pare<C9, Gestures.Pare<C10, Gestures.Pare<C11, Gestures.Pare<C12, Gestures.Pare<C13, Gestures.Pare<C14, Gestures.Pare<C15, Gestures.Pare<C16, C17, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate> {
        Gestures.Pare(c1, Gestures.Pare(c2, Gestures.Pare(c3, Gestures.Pare(c4, Gestures.Pare(c5, Gestures.Pare(c6, Gestures.Pare(c7, Gestures.Pare(c8, Gestures.Pare(c9, Gestures.Pare(c10, Gestures.Pare(c11, Gestures.Pare(c12, Gestures.Pare(c13, Gestures.Pare(c14, Gestures.Pare(c15, Gestures.Pare(c16, c17, pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self)
    }

    @inlinable
    public static func buildBlock<C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15, C16, C17, C18>(_ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13, _ c14: C14, _ c15: C15, _ c16: C16, _ c17: C17, _ c18: C18) -> Gestures.Pare<C1, Gestures.Pare<C2, Gestures.Pare<C3, Gestures.Pare<C4, Gestures.Pare<C5, Gestures.Pare<C6, Gestures.Pare<C7, Gestures.Pare<C8, Gestures.Pare<C9, Gestures.Pare<C10, Gestures.Pare<C11, Gestures.Pare<C12, Gestures.Pare<C13, Gestures.Pare<C14, Gestures.Pare<C15, Gestures.Pare<C16, Gestures.Pare<C17, C18, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate> {
        Gestures.Pare(c1, Gestures.Pare(c2, Gestures.Pare(c3, Gestures.Pare(c4, Gestures.Pare(c5, Gestures.Pare(c6, Gestures.Pare(c7, Gestures.Pare(c8, Gestures.Pare(c9, Gestures.Pare(c10, Gestures.Pare(c11, Gestures.Pare(c12, Gestures.Pare(c13, Gestures.Pare(c14, Gestures.Pare(c15, Gestures.Pare(c16, Gestures.Pare(c17, c18, pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self)
    }

    @inlinable
    public static func buildBlock<C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15, C16, C17, C18, C19>(_ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13, _ c14: C14, _ c15: C15, _ c16: C16, _ c17: C17, _ c18: C18, _ c19: C19) -> Gestures.Pare<C1, Gestures.Pare<C2, Gestures.Pare<C3, Gestures.Pare<C4, Gestures.Pare<C5, Gestures.Pare<C6, Gestures.Pare<C7, Gestures.Pare<C8, Gestures.Pare<C9, Gestures.Pare<C10, Gestures.Pare<C11, Gestures.Pare<C12, Gestures.Pare<C13, Gestures.Pare<C14, Gestures.Pare<C15, Gestures.Pare<C16, Gestures.Pare<C17, Gestures.Pare<C18, C19, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate>, B.Substate> {
        Gestures.Pare(c1, Gestures.Pare(c2, Gestures.Pare(c3, Gestures.Pare(c4, Gestures.Pare(c5, Gestures.Pare(c6, Gestures.Pare(c7, Gestures.Pare(c8, Gestures.Pare(c9, Gestures.Pare(c10, Gestures.Pare(c11, Gestures.Pare(c12, Gestures.Pare(c13, Gestures.Pare(c14, Gestures.Pare(c15, Gestures.Pare(c16, Gestures.Pare(c17, Gestures.Pare(c18, c19, pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self), pareGesture: B.self)
    }
    
    public static func buildEither<First, Second>(first component: First) -> EitherGesture<First, Second, B.Substate> {
        EitherGesture(gesture: .first(component), initialSubstate: B.initialSubstate)
    }
    
    public static func buildEither<First, Second>(second component: Second) -> EitherGesture<First, Second, B.Substate> {
        EitherGesture(gesture: .second(component), initialSubstate: B.initialSubstate)
    }
    
    public static func buildOptional<C>(_ component: C?) -> OptionalGesture<C, B.Substate> {
        OptionalGesture(wrapped: component, initialSubstate: B.initialSubstate)
    }
}
