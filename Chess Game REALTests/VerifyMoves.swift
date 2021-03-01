//
//  VerifyMoves.swift
//  Chess Game REALTests
//
//  Created by Josh Davis on 2/27/21.
//

import XCTest
@testable import Chess_Game_REAL

class VerifyMoves: XCTestCase {
    var model: BoardModel! = nil
    let rookMovesFromRow3Col3: PossibleMoves = [PieceCoords(row: 2, col: 3), PieceCoords(row: 1, col: 3), PieceCoords(row: 0, col: 3), PieceCoords(row: 4, col: 3), PieceCoords(row: 5, col: 3), PieceCoords(row: 6, col: 3), PieceCoords(row: 7, col: 3), PieceCoords(row: 3, col: 2), PieceCoords(row: 3, col: 1), PieceCoords(row: 3, col: 0), PieceCoords(row: 3, col: 4), PieceCoords(row: 3, col: 5), PieceCoords(row: 3, col: 6), PieceCoords(row: 3, col: 7)]
    let bishopMovesFromRow3Col3: PossibleMoves = [PieceCoords(row: 2, col: 2), PieceCoords(row: 1, col: 1), PieceCoords(row: 0, col: 0), PieceCoords(row: 4, col: 4), PieceCoords(row: 5, col: 5), PieceCoords(row: 6, col: 6), PieceCoords(row: 7, col: 7), PieceCoords(row: 4, col: 2), PieceCoords(row: 5, col: 1), PieceCoords(row: 6, col: 0), PieceCoords(row: 2, col: 4), PieceCoords(row: 1, col: 5), PieceCoords(row: 0, col: 6)]
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        model = nil
    }
    
    func addNewArrangement(arrangement: [[PieceKeys?]]) {
        model = BoardModel(withArrangement: arrangement)
    }
    

    func getMovesFor(piece: PieceKeys) -> PossibleMoves {
        return model.getMovesFor(pieceKey: piece)
    }
    
    func rows(_ lhcoords: PieceCoords?, _ rhcoords: PieceCoords?) -> Bool {
        guard let lh = lhcoords, let rh = rhcoords else { return false }
        return lh.row < rh.row
    }
    
    func cols(_ lhcoords: PieceCoords?, _ rhcoords: PieceCoords?) -> Bool {
        guard let lh = lhcoords, let rh = rhcoords else { return false }
        return lh.col < rh.col
    }
    
    func areMovesEqual(moves1: PossibleMoves, moves2: PossibleMoves) -> Bool {
        if moves1.count != moves2.count {
            return false
        }
        
        if moves1.count == 0 && moves2.count == 0 {
            return true
        }
        
        let lmoves = moves1.sorted(by: rows).sorted(by: cols)
        let rmoves = moves2.sorted(by: rows).sorted(by: cols)
        
        for index in 0..<lmoves.count {
            let lmove = lmoves[index]
            let rmove = rmoves[index]
            if lmove!.row != rmove!.row || lmove!.col != rmove!.col {
                return false
            }
        }
        return true
    }
    
    func testAreMovesEqualTrue() throws {
        let moves1: PossibleMoves = [PieceCoords(row: 1, col: 2), PieceCoords(row: 1, col: 3), PieceCoords(row: 2, col: 2), PieceCoords(row: 2, col: 3)]
        let moves2: PossibleMoves = [PieceCoords(row: 2, col: 3), PieceCoords(row: 2, col: 2), PieceCoords(row: 1, col: 3), PieceCoords(row: 1, col: 2)]
        XCTAssertTrue(areMovesEqual(moves1: moves1, moves2: moves2), "returns true for two sets of equal moves")
    }
    
    func testAreMovesEqualFalse() throws {
        let moves1: PossibleMoves = [PieceCoords(row: 1, col: 2), PieceCoords(row: 1, col: 3), PieceCoords(row: 2, col: 2), PieceCoords(row: 2, col: 3)]
        let moves2: PossibleMoves = [PieceCoords(row: 1, col: 4), PieceCoords(row: 1, col: 3), PieceCoords(row: 2, col: 2), PieceCoords(row: 2, col: 3)]
        XCTAssertFalse(areMovesEqual(moves1: moves1, moves2: moves2), "returns false for two sets of unequal moves")
    }
    
    func testDifferentLengthMovesEqual() throws {
        let moves1: PossibleMoves = [PieceCoords(row: 1, col: 2), PieceCoords(row: 1, col: 3), PieceCoords(row: 2, col: 2), PieceCoords(row: 2, col: 3)]
        let moves2: PossibleMoves = []
        XCTAssertFalse(areMovesEqual(moves1: moves1, moves2: moves2), "returns false for two sets of moves of unequal lengths")
    }
    
    func testEmptyMovesEqual() throws {
        let moves1: PossibleMoves = []
        let moves2: PossibleMoves = []
        XCTAssertTrue(areMovesEqual(moves1: moves1, moves2: moves2), "returns true for two sets of equal moves")
    }
    
//    MARK: Piece Specific Moves
    
    func testGetMovesForRook() {
        let arrangement: [[PieceKeys?]] = [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, .w_rook_1, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
        addNewArrangement(arrangement: arrangement)
        let actual = getMovesFor(piece: .w_rook_1)
        let expected: PossibleMoves = rookMovesFromRow3Col3
        XCTAssertTrue(areMovesEqual(moves1: actual, moves2: expected), "gives moves for rook with no obstacles")
    }
    
    func testGetMovesForQueen() {
        let arrangement: [[PieceKeys?]] = [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, .w_queen, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
        addNewArrangement(arrangement: arrangement)
        let actual = getMovesFor(piece: .w_queen)
        let expected: PossibleMoves = rookMovesFromRow3Col3 + bishopMovesFromRow3Col3
        XCTAssertTrue(areMovesEqual(moves1: actual, moves2: expected), "gives moves for queen with no obstacles")
    }
    
    func testGetMovesForBishop() {
        let arrangement: [[PieceKeys?]] = [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, .w_bishop_1, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
        addNewArrangement(arrangement: arrangement)
        let actual = getMovesFor(piece: .w_bishop_1)
        let expected: PossibleMoves = bishopMovesFromRow3Col3
        XCTAssertTrue(areMovesEqual(moves1: actual, moves2: expected), "gives more for bishop with no obstacles")
    }
    
    func testGetMovesForKnight() {
        let arrangement: [[PieceKeys?]] = [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, .w_knight_1, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
        addNewArrangement(arrangement: arrangement)
        let actual = getMovesFor(piece: .w_knight_1)
        let expected: PossibleMoves = [PieceCoords(row: 1, col: 2), PieceCoords(row: 1, col: 4), PieceCoords(row: 2, col: 5), PieceCoords(row: 4, col: 5), PieceCoords(row: 5, col: 4), PieceCoords(row: 5, col: 2), PieceCoords(row: 4, col: 1), PieceCoords(row: 2, col: 1)]
        XCTAssertTrue(areMovesEqual(moves1: actual, moves2: expected), "gives moves for knight with no obstacles")
    }
    
    func testGetMovesForPawnAlreadyMoved() {
        let arrangement: [[PieceKeys?]] = [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, .w_pawn_1, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
        addNewArrangement(arrangement: arrangement)
        let actual = getMovesFor(piece: .w_pawn_1)
        let expected: PossibleMoves = [PieceCoords(row: 2, col: 3)]
        XCTAssertTrue(areMovesEqual(moves1: actual, moves2: expected), "gives moves for a pawn that has already been moved, and is not threatening any squares")
    }
    
    func testIncludeAttackingSquaresForPawnMoves() {
        let arrangement: [[PieceKeys?]] = [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, .b_queen, nil, nil, nil, nil, nil],
            [nil, nil, nil, .w_pawn_1, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
        addNewArrangement(arrangement: arrangement)
        let actual = getMovesFor(piece: .w_pawn_1)
        let expected: PossibleMoves = [PieceCoords(row: 2, col: 3), PieceCoords(row: 2, col: 2)]
        XCTAssertTrue(areMovesEqual(moves1: actual, moves2: expected), "also shows when pawn is able to take a piece diagonally")
    }
    
    func testPawnDoesNotSameSide() {
        let arrangement: [[PieceKeys?]] = [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, .b_queen, nil, .w_queen, nil, nil, nil],
            [nil, nil, nil, .w_pawn_1, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
        addNewArrangement(arrangement: arrangement)
        let actual = getMovesFor(piece: .w_pawn_1)
        let expected: PossibleMoves = [PieceCoords(row: 2, col: 3), PieceCoords(row: 2, col: 2)]
        XCTAssertTrue(areMovesEqual(moves1: actual, moves2: expected), "and does not try to threaten same side squares")
    }
    
    func testPawnDoesNotThreatenedInvalidSquare() {
        let arrangement: [[PieceKeys?]] = [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, .b_bishop_1, nil, nil, nil, nil, nil, nil],
            [.w_pawn_1, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
        addNewArrangement(arrangement: arrangement)
        let actual = getMovesFor(piece: .w_pawn_1)
        let expected: PossibleMoves = [PieceCoords(row: 1, col: 0),PieceCoords(row: 1, col: 1)]
        XCTAssertTrue(areMovesEqual(moves1: actual, moves2: expected), "and does not try to threaten squares off the board")
    }
    
    func testGetMovesForPawnNeverMoved() {
        let arrangement: [[PieceKeys?]] = [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, .w_pawn_1, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
        addNewArrangement(arrangement: arrangement)
        let actual = getMovesFor(piece: .w_pawn_1)
        let expected: PossibleMoves = [PieceCoords(row: 5, col: 3), PieceCoords(row: 4, col: 3)]
        XCTAssertTrue(areMovesEqual(moves1: actual, moves2: expected), "shows when pawn is able to move two spaces, if it hasn't been moved yet")
    }
    
    func testGetMovesForKingAlreadyMoved() {
        let arrangement: [[PieceKeys?]] = [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, .w_king, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
        addNewArrangement(arrangement: arrangement)
        let actual = getMovesFor(piece: .w_king)
        let expected: PossibleMoves = [PieceCoords(row: 2, col: 3), PieceCoords(row: 3, col: 2), PieceCoords(row: 4, col: 3), PieceCoords(row: 3, col: 4)]
        XCTAssertTrue(areMovesEqual(moves1: actual, moves2: expected), "gives moves for king")
    }
    
//    MARK: General Movement Rules
    
    func testGetMovesWithObstaclesSameSide() {
        let arrangement: [[PieceKeys?]] = [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, .w_pawn_1, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, .w_rook_1, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
        addNewArrangement(arrangement: arrangement)
        let actual = getMovesFor(piece: .w_rook_1)
        let expected: PossibleMoves = [PieceCoords(row: 2, col: 3), PieceCoords(row: 4, col: 3), PieceCoords(row: 5, col: 3), PieceCoords(row: 6, col: 3), PieceCoords(row: 7, col: 3), PieceCoords(row: 3, col: 2), PieceCoords(row: 3, col: 1), PieceCoords(row: 3, col: 0), PieceCoords(row: 3, col: 4), PieceCoords(row: 3, col: 5), PieceCoords(row: 3, col: 6), PieceCoords(row: 3, col: 7)]
        XCTAssertTrue(areMovesEqual(moves1: actual, moves2: expected), "line of movement stops at squares with pieces of same side")
    }
    
    func testGetMovesWithObstaclesEnemySide() {
        let arrangement: [[PieceKeys?]] = [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, .b_pawn_1, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, .w_rook_1, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
        addNewArrangement(arrangement: arrangement)
        let actual = getMovesFor(piece: .w_rook_1)
        let expected: PossibleMoves = [PieceCoords(row: 2, col: 3), PieceCoords(row: 1, col: 3), PieceCoords(row: 4, col: 3), PieceCoords(row: 5, col: 3), PieceCoords(row: 6, col: 3), PieceCoords(row: 7, col: 3), PieceCoords(row: 3, col: 2), PieceCoords(row: 3, col: 1), PieceCoords(row: 3, col: 0), PieceCoords(row: 3, col: 4), PieceCoords(row: 3, col: 5), PieceCoords(row: 3, col: 6), PieceCoords(row: 3, col: 7)]
        XCTAssertTrue(areMovesEqual(moves1: actual, moves2: expected), "line of movement includes square with enemy, but stops after that")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
