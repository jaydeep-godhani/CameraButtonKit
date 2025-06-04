//
//  CameraButton.swift
//  CameraButtonKit
//
//  Created by jaydeep godhani on 04/06/25.
//

import UIKit

protocol CameraButtonDelegate: AnyObject {
    func onStartRecord()
    func onEndRecord()
    func onDurationTooShortError()
    func onSingleTap()
    func onCancelled()
}

class CameraButtonView: UIView {
    
    // MARK: - UI Components
    
    private let button = UIButton(type: .custom)
    private let spinnerLayer = CAShapeLayer()
    
    // MARK: - Configuration
    
    weak var delegate: CameraButtonDelegate?
    
    private var isRecording = false
    private var startTime: TimeInterval = 0
    private let minRecordDuration: TimeInterval = 0.3
    private let maxRecordDuration: TimeInterval = 60.0
    
    private var stopRecordingTimer: Timer?
    
    public var lineWidth: CGFloat = 10
    public var spinnerLineSpacing: CGFloat = 20
    public var spinnerPadding: CGFloat = 15
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupGestures()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        
        // Button setup
        button.backgroundColor = .white
        button.clipsToBounds = true
        addSubview(button)
        
        // Spinner layer setup
        spinnerLayer.strokeColor = UIColor.red.cgColor
        spinnerLayer.fillColor = UIColor.clear.cgColor
        spinnerLayer.lineWidth = lineWidth
        spinnerLayer.lineCap = .square
        spinnerLayer.strokeStart = 0
        spinnerLayer.strokeEnd = 0
        spinnerLayer.isHidden = true
        layer.addSublayer(spinnerLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let totalAvailableRadius = min(bounds.width, bounds.height) / 2
        let buttonRadius = totalAvailableRadius - spinnerLineSpacing - spinnerPadding - (lineWidth / 2)
        let buttonSize = buttonRadius * 2
        
        // Button frame
        button.frame = CGRect(
            x: (bounds.width - buttonSize) / 2,
            y: (bounds.height - buttonSize) / 2,
            width: buttonSize,
            height: buttonSize
        )
        button.layer.cornerRadius = buttonSize / 2
        
        // Spinner frame
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let spinnerRadius = buttonRadius + spinnerLineSpacing
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: spinnerRadius,
            startAngle: -.pi / 2,
            endAngle: 1.5 * .pi,
            clockwise: true
        )
        
        spinnerLayer.path = circularPath.cgPath
        spinnerLayer.frame = bounds
        spinnerLayer.position = center
    }
    
    // MARK: - Gestures
    
    private func setupGestures() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPress.minimumPressDuration = 0.5
        button.addGestureRecognizer(longPress)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.require(toFail: longPress)
        button.addGestureRecognizer(tap)
    }
    
    // MARK: - Actions
    
    @objc private func handleTap() {
        if !isRecording {
            delegate?.onSingleTap()
        }
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            startRecording()
        case .ended, .cancelled:
            endRecording()
        default:
            break
        }
    }
    
    private func startRecording() {
        guard !isRecording else { return }
        isRecording = true
        startTime = Date().timeIntervalSince1970
        delegate?.onStartRecord()
        
        spinnerLayer.isHidden = false
        startSpinning()
        
        // Stop automatically
        stopRecordingTimer = Timer.scheduledTimer(withTimeInterval: maxRecordDuration, repeats: false) { [weak self] _ in
            _ = self?.endRecording()
        }
    }
    
    @discardableResult
    private func endRecording() -> Bool {
        guard isRecording else { return false }
        isRecording = false
        stopRecordingTimer?.invalidate()
        
        spinnerLayer.isHidden = true
        stopSpinning()
        
        let duration = Date().timeIntervalSince1970 - startTime
        if duration < minRecordDuration {
            delegate?.onDurationTooShortError()
        } else {
            delegate?.onEndRecord()
        }
        
        return true
    }
    
    func cancelRecording() {
        guard isRecording else { return }
        isRecording = false
        stopRecordingTimer?.invalidate()
        
        spinnerLayer.isHidden = true
        stopSpinning()
        delegate?.onCancelled()
    }
    
    // MARK: - Progress Animation
    
    private func startSpinning() {
        spinnerLayer.isHidden = false
        spinnerLayer.strokeStart = 0
        spinnerLayer.strokeEnd = 0.1  // Small dash
        
        // PHASE 1: Stroke expands
        let strokeEndAnim = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnim.fromValue = 0
        strokeEndAnim.toValue = 1
        strokeEndAnim.duration = 0.7
        strokeEndAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        strokeEndAnim.fillMode = .forwards
        strokeEndAnim.isRemovedOnCompletion = false
        
        // PHASE 2: StrokeStart catches up, shrinking the visible arc
        let strokeStartAnim = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnim.fromValue = 0
        strokeStartAnim.toValue = 1
        strokeStartAnim.duration = 0.7
        strokeStartAnim.beginTime = 0.7
        strokeStartAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        strokeStartAnim.fillMode = .forwards
        strokeStartAnim.isRemovedOnCompletion = false
        
        // Combine into a single group
        let strokeGroup = CAAnimationGroup()
        strokeGroup.animations = [strokeEndAnim, strokeStartAnim]
        strokeGroup.duration = 1.4
        strokeGroup.repeatCount = .infinity
        strokeGroup.isRemovedOnCompletion = false
        strokeGroup.fillMode = .forwards
        
        spinnerLayer.add(strokeGroup, forKey: "strokeCycle")
        
        // Continuous rotation (unaffected by stroke phase)
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.fromValue = 0
        rotate.toValue = 2 * Double.pi
        rotate.duration = 2.0
        rotate.repeatCount = .infinity
        rotate.timingFunction = CAMediaTimingFunction(name: .linear)
        
        spinnerLayer.add(rotate, forKey: "rotation")
    }
    
    private func stopSpinning() {
        spinnerLayer.removeAllAnimations()
        spinnerLayer.strokeStart = 0
        spinnerLayer.strokeEnd = 0
        spinnerLayer.isHidden = true
    }
    
}
