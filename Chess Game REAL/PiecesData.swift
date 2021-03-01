//
//  File.swift
//  Chess Game REAL
//
//  Created by Josh Davis on 1/30/21.
//

import UIKit

struct PieceMoves {
    let moves: [MovePattern]
    let recursive: Bool
}

struct MovePattern {
    let rowChange: Int
    let colChange: Int
    init (_ rowChange: Int, _ colChange: Int) {
        self.rowChange = rowChange
        self.colChange = colChange
    }
}

class PieceData {
    private static var piecesByKey: [PieceKeys: Piece] = [
        .w_rook_1 : Piece(color: .white, name: .rook, key: .w_rook_1),
        .w_rook_2 : Piece(color: .white, name: .rook, key: .w_rook_2),
        .w_knight_1 : Piece(color: .white, name: .knight, key: .w_knight_1),
        .w_knight_2 : Piece(color: .white, name: .knight, key: .w_knight_2),
        .w_bishop_1 : Piece(color: .white, name: .bishop, key: .w_bishop_1),
        .w_bishop_2 : Piece(color: .white, name: .bishop, key: .w_bishop_2),
        .w_queen : Piece(color: .white, name: .queen, key: .w_queen),
        .w_king : Piece(color: .white, name: .king, key: .w_king),
        .w_pawn_1 : Piece(color: .white, name: .pawn, key: .w_pawn_1),
        .w_pawn_2 : Piece(color: .white, name: .pawn, key: .w_pawn_2),
        .w_pawn_3 : Piece(color: .white, name: .pawn, key: .w_pawn_3),
        .w_pawn_4 : Piece(color: .white, name: .pawn, key: .w_pawn_4),
        .w_pawn_5 : Piece(color: .white, name: .pawn, key: .w_pawn_5),
        .w_pawn_6 : Piece(color: .white, name: .pawn, key: .w_pawn_6),
        .w_pawn_7 : Piece(color: .white, name: .pawn, key: .w_pawn_7),
        .w_pawn_8 : Piece(color: .white, name: .pawn, key: .w_pawn_8),
        .b_rook_1 : Piece(color: .black, name: .rook, key: .b_rook_1),
        .b_rook_2 : Piece(color: .black, name: .rook, key: .b_rook_2),
        .b_knight_1 : Piece(color: .black, name: .knight, key: .b_knight_1),
        .b_knight_2 : Piece(color: .black, name: .knight, key: .b_knight_2),
        .b_bishop_1 : Piece(color: .black, name: .bishop, key: .b_bishop_1),
        .b_bishop_2 : Piece(color: .black, name: .bishop, key: .b_bishop_2),
        .b_queen : Piece(color: .black, name: .queen, key: .b_queen),
        .b_king : Piece(color: .black, name: .king, key: .b_king),
        .b_pawn_1 : Piece(color: .black, name: .pawn, key: .b_pawn_1),
        .b_pawn_2 : Piece(color: .black, name: .pawn, key: .b_pawn_2),
        .b_pawn_3 : Piece(color: .black, name: .pawn, key: .b_pawn_3),
        .b_pawn_4 : Piece(color: .black, name: .pawn, key: .b_pawn_4),
        .b_pawn_5 : Piece(color: .black, name: .pawn, key: .b_pawn_5),
        .b_pawn_6 : Piece(color: .black, name: .pawn, key: .b_pawn_6),
        .b_pawn_7 : Piece(color: .black, name: .pawn, key: .b_pawn_7),
        .b_pawn_8 : Piece(color: .black, name: .pawn, key: .b_pawn_8),
    ]
    
    static public func getPieceTypeFromKey(_ key: PieceKeys) -> PieceNames {
        return getPiece(piecekey: key).name
    }
    
    private static let movesByPieceName: [PieceNames: PieceMoves] = [
        .rook : PieceMoves(moves: [MovePattern(1, 0), MovePattern(0, 1), MovePattern(-1, 0), MovePattern(0, -1)], recursive: true),
        .bishop: PieceMoves(moves: [MovePattern(1, 1), MovePattern(-1, 1), MovePattern(-1, -1), MovePattern(1, -1)], recursive: true),
        .knight: PieceMoves(moves: [MovePattern(-2, 1), MovePattern(-2, -1), MovePattern(-1, 2), MovePattern(1, 2), MovePattern(2, 1), MovePattern(2, -1), MovePattern(1, -2), MovePattern(-1, -2)], recursive: false),
        .queen: PieceMoves(moves: [MovePattern(1, 0), MovePattern(0, 1), MovePattern(-1, 0), MovePattern(0, -1), MovePattern(1, 1), MovePattern(-1, 1), MovePattern(-1, -1), MovePattern(1, -1)], recursive: true),
        .pawn: PieceMoves(moves: [MovePattern(-1, 0)], recursive: false),
        .king: PieceMoves(moves: [MovePattern(1, 0), MovePattern(0, 1), MovePattern(-1, 0), MovePattern(0, -1)], recursive: false)
    ]
    
    static public func getMovesForPieceKey(key: PieceKeys) -> PieceMoves {
        let type = getPieceTypeFromKey(key)
        return self.movesByPieceName[type]!
    }
    
    static public func getPieceImage(pieceKey: PieceKeys) -> PieceImage {
        let piece = getPiece(piecekey: pieceKey)
        return piece.image
    }
    
    static public func getPiece(piecekey: PieceKeys) -> Piece {
        return piecesByKey[piecekey]!
    }
    
    static public func getPieceColorFromKey(piecekey: PieceKeys) -> Colors {
        let piece = getPiece(piecekey: piecekey)
        return piece.color
    }
    
    static public func getPieceKeyFromImage(image: PieceImage) -> PieceKeys! {
        for key in PieceKeys.allCases {
            let prospectiveImage = getPieceImage(pieceKey: key)
            if prospectiveImage == image {
                return key
            }
        }
        
        return nil
    }
}

enum PieceKeys: CaseIterable {
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

