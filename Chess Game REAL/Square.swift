//
//  Square.swift
//  Chess Game REAL
//
//  Created by Josh Davis on 1/18/21.
//

import UIKit

enum Colors {
    case white, black
}


class Square: UIView {
    
    var color: Colors?
    var piece: PieceKeys? = nil
    var boardCoords: PieceCoords?
    
    convenience init(color: Colors, boardCoords: PieceCoords) {
        self.init(frame: .zero)
        self.color = color
        showSquareColor()
        self.boardCoords = boardCoords
        translatesAutoresizingMaskIntoConstraints = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func showSquareColor() {
        backgroundColor = color == .white ? .white : .darkGray
    }
    
    func showHint() {
        backgroundColor = .green
    }
    
    func showAsStartingPosition() {
        backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
