//
//  PieceImage.swift
//  Chess Game REAL
//
//  Created by Nick Healy on 1/29/21.
//

import UIKit

struct PieceCoords: Equatable {
    var row: Int
    var col: Int
}

protocol PieceImageOnBoardDelegate {
    func getNewFrameForPieceImage(endingCoords: PieceCoords) -> CGRect
}

typealias ImageDimensions = (width: CGFloat, height: CGFloat)

let ENLARGEMENT_FACTOR: CGFloat = 1.50
let SELECTED_ALPHA: CGFloat = 0.80
let NORMAL_ALPHA: CGFloat = 1.00
let NORMAL_Z_INDEX: CGFloat = 0.00
let RAISED_Z_INDEX: CGFloat = 5.00

class PieceImage: UIImageView, PieceImageMovementDelegate {
    
    private var originalDimensions: ImageDimensions! = nil
    private var enlargedDimensions: ImageDimensions {
        return (originalDimensions!.width * ENLARGEMENT_FACTOR, originalDimensions!.height * ENLARGEMENT_FACTOR)
    }
    
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
        saveOriginalDimensions()
    }
    
    private func saveOriginalDimensions() {
        originalDimensions = (frame.width, frame.height)
    }

    func movePieceImageToPoint(point: CGPoint) {
        self.center = point
    }
    
    func moveImageToSquareAt(newCoords: PieceCoords) {
        centerPieceInSquare(squareAt: newCoords)
    }
    
    private func centerPieceInSquare(squareAt: PieceCoords) {
        if let newFrameOnBoard = delegate?.getNewFrameForPieceImage(endingCoords: squareAt) {
            self.frame = newFrameOnBoard
        }
    }
    
    func enlargeAndRaiseFromBoard() {
        applyNewDimensions(dimensions: enlargedDimensions)
        applyNewTransparency(alpha: SELECTED_ALPHA)
        applyNewZIndex(index: RAISED_Z_INDEX)
    }
    
    func returnToNormalSizeAndLowerToBoard() {
        applyNewDimensions(dimensions: originalDimensions)
        applyNewTransparency(alpha: NORMAL_ALPHA)
        applyNewZIndex(index: NORMAL_Z_INDEX)
    }
    
    private func applyNewDimensions(dimensions: ImageDimensions) {
        self.frame = CGRect(x: frame.minX, y: frame.minY, width: dimensions.width, height: dimensions.height)
    }
    
    private func applyNewTransparency(alpha: CGFloat) {
        self.alpha = alpha
    }
    
    private func applyNewZIndex(index: CGFloat) {
        layer.zPosition = index
    }
}
