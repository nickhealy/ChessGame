//
//  Piece.swift
//  Chess Game REAL
//
//  Created by Josh Davis on 1/18/21.
//

import UIKit

enum PieceNames {
    case rook, knight, bishop, queen, king, pawn
}

protocol PieceProtocol {
    var color: Colors { get }
    var name: PieceNames { get }
//    will also be image
    var image: PieceImage { get }
    var key: PieceKeys { get }
    var movePattern: [[Int]] { get }
    func findMoves(currentPosition: CGPoint) -> [CGPoint]
    func isOwnPiece(playerColor: Colors) -> Bool
}


struct Piece: PieceProtocol {
    var color: Colors
    
    var name: PieceNames
    
    var image: PieceImage
    
    var movePattern: [[Int]] = []
    var key: PieceKeys
    
    init(color: Colors, name: PieceNames, key: PieceKeys) {
        self.color = color
        self.name = name
        self.image = PieceImage(color: color, name: name)
        self.key = key
    }
    
    func findMoves(currentPosition: CGPoint) -> [CGPoint]{
        let moves: [CGPoint] = []
        return moves
    }
    func isOwnPiece(playerColor: Colors) -> Bool {
        return playerColor == color
    }
}


