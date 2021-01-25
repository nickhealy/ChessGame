//
//  BoardView.swift
//  Chess Game REAL
//
//  Created by Nick Healy on 1/18/21.
//

import UIKit

protocol BoardViewDelegate {
    func handleTap(row: Int, col: Int, location: CGPoint)
}

class BoardView: UIView {
    var delegate: BoardViewDelegate?
    
    var squares: [Square] = []
    
    var test_king: UIImageView! = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBoard()
        createTapListener()
    
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
        
        test_king = UIImageView(image: UIImage(named: "black_king"))
        test_king.frame = createFrame(boardCoords: CGPoint(x: 7, y: 7))
        
        addSubview(test_king)
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
    
    func createTapListener() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(processTap))
        addGestureRecognizer(tap)
    }
    
    @objc func processTap(_ gesture: UITapGestureRecognizer){
        print("TAPPED BIATCH")
        let location = gesture.location(in: self)
        let x = Int(location.x / squareSize.width)
        let y = Int(location.y / squareSize.height)
        print("\(x), \(y)")
        if delegate == nil {
            print("NO DELEGATE FUND")
        }
        delegate?.handleTap(row: y, col: x, location: location )
        UIView.animate(withDuration: 0.25, animations: {
            print("HSOULD BE ANIMATING")
            let newFrame = self.createFrame(boardCoords: CGPoint(x: x, y: y))
            self.test_king.frame = newFrame
            print("HSOULD BE ANIMATING")
        }, completion: nil )
    }
    
    func showPieceArrangement(newArrangement: [[PieceKeys?]]) {
        for row in 0..<8 {
            for col in 0..<8 {
                if let pieceKey = newArrangement[row][col] {
                    print("Found my king --> \(pieceKey)")
                    let piece = PieceFuncs.getPiece(key: pieceKey)
                    print("Found piece --? \(piece)")
                    let pieceImage = UIImage(named: piece.image)
                    let pieceFrame = createFrame(boardCoords: CGPoint(x: col, y: row))
                    print("frame --> \(pieceFrame)")
                    let imageView = UIImageView(frame: pieceFrame)
                    imageView.image = pieceImage
                    addSubview(imageView)
                }
            }
        }
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
