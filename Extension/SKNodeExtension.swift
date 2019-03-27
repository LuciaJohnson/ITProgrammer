//
//  SKNodeExtension.swift
//  BallDown
//
//  Copyright (c) 2015 ones. All rights reserved.
//

import Foundation
import SpriteKit

extension SKNode {
    
    var bind: AnyObject? {
        get {
            return self.userData?.object(forKey: "@bind") as AnyObject
        }
        set {
            if newValue == nil {
                self.userData?.removeObject(forKey: "@bind")
            }
            else {
                if self.userData == nil {
                    self.userData = NSMutableDictionary()
                }
                self.userData!.setValue(newValue, forKey: "@bind")
            }
        }
    }
        

}
