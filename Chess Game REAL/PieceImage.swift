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
    func beginPieceMove(startingPosition: CGPoint)
    func checkFinalPositionAndEndMove(endingPosition: CGPoint)
    func stopMovementIfOutsideBounds(currentPositionOnScreen: CGPoint)
    func getNewFrameForPieceImage(endingCoords: PieceCoords) -> CGRect
    func dragOverPointAt(point: CGPoint)
    func cancelMovementOnBoard()
}

class PieceImage: UIImageView, PieceImageMovementDelegate {
    
    var coords: PieceCoords?
    private var startingPosition: CGRect?
    private var isMovementCancelled: Bool = false
    
    var delegate: PieceImageOnBoardDelegate?
    
    init(color: Colors, name: PieceNames) {
        let pieceImage = UIImage(named: "\(color)_\(name)")
        super.init(image: pieceImage)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getPointFromTouch(touch: UITouch) -> CGPoint {
        let point = touch.location(in: self.superview)
        return point
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        rememberStartingPosition()
        if let touch = touches.first {
            let point = getPointFromTouch(touch: touch)
            delegate?.beginPieceMove(startingPosition: point)
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isMovementCancelled {
            return
        }
        guard let touch = touches.first else { return }
        let touchedPoint = getPointFromTouch(touch: touch)
        delegate?.stopMovementIfOutsideBounds(currentPositionOnScreen: touchedPoint)
        
        if isMovementCancelled {
            return
        }
    
        self.center = CGPoint(x: touchedPoint.x, y: touchedPoint.y)
        delegate?.dragOverPointAt(point: touchedPoint)
    }
    
    func rememberStartingPosition() {
        self.startingPosition = self.frame
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isMovementCancelled {
            isMovementCancelled = false
            return
        }
        
        if let touch = touches.first {
            let point = getPointFromTouch(touch: touch)
            delegate?.checkFinalPositionAndEndMove(endingPosition: point)
        }
    }
    
    func moveImageTo(newCoords: PieceCoords) {
        centerPieceInSquare(squareAt: newCoords)
    }
    
    func returnPieceToStartingPosition() {
        self.frame = self.startingPosition!
        self.startingPosition = nil
    }
    
    func centerPieceInSquare(squareAt: PieceCoords) {
        if let newFrameOnBoard = delegate?.getNewFrameForPieceImage(endingCoords: squareAt) {
            self.frame = newFrameOnBoard
        }
    }
    
    func saveNewCoords(coords: PieceCoords) {
        self.coords = coords
    }
    
    func cancelPieceImageMovementAndReturnToOriginalPosition() {
        returnPieceToStartingPosition()
        isMovementCancelled = true
    }
}
