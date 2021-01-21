//
//  BoardView.swift
//  Chess Game REAL
//
//  Created by Nick Healy on 1/18/21.
//

import UIKit

class BoardView: UIView {
    var squares: [Square] = []
    var pieces: [[Piece?]]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
        setupBoard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for square in squares {
            let squareFrame = createFrame(boardCoords: square.boardCoords!)
            square.frame = squareFrame
        }
    }
}

extension BoardView {
    func setupBoard() {
//        creates squares
        var isBlack: Bool = false
        for row in 0..<8 {
            for col in 0..<8 {
//                alternate black and white
                let color = isBlack ? Colors.black: Colors.white
                let square = Square(color: color, boardCoords: CGPoint(x: col, y: row))
                isBlack = !isBlack
                
//               adds view to ui
                addSubview(square)
                squares.append(square)
            }
            isBlack = !isBlack
        }
    }
    
    func populateBoard(currentArrangement: [[PlayPieces?]]) -> [[Piece?]] {
        var newPieces: [[Piece?]] = []
        
        for row in currentArrangement {
            var newRow: [Piece?] = []
            for piece in row {
                if let piece = piece {
                    newRow.append(Piece(name: piece))
                }
            }
            newPieces.append(newRow)
        }
        return newPieces
    }
    
    var squareSize: CGSize {
        let bounds = self.bounds
        return CGSize(width: ceil(bounds.width / 8), height: ceil(bounds.height / 8))
    }
    
    private func createFrame(boardCoords: CGPoint) -> CGRect {
        let offset = CGPoint(x: boardCoords.x * squareSize.width, y: boardCoords.y * squareSize.height)
        return CGRect(origin: offset, size: squareSize)
    }
    
    
}
