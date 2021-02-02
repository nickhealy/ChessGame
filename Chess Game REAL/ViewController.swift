//
//  ViewController.swift
//  Chess Game REAL
//
//  Created by Josh Davis on 1/16/21.
//

import UIKit

class ViewController: UIViewController {
    
    var boardView: BoardView?
    var boardModel = BoardModel()
    var currentlySelectedPiece: PieceKeys?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .cyan
        createBoard()
        
        boardView?.delegate = self
        boardView?.dragDelegate = self
        boardView?.updatePositionDelegate = self
    }
    
//    by this point we will have calculated the measurements of each square
    override func viewDidLayoutSubviews() {
        layoutStartingArrangement()
    }
    
    private func layoutStartingArrangement() {
        let startingArragement = boardModel.currentArrangement
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
//        boardView?.showPieceArrangement(newArrangement: boardModel.currentArrangement)
//    }
}

extension ViewController: BoardViewDelegate {
    
    func handleTap(row: Int, col: Int, location: CGPoint) {
        print("tap handled. row: \(row), col: \(col)")
        guard let pieceKey = boardModel.currentArrangement[row][col] else {
            return
        }
        let piece = PieceFuncs.getPiece(key: pieceKey)
        print("tapped \(piece.name) of color \(piece.color)")
    }
}

extension ViewController: PieceDragDelegateProtocol {
    
    func piecePickUp(piece: UIImageView, row: Int, col: Int) {
        boardModel.currentArrangement[row][col] = nil
    }
    
    func pieceDrag(piece: UIImageView, row: Int, col: Int) {
        boardModel.currentArrangement[row][col] = PieceKeys.b_king
        print(boardModel.currentArrangement)
//        todo : this! s
    }
}

extension ViewController: PiecePositionUpdateDelegate {
    func getSideOfSquareOccupant(pieceCoords: PieceCoords) -> Colors? {
        let currentRow = pieceCoords.row
        let currentCol = pieceCoords.col
        
        if let keyOfOccupant = boardModel.currentArrangement[currentRow][currentCol] {
            let occupyingPiece = PieceData.getPiece(piecekey: keyOfOccupant)
            let colorOfOccupyingPiece = occupyingPiece.color
            return colorOfOccupyingPiece
        }
        return nil
    
    }
    
    func dropOnSquareAt(pieceCoords: PieceCoords ) {
        let droppedRow = pieceCoords.row
        let droppedCol = pieceCoords.col
        boardModel.currentArrangement[droppedRow][droppedCol] = self.currentlySelectedPiece
        print(boardModel.currentArrangement)
        currentlySelectedPiece = nil
    }
    
    func removePieceFromBoardAt(pieceCoords: PieceCoords) {
        let touchedRow = pieceCoords.row
        let touchedCol = pieceCoords.col
        print("touched : \(touchedRow), \(touchedCol)")
        
        let selectedPiece = boardModel.currentArrangement[touchedRow][touchedCol]
        currentlySelectedPiece = selectedPiece
        
        boardModel.currentArrangement[touchedRow][touchedCol] = nil
        
    }
    
    
    func didTouchPiece(pieceCoords: PieceCoords) {
//      remove the piece from the BoardModel
        let touchedRow = pieceCoords.row
        let touchedCol = pieceCoords.col
        print("here i am")
        boardModel.currentArrangement[touchedRow][touchedCol] = nil
        print(boardModel.currentArrangement)
    }
    
    func isMovingPiece(pieceCoods: PieceCoords) {
        return
    }
    
    func didDropPiece(pieceCoords: PieceCoords) {
        return
    }
    
    
}




