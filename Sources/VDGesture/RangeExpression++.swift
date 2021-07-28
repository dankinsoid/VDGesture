//
//  RangeExpression++.swift
//  VDKitFix
//
//  Created by Данил Войдилов on 27.07.2021.
//

import Foundation

struct AnyRange<Bound: Comparable> {
    
    let contains: (_ element: Bound) -> Bool
    let min: Bound?
    let max: Bound?
    
    init<R: RangeExpression>(_ range: R) where R.Bound == Bound {
        contains = range.contains
        min = range.min
        max = range.max
    }
    
    init() {
        contains = { _ in true }
        min = nil
        max = nil
    }
}

extension RangeExpression {
    var min: Bound? {
        (self as? Range<Bound>)?.lowerBound ?? (self as? ClosedRange<Bound>)?.lowerBound ?? (self as? PartialRangeFrom)?.lowerBound
    }
    
    var max: Bound? {
        (self as? Range<Bound>)?.upperBound ?? (self as? ClosedRange<Bound>)?.upperBound ?? (self as? PartialRangeThrough)?.upperBound ?? (self as? PartialRangeUpTo)?.upperBound
    }
}
