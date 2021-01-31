//
//  PieceImage.swift
//  Chess Game REAL
//
//  Created by Josh Davis on 1/29/21.
//

import UIKit

struct PieceCoords {
    var row: Int
    var col: Int
}
protocol PieceImageDelegate {
    func didTouchPiece(pieceCoords: PieceCoords)
    func isMovingPiece(pieceCoods: PieceCoords)
    func didDropPiece(pieceCoords: PieceCoords)
}

class PieceImage: UIImageView {
    var coords: PieceCoords?
    private var offsetX: CGFloat = 0.0
    private var offsetY: CGFloat = 0.0
    
    
    var pieceImageDelegate: PieceImageDelegate?
    
    init(color: Colors, name: PieceNames) {
        let pieceImage = UIImage(named: "\(color)_\(name)")
        super.init(image: pieceImage)
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = getPointFromTouch(touch: touch)
            offsetX = point.x - self.center.x
            offsetY = point.y - self.center.y
        }
        
        guard let coords = self.coords else {
            return
        }
        pieceImageDelegate?.didTouchPiece(pieceCoords: coords)
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = getPointFromTouch(touch: touch)
            self.center = CGPoint(x: point.x - self.offsetX, y: point.y - self.offsetY)
        }
//        todo: make this work so it gets passsed a location instead
//        pieceImageDelegate?.isMovingPiece(pieceCoods: coords)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchesMoved(touches, with: event)
//        todo: make this work so it gets passed a location as well
//        pieceImageDelegate?.didDropPiece(pieceCoords: self.coords)
    }
    
    func getPointFromTouch(touch: UITouch) -> CGPoint {
        let point = touch.location(in: self.superview)
        return point
    }
    
    func saveNewCoords(coords: PieceCoords) {
        self.coords = coords
    }
    
    
    
}
