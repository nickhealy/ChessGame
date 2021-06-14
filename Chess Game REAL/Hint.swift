//
//  Hint.swift
//  Chess Game REAL
//
//  Created by Josh Davis on 4/19/21.
//

import UIKit

enum HintType {
    case possibleMove, startingPosition
}

class Hint: UIView {
    var _hint: UIView?
    
    convenience init(frame: CGRect, type: HintType) {
        self.init(frame: frame)
        renderHint(type: type)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _hint = UIView(frame: frame)
    }
    
    private func renderHint(type: HintType) {
        guard let hint = _hint else { return }
        hint.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hint)
        hint.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        hint.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        hint.topAnchor.constraint(equalTo: topAnchor, constant: frame.height / 4).isActive = true
        hint.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.width / 4).isActive = true
        hint.layer.cornerRadius = hint.frame.width / 4
        hint.layer.masksToBounds = true
        
        hint.backgroundColor = type == HintType.possibleMove ? .green : .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
