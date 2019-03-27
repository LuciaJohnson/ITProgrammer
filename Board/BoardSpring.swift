//
//  BoardSpring.swift
//  BallDown
//
//  Copyright © 2015 ones. All rights reserved.
//

import Foundation
import SpriteKit

class BoardSpring: BoardAbstract {
    
    static let DATA_IMPULSE = "BoardSpring.topBoard.impluse"
    static let DATA_HAS_SPRING_IMPULSE = "BoardSpring.impluse"
    
    let topBoardImpulseY = CGFloat(100)
    let halfActionTimeStandard = TimeInterval(0.15)
    let boardWidth = Boards.width
    let boardHeight = Boards.height / 2
    let boardRadius = Boards.radius / 2
    let springWidth = CGFloat(40)
    let maxSpringHeight = CGFloat(30)
    let minSpringHeight = CGFloat(10)
    let springCount = 3
    let boardColor = SKColor(hue: CGFloat(50) / 360.0, saturation: 0.8, brightness: 0.9, alpha: 1)
    let boardStrokeColor = SKColor(hue: CGFloat(50) / 360.0, saturation: 0.8, brightness: 0.8, alpha: 1)
    
    var topBoardCollideMask : UInt32!
    var bottomBoardCollideMask : UInt32!
    
    override func newNode(_ boardTemplate: BoardTemplate, boardSize: CGSize) -> SKNode {
        
        topBoardCollideMask = boardTemplate.collideMaskFirst
        bottomBoardCollideMask = boardTemplate.collideMaskSecond
        
        let board = SKNode()
        board.name = "BoardSpring"
        
        let bottomBoard = SKShapeNode(rectOf: CGSize(width: boardWidth, height: boardHeight), cornerRadius: boardRadius)
        bottomBoard.name = "BoardSpring.bottomBoard"
        bottomBoard.physicsBody = SKPhysicsBody(rectangleOf: bottomBoard.frame.size)
        bottomBoard.physicsBody!.categoryBitMask = bottomBoardCollideMask
        bottomBoard.physicsBody!.isDynamic = false
        bottomBoard.position.y = 0
        bottomBoard.fillColor = boardColor
        bottomBoard.strokeColor = boardStrokeColor
        board.addChild(bottomBoard)
        bottomBoard.bind = self
        
        let springsHeight = maxSpringHeight
        let springsWidth = boardWidth * 0.8
        let springDeltaY = springsHeight / CGFloat(springCount + 1)
        var springsDrawY = CGFloat(0)
        let springsPath = CGMutablePath()
        for i in 0 ..< springCount + 2 {
            springsDrawY = CGFloat(i) * springDeltaY
            springsPath.move(to: CGPoint(x: 0, y: springsDrawY))
            springsPath.addLine(to: CGPoint(x: springWidth, y: springsDrawY))
            springsPath.move(to: CGPoint(x: springsWidth - springWidth, y: springsDrawY))
            springsPath.addLine(to: CGPoint(x: springsWidth, y: springsDrawY))
        }
        // TODO
//        springsPath.closeSubpath()
        
        let springs = SKShapeNode(path: springsPath, centered: true)
        springs.name = "BoardSpring.springs"
        springs.position.y = bottomBoard.position.y + bottomBoard.frame.height / 2 + springs.frame.height / 2
        board.addChild(springs)
        
        
        let topBoard = SKShapeNode(rectOf: CGSize(width: boardWidth, height: boardHeight), cornerRadius: boardRadius)
        topBoard.name = "BoardSpring.topBoard"
        topBoard.physicsBody = SKPhysicsBody(rectangleOf: topBoard.frame.size)
        topBoard.physicsBody!.categoryBitMask = topBoardCollideMask
        topBoard.physicsBody!.isDynamic = false
        topBoard.position.y = springs.position.y + springs.frame.height / 2 + topBoard.frame.height / 2
        topBoard.fillColor = boardColor
        topBoard.strokeColor = boardStrokeColor
        topBoard.userData = NSMutableDictionary()
        topBoard.userData!.setValue(self, forKey: "board")
        topBoard.userData!.setValue(self.topBoardImpulseY, forKey: BoardSpring.DATA_IMPULSE)
        board.addChild(topBoard)
        topBoard.bind = self
        
        return board
    }
    
    override func onBeginContact(board: SKNode, ball: Ball, contact: SKPhysicsContact, game: GameDelegate) {
        
        if let impulseY = board.userData!.object(forKey: BoardSpring.DATA_IMPULSE) as? CGFloat {
            // topBoard
            
            if ball.userData!.object(forKey: BoardSpring.DATA_HAS_SPRING_IMPULSE) == nil {
                ball.userData!.setValue(true, forKey: BoardSpring.DATA_HAS_SPRING_IMPULSE)
                ball.physicsBody!.applyImpulse(CGVector(dx: 0, dy: impulseY))
                ball.run(SKAction.sequence([
                    SKAction.wait(forDuration: TimeInterval(0.2)),
                    SKAction.run({
                        ball.userData!.removeObject(forKey: BoardSpring.DATA_HAS_SPRING_IMPULSE)
                    })
                ]))
            }
            
            let springs: SKNode! = board.parent!.childNode(withName: "BoardSpring.springs")
            
            let topBoardPositionY = board.position.y
            let springsRawPositionY = springs.position.y
            
            let halfActionTimeF = CGFloat(halfActionTimeStandard) / (log10(game.accelerate) + 1)
            let halfActionTime = TimeInterval(halfActionTimeF)
            
            board.run(SKAction.sequence([
                SKAction.moveTo(y: topBoardPositionY / 2, duration: halfActionTime),
                SKAction.moveTo(y: topBoardPositionY, duration: halfActionTime)
            ]))
            springs.run(SKAction.sequence([
                SKAction.scaleY(to: 0.1, duration: halfActionTime),
                SKAction.scaleY(to: 1.0, duration: halfActionTime)
            ]))
            springs.run(SKAction.sequence([
                SKAction.fadeOut(withDuration: halfActionTime / 2),
                SKAction.wait(forDuration: halfActionTime),
                SKAction.fadeIn(withDuration: halfActionTime / 2)
            ]))
            springs.run(SKAction.sequence([
                SKAction.moveTo(y: boardHeight / 2 + 3, duration: halfActionTime),
                SKAction.moveTo(y: springsRawPositionY, duration: halfActionTime)
            ]))
        }
    }
    
    override func playCollideSound(fromFloor: Int, toFloor: Int) {
        Av.share.collide.play()
    }
}
