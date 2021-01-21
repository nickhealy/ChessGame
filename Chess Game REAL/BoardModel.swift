//
//  File.swift
//  Chess Game REAL
//
//  Created by Nick Healy on 1/20/21.
//

enum PlayPieces {
    case white_rook, white_knight, white_bishop, white_queen, white_king, white_pawn, black_rook, black_knight, black_bishop, black_queen, black_king, black_pawn
}

class BoardModel {
    var currentArrangement: [[PlayPieces?]]! = nil
    
    init(){
        currentArrangement = [
            [.white_rook, .white_knight, .white_bishop, .white_queen, .white_king, .white_bishop, .white_knight, .white_rook],
            [.white_pawn, .white_pawn, .white_pawn, .white_pawn, .white_pawn, .white_pawn, .white_pawn, .white_pawn,],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [.black_pawn, .black_pawn, .black_pawn, .black_pawn, .black_pawn, .black_pawn, .black_pawn, .black_pawn,],
            [.black_rook, .black_knight, .black_bishop, .black_queen, .black_king, .black_bishop, .black_knight, .black_rook],
        ]
    }
}
