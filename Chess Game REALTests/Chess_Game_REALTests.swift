//
//  Chess_Game_REALTests.swift
//  Chess Game REALTests
//
//  Created by Nick Healy on 2/15/21.
//

import XCTest
@testable import Chess_Game_REAL

class BoardModelTests: XCTestCase {
    var model: BoardModel?
    var testArrangement: [[PieceKeys?]] = [
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, .w_king, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, .w_rook_1],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, .b_pawn_1, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
    ]
    
    override func setUpWithError() throws {
        model = BoardModel(withArrangement: testArrangement)
    }

    override func tearDownWithError() throws {
        model = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRemovePiece() throws {
        let expected: [[PieceKeys?]] = [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, .w_rook_1],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, .b_pawn_1, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
        model?.removePieceAt(pieceCoords: PieceCoords(row: 1, col: 1))
        XCTAssertEqual(expected, model?.getCurrentPieceArrangement(), "removes a piece at selected piece coords")
    }
    
    func testMovePiece() throws {
        let expected: [[PieceKeys?]] = [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, .w_king, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, .w_rook_1],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, .b_pawn_1, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
        
        model?.movePieceTo(piece: .w_king, newCoords: PieceCoords(row: 1, col: 2))
        XCTAssertEqual(expected, model?.getCurrentPieceArrangement(), "moves passed in piece key to desired coords")
    }
    
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
