//
//  ColorScrubberView.swift
//  OutfitBlock
//
//  Created by Ri Zhao on 2018-08-18.
//  Copyright © 2018 Ri Zhao. All rights reserved.
//

import UIKit
import QuartzCore

class ColorScrubber: UIControl {
    var scrubValue = 0.7
    var minValue = 0.3
    var maxValue = 1.0
    
    let gradientTrack = CAGradientLayer()
    
    let selectorLayer = ColorScrubberSelectorLayer()
    
    var selectorHeight : CGFloat {
        return CGFloat(bounds.width / 4)
    }
 
    var previousLocation = CGPoint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let colorLight : UIColor = UIColor.init(hue: 0.675, saturation: CGFloat(minValue), brightness: CGFloat(maxValue), alpha: 1.0)
        let color : UIColor = UIColor.init(hue: 0.675, saturation: CGFloat(scrubValue), brightness: CGFloat(maxValue), alpha: 1.0)
        let colorDark : UIColor = UIColor.init(hue: 0.675, saturation: CGFloat(maxValue), brightness: CGFloat(maxValue), alpha: 1.0)
        //layer.backgroundColor = UIColor.w

        gradientTrack.colors = [colorLight.cgColor, color.cgColor, colorDark.cgColor]
        layer.addSublayer(gradientTrack)
        gradientTrack.masksToBounds = true
        gradientTrack.cornerRadius = 20.0
        
        selectorLayer.ColorScrubber = self
        selectorLayer.borderColor = UIColor.gray.cgColor
        selectorLayer.borderWidth = 8.0
        selectorLayer.masksToBounds = true
        selectorLayer.cornerRadius = 10.0
        selectorLayer.backgroundColor = UIColor.green.withAlphaComponent(0.5).cgColor
        layer.addSublayer(selectorLayer)
        
        updateLayerFrames()
    }
    
    required init?(coder : NSCoder) {
        super.init(coder: coder)
    }
    
    func updateLayerFrames(){
        gradientTrack.frame = bounds.insetBy(dx: selectorHeight / 4, dy: selectorHeight / 2)
        gradientTrack.setNeedsDisplay()
        
        let selectorCenter = CGFloat(positionForValue(value: scrubValue))
        let color : UIColor = UIColor.init(hue: 0.675, saturation: CGFloat(scrubValue), brightness: 1.0, alpha: 1.0)
        //gradientTrack.colors = [UIColor.white.cgColor, color.cgColor, UIColor.black.cgColor]
        selectorLayer.backgroundColor = color.withAlphaComponent(0.8).cgColor

        selectorLayer.frame = CGRect(x: 0.0, y: selectorCenter, width: bounds.width, height: selectorHeight)
        selectorLayer.setNeedsDisplay()
    }
    
    func positionForValue(value: Double) -> Double{
        let position: Double =  (Double(bounds.height - selectorHeight) * (value - minValue) / (maxValue - minValue))
        
        return min(max(position, 0), Double(bounds.height))
     
    }
    
    override var frame: CGRect{
        didSet {
            updateLayerFrames()
        }
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)
        
        // Hit test the thumb layers
        if selectorLayer.frame.contains(previousLocation){
            selectorLayer.highlighted = true
        }
        return selectorLayer.highlighted
    }
    
    func boundValue(value: Double) -> Double {
        return min(max(value, minValue), maxValue)
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        // how much did the user drag
        let dLocation = Double(location.y - previousLocation.y)
        let dValue = (maxValue - minValue) * dLocation / Double(bounds.height - selectorHeight )
        
        previousLocation = location
        
        //update values if the selector is being dragged
        if selectorLayer.highlighted{
            scrubValue += dValue
            scrubValue = boundValue(value: scrubValue)
        }
        
        //update UI
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        updateLayerFrames()
        CATransaction.commit()
        
        return true
    }
    
    
}
