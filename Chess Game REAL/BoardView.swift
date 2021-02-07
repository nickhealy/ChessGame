//
//  BoardView.swift
//  Chess Game REAL
//
//  Created by Nick Healy on 1/18/21.
//

import UIKit

protocol PiecePositionUpdateDelegate {
    func selectPieceAt(pieceCoords: PieceCoords)
    func getSelectedPieceKey() -> PieceKeys?
    func getSideOfSquareOccupant(pieceCoords: PieceCoords) -> Colors?
    func dropOnSquareAt(pieceCoords: PieceCoords)
    func returnPieceToOriginalPositionInModel()
}

class BoardView: UIView {
    var squares: [Square] = []
    var squareHint: UIView?
    var updatePositionDelegate: PiecePositionUpdateDelegate?
    
    private var xOffset: CGFloat = 0.0
    private var yOffset: CGFloat = 0.0

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        renderBoardSquares()
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        formatBoardSquares()
    }
    
    func formatBoardSquares(){
        for square in squares {
            let squareFrame = createFrame(pieceCoords: square.boardCoords!)
            square.frame = squareFrame
        }
    }
}

extension BoardView {
    func renderBoardSquares() {
//        creates squares
        var isBlack: Bool = false
        for row in 0..<8 {
            for col in 0..<8 {
//                alternate black and white
                let color = isBlack ? Colors.black: Colors.white
                let square = Square(color: color, boardCoords: PieceCoords(row: row, col: col))
                isBlack = !isBlack
                
//               adds view to ui
                addSubview(square)
                squares.append(square)
            }
            isBlack = !isBlack
        }
    }
        
    func addPieceImagesToBoard(newArrangement: [[PieceKeys?]]) {
        for row in 0..<8 {
            for col in 0..<8 {
                if let pieceKeyAtCurrentSquare = newArrangement[row][col] {
                    let pieceImage = PieceData.getPieceImage(pieceKey: pieceKeyAtCurrentSquare)
                    pieceImage.delegate = self
                    addPieceImageToBoard(pieceImage: pieceImage, coords: PieceCoords(row: row, col: col))
                }
            }
        }
    }
    
    func addPieceImageToBoard(pieceImage: PieceImage, coords: PieceCoords) {
        let pieceImageFrame = createFrame(pieceCoords: coords)
        pieceImage.frame = pieceImageFrame
        addSubview(pieceImage)
    }
    
    var squareSize: CGSize {
        let bounds = self.bounds
        return CGSize(width: ceil(bounds.width / 8), height: ceil(bounds.height / 8))
    }
    
//    should be private in future
    func createFrame(pieceCoords: PieceCoords) -> CGRect {
        let originY = CGFloat(pieceCoords.row) * squareSize.width
        let originX = CGFloat(pieceCoords.col) * squareSize.height
        let offset = CGPoint(x: originX, y: originY)
        return CGRect(origin: offset, size: squareSize)
    }
    
    
}

extension BoardView: PieceImageOnBoardDelegate {
    
    func beginPieceMove(startingPosition: CGPoint) {
        let startingCoords = createPieceCoordsFromTouchedPoint(touchedPoint: startingPosition)
        self.updatePositionDelegate?.selectPieceAt(pieceCoords: startingCoords)
        self.raiseSelectedPiece()
        self.initializeSquareHint()
    }
    
    func raiseSelectedPiece() {
        if let selectedPieceImage = getSelectedPieceImage() {
            selectedPieceImage.layer.zPosition = 1.0
        }
    }
    
    func lowerSelectedPiece() {
        if let selectedPieceImage = getSelectedPieceImage() {
            print("lowering piece")
            selectedPieceImage.layer.zPosition = 0.0
        }
    }
    
    func getSelectedPieceImage() -> PieceImage? {
        if let pieceKey = self.updatePositionDelegate?.getSelectedPieceKey() {
            return PieceData.getPieceImage(pieceKey: pieceKey)
        }
        return nil
    }
    
    func createPieceCoordsFromTouchedPoint(touchedPoint: CGPoint) -> PieceCoords {
        let row = Int(touchedPoint.y / squareSize.height)
        let col = Int(touchedPoint.x / squareSize.width)
        
        return PieceCoords(row: row, col: col)
    }
    
    func initializeSquareHint() {
        self.squareHint = UIView()
        addSubview(self.squareHint!)
    }
    
    func dragOverPointAt(point: CGPoint) {
        let draggedCoords = createPieceCoordsFromTouchedPoint(touchedPoint: point)
        createSquareHintFilterFor(squareAt: draggedCoords)
    }
    
    func createSquareHintFilterFor(squareAt: PieceCoords) {
        let squareOccupiedBy = self.updatePositionDelegate?.getSideOfSquareOccupant(pieceCoords: squareAt)
        let newHintFrame = createFrame(pieceCoords: squareAt)
        let newHintColor = getOccupiedByColor(color: squareOccupiedBy)
        
        self.squareHint?.frame = newHintFrame
        self.squareHint?.backgroundColor = newHintColor.withAlphaComponent(0.5)
        
    }
    
    func getOccupiedByColor(color: Colors?) -> UIColor {
        var newHintColor: UIColor?
        
        switch color {
        case .black:
            newHintColor = .green
        case .white:
            newHintColor = .blue
        default:
            newHintColor = .magenta
        }
        
        return newHintColor!
    }
    
    func isOutsideBounds(droppedPosition: CGPoint) -> Bool {
        return !self.bounds.contains(droppedPosition)
    }
    
    func endPieceMove(endingPosition: CGPoint) {
        removeSquareHint()
        self.lowerSelectedPiece()
        let endingCoords = createPieceCoordsFromTouchedPoint(touchedPoint: endingPosition)
        self.updatePositionDelegate?.dropOnSquareAt(pieceCoords: endingCoords)
    }
    
    func removeSquareHint() {
        self.squareHint?.removeFromSuperview()
    }
    
    func cancelMovementOnBoard() {
        removeSquareHint()
        self.updatePositionDelegate?.returnPieceToOriginalPositionInModel()
    }
    
    func cancelSquareHints() {
        cancelMovementOnBoard()
    }
    
    func getNewFrameForPieceImage(endingPosition: CGPoint) -> CGRect {
        let endingCoords = createPieceCoordsFromTouchedPoint(touchedPoint: endingPosition)
        return createFrame(pieceCoords: endingCoords)
    }
}

extension BoardView: BoardUIDelegate {
    func returnPieceImageToStartingPosition() {
        return
    }
    
    func removePieceImageFromBoardAt(enemyPieceKey: PieceKeys) {
        let pieceImage = PieceData.getPieceImage(pieceKey: enemyPieceKey)
        pieceImage.removeFromSuperview()
        print("should be removing piece")
    }
    
    
}
