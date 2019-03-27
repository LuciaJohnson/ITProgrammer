//
//  BoardScroll.swift
//  BallDown
//
//  Copyright © 2015 ones. All rights reserved.
//

import Foundation
import SpriteKit

class BoardScroll: BoardAbstract {
    
    static let KEY_SPEED_X = "BoardScroll.speedX"
    
    let boardHeight = CGFloat(50)
    let wheelRatio = CGFloat(0.7)
    let speed = CGFloat(100)
    let boardColor = SKColor(hue: CGFloat(23)/360.0, saturation: 0.8, brightness: 0.9, alpha: 1)
    let boardStrokeColor = SKColor(hue: CGFloat(23)/360.0, saturation: 0.8, brightness: 0.7, alpha: 1)
    let wheelColor = SKColor(hue: CGFloat(15)/360.0, saturation: 0, brightness: 1, alpha: 1)
    let wheelStrokeColor = SKColor(hue: CGFloat(15) / 360, saturation: 0.8, brightness: 0.7, alpha: 1)
    
    var boardCollideMask: UInt32!
    var speedX: CGFloat!
    
    override func newNode(_ boardTemplate: BoardTemplate, boardSize: CGSize) -> SKNode {
        
        boardCollideMask = boardTemplate.collideMaskFirst
        let clockWise = arc4random() % 2 == 0
        speedX = clockWise ? self.speed : -self.speed
        
        let boardWidth = boardSize.width
        let boardRadius = boardHeight / 2
        let boardAvaliableWidth = boardWidth - boardRadius * 2
        let boardPath = CGMutablePath()
        boardPath.addArc(center: CGPoint(x: -boardAvaliableWidth / 2, y: CGFloat(0)), radius: boardRadius, startAngle: CGFloat(-Double.pi / 2), endAngle: CGFloat(Double.pi / 2), clockwise: true)
        boardPath.addArc(center: CGPoint(x: boardAvaliableWidth / 2, y: 0), radius: boardRadius, startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(-Double.pi / 2), clockwise: true)
        boardPath.closeSubpath()
        
        let board = SKShapeNode(path: boardPath)
        board.name = "BoardSpring"
        board.physicsBody = SKPhysicsBody(polygonFrom: boardPath)
        board.physicsBody!.categoryBitMask = boardCollideMask
        board.physicsBody!.isDynamic = false
        board.fillColor = boardColor
        board.strokeColor = boardStrokeColor
        
        let leftWheel = newWheel(speedX: speedX)
        leftWheel.position.x = -boardAvaliableWidth / 2
        board.addChild(leftWheel)
        
        let rightWheel = newWheel(speedX: speedX)
        rightWheel.position.x = boardAvaliableWidth / 2
        board.addChild(rightWheel)
        
        return board
    }
    override func onBeginContact(board: SKNode, ball: Ball, contact: SKPhysicsContact, game: GameDelegate) {
        
        ball.speedXSecond = speedX
    }
    override func onEndContact(board: SKNode, ball: Ball, contact: SKPhysicsContact, game: GameDelegate) {
        ball.speedXSecond = 0
    }
    private func newWheel(speedX: CGFloat) -> SKNode {
        
        let wheelRadius = CGFloat(boardHeight / 2 * wheelRatio)
        let wheelPath = CGMutablePath()
        wheelPath.addArc(center: CGPoint.zero, radius: wheelRadius, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        wheelPath.addLine(to: CGPoint.zero)
        wheelPath.move(to: CGPoint.zero)

        let wheelLineX = wheelRadius / 2
        let wheelLineY = wheelRadius / 2 * 1.73
        wheelPath.addLine(to: CGPoint(x: -wheelLineX, y: wheelLineY))
        wheelPath.move(to: CGPoint.zero)
        wheelPath.addLine(to: CGPoint(x: -wheelLineX, y: -wheelLineY))

        let wheel = SKShapeNode(path: wheelPath, centered: true)
        wheel.lineWidth = 2.0
        wheel.fillColor = wheelColor
        wheel.strokeColor = wheelStrokeColor
        
        let radians = -speedX / (boardHeight / 2)
        wheel.run(SKAction.repeatForever(SKAction.rotate(byAngle: radians, duration: TimeInterval(1))))
        
        return wheel
    }
}
