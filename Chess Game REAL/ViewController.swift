//
//  ViewController.swift
//  Chess Game REAL
//
//  Created by Nick Healy on 1/16/21.
//

import UIKit

struct SelectedPiece: Equatable {
    var key: PieceKeys
    var image: PieceImage
    var originalPosition: PieceCoords
    var possibleMoves: PossibleMoves
    
    init(key: PieceKeys, at: PieceCoords, inBoard: BoardModel) {
        self.key = key
        self.originalPosition = at
        self.image = PieceData.getPieceImage(pieceKey: key)
        self.possibleMoves = inBoard.getMovesFor(pieceKey: key)
    }
    
    static func == (lhs: SelectedPiece, rhs: SelectedPiece) -> Bool {
        return lhs.key == rhs.key && lhs.originalPosition == rhs.originalPosition
    }
}

protocol BoardUIDelegate {
    func removePieceImageFromBoardAt(enemyPieceKey: PieceKeys)
}

protocol PiecePositionDelegate {
    func getPieceAt(pieceCoords: PieceCoords) -> PieceKeys?
    func removePieceAt(pieceCoords: PieceCoords)
    func getCurrentPieceArrangement() -> [[PieceKeys?]]
}

protocol PieceImageMovementDelegate {
    func moveImageToSquareAt(newCoords: PieceCoords)
}
    

class ViewController: UIViewController {
    var selectedPiece: SelectedPiece?
    var boardView: BoardView?
    var boardModel: BoardModel?
    
    var positionInModelDelegate: PiecePositionDelegate?
    var boardUIDelegate: BoardUIDelegate?
    var pieceDragAndDropManager: DragAndDropManager?
    var moveHintManager: MoveHintManager?
    var moveManager: MoveManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .cyan
        createBoard()
        boardModel = BoardModel()
        moveManager = MoveManager(board: boardModel!)
        boardView?.updatePositionDelegate = self
        positionInModelDelegate = boardModel
        boardUIDelegate = boardView
        moveHintManager = boardView
        pieceDragAndDropManager = DragAndDropManager(board: boardView!)
    }
    
//    by this point we will have calculated the measurements of each square
    override func viewDidLayoutSubviews() {
        layoutStartingArrangement()
    }
    
    private func layoutStartingArrangement() {
        guard let startingArragement = positionInModelDelegate?.getCurrentPieceArrangement() else { return }
//        updateCoordsOfPiecesToArrangement(pieceArrangement)
        boardView?.addPieceImagesToBoard(newArrangement: startingArragement)

    }
    
    private func createBoard() {
//        creates board frame
        boardView = BoardView()
        
        guard let boardView = boardView else { return }
        boardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boardView)
        
        boardView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10).isActive = true
        boardView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor).isActive = true
        boardView.heightAnchor.constraint(equalTo: boardView.widthAnchor).isActive = true
        boardView.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor).isActive = true
    }
    
    func renderNewBoardPosition() {
        
    }
    
}

protocol PieceImageMovementManager {
    func cancelMoveAndReturnPieceToOriginalPosition(image: PieceImage, originalPosition: PieceCoords)
    func stickPieceInPotentialSquare(image: PieceImage, squareAt: PieceCoords)
    func movePieceNormallyOverPoint(image: PieceImage, point: CGPoint)
    func resetMove()
}

protocol MoveHintManager {
    func highlightSquaresAt(possibleMoves: PossibleMoves)
    func removeSquareHighlights()
    func highlightStartingPosition(at: PieceCoords)
}

extension ViewController: PiecePositionUpdateDelegate {
    
    func getSideOfSquareOccupant(pieceCoords: PieceCoords) -> Colors? {
        if let keyOfOccupant = positionInModelDelegate?.getPieceAt(pieceCoords: pieceCoords) {
            let occupyingPiece = PieceData.getPiece(piecekey: keyOfOccupant)
            let colorOfOccupyingPiece = occupyingPiece.color
            return colorOfOccupyingPiece
        }
        return nil
    
    }
    
    func handleBoardTouchedAt(pieceCoords: PieceCoords) {
        if (thereIsSelectablePieceAt(pieceCoords: pieceCoords)) {
            selectPieceAt(pieceCoords: pieceCoords)
        }
    }
    
//    MARK: Selecting A Piece
    private func thereIsSelectablePieceAt(pieceCoords: PieceCoords) -> Bool {
//        for now will let us select any piece, regardless of color
        if positionInModelDelegate?.getPieceAt(pieceCoords: pieceCoords) != nil {
            return true
        } else {
            return false
        }
    }
    
    func selectPieceAt(pieceCoords: PieceCoords) {
        guard let pieceKey = positionInModelDelegate?.getPieceAt(pieceCoords: pieceCoords) else { return }
        self.selectedPiece = SelectedPiece(key: pieceKey, at: pieceCoords, inBoard: boardModel!)
        showStartingPosition()
        highlightPossibleMovesOnBoard()
    }
    
    private func showStartingPosition() {
        guard let startingPosition = selectedPiece?.originalPosition else { return }
        moveHintManager?.highlightStartingPosition(at: startingPosition)
    }
    
    private func highlightPossibleMovesOnBoard() {
        guard let possibleMoves = selectedPiece?.possibleMoves else { return }
        moveHintManager?.highlightSquaresAt(possibleMoves: possibleMoves)
    }
    
    func getSelectedPieceKey() -> PieceKeys? {
        return self.selectedPiece?.key
    }
    
//    MARK: Dragging a Piece
    
    func handlePieceDragOver(pieceCoords: PieceCoords, touchedPoint: CGPoint) {
        guard let selected = selectedPiece else { return }
        
        if selected.possibleMoves.contains(pieceCoords) {
            pieceDragAndDropManager?.stickPieceInPotentialSquare(image: selected.image, squareAt: pieceCoords)
        } else {
            pieceDragAndDropManager?.movePieceNormallyOverPoint(image: selected.image, point: touchedPoint)
        }
    }
    
    func cancelPieceMovement() {
        guard let selected = selectedPiece else { return }
        pieceDragAndDropManager?.cancelMoveAndReturnPieceToOriginalPosition(image: selected.image, originalPosition: selected.originalPosition)
        deselectPiece()
    }
    
    func resetMove() {
        pieceDragAndDropManager?.resetMove()
    }
    
//    MARK: Placing a piece on a new square
    func movePieceTo(pieceCoords: PieceCoords) {
        print("should be moving piece to \(pieceCoords)")
        guard let selected = selectedPiece else { return }
        moveManager?.createMove(piece: selected, to: pieceCoords)
        
    }
    
    func dropOnSquareAt(pieceCoords: PieceCoords ) {
        if (isCollision(droppedCoords: pieceCoords)) {
            if (isFriendlyCollsion(droppedCoords: pieceCoords)) {
                handleFriendlyCollision()
            } else {
                takeEnemyPieceAt(pieceCoords: pieceCoords)
            }
        } else {
//            handlePieceMovementInModelAndView(newCoords: pieceCoords)
        }
    }
    
//    MARK: Regular Movement

//    func handlePieceMovementInModelAndView(newCoords: PieceCoords) {
//        if let selectedPiece = self.selectedPiece {
//            positionInModelDelegate?.movePieceTo(piece: selectedPiece.key, newCoords: newCoords)
////            movePieceImageTo(newCoords: newCoords)
//            deselectPiece()
//        }
//    }
    
//    func movePieceImageTo(newCoords: PieceCoords) {
//        let pieceImageDelegate: PieceImageMovementDelegate = selectedPiece!.image
//        pieceImageDelegate.moveImageTo(newCoords: newCoords)
//    }
//
    func deselectPiece() {
        self.selectedPiece = nil
        moveHintManager?.removeSquareHighlights()
    }
    
    func takeEnemyPieceAt(pieceCoords: PieceCoords) {
        let keyOfPieceToBeTaken = positionInModelDelegate?.getPieceAt(pieceCoords: pieceCoords)
        positionInModelDelegate?.removePieceAt(pieceCoords: pieceCoords)
//        positionInModelDelegate?.movePieceTo(piece: selectedPiece!.key, newCoords: pieceCoords)
//        movePieceImageTo(newCoords: pieceCoords)
        boardUIDelegate?.removePieceImageFromBoardAt(enemyPieceKey: keyOfPieceToBeTaken!)
    }
    
    
    func isCollision(droppedCoords: PieceCoords) -> Bool {
        return positionInModelDelegate?.getPieceAt(pieceCoords: droppedCoords) != nil
    }
    
// MARK: Friendly Collision
    
    func isFriendlyCollsion(droppedCoords: PieceCoords) -> Bool {
        let targetPieceKey = positionInModelDelegate?.getPieceAt(pieceCoords: droppedCoords)
        let selectedPieceKey = selectedPiece!.key
        return PieceData.getPieceColorFromKey(piecekey: targetPieceKey!) == PieceData.getPieceColorFromKey(piecekey: selectedPieceKey)
    }
    
    func handleFriendlyCollision() {
        tellImageToReturnToOriginalPosition()
        returnPieceToOriginalPositionInModelAndDeselect()
    }
    
    func tellImageToReturnToOriginalPosition() {
        var temporaryImageDelegate: PieceImageMovementDelegate?
        if let selectedPiece = selectedPiece {
            
            temporaryImageDelegate = selectedPiece.image
//            temporaryImageDelegate?.returnPieceToStartingPosition()
        }
    }
    
    func returnPieceToOriginalPositionInModelAndDeselect() {
//        positionInModelDelegate?.movePieceTo(piece: selectedPiece!.key, newCoords: selectedPiece!.originalPosition)
        deselectPiece()
    }
    
//    MARK: Movement Off Board
    
    func handleCancellingDrag() {
        tellImageToCancelMovementAndReturnToOriginalPostion()
        returnPieceToOriginalPositionInModelAndDeselect()
    }
    
    func tellImageToCancelMovementAndReturnToOriginalPostion() {
        var temporaryImageDelegate: PieceImageMovementDelegate?
        if let selectedPiece = selectedPiece {
            temporaryImageDelegate = selectedPiece.image
//            temporaryImageDelegate?.cancelPieceImageMovementAndReturnToOriginalPosition()
        }
    }
}





