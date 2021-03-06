//
//  MoveManager.swift
//  Chess Game REAL
//
//  Created by Nick Healy on 3/28/21.
//

import Foundation

struct Move {
    let piece: PieceKeys
    let from: PieceCoords
    let to: PieceCoords
    let isCastle: Bool
//    todo: add turn-based functionality
    let player: String = "self"
//    todo: add timestamp functionality
}

protocol BoardModelDelegate {
    func applyMoveToBoard(move: Move)
}

class MoveManager {
    var boardModelDelegate: BoardModelDelegate?
    func createMove(piece: SelectedPiece, to: PieceCoords, isCastle: Bool = false) {
        let newMove = Move(piece: piece.key, from: piece.originalPosition, to: to, isCastle: isCastle)
        makeMove(move: newMove)
    }
    
    init(board: BoardModelDelegate) {
        boardModelDelegate = board
    }
    
    private func makeMove(move: Move) {
//        todo, this will have to be some sort of ws thing, this would happen at end of process
        if true {
            boardModelDelegate?.applyMoveToBoard(move: move)
        }
    }
}
