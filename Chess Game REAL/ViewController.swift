//
//  ViewController.swift
//  Chess Game REAL
//
//  Created by Nick Healy on 1/16/21.
//

import UIKit

struct SelectedPiece {
    var key: PieceKeys
    var image: PieceImage
    var originalPosition: PieceCoords
}

protocol BoardUIDelegate {
    func removePieceImageFromBoardAt(enemyPieceKey: PieceKeys)
}

protocol PiecePositionDelegate {
    func getPieceAt(pieceCoords: PieceCoords) -> PieceKeys?
    func movePieceTo(piece: PieceKeys, newCoords: PieceCoords)
    func removePieceAt(pieceCoords : PieceCoords)
}

protocol PieceImageMovementDelegate {
    func returnPieceToStartingPosition()
    func cancelPieceImageMovementAndReturnToOriginalPosition()
    func moveImageTo(newCoords: PieceCoords)
}
    

class ViewController: UIViewController {
    var selectedPiece: SelectedPiece?
    var boardView: BoardView?
    var boardModel: BoardModel?
    
    var positionInModelDelegate: PiecePositionDelegate?
    var boardUIDelegate: BoardUIDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .cyan
        createBoard()
        boardModel = BoardModel()
        boardView?.updatePositionDelegate = self
        positionInModelDelegate = boardModel
        boardUIDelegate = boardView
    }
    
//    by this point we will have calculated the measurements of each square
    override func viewDidLayoutSubviews() {
        layoutStartingArrangement()
    }
    
    private func layoutStartingArrangement() {
        guard let startingArragement = boardModel?.getCurrentPieceArrangement() else { return }
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
    
//    MARK: Selecting A Piece
    
    func selectPieceAt(pieceCoords: PieceCoords) {
        if let newSelectedPiece = createNewSelectedPiece(coords: pieceCoords) {
            selectedPiece = newSelectedPiece
            positionInModelDelegate?.removePieceAt(pieceCoords: pieceCoords)
        }
    }
    
    private func createNewSelectedPiece(coords: PieceCoords) -> SelectedPiece? {
        guard let pieceKey = positionInModelDelegate?.getPieceAt(pieceCoords: coords) else { return nil }
        let pieceImage = PieceData.getPieceImage(pieceKey: pieceKey)
        return SelectedPiece(key: pieceKey, image: pieceImage, originalPosition: coords)
    }
    
    func getSelectedPieceKey() -> PieceKeys? {
        return self.selectedPiece?.key
    }
    
    func dropOnSquareAt(pieceCoords: PieceCoords ) {
        
        if (isCollision(droppedCoords: pieceCoords)) {
            if (isFriendlyCollsion(droppedCoords: pieceCoords)) {
                handleFriendlyCollision()
            } else {
                takeEnemyPieceAt(pieceCoords: pieceCoords)
            }
        } else {
            handlePieceMovementInModelAndView(newCoords: pieceCoords)
        }
    }
    
//    MARK: Regular Movement

    func handlePieceMovementInModelAndView(newCoords: PieceCoords) {
        if let selectedPiece = self.selectedPiece {
            positionInModelDelegate?.movePieceTo(piece: selectedPiece.key, newCoords: newCoords)
            movePieceImageTo(newCoords: newCoords)
            deselectPiece()
        }
    }
    
    func movePieceImageTo(newCoords: PieceCoords) {
        let pieceImageDelegate: PieceImageMovementDelegate = selectedPiece!.image
        pieceImageDelegate.moveImageTo(newCoords: newCoords)
    }
    
    func deselectPiece() {
        self.selectedPiece = nil
    }
    
    func takeEnemyPieceAt(pieceCoords: PieceCoords) {
        let keyOfPieceToBeTaken = positionInModelDelegate?.getPieceAt(pieceCoords: pieceCoords)
        positionInModelDelegate?.movePieceTo(piece: selectedPiece!.key, newCoords: pieceCoords)
        movePieceImageTo(newCoords: pieceCoords)
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
    
    func tellImageToCancelMovementAndReturnToOriginalPostion() {
        var temporaryImageDelegate: PieceImageMovementDelegate?
        if let selectedPiece = selectedPiece {
            temporaryImageDelegate = selectedPiece.image
            temporaryImageDelegate?.cancelPieceImageMovementAndReturnToOriginalPosition()
        }
    }
    
    func returnPieceToOriginalPositionInModelAndDeselect() {
        positionInModelDelegate?.movePieceTo(piece: selectedPiece!.key, newCoords: selectedPiece!.originalPosition)
        deselectPiece()
    }
    
//    MARK: Movement Off Board
    
    func handleCancellingDrag() {
        tellImageToCancelMovementAndReturnToOriginalPostion()
        returnPieceToOriginalPositionInModelAndDeselect()
    }
    
    func tellImageToReturnToOriginalPosition() {
        var temporaryImageDelegate: PieceImageMovementDelegate?
        if let selectedPiece = selectedPiece {
            
            temporaryImageDelegate = selectedPiece.image
            temporaryImageDelegate?.returnPieceToStartingPosition()
        }
    }
}





