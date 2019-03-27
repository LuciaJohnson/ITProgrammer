//
//  BoardBroken.swift
//  BallDown
//
//  Copyright © 2015 ones. All rights reserved.
//

import Foundation
import SpriteKit

class BoardBroken: BoardAbstract {
    
    static let BOARD_LEFT_NAME = "BrokenBoard.leftBoard"
    static let BOARD_RIGHT_NAME = "BrokenBoard.rightBoard"
    
    let gapWidth = CGFloat(10)
    let leftBoardWidth = Boards.width * 0.6
    let actionDuration = TimeInterval(1)
    let fillColor = SKColor(hue: CGFloat(30) / 360.0, saturation: 0.2, brightness: 0.9, alpha: 1)
    let strokeColor = SKColor(hue: CGFloat(30) / 360.0, saturation: 0.2, brightness: 0.7, alpha: 1)
    
    var leftBoardCollideMask: UInt32!
    var rightBoardCollideMask: UInt32!
    
    weak var leftBoard: SKShapeNode!
    weak var rightBoard: SKShapeNode!
   
    override func newNode(_ boardTemplate: BoardTemplate, boardSize: CGSize) -> SKNode {
        
        leftBoardCollideMask = boardTemplate.collideMaskFirst
        rightBoardCollideMask = boardTemplate.collideMaskSecond
        
        let boardWidth = boardSize.width
        let boardHeigh = boardSize.height / 2
        let radius = boardHeigh / 2
        let board = SKNode()
        
        let leftPath = CGMutablePath()
        leftPath.addArc(center: CGPoint.zero, radius: radius, startAngle: CGFloat(-Double.pi / 2), endAngle: CGFloat(Double.pi / 2), clockwise: true)
        leftPath.addLine(to: CGPoint(x: leftBoardWidth - radius - gapWidth, y: radius))
        leftPath.addLine(to: CGPoint(x: leftBoardWidth - radius, y: -radius))
        leftPath.closeSubpath()
        
        let leftBoard = SKShapeNode(path: leftPath, centered: false)
        leftBoard.name = BoardBroken.BOARD_LEFT_NAME
        leftBoard.physicsBody = SKPhysicsBody(rectangleOf: leftBoard.frame.size, center: CGPoint(x: (leftBoardWidth / 2 - radius), y: CGFloat(0)))
        leftBoard.physicsBody!.categoryBitMask = leftBoardCollideMask
        leftBoard.physicsBody!.isDynamic = false
        leftBoard.position.x = -(boardWidth / 2 - radius)
        leftBoard.userData = NSMutableDictionary()
        leftBoard.userData!.setValue(self, forKey: Boards.DATA_BOARD_NAME)
        leftBoard.fillColor = fillColor
        leftBoard.strokeColor = strokeColor
        board.addChild(leftBoard)
        self.leftBoard = leftBoard
        self.leftBoard.bind = self
        
        let rightBoardWidth = boardWidth - leftBoardWidth
        let rightPath = CGMutablePath()
        rightPath.addArc(center: CGPoint.zero, radius: radius, startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(-Double.pi / 2), clockwise: true)
        rightPath.addLine(to: CGPoint(x: -(rightBoardWidth - radius - gapWidth), y: -radius))
        rightPath.addLine(to: CGPoint(x: -(rightBoardWidth - radius), y: radius))
        rightPath.closeSubpath()
        
        let rightBoard = SKShapeNode(path: rightPath, centered: false)
        rightBoard.name = BoardBroken.BOARD_RIGHT_NAME
        rightBoard.physicsBody = SKPhysicsBody(rectangleOf: rightBoard.frame.size, center: CGPoint(x: -(rightBoardWidth / 2 - radius), y: CGFloat(0)))
        rightBoard.physicsBody!.categoryBitMask = rightBoardCollideMask
        rightBoard.physicsBody!.isDynamic = false
        rightBoard.position.x = boardWidth / 2 - radius
        rightBoard.userData = NSMutableDictionary()
        rightBoard.userData!.setValue(self, forKey: Boards.DATA_BOARD_NAME)
        rightBoard.fillColor = fillColor
        rightBoard.strokeColor = strokeColor
        board.addChild(rightBoard)
        self.rightBoard = rightBoard
        self.rightBoard.bind = self
        
        return board
    }
    
    override func onBeginContact(board: SKNode, ball: Ball, contact: SKPhysicsContact, game: GameDelegate) {
        
        if leftBoard.action(forKey: "rotate") == nil && rightBoard.action(forKey: "rotate") == nil {
            makeActions(board: leftBoard, isLeft: true)
            makeActions(board: rightBoard, isLeft: false)
        }
    }
    
    private func makeActions(board: SKNode, isLeft: Bool) {
        board.run(SKAction.rotate(byAngle: CGFloat(isLeft ? -Double.pi / 2: Double.pi / 2), duration: actionDuration), withKey: "rotate")
        board.run(SKAction.sequence([
            SKAction.fadeOut(withDuration: actionDuration),
            SKAction.removeFromParent()
        ]))
    }

}
