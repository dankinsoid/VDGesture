//
//  Recognizer.swift
//  VDKitFix
//
//  Created by Данил Войдилов on 27.07.2021.
//

import UIKit

extension UIView {
    public func add<G: GestureType>(gesture: G) {
        addGestureRecognizer(VDGestureRecognizer(gesture))
    }
}

protocol UpdatableRecognizer: UIGestureRecognizer {
    func update()
    func velocity() -> CGPoint
    func velocity(of touch: Int) -> CGPoint
}

final class VDGestureRecognizer<Gesture: GestureType>: UILongPressGestureRecognizer, UIGestureRecognizerDelegate, UpdatableRecognizer {

    var gesture: Gesture
    private lazy var gestureState = gesture.initialState
    private var isFinished = false
    private var lastLocations: [Int?: TouchLocation] = [:]
    private var context: GestureContext {
        GestureContext(recognizer: self)
    }
    
    init(_ gesture: Gesture) {
        self.gesture = gesture
        super.init(target: nil, action: nil)
        minimumPressDuration = 0
        delegate = self
        addTarget(self, action: #selector(handle))
    }
    
    @objc
    private func handle() {
        if isFinished, state == .cancelled {
            isFinished = false
            return
        }
        if state == .possible {
            return
        }
        switch gesture.recognize(gesture: context, state: &gestureState) {
        case .valid:
            lastLocations = [:]
            lastLocations[nil] = TouchLocation(point: location(in: nil), time: Date())
            if numberOfTouches > 0 {
                (0..<numberOfTouches).forEach {
                    lastLocations[$0] = TouchLocation(point: location(ofTouch: $0, in: nil), time: Date())
                }
            }
        case .failed, .finished:
            gestureState = gesture.initialState
            lastLocations = [:]
            isFinished = true
            isEnabled = false
            isEnabled = true
        }
    }
    
    func update() {
        handle()
    }
    
    func velocity() -> CGPoint {
        velocity(touch: nil)
    }
    
    func velocity(of touch: Int) -> CGPoint {
        velocity(touch: touch)
    }
    
    private func velocity(touch: Int?) -> CGPoint {
        guard let last = lastLocations[touch] else { return .zero }
        let time = Date()
        let duration = CGFloat(time.timeIntervalSince(last.time))
        guard duration > 0 else { return .zero }
        let windowLocation = touch.map { location(ofTouch: $0, in: nil) } ?? location(in: nil)
        return CGPoint(
            x: (windowLocation.x - last.point.x) / duration,
            y: (windowLocation.y - last.point.y) / duration
        )
    }
 
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
    
    @available(iOS 3.2, *)
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        gesture.config.recognizeSimultaneously
    }
    
    @available(iOS 7.0, *)
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        false
    }
    
    @available(iOS 7.0, *)
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        false
    }
    
    @available(iOS 3.2, *)
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        true
    }
    
    @available(iOS 9.0, *)
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
        true
    }
    
    @available(iOS 13.4, *)
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive event: UIEvent) -> Bool {
        true
    }
}

private struct TouchLocation {
    var point: CGPoint
    var time: Date
}
