//
//  ViewController.swift
//  Chess Game REAL
//
//  Created by Josh Davis on 1/16/21.
//

import UIKit

struct SelectedPiece {
    var key: PieceKeys
    var image: PieceImage
    var originalPosition: PieceCoords
    
//    init(coords: PieceCoords, image: PieceImage, key: PieceKeys) {
//        self.originalPosition = coords
//        self.key = key
//        self.image = image
//    }
}

protocol PieceImagePositionManager {
        func returnToStartingPosition()
}

protocol PiecePositionDelegate {
    func getPieceAt(pieceCoords: PieceCoords) -> PieceKeys?
    func movePieceTo(piece: PieceKeys, newCoords: PieceCoords)
    func removePieceAt(pieceCoords : PieceCoords)
}
    

class ViewController: UIViewController {
    var selectedPiece: SelectedPiece?
    var boardView: BoardView?
    var boardModel: BoardModel?
    
    var positionInModelDelegate: PiecePositionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .cyan
        createBoard()
        boardModel = BoardModel()
        boardView?.updatePositionDelegate = self
        positionInModelDelegate = boardModel
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
    
//    func updateBoard() {
//        boardView?.showPieceArrangement(newArrangement: BoardModel.currentArrangement)
//    }
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
    
    func dropOnSquareAt(pieceCoords: PieceCoords ) {
        if let selectedPiece = self.selectedPiece {
            if (isCollision(droppedCoords: pieceCoords)) {
                print("COLLSION")
                if (isFriendlyCollsion(droppedCoords: pieceCoords)) {
                    print("FRIENDLY COLLISION")
                    returnPieceToOriginalPositionInModel()
                    
                } else {
                    positionInModelDelegate?.movePieceTo(piece: selectedPiece.key, newCoords: pieceCoords)
                    print("NOT FRIENDLY COLLISION")
                }
            } else {
                print("NO COLLISION")
                positionInModelDelegate?.movePieceTo(piece: selectedPiece.key, newCoords: pieceCoords)
            }
        }
        deselectPiece()
    }
    
    func deselectPiece() {
        self.selectedPiece = nil
    }
    
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
    
    func returnPieceToOriginalPositionInModel() {
        if let selectedPiece = self.selectedPiece {
//            let selectedPieceKey = PieceData.getPieceCoordsFromImage(image: selectedPiece)
            positionInModelDelegate?.movePieceTo(piece: selectedPiece.key, newCoords: selectedPiece.originalPosition)
            deselectPiece()
        }
    }
    
    func getSelectedPieceKey() -> PieceKeys? {
        return self.selectedPiece?.key
    }
    
    func isCollision(droppedCoords: PieceCoords) -> Bool {
        return positionInModelDelegate?.getPieceAt(pieceCoords: droppedCoords) != nil
    }
    
    func isFriendlyCollsion(droppedCoords: PieceCoords) -> Bool {
        let targetPieceKey = positionInModelDelegate?.getPieceAt(pieceCoords: droppedCoords)
        let selectedPieceKey = selectedPiece!.key
        return PieceData.getPieceColorFromKey(piecekey: targetPieceKey!) == PieceData.getPieceColorFromKey(piecekey: selectedPieceKey)
    }
}




