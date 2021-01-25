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
    var image: String { get }
    var movePattern: [[Int]] { get }
    var hasMoved: Bool { get }
    func findMoves(currentPosition: CGPoint) -> [CGPoint]
    func isOwnPiece(playerColor: Colors) -> Bool
}


struct Piece: PieceProtocol {
    var color: Colors
    
    var name: PieceNames
    
    var image: String
    
    var movePattern: [[Int]] = []
    
    var hasMoved: Bool = false
    
    init(color: Colors, name: PieceNames) {
        self.color = color
        self.name = name
        self.image = "\(color)_\(name)"
    }
    
    func findMoves(currentPosition: CGPoint) -> [CGPoint]{
        let moves: [CGPoint] = []
        return moves
    }
    func isOwnPiece(playerColor: Colors) -> Bool {
        return playerColor == color
    }
}


