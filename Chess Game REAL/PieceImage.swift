//
//  PieceImage.swift
//  Chess Game REAL
//
//  Created by Josh Davis on 1/29/21.
//

import UIKit

struct PieceCoords {
    var row: Int
    var col: Int
}

protocol PieceImageOnBoardDelegate {
//    func didTouchPiece(pieceCoords: PieceCoords)
//    func isMovingPiece(pieceCoods: PieceCoords)
//    func didDropPiece(pieceCoords: PieceCoords)
    func beginPieceMove(startingPosition: CGPoint)
    func endPieceMove(endingPosition: CGPoint)
    func isOutsideBounds(droppedPosition: CGPoint) -> Bool
    func getNewFrameForPieceImage(endingPosition: CGPoint) -> CGRect
    func dragOverPointAt(point: CGPoint)
    func cancelMovementOnBoard()
}

class PieceImage: UIImageView {
    var coords: PieceCoords?
    private var offsetX: CGFloat = 0.0
    private var offsetY: CGFloat = 0.0
    private var startingPosition: CGRect?
    private var isOutsideBoardView: Bool = false
    
    var delegate: PieceImageOnBoardDelegate?
    
    init(color: Colors, name: PieceNames) {
        let pieceImage = UIImage(named: "\(color)_\(name)")
        super.init(image: pieceImage)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        rememberStartingPosition()
        if let touch = touches.first {
            let point = getPointFromTouch(touch: touch)
            offsetX = point.x - self.center.x
            offsetY = point.y - self.center.y
            
            delegate?.beginPieceMove(startingPosition: point)
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOutsideBoardView {
            return
        }
        if let touch = touches.first {
            let point = getPointFromTouch(touch: touch)
            if movedPointOutsideBoard(droppedPoint: point) {
                terminateMovement()
                return
            }
                
            self.center = CGPoint(x: point.x - self.offsetX, y: point.y - self.offsetY)
            delegate?.dragOverPointAt(point: point)
        }
    }
    
    func terminateMovement() {
        isOutsideBoardView = true
        delegate?.cancelMovementOnBoard()
        returnPieceToStartingPosition()
    }
    
    func rememberStartingPosition() {
        self.startingPosition = self.frame
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOutsideBoardView {
            isOutsideBoardView = false
            return
        }
        self.touchesMoved(touches, with: event)
//        todo: make this work so it gets passed a location as well
//        pieceImageDelegate?.didDropPiece(pieceCoords: self.coords)
        if let touch = touches.first {
            let point = getPointFromTouch(touch: touch)
            
            delegate?.endPieceMove(endingPosition: point)
            centerPieceInSquare(newPosition: point)
            
        }
        
    }
    
    func returnPieceToStartingPosition() {
        self.frame = self.startingPosition!
        self.startingPosition = nil
    }
    
    func movedPointOutsideBoard(droppedPoint: CGPoint) -> Bool {
        let isOutside = delegate?.isOutsideBounds(droppedPosition: droppedPoint)
        if isOutside != nil {
            return isOutside!
        }
        return true
    }
    
    func centerPieceInSquare(newPosition: CGPoint) {
        if let newFrameOnBoard = delegate?.getNewFrameForPieceImage(endingPosition: newPosition) {
            self.frame = newFrameOnBoard
        }
    }
    
    func getPointFromTouch(touch: UITouch) -> CGPoint {
        let point = touch.location(in: self.superview)
        return point
    }
    
    func saveNewCoords(coords: PieceCoords) {
        self.coords = coords
    }
}
