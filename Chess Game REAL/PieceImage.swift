//
//  PieceImage.swift
//  Chess Game REAL
//
//  Created by Josh Davis on 1/29/21.
//

import UIKit

struct PieceCoords: Equatable {
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
    
    func setInitialPositionInUI(frame: CGRect) {
        self.frame = frame
        rememberNewStartingPosition()
    }
    
    func getPointFromTouch(touch: UITouch) -> CGPoint {
        let point = touch.location(in: self.superview)
        return point
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        rememberNewStartingPosition()
        if let touch = touches.first {
            print("touched at \(touch.location(in: window))")
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
        
        continueDragIfMovementNotCancelled(currentPoint: touchedPoint)
    }
    
    func continueDragIfMovementNotCancelled(currentPoint: CGPoint) {
        if isMovementCancelled {
            return
        }
    
        self.center = CGPoint(x: currentPoint.x, y: currentPoint.y)
        delegate?.dragOverPointAt(point: currentPoint)
    }
    
    func rememberNewStartingPosition() {
        print("REMEMBERING")
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
    
    func cancelPieceImageMovementAndReturnToOriginalPosition() {
        returnPieceToStartingPosition()
        isMovementCancelled = true
    }
    
    func returnPieceToStartingPosition() {
        self.frame = self.startingPosition!
        self.startingPosition = nil
    }
    
    func moveImageTo(newCoords: PieceCoords) {
        centerPieceInSquare(squareAt: newCoords)
    }
    
    func centerPieceInSquare(squareAt: PieceCoords) {
        if let newFrameOnBoard = delegate?.getNewFrameForPieceImage(endingCoords: squareAt) {
            print(newFrameOnBoard)
            self.frame = newFrameOnBoard
        }
    }
    
}
