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
    var piece: Piece? = nil
    var boardCoords: CGPoint?
    
    convenience init(color: Colors, boardCoords: CGPoint) {
        self.init(frame: .zero)
        self.color = color
        backgroundColor = color == .white ? .white : .black
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
