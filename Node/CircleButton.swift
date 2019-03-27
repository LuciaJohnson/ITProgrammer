//
//  CircleButton.swift
//  BallDown
//
//  Copyright (c) 2015 ones. All rights reserved.
//

import Foundation
import SpriteKit

class CircleButton: SKShapeNode {
    
    static let radius = CGFloat(65)
    static let outlineLineWidth = CGFloat(2)
    static let strokeColorNormal = SKColor(hue: 0, saturation: 0, brightness: 0.9, alpha: 1)
    static let strokeColorTapped = SKColor(hue: 0, saturation: 0, brightness: 0.68, alpha: 0.4)
    static let fillColorNormal = SKColor(hue: 0, saturation: 0, brightness: 1, alpha: 0)
    static let fillColorTapped = SKColor(hue: 0, saturation: 0, brightness: 0.9, alpha: 0.4)
    static let contentColorNormal = SKColor(hue: 0, saturation: 0, brightness: 1, alpha: 1)
    static let contentColorTapped = SKColor(hue: 0, saturation: 0, brightness: 1, alpha: 0)
    
    // state
    var colorChaning = false
    var contentColorChanging = false
    
    var tapped: Bool {
        get {
            return colorChaning || contentColorChanging
        }
    }
    var onTapped: ((CircleButton)-> Void)?
    
    private var content: SKNode!
    var contentOnChanged: ((SKNode, SKColor)-> Void)?
    
    private func build() {
        self.lineWidth = CircleButton.outlineLineWidth
        self.isUserInteractionEnabled = true
        self.strokeColor = CircleButton.strokeColorNormal
        self.fillColor = CircleButton.fillColorNormal
        
        self.addChild(content)
        self.contentOnChanged?(self.content, CircleButton.contentColorNormal)
    }

    static func make(content: SKNode, contentOnChanged: ((SKNode, SKColor)-> Void)?, onTapped: ((CircleButton)-> Void)?)-> CircleButton {
        
        let button = CircleButton(circleOfRadius: radius)
        
        button.content = content
        button.contentOnChanged = contentOnChanged
        button.onTapped = onTapped
        
        button.build()
        
        return button
    }
    
    static func shape(content: SKShapeNode, onTapped: ((CircleButton)-> Void)?)-> CircleButton {
        
        return CircleButton.make(content: content, contentOnChanged: {node, color in
            
            let shapeNode = node as! SKShapeNode
            shapeNode.fillColor = color
            shapeNode.strokeColor = color
            
        }, onTapped: onTapped)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // on tapped
        if tapped {
            return
        }
        
        let duration = TimeInterval(0.2)
        
        // change button color
        self.colorChaning = true
        self.run(SKAction.sequence([
            SKAction.customAction(withDuration: duration / 2, actionBlock: {node, elapsedTime in
                self.fillColor = self.changeColor(fromColor: CircleButton.fillColorNormal, toColor: CircleButton.fillColorTapped, duration: duration / 2, elapsedTime: elapsedTime)
                self.strokeColor = self.changeColor(fromColor: CircleButton.strokeColorNormal, toColor: CircleButton.strokeColorTapped, duration: duration / 2, elapsedTime: elapsedTime)
            }),
            SKAction.customAction(withDuration: duration / 2, actionBlock: {node, elapsedTime in
                self.fillColor = self.changeColor(fromColor: CircleButton.fillColorTapped, toColor: CircleButton.fillColorNormal, duration: duration / 2, elapsedTime: elapsedTime)
                self.strokeColor = self.changeColor(fromColor: CircleButton.strokeColorTapped, toColor: CircleButton.strokeColorNormal, duration: duration / 2, elapsedTime: elapsedTime)
            }),
            SKAction.run({
                self.colorChaning = false
            })
        ]))
        
        // change content color
        self.contentColorChanging = true
        self.run(SKAction.sequence([
            SKAction.customAction(withDuration: duration / 2, actionBlock: {node, elapsedTime in
                let contentColor = self.changeColor(fromColor: CircleButton.contentColorNormal, toColor: CircleButton.contentColorTapped, duration: duration / 2, elapsedTime: elapsedTime)
                self.contentOnChanged?(self.content, contentColor)
            }),
            SKAction.customAction(withDuration: duration / 2, actionBlock: {node, elapsedTime in
                let contentColor = self.changeColor(fromColor: CircleButton.contentColorTapped, toColor: CircleButton.contentColorNormal, duration: duration / 2, elapsedTime: elapsedTime)
                self.contentOnChanged?(self.content, contentColor)
            }),
            SKAction.run({
                self.contentColorChanging = false
            })
        ]))
        
        // play sound
        Av.share.tapButton.play()
        self.onTapped?(self)
    }
    
    private func changeColor(fromColor: SKColor, toColor: SKColor, duration: TimeInterval, elapsedTime: CGFloat)-> SKColor {
        
        let fromColorComponents = fromColor.cgColor.components!
        let toColorComponents = toColor.cgColor.components!
        
        func makeColor(index: Int)-> CGFloat {
            
            let start = fromColorComponents[index]
            let stop = toColorComponents[index]
            let color = start + (stop - start) * (CGFloat(elapsedTime) / CGFloat(duration))
            return color
        }
        
        return SKColor(red: makeColor(index: 0), green: makeColor(index: 1), blue: makeColor(index: 2), alpha: makeColor(index: 3))
    }
}

