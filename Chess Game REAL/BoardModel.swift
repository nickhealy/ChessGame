//
//  File.swift
//  Chess Game REAL
//
//  Created by Nick Healy on 1/20/21.
//

class BoardModel {
    var currentArrangement: [[PieceKeys?]]
    
    init(){
        currentArrangement = [
//            [.w_rook_1, .w_knight_1, .w_bishop_1, .w_queen, .w_king, .w_bishop_2, .w_knight_2, .w_rook_2],
//            [.w_pawn_1, .w_pawn_2, .w_pawn_3, .w_pawn_4, .w_pawn_5, .w_pawn_6, .w_pawn_7, .w_pawn_8,],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, .w_king, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, .b_king, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
//            [.b_pawn_1, .b_pawn_2, .b_pawn_3, .b_pawn_4, .b_pawn_5, .b_pawn_6, .b_pawn_7, .b_pawn_8,],
//            [.b_rook_1, .b_knight_1, .b_bishop_1, .b_queen, .b_king, .b_bishop_2, .b_knight_2, .b_rook_2],
        ]
    }
}
