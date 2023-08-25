//
//  CountingLabel.swift
//
//
//  Created by Ben Comber on 26/01/2020.
//

import UIKit

class CountingLabel: UILabel {
    
    typealias OptionalCallback = (() -> Void)
    typealias OptionalFormatBlock = (() -> String)
    
    var completion: OptionalCallback?
    var customFormatBlock: OptionalFormatBlock?
    
    private var currentValue: Float {
        if progress >= totalTime { return destinationValue }
        return startingValue + (update(t: Float(progress / totalTime)) * (destinationValue - startingValue))
    }
    
    private var rate: Float = 0
    private var startingValue: Float = 0
    private var destinationValue: Float = 0
    private var progress: TimeInterval = 0
    private var lastUpdate: TimeInterval = 0
    private var totalTime: TimeInterval = 0
    private var easingRate: Float = 0
    private var timer: CADisplayLink?
    
    private func count(from: Float, to: Float, duration: TimeInterval) {
        if from == to {return}
        startingValue = from
        destinationValue = to
        
        if duration == 0.0 {
            setTextValue(value: to)
            completion?()
            return
        }
        
        easingRate = 3.0
        progress = 0.0
        totalTime = duration
        lastUpdate = Date.timeIntervalSinceReferenceDate
        rate = 3.0
        
        timer?.invalidate()
        timer = nil
        addDisplayLink()
    }
    
    public func countFromCurrent(to: Float, duration: TimeInterval) {
        count(from: currentValue, to: to, duration: duration)
    }
    
    public func countFromZero(to: Float, duration: TimeInterval) {
        count(from: 0, to: to, duration: duration)
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        progress = totalTime
        completion?()
    }
    
    private func addDisplayLink() {
        timer = CADisplayLink(target: self, selector: #selector(self.updateValue(timer:)))
        timer?.add(to: .main, forMode: .default)
        timer?.add(to: .main, forMode: .tracking)
    }
    
    private func update(t: Float) -> Float {
        var t = t
        var sign: Float = 1
        if Int(rate) % 2 == 0 { sign = -1 }
        t *= 2
        return t < 1 ? 0.5 * powf(t, rate) : (sign*0.5) * (powf(t-2, rate) + sign*2)
    }
    
    @objc private func updateValue(timer: Timer) {
        let now: TimeInterval = Date.timeIntervalSinceReferenceDate
        progress += now - lastUpdate
        lastUpdate = now
        
        if progress >= totalTime {
            self.timer?.invalidate()
            self.timer = nil
            progress = totalTime
        }
        
        setTextValue(value: currentValue)
        if progress == totalTime { completion?() }
    }
    
    func setTextValue(value: Float) {
        text = String(format: "%.0f", value)
    }
    
}

final class CountingOneDPLabel: CountingLabel {
    
    override func setTextValue(value: Float) {
        text = String(format: "%.1f", value)
    }
    
}
