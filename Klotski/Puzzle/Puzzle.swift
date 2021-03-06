//
//  Puzzle.swift
//  Klotski
//
//  Created by Alina Ene on 30/04/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//
import Foundation

final class Puzzle {
    
    let dataManager = DataManager()
    
    private var types: [[PieceType]] = Array(repeating: Array(repeating: .none, count: 4), count: 5)
    private var boards: [[Int]] = Array(repeating: Array(repeating: -1, count: 4), count: 5)
    private var layoutWasVisited: [String: Bool] = [:]
    private var st: [String: Int] = [:]
    private var ts: [Int: String] = [:]
    private var boardCodes: [Int: String] = [:]
    private var parents: [Int] = Array(repeating: 0, count: 30000)
    private var queue: [String] = []
    private var stringQueue = Queue<String>()
    private var layoutsVisitedCount: Int = 0
    private var code: String = ""
    private var pieces: [Piece] = []
    var backtrackCoords: [[Coordinates]] = []
    
    func initBoard() {
        code = ""
        pieces = dataManager.pieces
        for piece in pieces {
            setCoordinates(piece: piece)
        }
    }
    
    private func setCoordinates(piece: Piece) {
        let y = piece.coord.y
        let x = piece.coord.x
        let w = piece.size.w
        let h = piece.size.h
        for i in y..<(y + h) {
            for j in x..<(x + w) {
                if i < dataManager.boardHeight && j < dataManager.boardWidth {
                    types[i][j] = piece.type
                    boards[i][j] = piece.id
                }
            }
        }
    }
    
    func encode() {
        code = ""
        for i in 0..<dataManager.boardHeight {
            for j in 0..<dataManager.boardWidth {
                code.append("\(types[i][j].rawValue)")
                code.append(boards[i][j] < 0 ? "0" : "\(boards[i][j])")
            }
        }
    }
    
    func currentStateCodeFrom(_ stringValue: String) -> String {
        var code = ""
        for (index, char) in stringValue.enumerated() {
            if index % 2 == 0 {
                code.append(char)
            }
        }
        return code
    }
    
    func setCurrentBoardFrom(_ string: String) {
        var stateCode = currentStateCodeFrom(string)
        types = Array(repeating: Array(repeating: .none, count: 4), count: 5)
        boards = Array(repeating: Array(repeating: -1, count: 4), count: 5)
        
        var b = 0
        var c = 0
        for i in 0..<dataManager.boardHeight {
            for j in 0..<dataManager.boardWidth {
                var size: Size?
                switch stateCode[c] {
                case "1":
                    size = dataManager.size11
                case "2":
                    size = dataManager.size12
                    stateCode = stateCode.replaceString(at: c + 4, with: "@")
                case "3":
                    size = dataManager.size21
                    stateCode = stateCode.replaceString(at: c + 1, with: "@")
                case "4":
                    size = dataManager.size22
                    stateCode = stateCode.replaceString(at: c + 1, with: "@").replaceString(at: c + 4, with: "@").replaceString(at: c + 5, with: "@")
                default:
                    break
                }
                if let s = size {
                    pieces[b] = Piece(id: Int(string[2 * c + 1])!, size: s, coord: Coordinates(x: j, y: i))
                    setCoordinates(piece: pieces[b])
                    b += 1
                }
                c += 1
            }
        }
    }
    
    private var didFinishTraversal: Bool {
        return (types[3][1] == types[3][2] && types[3][2] == types[4][1] &&
            types[4][1] == types[4][2] && types[4][1] == .bigSquare)
    }
    
    func updateCurrent(subLayout: String, currentLayout: String) {
        stringQueue.enqueue(subLayout)
        layoutWasVisited[subLayout] = true
        ts[layoutsVisitedCount] = subLayout
        boardCodes[layoutsVisitedCount] = code
        st[subLayout] = layoutsVisitedCount
        layoutsVisitedCount += 1
        parents[st[subLayout]!] = st[currentLayout]!
    }
    
    private func move(piece: Piece, currentLayout: String, direction: Direction, and completion: (String) -> ()) -> Bool {
        
        if !go(direction: direction, for: piece) {
            return false
        }
        encode()
        let stateLayout = currentStateCodeFrom(code)
        if layoutWasVisited[stateLayout] == nil {
            updateCurrent(subLayout: stateLayout, currentLayout: currentLayout)
            print(stateLayout)
            if didFinishTraversal {
                completion(stateLayout)
                return true
            }
        }
        switch direction {
        case .left:
            go(direction: .right, for: piece)
        case .right:
            go(direction: .left, for: piece)
        case .up:
            go(direction: .down, for: piece)
        case .down:
            go(direction: .up, for: piece)
        }
        return false
    }
    
    @discardableResult
    private func go(direction: Direction, for piece: Piece) -> Bool {
        if !canGo(direction, for: piece) { return false }
        
        let y = piece.coord.y
        let x = piece.coord.x
        let w = piece.size.w
        let h = piece.size.h
        switch direction {
        case .up:
            
            types[y + h - 1][x] = .none
            types[y + h - 1][x + w - 1] = .none
            boards[y + h - 1][x] = -1
            boards[y + h - 1][x + w - 1] = -1
            types[y - 1][x] = piece.type
            types[y - 1][x + w - 1] = piece.type
            boards[y - 1][x] = piece.id
            boards[y - 1][x + w - 1] = piece.id
            piece.coord.y -= 1
            
        case .down:
            
            types[y][x] = .none
            types[y][x + w - 1] = .none
            boards[y][x] = -1
            boards[y][x + w - 1] = -1
            types[y + h][x] = piece.type
            types[y + h][x + w - 1] = piece.type
            boards[y + h][x] = piece.id
            boards[y + h][x + w - 1] = piece.id
            piece.coord.y += 1
            
        case .left:
            
            types[y][x + w - 1] = .none
            types[y + h - 1][x + w - 1] = .none
            boards[y][x + w - 1] = -1
            boards[y + h - 1][x + w - 1] = -1
            types[y][x - 1] = piece.type
            types[y + h - 1][x - 1] = piece.type
            boards[y][x - 1] = piece.id
            boards[y + h - 1][x - 1] = piece.id
            piece.coord.x -= 1
            
        case .right:
            types[y][x] = .none
            types[y + h - 1][x] = .none
            boards[y][x] = -1
            boards[y + h - 1][x] = -1
            types[y][x + w] = piece.type
            types[y + h - 1][x + w] = piece.type
            boards[y][x + w] = piece.id
            boards[y + h - 1][x + w] = piece.id
            piece.coord.x += 1
        }
        return true
    }
    
    private func canGo(_ direction: Direction, for piece: Piece) -> Bool {
        let y = piece.coord.y
        let x = piece.coord.x
        let w = piece.size.w
        let h = piece.size.h
        
        switch direction {
        case .down:
            if y + h == dataManager.boardHeight {
                return false
            }
            if types[y + h][x] == .none && types[y + h][x + w - 1] == .none {
                return true
            }
        case .up:
            if y == 0 {
                return false
            }
            if types[y - 1][x] == .none && types[y - 1][x + w - 1] == .none {
                return true
            }
        case .left:
            if x == 0 {
                return false
            }
            if types[y][x - 1] == .none && types[y + h - 1][x - 1] == .none {
                return true
            }
        case .right:
            if x + w == dataManager.boardWidth {
                return false
            }
            if types[y][x + w] == .none && types[y + h - 1][x + w] == .none {
                return true
            }
        }
        return false
    }
    
    func search(and completion: (String) -> ()) {
        types = Array(repeating: Array(repeating: .none, count: 4), count: 5)
        boards = Array(repeating: Array(repeating: -1, count: 4), count: 5)
        initBoard()
        while !stringQueue.isEmpty {
            stringQueue.dequeue()
        }
        backtrackCoords.removeAll()
        ts.removeAll()
        boardCodes.removeAll()
        layoutWasVisited.removeAll()
        st.removeAll()
        layoutsVisitedCount = 0
        parents = Array(repeating: 0, count: 30000)
        
        encode()
        
        let stateCode = currentStateCodeFrom(code)
        stringQueue.enqueue(stateCode)
        layoutWasVisited[stateCode] = true
        ts[layoutsVisitedCount] = stateCode
        boardCodes[layoutsVisitedCount] = code
        
        st[stateCode] = layoutsVisitedCount
        layoutsVisitedCount += 1
        parents[0] = 0
        
        while !stringQueue.isEmpty {
            
            if let currentLayout = stringQueue.dequeue() {
                setCurrentBoardFrom(boardCodes[st[currentLayout]!]!)
                encode()
                
                for piece in pieces {
                    
                    if move(piece: piece, currentLayout: currentLayout, direction: .up, and: completion) {
                        return
                    }
                    if move(piece: piece, currentLayout: currentLayout, direction: .down, and: completion) {
                        return
                    }
                    if move(piece: piece, currentLayout: currentLayout, direction: .left, and: completion) {
                        return
                    }
                    if move(piece: piece, currentLayout: currentLayout, direction: .right, and: completion) {
                        return
                    }
                }
            }
        }
    }
    
    private func decode(string: String) {
        var fooArr = Array(repeating: dataManager.cNone, count: 10)
        for index in 0..<string.count {
            if index % 2 == 0 {
                let cursor = Int(string[index + 1])!
                if string[index] != "0" && fooArr[cursor] == dataManager.cNone {
                    let x = (index / 2) % 4
                    fooArr[cursor] = Coordinates(x: x, y: (index / 2 - x) / 4)
                }
            }
        }
        backtrackCoords.append(fooArr)
    }
    
    @discardableResult
    func recursivelyDecode(layout: String) -> [[Coordinates]] {
        if st[layout] == 0 {
            decode(string: boardCodes[st[layout]!]!)
            backtrackCoords = backtrackCoords.reversed()
            return backtrackCoords
        }
        decode(string: boardCodes[st[layout]!]!)
        recursivelyDecode(layout: ts[parents[st[layout]!]]!)
        return []
    }
}
