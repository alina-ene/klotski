//
//  AI.swift
//  Klotski
//
//  Created by Alina Ene on 30/04/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//
import Foundation

final class AI {
    static let shared = AI()
    
    private var types: [[PieceType]] = Array(repeating: Array(repeating: .none, count: 4), count: 5)
    private var boards: [[Int]] = Array(repeating: Array(repeating: -1, count: 4), count: 5)
    private var layoutWasVisited: [String: Bool] = [:]
    
    var st: [String: Int] = [:]
    var ts: [Int: String] = [:]
    
    var boardCodes: [Int: String] = [:]
    var parents: [Int] = Array(repeating: 0, count: 30000)
    var queue: [String] = []
    var stringQueue = Queue<String>()
    var layoutsVisitedCount: Int = 0
    var code: String = ""
    private var pieces: [Piece] = DataManager.shared.pieces
    var backtrackCoords: [[(Int, Int)]] = []
    
    func initBoard() {
        code = ""
        pieces = DataManager.shared.pieces
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
                if i < 5 && j < 4 {
                    types[i][j] = piece.type
                    boards[i][j] = piece.id
                }
            }
        }
    }
    
    func encode() {
        code = ""
        for i in 0..<DataManager.boardHeight {
            for j in 0..<DataManager.boardWidth {
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
    
    func setCurrentBoardFrom(_ stringValue: String) {
        var stateCode = currentStateCodeFrom(stringValue)
        types = Array(repeating: Array(repeating: .none, count: 4), count: 5)
        boards = Array(repeating: Array(repeating: -1, count: 4), count: 5)
        
        var b = 0
        var c = 0
        for i in 0..<DataManager.boardHeight {
            for j in 0..<DataManager.boardWidth {
                var size: (Int, Int)?
                switch stateCode[c] {
                case "1":
                    size = (w: 1, h: 1)
                case "2":
                    size = (w: 1, h: 2)
                    stateCode = stateCode.replace(StringAtIndex: c+4, with: "@")
                case "3":
                    size = (w: 2, h: 1)
                    stateCode = stateCode.replace(StringAtIndex: c+1, with: "@")
                case "4":
                    size = (w: 2, h: 2)
                    stateCode = stateCode.replace(StringAtIndex: c+1, with: "@").replace(StringAtIndex: c+4, with: "@").replace(StringAtIndex: c+5, with: "@")
                default:
                    break
                }
                if let s = size {
                    pieces[b] = Piece(id: Int(stringValue[2*c + 1])!, size: s)
                    pieces[b].coord = (j, i)
                    setCoordinates(piece: pieces[b])
                    b += 1
                }
                c += 1
            }
        }
        
    }
    
    var didFinishTraversal: Bool {
        return (types[3][1].rawValue == types[3][2].rawValue && types[3][2].rawValue == types[4][1].rawValue &&
            types[4][1].rawValue == types[4][2].rawValue && types[4][1] == .bigSquare)
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
    
    func move(piece: Piece, currentLayout: String, direction: Direction, and completion: (String) -> ()) -> Bool {
        
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
    func go(direction: Direction, for piece: Piece) -> Bool {
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
            if y + h == DataManager.boardHeight {
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
            if x + w == DataManager.boardWidth {
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
    
}


extension AI {
    
    func decode(string: String) {
        var fooArr = Array(repeating: (-1, -1), count: 10)
        for index in 0..<string.count {
            
            if index % 2 == 0 {
                
                let cursor = Int(string[index + 1])!
                if string[index] != "0" && fooArr[cursor].0 == -1 && fooArr[cursor].1 == -1 {
                    fooArr[cursor].0 = (index / 2) % 4
                    fooArr[cursor].1 = (index / 2 - fooArr[cursor].0) / 4
                }
            }
        }
        backtrackCoords.append(fooArr)
    }
    
    @discardableResult
    func recursivelyDecode(layout: String) -> [[(Int, Int)]] {
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

extension String {
    
    subscript(idx: Int) -> String {
        guard let strIdx = index(startIndex, offsetBy: idx, limitedBy: endIndex)
            else { fatalError("String index out of bounds") }
        return "\(self[strIdx])"
    }
    
    
    func replace(StringAtIndex: Int, with newChar: Character) -> String {
        var modifiedString = ""
        for (i, char) in self.enumerated() {
            modifiedString += String((i == StringAtIndex) ? newChar : char)
        }
        return modifiedString
    }
    
}
