//
//  File.swift
//  Chess Game REAL
//
//  Created by Nick Healy on 1/20/21.
//

typealias PossibleMoves = [PieceCoords?]

class BoardModel: PiecePositionDelegate {
    static private var startingArrangement: [[PieceKeys?]] = [
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, .w_king, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, .w_rook_1],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, .b_pawn_1, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
    ]
    
    private var currentArrangement: [[PieceKeys?]] = [
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, .w_king, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, .w_rook_1],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, .b_pawn_1, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
    ]
    
    init(withArrangement: [[PieceKeys?]] = startingArrangement) {
        self.currentArrangement = withArrangement
    }
               
    internal func getPieceAt(pieceCoords: PieceCoords) -> PieceKeys? {
        return currentArrangement[pieceCoords.row][pieceCoords.col]
    }
    
    internal func movePieceTo(piece: PieceKeys, newCoords: PieceCoords) {
        if let currentCoords = getCoordsFromKey(key: piece) {
            removePieceAt(pieceCoords: currentCoords)
            currentArrangement[newCoords.row][newCoords.col] = piece
        }
        
    }
    
    private func getCoordsFromKey(key: PieceKeys) -> PieceCoords? {
        for row in 0..<8 {
            for col in 0..<8 {
                if currentArrangement[row][col] == key {
                    return PieceCoords(row: row, col: col)
                }
            }
        }
        print("ERROR: no coords found for \(key)")
        return nil
    }
    
    internal func getCurrentPieceArrangement() -> [[PieceKeys?]] {
        return currentArrangement
    }
    
    internal func removePieceAt(pieceCoords: PieceCoords) {
        currentArrangement[pieceCoords.row][pieceCoords.col] = nil
    }
    
    internal func getMovesFor(pieceKey: PieceKeys) -> PossibleMoves {
        return []
    }
}
