//
//  RangeExpression++.swift
//  VDKitFix
//
//  Created by Данил Войдилов on 27.07.2021.
//

import Foundation

extension RangeExpression {
    var min: Bound? {
        (self as? Range<Bound>)?.lowerBound ?? (self as? ClosedRange<Bound>)?.lowerBound ?? (self as? PartialRangeFrom)?.lowerBound
    }
    
    var max: Bound? {
        (self as? Range<Bound>)?.upperBound ?? (self as? ClosedRange<Bound>)?.upperBound ?? (self as? PartialRangeThrough)?.upperBound ?? (self as? PartialRangeUpTo)?.upperBound
    }
}
