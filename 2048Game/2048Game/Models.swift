//
//  Models.swift
//  2048Game
//

import Foundation
import UIKit

struct Tile: Equatable {
    var value: Int
    var position: Position
    var isNew: Bool = false
    var isMerged: Bool = false
    let id: UUID = UUID()
    
    static func == (lhs: Tile, rhs: Tile) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Position: Equatable, Hashable {
    var row: Int
    var col: Int
    
    static func == (lhs: Position, rhs: Position) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(col)
    }
}

enum Direction {
    case up, down, left, right
}

struct GameState {
    var score: Int = 0
    var bestScore: Int = 0
    var isGameOver: Bool = false
    var hasWon: Bool = false
}
