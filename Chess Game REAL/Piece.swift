//
//  Piece.swift
//  Chess Game REAL
//
//  Created by Josh Davis on 1/18/21.
//

import UIKit

//enum PieceNames {
//    case rook, knight, bishop, queen, king, pawn
//}

protocol PieceProtocol {
    var color: Colors? { get }
    var name: PlayPieces { get }
//    will also be image 
    var movePattern: [[Int]] { get }
    var hasMoved: Bool { get }
    func findMoves(currentPosition: CGPoint) -> [CGPoint]
    func isOwnPiece(playerColor: Colors) -> Bool
}


struct Piece: PieceProtocol {
    var color: Colors?
    
    var name: PlayPieces
    
    var movePattern: [[Int]] = []
    
    var hasMoved: Bool = false
    
    func findMoves(currentPosition: CGPoint) -> [CGPoint]{
        let moves: [CGPoint] = []
        return moves
    }
    func isOwnPiece(playerColor: Colors) -> Bool {
        return playerColor == color
    }
}
