//
//  BoardSquareCollectionViewCell.swift
//  Chess Game REAL
//
//  Created by Josh Davis on 1/17/21.
//

import UIKit

class BoardSquareCollectionViewCell: UIView {
    let identifier = "BoardSquare"
    
    var testLabel: UILabel = {
        var test = UILabel()
        return test
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


