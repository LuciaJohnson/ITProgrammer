//
//  NumberNode.swift
//  BallDown
//
//  Copyright © 2015 ones. All rights reserved.
//

import Foundation
import SpriteKit

class NumberNode: SKLabelNode {
    
    var intValue: Int {
        get {
            return Int(super.text!)!
        }
        set {
            super.text = String(newValue)
        }
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTo(number: Int, complete: @escaping ()-> Void) {
        
        let diff = number - self.intValue
        if (diff < 0) {
            // error
        }
        else if (diff == 0) {
            complete()
            return
        }
        else {
            var test = diff
            var count = 0
            let denominator = 10
            
            repeat {
                count += test % denominator
                test /= denominator
            } while (test > 0)
            
            
            self.run(SKAction.sequence([
                SKAction.repeat(SKAction.sequence([
                    SKAction.run({
                        
                        let diff = number - self.intValue
                        if (diff == 0) {
                            return
                        }
                        
                        var needAdd = 10
                        while (needAdd  <= diff) {
                            needAdd *= 10
                        }
                        needAdd /= 10
                        
                        self.intValue += needAdd
                        
                    }),
                    SKAction.wait(forDuration: TimeInterval(0.05))
                    ]), count: count),
                SKAction.run(complete)
            ]))
        }
    }
}
