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
        vc.positionInModelDelegate = nil
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
    
    func moveWKingTo(square: PieceCoords) {
        vc.selectPieceAt(pieceCoords: PieceCoords(row: 1, col: 1))
        vc.dropOnSquareAt(pieceCoords: square)
    }
    
    func moveWKingToAndGetFrame(square:PieceCoords) -> CGRect? {
        moveWKingTo(square: square)
        guard let movedPieceKey = vc.positionInModelDelegate?.getPieceAt(pieceCoords: square) else {
            return nil
        }
        return PieceData.getPieceImage(pieceKey: movedPieceKey).frame
    }
    
    func testDoNormalPieceMoveInModel() throws {
        moveWKingTo(square: PieceCoords(row: 0, col: 1))
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
        let to: PieceCoords = PieceCoords(row: 1, col: 2)
        let movedPieceFrame = moveWKingToAndGetFrame(square: to)
        
        XCTAssertEqual(movedPieceFrame, CGRect(x: 82.0, y: 41.0, width: 41.0, height: 41.0), "moves piece to new square for normal movement")
    }
    
    func testDropOnEnemySquareModel() throws {
        moveWKingTo(square: PieceCoords(row: 5, col: 5))
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
    
    func testDropOnEnemySquareView() throws {
        let movedPieceFrame = moveWKingToAndGetFrame(square: PieceCoords(row: 5, col: 5))
        XCTAssertEqual(movedPieceFrame, CGRect(x: 205.0, y: 205.0, width: 41.0, height: 41.0), "moves piece to new square when taking enemy piece")
    }
    
    func testDropOnSameSideSquareModel() throws {
        moveWKingTo(square: PieceCoords(row: 2, col: 7))
        XCTAssertEqual(vc.positionInModelDelegate?.getCurrentPieceArrangement(), self.testArrangement , "does not alter model if piece dropped on same side")
    }
    
//    func testNormalPieceMoveIntegration() throws {
//        simulateMoveWKingInsideBoard()
//        let expected: [[PieceKeys?]] = [
//            [nil, nil, nil, nil, nil, nil, nil, nil],
//            [nil, nil, nil, nil, nil, nil, nil, nil],
//            [nil, .w_king, nil, nil, nil, nil, nil, .w_rook_1],
//            [nil, nil, nil, nil, nil, nil, nil, nil],
//            [nil, nil, nil, nil, nil, nil, nil, nil],
//            [nil, nil, nil, nil, nil, .b_pawn_1, nil, nil],
//            [nil, nil, nil, nil, nil, nil, nil, nil],
//            [nil, nil, nil, nil, nil, nil, nil, nil],
//        ]
//        
//        XCTAssertEqual(expected, vc.positionInModelDelegate?.getCurrentPieceArrangement())
//    }
//    
//    func simulateMoveWKingInsideBoard() {
//        let app = XCUIApplication()
//        app.launch()
//        let fromCoordinate = app.coordinate(withNormalizedOffset: CGVector(dx: 91.0, dy: 242.5))
//        let toCoordinate = app.coordinate(withNormalizedOffset: CGVector(dx: 86.0, dy: 288.0))
//        fromCoordinate.press(forDuration: 0, thenDragTo: toCoordinate)
//    }
}
