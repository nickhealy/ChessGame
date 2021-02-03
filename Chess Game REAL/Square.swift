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
        backgroundColor = color == .white ? .white : .darkGray
        self.boardCoords = boardCoords
        translatesAutoresizingMaskIntoConstraints = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
