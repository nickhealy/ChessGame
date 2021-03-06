//
//  PieceImageMovementManager.swift
//  Chess Game REAL
//
//  Created by Nick Healy on 3/6/21.
//

import Foundation
import UIKit

protocol MovementManagerDelegate {
    func handlePieceBeingMovedOffBoard()
    func handleBoardTouchedAt(position: CGPoint)
    func isPositionOffBoard(position: CGPoint) -> Bool
    func getTouchedPositionInBoard(touchedPoint: UITouch) -> CGPoint
    func handlePieceDroppedAt(position: CGPoint)
    func handlePieceDraggedAt(position: CGPoint)
}

class DragAndDropManager: PieceImageMovementManager {
    private var wasPieceMovedOffBoard: Bool = false
   
    private var board: MovementManagerDelegate
    
    init(board: BoardView) {
        self.board = board
    }
    
    func handlePieceDrop(_ touches: Set<UITouch>) {
        if (wasPieceMovedOffBoard) {
            return
        }
//        if let point = getPointFromTouchData(touches) {
//            board.handlePieceDroppedAt(position: point)
//        }
    }
    
    func movePieceNormallyOverPoint(image: PieceImage, point: CGPoint) {
        image.movePieceImageToPoint(point: point)
        enlargePieceImage(image: image)
    }
    
    func stickPieceInPotentialSquare(image: PieceImage, squareAt: PieceCoords) {
        image.moveImageToSquareAt(newCoords: squareAt)
        bringImageToNormalSize(image: image)
    }
    
    func cancelMoveAndReturnPieceToOriginalPosition(image: PieceImage, originalPosition: PieceCoords) {
        wasPieceMovedOffBoard = true
        image.moveImageToSquareAt(newCoords: originalPosition)
    }
    
    func enlargePieceImage(image: PieceImage) {
        image.enlargeAndRaiseFromBoard()
    }
    
    func bringImageToNormalSize(image: PieceImage) {
        image.returnToNormalSizeAndLowerToBoard()
    }
    
    func resetMove() {
        wasPieceMovedOffBoard = false
    }
    
}
