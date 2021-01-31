//
//  File.swift
//  Chess Game REAL
//
//  Created by Josh Davis on 1/30/21.
//

import UIKit

class PieceData {
    private static var piecesByKey: [PieceKeys: Piece] = [
        .w_rook_1 : Piece(color: .white, name: .rook),
        .w_rook_2 : Piece(color: .white, name: .rook),
        .w_knight_1 : Piece(color: .white, name: .knight),
        .w_knight_2 : Piece(color: .white, name: .knight),
        .w_bishop_1 : Piece(color: .white, name: .bishop),
        .w_bishop_2 : Piece(color: .white, name: .bishop),
        .w_queen : Piece(color: .white, name: .queen),
        .w_king : Piece(color: .white, name: .king),
        .w_pawn_1 : Piece(color: .white, name: .pawn),
        .w_pawn_2 : Piece(color: .white, name: .pawn),
        .w_pawn_3 : Piece(color: .white, name: .pawn),
        .w_pawn_4 : Piece(color: .white, name: .pawn),
        .w_pawn_5 : Piece(color: .white, name: .pawn),
        .w_pawn_6 : Piece(color: .white, name: .pawn),
        .w_pawn_7 : Piece(color: .white, name: .pawn),
        .w_pawn_8 : Piece(color: .white, name: .pawn),
        .b_rook_1 : Piece(color: .black, name: .rook),
        .b_rook_2 : Piece(color: .black, name: .rook),
        .b_knight_1 : Piece(color: .black, name: .knight),
        .b_knight_2 : Piece(color: .black, name: .knight),
        .b_bishop_1 : Piece(color: .black, name: .bishop),
        .b_bishop_2 : Piece(color: .black, name: .bishop),
        .b_queen : Piece(color: .black, name: .queen),
        .b_king : Piece(color: .black, name: .king),
        .b_pawn_1 : Piece(color: .black, name: .pawn),
        .b_pawn_2 : Piece(color: .black, name: .pawn),
        .b_pawn_3 : Piece(color: .black, name: .pawn),
        .b_pawn_4 : Piece(color: .black, name: .pawn),
        .b_pawn_5 : Piece(color: .black, name: .pawn),
        .b_pawn_6 : Piece(color: .black, name: .pawn),
        .b_pawn_7 : Piece(color: .black, name: .pawn),
        .b_pawn_8 : Piece(color: .black, name: .pawn),
    ]
    
    static public func getPieceImage(pieceKey: PieceKeys) -> PieceImage {
        let piece = getPiece(piecekey: pieceKey)
        return piece.image
    }
    
    static public func getPiece(piecekey: PieceKeys) -> Piece {
        return piecesByKey[piecekey]!
    }
}

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

