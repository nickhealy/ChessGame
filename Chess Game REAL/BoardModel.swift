//
//  File.swift
//  Chess Game REAL
//
//  Created by Nick Healy on 1/20/21.
//

typealias PossibleMoves = [PieceCoords?]

protocol EngineProtocol {
    showMoveOnBoard(
}

class BoardModel: PiecePositionDelegate {
    private var engine: ViewController
    
    static private var startingArrangement: [[PieceKeys?]] = [
        [.w_rook_1, .w_knight_1, .w_bishop_1, .w_king, .w_queen, .w_bishop_2, .w_knight_2, .w_rook_2],
        [.w_pawn_1, .w_pawn_2, .w_pawn_3, .w_pawn_4, .w_pawn_5, .w_pawn_6, .w_pawn_7, .w_pawn_8],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [.b_pawn_1, .b_pawn_2, .b_pawn_3, .b_pawn_4, .b_pawn_5, .b_pawn_6, .b_pawn_7, .b_pawn_8],
        [.b_rook_1, .b_knight_1, .b_bishop_1, .b_king, .b_queen, .b_bishop_2, .b_knight_2, .b_rook_2],
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
    
    init(engine: ViewController, withArrangement: [[PieceKeys?]] = startingArrangement) {
        self.currentArrangement = withArrangement
        self.engine = engine
    }
    
    internal func getCurrentPieceArrangement() -> [[PieceKeys?]] {
        return currentArrangement
    }
    
    internal func removePieceAt(pieceCoords: PieceCoords) {
        currentArrangement[pieceCoords.row][pieceCoords.col] = nil
    }
    
    internal func getMovesFor(pieceKey: PieceKeys) -> PossibleMoves {
        var possibleMoves: PossibleMoves = []
        guard let currentCoords = getCoordsFromKey(key: pieceKey) else { return [] }
        
        let pieceMoveInfo = PieceData.getMovesForPieceKey(key: pieceKey)
        
        for movePattern in pieceMoveInfo.moves {
            var hasNotOvertakenEnemy: Bool = true
            var visitingCoords = getNextCoordsToVisit(from: currentCoords, withPattern: movePattern)
            while isValidMove(visitingCoords, ownPiece: pieceKey) && hasNotOvertakenEnemy {
                possibleMoves.append(visitingCoords)
                hasNotOvertakenEnemy = hasPieceNotReachedEnemy(coords: visitingCoords, ownPiece: pieceKey)
                if (pieceMoveInfo.recursive || (PieceData.getPieceTypeFromKey(pieceKey) == PieceNames.pawn && visitingCoords.row == 5)) {
                    visitingCoords = getNextCoordsToVisit(from: visitingCoords, withPattern: movePattern)
                } else {
                    break
                }
            }
        }
        
        if (PieceData.getPieceTypeFromKey(pieceKey) == PieceNames.pawn) {
            possibleMoves.append(contentsOf: getCoordsThreatenedByPawn(from: currentCoords, pawn: pieceKey))
        }
        return possibleMoves
    }
    
    private func getNextCoordsToVisit(from: PieceCoords, withPattern: MovePattern) -> PieceCoords {
        let newRow = from.row + withPattern.rowChange
        let newCol = from.col + withPattern.colChange
        return PieceCoords(row: newRow, col: newCol)
    }
    
    private func hasPieceNotReachedEnemy(coords: PieceCoords, ownPiece: PieceKeys) -> Bool {
        if squareIsOccupied(at: coords) {
           return occupiedByFriend(coords: coords, ownPiece: ownPiece)
        } else {
            return true
        }
    }
    
    private func isNotEnemy(occupyingPiece: PieceKeys, ownPiece: PieceKeys) -> Bool {
        let occupyingPieceColor = PieceData.getPieceColorFromKey(piecekey: occupyingPiece)
        let ownPieceColor = PieceData.getPieceColorFromKey(piecekey: ownPiece)
        return occupyingPieceColor != ownPieceColor
    }
    
    private func isValidMove(_ coordsToVerify: PieceCoords, ownPiece: PieceKeys) -> Bool {
        if coordsToVerify.row < 0 || coordsToVerify.row > 7 || coordsToVerify.col < 0 || coordsToVerify.col > 7 {
            return false
        } else if squareIsOccupied(at: coordsToVerify) && occupiedByFriend(coords: coordsToVerify, ownPiece: ownPiece) {
            return false
        } else {
            return true
        }
    }
    
    private func squareIsOccupied(at: PieceCoords) -> Bool {
        if getPieceAt(pieceCoords: at) != nil {
            return true
        } else {
            return false
        }
    }
    
    private func occupiedByFriend(coords: PieceCoords, ownPiece: PieceKeys) -> Bool {
        if let currentOccupant = getPieceAt(pieceCoords: coords) {
            return isFriend(occupant: currentOccupant, ownPiece: ownPiece)
        } else {
            return false
        }
    }
    
    private func occupiedByEnemy(coords: PieceCoords, ownPiece: PieceKeys) -> Bool {
        if let currentOccupant = getPieceAt(pieceCoords: coords) {
            return isEnemy(occupant: currentOccupant, ownPiece: ownPiece)
        } else {
            return false
        }
    }
    
    private func isEnemy(occupant: PieceKeys, ownPiece: PieceKeys) -> Bool {
        let occupyingPieceColor = PieceData.getPieceColorFromKey(piecekey: occupant)
        let ownPieceColor = PieceData.getPieceColorFromKey(piecekey: ownPiece)
        return occupyingPieceColor != ownPieceColor
    }
    
    private func isFriend(occupant: PieceKeys, ownPiece: PieceKeys) -> Bool {
        let occupyingPieceColor = PieceData.getPieceColorFromKey(piecekey: occupant)
        let ownPieceColor = PieceData.getPieceColorFromKey(piecekey: ownPiece)
        return occupyingPieceColor == ownPieceColor
    }
    
    private func getCoordsThreatenedByPawn(from: PieceCoords, pawn: PieceKeys) -> [PieceCoords] {
        var threatenedCoords: [PieceCoords] = []
        let possibleCoords = getDiagonallyAdjacentCoordsFrom(from)
        for coord in possibleCoords {
            if occupiedByEnemy(coords: coord, ownPiece: pawn) && isValidMove(coord, ownPiece: pawn){
                threatenedCoords.append(coord)
            }
        }
        return threatenedCoords
    }
    
    private func getDiagonallyAdjacentCoordsFrom(_ from: PieceCoords) -> [PieceCoords] {
        let patterns = [MovePattern(-1, -1), MovePattern(-1, 1)]
        var coords: [PieceCoords] = []
        for pattern in patterns {
            let newRow = from.row + pattern.rowChange
            let newCol = from.row + pattern.colChange
            coords.append(PieceCoords(row: newRow, col: newCol))
        }
        return coords
    }
    
    public func isEnemyInCheck() -> Bool {
        return true
    }
    
    public func areWeInCheck() -> Bool {
        return true
    }
    
    private func getCoordsFromKey(key: PieceKeys) -> PieceCoords? {
        for row in 0..<8 {
            for col in 0..<8 {
                if getPieceAt(pieceCoords: PieceCoords(row: row, col: col)) == key {
                    return PieceCoords(row: row, col: col)
                }
            }
        }
        print("ERROR: no coords found for \(key)")
        return nil
    }
}

extension BoardModel: BoardModelDelegate {
    internal func getPieceAt(pieceCoords: PieceCoords) -> PieceKeys? {
        return currentArrangement[pieceCoords.row][pieceCoords.col]
    }
    
    func applyMove(move: Move) {
        let from = move.from
        let to = move.to
        guard let moved = getPieceAt(pieceCoords: from) else { return }
        if (isCollision()) {
            return
        } else {
            removePieceAt(pieceCoords: from)
            placeSelectedPieceAt(piece: moved, at: to)
            engine.addMoveToBoard(from: from, to: to)
        }
    }
    
    internal func placeSelectedPieceAt(piece: PieceKeys, at: PieceCoords) {
        currentArrangement[at.row][at.col] = piece
    }
    
    internal func isCollision() -> Bool {
        return false
    }
}
