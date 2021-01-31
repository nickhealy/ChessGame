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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .cyan
        createBoard()
        
        boardView?.delegate = self
        boardView?.dragDelegate = self
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
//    private func updateCoordsOfPiecesToArrangement(_ model: [[PieceKeys?]]) {
//        for row in 0..<8 {
//            for col in 0..<8 {
//                if let keyOfPieceInSquare = model[row][col] {
//                    let piece =
//                }
//            }
//        }
//    }

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

extension ViewController: PieceImageDelegate {
    func didTouchPiece(pieceCoords: PieceCoords) {
//      remove the piece from the BoardModel
        let row = pieceCoords.row
        let col = pieceCoords.col
        boardModel.currentArrangement[row][col] = nil
        print(boardModel.currentArrangement)
    }
    
    func isMovingPiece(pieceCoods: PieceCoords) {
        return
    }
    
    func didDropPiece(pieceCoords: PieceCoords) {
        return
    }
    
    
}


