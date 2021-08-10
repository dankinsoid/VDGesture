//
//  File.swift
//  
//
//  Created by Данил Войдилов on 08.08.2021.
//

import UIKit

public final class Touch: Hashable {
    public let uiTouch: UITouch
    public let beginTimestamp: TimeInterval
    var previousTimestamp: TimeInterval?
    var prevLocation: CGPoint?
     
    public var velocity: CGVector {
        guard let location = prevLocation, let time = previousTimestamp else { return .zero }
        let duration = CGFloat(Date().timeIntervalSince1970 - time)
        guard duration > 0 else { return .zero }
        let windowLocation = uiTouch.location(in: nil)
        return CGVector(
            dx: (windowLocation.x - location.x) / duration,
            dy: (windowLocation.y - location.y) / duration
        )
    }
    
    public var angle: CGFloat {
        let velocity = self.velocity
        guard velocity != .zero else { return 0 }
        if velocity.dx == 0 {
            return velocity.dy > 0 ? .pi / 2 : 3 * .pi / 2
        }
        switch (velocity.dx < 0, velocity.dy < 0) {
        case (true, true): return atan(velocity.dy / velocity.dx) + .pi
        case (true, false): return atan(velocity.dy / velocity.dx) + .pi
        case (false, true): return atan(velocity.dy / velocity.dx) + .pi * 2
        case (false, false): return atan(velocity.dy / velocity.dx)
        }
    }
    
    init(_ uiTouch: UITouch, beginTimestamp: TimeInterval = Date().timeIntervalSince1970) {
        self.uiTouch = uiTouch
        self.beginTimestamp = beginTimestamp
    }
    
    public static func == (lhs: Touch, rhs: Touch) -> Bool {
        lhs.uiTouch == rhs.uiTouch && lhs.beginTimestamp == rhs.beginTimestamp
    }
    
    public func hash(into hasher: inout Hasher) {
        uiTouch.hash(into: &hasher)
    }
}

public extension Touch {
    var phase: UITouch.Phase { uiTouch.phase }
    var majorRadius: CGFloat { uiTouch.majorRadius }
    var majorRadiusTolerance: CGFloat { uiTouch.majorRadiusTolerance }
    var window: UIWindow? { uiTouch.window }
    var view: UIView? { uiTouch.view }
    var force: CGFloat { uiTouch.force }
    var maximumPossibleForce: CGFloat { uiTouch.maximumPossibleForce }
    var altitudeAngle: CGFloat { uiTouch.altitudeAngle }
    var estimationUpdateIndex: Int? { uiTouch.estimationUpdateIndex?.intValue }
    var estimatedProperties: UITouch.Properties { uiTouch.estimatedProperties }
    var estimatedPropertiesExpectingUpdates: UITouch.Properties { uiTouch.estimatedPropertiesExpectingUpdates }
    var location: CGPoint { uiTouch.location(in: view) }
    var previousLocation: CGPoint { uiTouch.previousLocation(in: view) }
    var preciseLocation: CGPoint { uiTouch.preciseLocation(in: view) }
    var precisePreviousLocation: CGPoint { uiTouch.precisePreviousLocation(in: view) }
    var azimuthAngle: CGFloat { uiTouch.azimuthAngle(in: view) }
    var azimuthUnitVector: CGVector { uiTouch.azimuthUnitVector(in: view) }
    func location(in view: UIView?) -> CGPoint { uiTouch.location(in: view) }
    func previousLocation(in view: UIView?) -> CGPoint { uiTouch.previousLocation(in: view) }
    func preciseLocation(in view: UIView?) -> CGPoint { uiTouch.preciseLocation(in: view) }
    func precisePreviousLocation(in view: UIView?) -> CGPoint { uiTouch.precisePreviousLocation(in: view) }
    func azimuthAngle(in view: UIView?) -> CGFloat { uiTouch.azimuthAngle(in: view) }
    func azimuthUnitVector(in view: UIView?) -> CGVector { uiTouch.azimuthUnitVector(in: view) }
}

extension CGVector {
    public var length: CGFloat {
        sqrt(dx * dx + dy * dy)
    }
}

extension CGPoint {
    public func distance(to point: CGPoint) -> CGFloat {
        CGVector(dx: x - point.x, dy: y - point.y).length
    }
}

extension UITouch.Phase: CustomStringConvertible {
    public var description: String {
        switch self {
        case .began:    return "began"
        case .moved: return "moved"
        case .stationary: return "stationary"
        case .ended: return "ended"
        case .cancelled: return "cancelled"
        case .regionEntered: return "regionEntered"
        case .regionMoved: return "regionMoved"
        case .regionExited: return "regionExited"
        @unknown default: return "unknown"
        }
    }
}
