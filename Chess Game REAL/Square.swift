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
    var boardCoords: CGPoint?
    
    convenience init(color: Colors, boardCoords: CGPoint) {
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
    
//    func renderPiece() {
//        let pieceImage = UIImage(named: piece?.image ?? "default")
//        let pieceImageView = UIImageView(image: pieceImage)
//        addSubview(pieceImageView)
//        
//        pieceImageView.translatesAutoresizingMaskIntoConstraints = false
//        pieceImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        pieceImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        pieceImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
//        pieceImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
//    }
   
}
