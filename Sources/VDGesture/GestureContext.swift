//
//  GestureContext.swift
//  VDKitFix
//
//  Created by Данил Войдилов on 27.07.2021.
//

import UIKit

public struct GestureContext {
    var recognizer: UpdatableRecognizer
    let touch: Touch?
    
    public var state: UIGestureRecognizer.State { recognizer.state }
    
    public var touches: [Touch] {
        recognizer.touches.sorted(by: { $0.beginTimestamp < $1.beginTimestamp })
    }
    
    public var children: [GestureContext] {
        touches.map { GestureContext(recognizer: recognizer, touch: $0) }
    }
    
    public func update(after interval: TimeInterval) {
        recognizer.update(after: interval)
    }
    
    public func set(debugRemark: String) {
        recognizer.set(debugRemark: debugRemark)
    }
    
    public func debugFail<G: GestureType>(of type: G.Type, reason: String) {
        set(debugRemark: "\(type): '\(reason)'")
    }
}

public extension GestureContext {
    var majorRadius: CGFloat { touch?.majorRadius ?? 0 }
    var majorRadiusTolerance: CGFloat { touch?.majorRadiusTolerance ?? 0 }
    var window: UIWindow? { touch?.window }
    var view: UIView? { touch?.view }
    var force: CGFloat { touch?.force ?? 0 }
    var maximumPossibleForce: CGFloat { touch?.maximumPossibleForce ?? 0 }
    var altitudeAngle: CGFloat { touch?.altitudeAngle ?? 0 }
    var estimationUpdateIndex: Int? { touch?.estimationUpdateIndex }
    var estimatedProperties: UITouch.Properties { touch?.estimatedProperties ?? [] }
    var estimatedPropertiesExpectingUpdates: UITouch.Properties { touch?.estimatedPropertiesExpectingUpdates ?? [] }
    var location: CGPoint { touch?.location(in: view) ?? .zero }
    var previousLocation: CGPoint { touch?.previousLocation(in: view) ?? .zero }
    var preciseLocation: CGPoint { touch?.preciseLocation(in: view) ?? .zero }
    var precisePreviousLocation: CGPoint { touch?.precisePreviousLocation(in: view) ?? .zero }
    var velocity: CGVector { touch?.velocity ?? .zero }
    var angle: CGFloat { touch?.angle ?? 0 }
    var azimuthAngle: CGFloat { touch?.azimuthAngle ?? 0 }
    var azimuthUnitVector: CGVector { touch?.azimuthUnitVector ?? .zero }
    func location(in view: UIView?) -> CGPoint { touch?.location(in: view) ?? .zero }
    func previousLocation(in view: UIView?) -> CGPoint { touch?.previousLocation(in: view) ?? .zero }
    func preciseLocation(in view: UIView?) -> CGPoint { touch?.preciseLocation(in: view) ?? .zero }
    func precisePreviousLocation(in view: UIView?) -> CGPoint { touch?.precisePreviousLocation(in: view) ?? .zero }
    func azimuthAngle(in view: UIView?) -> CGFloat { touch?.azimuthAngle(in: view) ?? 0 }
    func azimuthUnitVector(in view: UIView?) -> CGVector { touch?.azimuthUnitVector(in: view) ?? .zero }
}
