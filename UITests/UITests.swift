//
//  UITests.swift
//  UITests
//
//  Created by Josh Davis on 3/5/21.
//

import XCTest
//@testable import Chess_Game_REAL

class UITests: XCTestCase {
    
//    var vc = ViewController()
//    let testArrangement: [[PieceKeys?]] = [
//        [nil, nil, nil, nil, nil, nil, nil, nil],
//        [nil, .w_king, nil, nil, nil, nil, nil, nil],
//        [nil, nil, nil, nil, nil, nil, nil, .w_rook_1],
//        [nil, nil, nil, nil, nil, nil, nil, nil],
//        [nil, nil, nil, nil, nil, nil, nil, nil],
//        [nil, nil, nil, nil, nil, .b_pawn_1, nil, nil],
//        [nil, nil, nil, nil, nil, nil, nil, nil],
//        [nil, nil, nil, nil, nil, nil, nil, nil],
//    ]
    override func setUpWithError() throws {
//        let model = BoardModel(withArrangement: testArrangement)
//        vc.positionInModelDelegate = model

        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
//        vc.positionInModelDelegate = nil
    }
//
    func testNormalPieceMoveIntegration() throws {
        simulateMoveWKingInsideBoard()
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

//        XCTAssertEqual(expected, vc.positionInModelDelegate?.getCurrentPieceArrangement())
    }
    
    func simulateMoveWKingInsideBoard() {
        let app = XCUIApplication()
        app.launch()
        let fromCoordinate = app.coordinate(withNormalizedOffset: CGVector(dx: 91.0, dy: 242.5))
        let toCoordinate = app.coordinate(withNormalizedOffset: CGVector(dx: 86.0, dy: 288.0))
        fromCoordinate.press(forDuration: 0, thenDragTo: toCoordinate)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
