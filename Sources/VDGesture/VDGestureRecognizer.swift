//
//  Recognizer.swift
//  VDKitFix
//
//  Created by Данил Войдилов on 27.07.2021.
//

import UIKit

extension UIView {
    public func add<G: GestureType>(gesture: G, file: String = #file, line: UInt = #line) {
        addGestureRecognizer(VDGestureRecognizer(gesture, file: file, line: line))
    }
    
    public func add<G: GestureType>(file: String = #file, line: UInt = #line, gesture: () -> G) {
        add(gesture: gesture(), file: file, line: line)
    }
}

protocol UpdatableRecognizer: UIGestureRecognizer {
    func update(after interval: TimeInterval)
    func velocity() -> CGPoint
    func velocity(of touch: Int) -> CGPoint
    func set(debugRemark: String)
}

final class VDGestureRecognizer<Gesture: GestureType>: UILongPressGestureRecognizer, UIGestureRecognizerDelegate, UpdatableRecognizer {

    var gesture: Gesture
    private lazy var gestureState = gesture.initialState
    private var debugFile: String
    private var debugLine: UInt
    private var isFinished = false
    private var lastLocations: [Int?: TouchLocation] = [:]
    private var timers: [Timer] = []
    private var context: GestureContext {
        GestureContext(recognizer: self)
    }
    
    init(_ gesture: Gesture, file: String, line: UInt) {
        self.gesture = gesture
        debugFile = (file as NSString).lastPathComponent
        debugLine = line
        super.init(target: nil, action: nil)
        minimumPressDuration = 0
        delegate = self
        addTarget(self, action: #selector(handle))
    }
    
    @objc
    private func handle() {
        update(skipPossible: true)
    }
    
    private func update(skipPossible: Bool) {
        if skipPossible, state == .possible {
            return
        }
        if isFinished {
            isFinished = false
            if state == .cancelled {
                return
            }
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
        case .none:
            break
        case .failed, .finished:
            timers.forEach { $0.invalidate() }
            timers = []
            gestureState = gesture.initialState
            lastLocations = [:]
            isFinished = true
            isEnabled = false
            isEnabled = true
        }
    }
    
    func update(after interval: TimeInterval) {
        if interval == 0 {
            update(skipPossible: isFinished)
        } else {
            timers.append(
                Timer.scheduledTimer(withTimeInterval: interval, repeats: false) {[weak self] in
                    guard $0.isValid else { return }
                    self?.update(skipPossible: self?.isFinished ?? false)
                }
            )
        }
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
 
    func set(debugRemark: String) {
        #if DEBUG
        if gesture.config.enableDebug {
            print("Gesture(\(debugFile) \(debugLine)) | \(debugRemark)")
        }
        #endif
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
        !gesture.config.ignoreSubviews || touch.view === gestureRecognizer.view
    }
    
    @available(iOS 9.0, *)
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
        true
    }
    
    @available(iOS 13.4, *)
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive event: UIEvent) -> Bool {
        true
    }
    
    deinit {
        timers.forEach { $0.invalidate() }
    }
}

private struct TouchLocation {
    var point: CGPoint
    var time: Date
}
