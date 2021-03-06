//
//  BoardView.swift
//  Chess Game REAL
//
//  Created by Nick Healy on 1/18/21.
//

import UIKit

protocol PiecePositionUpdateDelegate {
    func selectPieceAt(pieceCoords: PieceCoords)
    func handleBoardTouchedAt(pieceCoords: PieceCoords)
    func handlePieceDragOver(pieceCoords: PieceCoords, touchedPoint: CGPoint)
    func cancelPieceMovement()
    func resetMove()
    func getSelectedPieceKey() -> PieceKeys?
    func getSideOfSquareOccupant(pieceCoords: PieceCoords) -> Colors?
    func dropOnSquareAt(pieceCoords: PieceCoords)
    func handleCancellingDrag()
    func movePieceTo(pieceCoords: PieceCoords)
}

class BoardView: UIView {
    var squares: [Square] = []
    var squareHint: UIView?
    var dragAndDropManager: PieceImageMovementManager?
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
        dragAndDropManager = DragAndDropManager(board: self)
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
                square.layer.zPosition = 0.00
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
        pieceImage.setInitialPositionInUI(frame: pieceImageFrame)
        pieceImage.layer.zPosition = 1.0
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

enum GameErrors: Error {
    case PointOutsideBoard
}


extension BoardView: MovementManagerDelegate {
    func handleBoardTouchedAt(position: CGPoint) {
       updatePositionDelegate?.selectPieceAt(pieceCoords: createPieceCoordsFromTouchedPoint(touchedPoint: position))
    }
    
    func handlePieceBeingMovedOffBoard() {
        
    }
    
    func handlePieceDraggedAt(position: CGPoint) {
        print("DRAGGED OVER \(createPieceCoordsFromTouchedPoint(touchedPoint: position))")
    }
    
    func handlePieceDroppedAt(position: CGPoint) {
        print("TOUCH ENDED AT \(createPieceCoordsFromTouchedPoint(touchedPoint: position))")
    }
    
    func getTouchedPositionInBoard(touchedPoint: UITouch) -> CGPoint {
        return touchedPoint.location(in: self)
    }
    
    func isPositionOffBoard(position: CGPoint) -> Bool {
        !self.bounds.contains(position)
    }
    
    private func createPieceCoordsFromTouchedPoint(touchedPoint: CGPoint) -> PieceCoords {
        let row = Int(touchedPoint.y / squareSize.height)
        let col = Int(touchedPoint.x / squareSize.width)
        return PieceCoords(row: row, col: col)
    }
    
    private func touchedMoveablePiece() -> Bool {
        return true
    }
}

extension BoardView: MoveHintManager {
    func highlightSquaresAt(possibleMoves: PossibleMoves) {
        possibleMoves.forEach { move in
            let squareIdx = getIndexOfSquareFromCoords(coords: move!)
            squares[squareIdx].showHint()
        }
    }
    
    func removeSquareHighlights() {
        squares.forEach { $0.showSquareColor()}
    }
    
    func highlightStartingPosition(at: PieceCoords) {
        let indexOfStartingSquare = getIndexOfSquareFromCoords(coords: at)
        squares[indexOfStartingSquare].showAsStartingPosition()
    }
    
    private func getIndexOfSquareFromCoords(coords: PieceCoords) -> Int {
        return coords.row * 8 + coords.col
    }
}

extension BoardView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchedPoint = getTouchedPositionInBoard(touchedPoint: touch)
            updatePositionDelegate?.handleBoardTouchedAt(pieceCoords: createPieceCoordsFromTouchedPoint(touchedPoint: touchedPoint))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchedPoint = getTouchedPositionInBoard(touchedPoint: touch)
            if (isPositionOffBoard(position: touchedPoint)) {
                updatePositionDelegate?.cancelPieceMovement()
                updatePositionDelegate?.resetMove()
            } else {
                updatePositionDelegate?.handlePieceDragOver(pieceCoords: createPieceCoordsFromTouchedPoint(touchedPoint: touchedPoint), touchedPoint: touchedPoint)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchedPoint = getTouchedPositionInBoard(touchedPoint: touch)
            if (isPositionOffBoard(position: touchedPoint)) {
                return
            }
            updatePositionDelegate?.movePieceTo(pieceCoords: createPieceCoordsFromTouchedPoint(touchedPoint: touchedPoint))
        }
    }
    
    func raiseSelectedPiece() {
        if let selectedPieceImage = getSelectedPieceImage() {
            selectedPieceImage.layer.zPosition = 5.0
        }
    }
    
    func cancelMovementOnBoard() {
        updatePositionDelegate?.handleCancellingDrag()
        self.lowerSelectedPiece()
        removeSquareHint()
    }
}

extension BoardView: PieceImageOnBoardDelegate {
    func stopMovementIfOutsideBounds(currentPositionOnScreen: CGPoint) {
        return
        
    }
    
    func beginPieceMove(startingPosition: CGPoint) {
//        let startingCoords = createPieceCoordsFromTouchedPoint(touchedPoint: startingPosition)
//        self.updatePositionDelegate?.selectPieceAt(pieceCoords: startingCoords)
//        self.raiseSelectedPiece()
//        self.initializeSquareHint()
    }
//
    
    func lowerSelectedPiece() {
        if let selectedPieceImage = getSelectedPieceImage() {
            selectedPieceImage.layer.zPosition = 1.0
        }
    }
    
    func getSelectedPieceImage() -> PieceImage? {
        if let pieceKey = self.updatePositionDelegate?.getSelectedPieceKey() {
            return PieceData.getPieceImage(pieceKey: pieceKey)
        }
        return nil
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
    
    func isOutsideBounds(point: CGPoint) -> Bool {
        return !self.bounds.contains(point)
    }
    
    
    func checkFinalPositionAndEndMove(endingPosition: CGPoint) {
        removeSquareHint()
        self.lowerSelectedPiece()
        let endingCoords = createPieceCoordsFromTouchedPoint(touchedPoint: endingPosition)
        self.updatePositionDelegate?.dropOnSquareAt(pieceCoords: endingCoords)
    }
    
    func removeSquareHint() {
        self.squareHint?.removeFromSuperview()
    }

    func getNewFrameForPieceImage(endingCoords: PieceCoords) -> CGRect {
//        let endingCoords = createPieceCoordsFromTouchedPoint(touchedPoint: endingPosition)
        return createFrame(pieceCoords: endingCoords)
    }
}

extension BoardView: BoardUIDelegate {
    func removePieceImageFromBoardAt(enemyPieceKey: PieceKeys) {
        let pieceImage = PieceData.getPieceImage(pieceKey: enemyPieceKey)
        pieceImage.removeFromSuperview()
    }

}
