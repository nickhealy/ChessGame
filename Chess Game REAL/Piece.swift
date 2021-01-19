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
    var name: String { get }
//    will also be image 
    var movePattern: [[Int]] { get }
    var hasMoved: Bool { get }
    func findMoves(currentPosition: CGPoint) -> [CGPoint]
    func isOwnPiece(playerColor: Colors) -> Bool
}


class Piece: NSObject {

}
