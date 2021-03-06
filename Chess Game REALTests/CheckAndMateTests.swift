//
//  CheckAndMateTests.swift
//  Chess Game REALTests
//
//  Created by Josh Davis on 3/5/21.
//

import XCTest
@testable import Chess_Game_REAL

class CheckAndMateTests: XCTestCase {
    var model: BoardModel! = nil

    override func tearDownWithError() throws {
        model = nil
    }
    
    func addNewArrangement(arrangement: [[PieceKeys?]]) {
        model = BoardModel(withArrangement: arrangement)
    }

    func testEnemyInCheck() throws {
        let arrangement: [[PieceKeys?]] = [
            [nil, nil, nil, .b_king, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, .w_rook_1, nil, nil, nil, nil],
        ]
        addNewArrangement(arrangement: arrangement)
        let actual = model.isEnemyInCheck()
        
        XCTAssertTrue(actual, "returns true when enemy king is in check")
    }
    
    func testEnemyInCheckFalse() throws {
        let arrangement: [[PieceKeys?]] = [
            [nil, nil, nil, .b_king, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, .w_rook_1, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
        addNewArrangement(arrangement: arrangement)
        let actual = model.isEnemyInCheck()
        
        XCTAssertFalse(actual, "returns false when enemy is not in check")
    }
    
    func testAreWeInCheckTrue() throws {
        let arrangement: [[PieceKeys?]] = [
            [nil, nil, nil, .b_rook_1, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, .w_king, nil, nil, nil, nil],
        ]
        addNewArrangement(arrangement: arrangement)
        let actual = model.areWeInCheck()
        
        XCTAssertTrue(actual, "return true when own king is in check")
    }
    
    func testAreWeInCheckTrueFalse() throws {
        let arrangement: [[PieceKeys?]] = [
            [nil, nil, nil, nil, .b_rook_1, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, .w_king, nil, nil, nil, nil],
        ]
        addNewArrangement(arrangement: arrangement)
        let actual = model.areWeInCheck()
        
        XCTAssertFalse(actual, "returns fase when own king not in check")
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
