//
//  ViewController.swift
//  Chess Game REAL
//
//  Created by Josh Davis on 1/16/21.
//

import UIKit

class ViewController: UIViewController {
    
    var boardView: BoardView! = nil
    var boardModel = BoardModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .cyan
        createBoard()
        createTapListener()
    }

    private func createBoard() {
//        creates board frame
        boardView = BoardView()
        boardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boardView)
        
        boardView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10).isActive = true
        boardView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor).isActive = true
        boardView.heightAnchor.constraint(equalTo: boardView.widthAnchor).isActive = true
        boardView.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor).isActive = true
    }
    
    func createTapListener() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(processTap))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }
    
    @objc func processTap(_ gesture: UITapGestureRecognizer){
        let location = gesture.location(in: boardView)
        let x = Int(location.x / boardView.squareSize.width)
        let y = Int(location.y / boardView.squareSize.height)
        print("\(x),\(y)")
    }
}



