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
    var touches: Set<Touch> { get }
    func update(after interval: TimeInterval)
    func set(debugRemark: String)
}

final class VDGestureRecognizer<Gesture: GestureType>: UILongPressGestureRecognizer, UIGestureRecognizerDelegate, UpdatableRecognizer {

    var gesture: Gesture
    private lazy var gestureState = gesture.initialState
    private var debugFile: String
    private var debugLine: UInt
    private var isFinished = false
    private var timers: [Timer] = []
    var touches: Set<Touch> = []
    private var context: GestureContext {
        GestureContext(recognizer: self, touch: touches.sorted(by: { $0.beginTimestamp < $1.beginTimestamp }).first)
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
        switch gesture.reduce(context: context, state: &gestureState) {
        case .valid:
            touches.forEach {
                $0.previousTimestamp = Date().timeIntervalSince1970
                $0.prevLocation = $0.uiTouch.location(in: nil)
            }
        case .none:
            break
        case .failed, .finished:
            timers.forEach { $0.invalidate() }
            timers = []
            touches = []
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        update(touches: touches, remove: false)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        update(touches: touches, remove: false)
    }
    
    override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
        update(touches: touches, remove: false)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        update(touches: touches, remove: true)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        update(touches: touches, remove: true)
    }
    
    private func update(touches: Set<UITouch>, remove: Bool) {
        let newTouches = touches.map { touch in
            self.touches.first(where: { $0.uiTouch == touch }) ?? Touch(touch)
        }
        if remove {
            self.touches = self.touches.subtracting(newTouches).filter({ $0.phase != .ended && $0.phase != .cancelled })
        } else {
            self.touches = self.touches.union(newTouches).filter({ $0.phase != .ended && $0.phase != .cancelled })
        }
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
