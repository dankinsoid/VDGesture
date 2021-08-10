//
//  File.swift
//  
//
//  Created by Данил Войдилов on 08.08.2021.
//

import Foundation

@resultBuilder
public struct GesturesBuilder {
    
    @inlinable
    public static func buildBlock(_ components: [AnyGesture]...) -> [AnyGesture] {
        Array(components.joined())
    }
    
    @inlinable
    public static func buildArray(_ components: [[AnyGesture]]) -> [AnyGesture] {
        Array(components.joined())
    }
    
    @inlinable
    public static func buildEither(first component: [AnyGesture]) -> [AnyGesture] {
        component
    }
    
    @inlinable
    public static func buildEither(second component: [AnyGesture]) -> [AnyGesture] {
        component
    }
    
    @inlinable
    public static func buildOptional(_ component: [AnyGesture]?) -> [AnyGesture] {
        component ?? []
    }
    
    @inlinable
    public static func buildLimitedAvailability(_ component: [AnyGesture]) -> [AnyGesture] {
        component
    }
    
    @inlinable
    public static func buildExpression(_ expression: AnyGesture) -> [AnyGesture] {
        [expression]
    }
    
    @inlinable
    public static func buildExpression<T: GestureType>(_ expression: T) -> [AnyGesture] {
        [expression.any()]
    }
}
