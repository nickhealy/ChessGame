//
//  PieceMoveEndTests.swift
//  Chess Game REALTests
//
//  Created by Josh Davis on 2/15/21.
//

import XCTest
@testable import Chess_Game_REAL

class PieceMoveEndTests: XCTestCase {
    var vc = ViewController()
    let testArrangement: [[PieceKeys?]] = [
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
        let model = BoardModel(withArrangement: testArrangement)
        vc.positionInModelDelegate = model
    }

    override func tearDownWithError() throws {
        vc.boardModel = nil
    }

    func testGetSideOfSquareOccupant() throws {
        let actual = vc.getSideOfSquareOccupant(pieceCoords: PieceCoords(row: 1, col: 1))
        XCTAssertEqual(actual, Colors.white, "should identify color of piece on a square")
    }
    
    func testGetSideOfSquareOccupantNoOccupant() throws {
        let actual = vc.getSideOfSquareOccupant(pieceCoords: PieceCoords(row: 1, col: 2))
        XCTAssertNil(actual, "should return nil when no square occupies")
    }
    
    func testSelectPiece() throws {
        vc.selectPieceAt(pieceCoords: PieceCoords(row: 1, col: 1))
        let expected = SelectedPiece(key: .w_king, image: PieceImage(color: .white, name: .king), originalPosition: PieceCoords(row: 1, col: 1))
        let actual = vc.selectedPiece
        XCTAssertEqual(expected, actual, "selects piece and stores info in vc")
    }
    
    func testDoNormalPieceMoveInModel() throws {
        vc.selectPieceAt(pieceCoords: PieceCoords(row: 1, col: 1))
        vc.dropOnSquareAt(pieceCoords: PieceCoords(row: 0, col: 1))
        let expected: [[PieceKeys?]] = [
            [nil, .w_king, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, .w_rook_1],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, .b_pawn_1, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
        
        XCTAssertEqual(expected, vc.positionInModelDelegate?.getCurrentPieceArrangement(), "if selected piece dropped on empty square, should move piece to that square")
    }
    
    func testDoNormalPieceMoveInView() throws {
        
    }
    
    func testDropOnEnemySquare() throws {
        vc.selectPieceAt(pieceCoords: PieceCoords(row: 1, col: 1))
        vc.dropOnSquareAt(pieceCoords: PieceCoords(row: 5, col: 5))
        let expected: [[PieceKeys?]] = [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, .w_rook_1],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, .w_king, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
        XCTAssertEqual(expected, vc.positionInModelDelegate?.getCurrentPieceArrangement(), "if selected piece dropped on enemy square, should take piece at that square")
    }
}
