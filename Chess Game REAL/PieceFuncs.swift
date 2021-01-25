//
//  PieceFuncs.swift
//  Chess Game REAL
//
//  Created by Josh Davis on 1/24/21.
//

import Foundation

enum PieceKeys {
    case w_rook_1,
         w_rook_2,
         w_knight_1,
         w_knight_2,
         w_bishop_1,
         w_bishop_2,
         w_queen,
         w_king,
         w_pawn_1,
         w_pawn_2,
         w_pawn_3,
         w_pawn_4,
         w_pawn_5,
         w_pawn_6,
         w_pawn_7,
         w_pawn_8,
         b_rook_1,
         b_rook_2,
         b_knight_1,
         b_knight_2,
         b_bishop_1,
         b_bishop_2,
         b_queen,
         b_king,
         b_pawn_1,
         b_pawn_2,
         b_pawn_3,
         b_pawn_4,
         b_pawn_5,
         b_pawn_6,
         b_pawn_7,
         b_pawn_8
}

class PieceFuncs {
    static var w_rook_1 = Piece(color: .white, name: .rook)
    static var w_rook_2 = Piece(color: .white, name: .rook)
    static var w_knight_1 = Piece(color: .white, name: .knight)
    static var w_knight_2 = Piece(color: .white, name: .knight)
    static var w_bishop_1 = Piece(color: .white, name: .bishop)
    static var w_bishop_2 = Piece(color: .white, name: .bishop)
    static var w_queen = Piece(color: .white, name: .queen)
    static var w_king = Piece(color: .white, name: .king)
    static var w_pawn_1 = Piece(color: .white, name: .pawn)
    static var w_pawn_2 = Piece(color: .white, name: .pawn)
    static var w_pawn_3 = Piece(color: .white, name: .pawn)
    static var w_pawn_4 = Piece(color: .white, name: .pawn)
    static var w_pawn_5 = Piece(color: .white, name: .pawn)
    static var w_pawn_6 = Piece(color: .white, name: .pawn)
    static var w_pawn_7 = Piece(color: .white, name: .pawn)
    static var w_pawn_8 = Piece(color: .white, name: .pawn)
    
    static var b_rook_1 = Piece(color: .black, name: .rook)
    static var b_rook_2 = Piece(color: .black, name: .rook)
    static var b_knight_1 = Piece(color: .black, name: .knight)
    static var b_knight_2 = Piece(color: .black, name: .knight)
    static var b_bishop_1 = Piece(color: .black, name: .bishop)
    static var b_bishop_2 = Piece(color: .black, name: .bishop)
    static var b_queen = Piece(color: .black, name: .queen)
    static var b_king = Piece(color: .black, name: .king)
    static var b_pawn_1 = Piece(color: .black, name: .pawn)
    static var b_pawn_2 = Piece(color: .black, name: .pawn)
    static var b_pawn_3 = Piece(color: .black, name: .pawn)
    static var b_pawn_4 = Piece(color: .black, name: .pawn)
    static var b_pawn_5 = Piece(color: .black, name: .pawn)
    static var b_pawn_6 = Piece(color: .black, name: .pawn)
    static var b_pawn_7 = Piece(color: .black, name: .pawn)
    static var b_pawn_8 = Piece(color: .black, name: .pawn)
    
    static var pieceCollection: [Piece] = [
         w_rook_1,
         w_rook_2,
         w_knight_1,
         w_knight_2,
         w_bishop_1,
         w_bishop_2,
         w_queen,
         w_king,
         w_pawn_1,
         w_pawn_2,
         w_pawn_3,
         w_pawn_4,
         w_pawn_5,
         w_pawn_6,
         w_pawn_7,
         w_pawn_8,
         b_rook_1,
         b_rook_2,
         b_knight_1,
         b_knight_2,
         b_bishop_1,
         b_bishop_2,
         b_queen,
         b_king,
         b_pawn_1,
         b_pawn_2,
         b_pawn_3,
         b_pawn_4,
         b_pawn_5,
         b_pawn_6,
         b_pawn_7,
         b_pawn_8
    ]
    
    static public func getPiece(key: PieceKeys) -> Piece {
        switch key {
        case .w_rook_1:
            return w_rook_1
        case .w_rook_2:
            return w_rook_2
        case .w_knight_1:
            return w_knight_1
        case .w_knight_2:
            return w_knight_2
        case .w_bishop_1:
            return w_bishop_1
        case .w_bishop_2:
            return w_bishop_2
        case .w_queen:
            return w_queen
        case .w_king:
            return w_king
        case .w_pawn_1:
            return w_pawn_1
        case .w_pawn_2:
            return w_pawn_2
        case .w_pawn_3:
            return w_pawn_3
        case .w_pawn_4:
            return w_pawn_4
        case .w_pawn_5:
            return w_pawn_5
        case .w_pawn_6:
            return w_pawn_6
        case .w_pawn_7:
            return w_pawn_7
        case .w_pawn_8:
            return w_pawn_8
        case .b_rook_1:
            return b_rook_1
        case .b_rook_2:
            return b_rook_2
        case .b_knight_1:
            return b_knight_1
        case .b_knight_2:
            return b_knight_2
        case .b_bishop_1:
            return b_bishop_1
        case .b_bishop_2:
            return b_bishop_2
        case .b_queen:
            return b_queen
        case .b_king:
            return b_king
        case .b_pawn_1:
            return b_pawn_1
        case .b_pawn_2:
            return b_pawn_2
        case .b_pawn_3:
            return b_pawn_3
        case .b_pawn_4:
            return b_pawn_4
        case .b_pawn_5:
            return b_pawn_5
        case .b_pawn_6:
            return b_pawn_6
        case .b_pawn_7:
            return b_pawn_7
        case .b_pawn_8:
            return b_pawn_8
        }
        
    }
}
