//
//  MoveManager.swift
//  Chess Game REAL
//
//  Created by Nick Healy on 3/28/21.
//

import Foundation
import Starscream

struct Move: Codable {
    let from: PieceCoords
    let to: PieceCoords
    let isCastle: Bool
//    todo: add turn-based functionality
    let player: String = "self"
//    todo: add timestamp functionality
}

struct Response: Codable {
    let from: PieceCoords
    let to: PieceCoords
    let isCastle: Bool
    let player: String
}

protocol BoardModelDelegate {
    func applyMove(move: Move)
}

class MoveManager: WebSocketDelegate {
    var socket: WebSocket!
    func createMove(piece: SelectedPiece, to: PieceCoords, isCastle: Bool = false) {
        let newMove = Move(from: piece.originalPosition, to: to, isCastle: isCastle)
        makeMove(move: newMove)
    }
    
    init(board: BoardModelDelegate) {
        boardModelDelegate = board
        var request = URLRequest(url: URL(string: "http://localhost:8080")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    private func makeMove(move: Move) {
//        todo, this will have to be some sort of ws thing, this would happen at end of process
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(move)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
            socket.write(data: jsonData)
    
        } catch {
            print("error")
        }
        print()
    }
    
    private func processResponse(response: Data) {
        let jsonDecoder = JSONDecoder()
        
        do {
            let inbound = try jsonDecoder.decode(Move.self, from: response)
//            TODO: create turn based logic
            boardModelDelegate?.applyMove(move: inbound)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .text(let string):
            print("received \(string)")
            processResponse(response: Data(string.utf8))
        case .binary(let data):
            print("received binary \(data)")
        default:
            print("received default")
        }
    }
    
    var boardModelDelegate: BoardModelDelegate?
}
