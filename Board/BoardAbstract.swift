//
//  BoardAbstract.swift
//  BallDown
//
//  Copyright © 2015 ones. All rights reserved.
//

import Foundation
import SpriteKit

class BoardAbstract: BoardDelegate {
    
    let boardSize = CGSize(width: Boards.width, height: Boards.height)
    
    var floorNumber: Int!
    var node: SKNode!

    func onCreate(_ boardTemplate: BoardTemplate, floorNumber: Int) {
        self.floorNumber = floorNumber
        node = newNode(boardTemplate, boardSize: self.boardSize)
        node.bind = self
    }
    func onDestroy() {
        node.bind = nil
        node = nil
    }
    
    func newNode(_ boardTemplate: BoardTemplate, boardSize: CGSize) -> SKNode {
        fatalError("newNode() must override")
    }
    func didBeginContact(board: SKNode, ball: Ball, contact: SKPhysicsContact, game: GameDelegate) {
        onBeginContact(board: board, ball: ball, contact: contact, game: game)
        playCollideSound(fromFloor: ball.lastFloor, toFloor: self.floorNumber)
    }
    func didEndContact(board: SKNode, ball: Ball, contact: SKPhysicsContact, game: GameDelegate) {
        onEndContact(board: board, ball: ball, contact: contact, game: game)
        ball.lastFloor = floorNumber
    }

    func onBeginContact(board: SKNode, ball: Ball, contact: SKPhysicsContact, game: GameDelegate) {
        
    }
    func playCollideSound(fromFloor: Int, toFloor: Int) {
        
        if toFloor > fromFloor {
            Av.share.collide.play()
        }
    }
    func onEndContact(board: SKNode, ball: Ball, contact: SKPhysicsContact, game: GameDelegate) {
        
    }
}
