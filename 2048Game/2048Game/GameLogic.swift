//
//  GameLogic.swift
//  2048Game
//

import Foundation

class GameLogic {
    private let gridSize: Int
    private(set) var tiles: [Tile] = []
    private(set) var gameState = GameState()
    var hasShownWinMessage = false
    
    struct MoveResult {
        var moved: Bool = false
        var movedTiles: [(Position, Position)] = []
        var mergedTiles: [Position] = []
    }
    
    init(gridSize: Int) {
        self.gridSize = gridSize
        gameState.bestScore = UserDefaults.standard.bestScore
        resetGame()
    }
    
    func resetGame() {
        tiles.removeAll()
        gameState.score = 0
        gameState.isGameOver = false
        gameState.hasWon = false
        hasShownWinMessage = false
        addRandomTile()
        addRandomTile()
    }
    
    func move(direction: Direction) -> MoveResult {
        var result = MoveResult()
        var grid = createGrid()
        var merged: Set<Position> = []
        
        let traversals = buildTraversals(direction: direction)
        
        for row in traversals.rows {
            for col in traversals.cols {
                let position = Position(row: row, col: col)
                guard let tile = grid[row][col] else { continue }
                
                let farthest = findFarthestPosition(from: position, direction: direction, grid: grid)
                let next = getNextPosition(from: farthest, direction: direction)
                
                if let nextTile = getGridTile(at: next, grid: grid),
                   nextTile.value == tile.value,
                   !merged.contains(next) {
                    let mergedValue = tile.value * 2
                    let mergedTile = Tile(value: mergedValue, position: next, isNew: false, isMerged: true)
                    
                    grid[next.row][next.col] = mergedTile
                    grid[position.row][position.col] = nil
                    
                    if let index = tiles.firstIndex(where: { $0.position == next }) {
                        tiles[index] = mergedTile
                    }
                    if let index = tiles.firstIndex(where: { $0.position == position }) {
                        tiles.remove(at: index)
                    }
                    
                    merged.insert(next)
                    result.mergedTiles.append(position)
                    result.moved = true
                    
                    gameState.score += mergedValue
                    if mergedValue == 2048 {
                        gameState.hasWon = true
                    }
                } else {
                    if farthest != position {
                        grid[farthest.row][farthest.col] = Tile(value: tile.value, position: farthest)
                        grid[position.row][position.col] = nil
                        
                        if let index = tiles.firstIndex(where: { $0.position == position }) {
                            tiles[index].position = farthest
                        }
                        
                        result.movedTiles.append((position, farthest))
                        result.moved = true
                    }
                }
            }
        }
        
        if result.moved {
            addRandomTile()
            
            if gameState.score > gameState.bestScore {
                gameState.bestScore = gameState.score
                UserDefaults.standard.bestScore = gameState.bestScore
            }
            
            if !canMove() {
                gameState.isGameOver = true
            }
        }
        
        return result
    }
    
    func clearFlags() {
        for index in tiles.indices {
            tiles[index].isNew = false
            tiles[index].isMerged = false
        }
    }
    
    private func addRandomTile() {
        let emptyPositions = getEmptyPositions()
        guard !emptyPositions.isEmpty else { return }
        
        let randomPosition = emptyPositions.randomElement()!
        let value = Double.random(in: 0...1) < 0.9 ? 2 : 4
        let tile = Tile(value: value, position: randomPosition, isNew: true)
        tiles.append(tile)
    }
    
    private func getEmptyPositions() -> [Position] {
        var positions: [Position] = []
        let occupiedPositions = Set(tiles.map { $0.position })
        
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let position = Position(row: row, col: col)
                if !occupiedPositions.contains(position) {
                    positions.append(position)
                }
            }
        }
        return positions
    }
    
    private func createGrid() -> [[Tile?]] {
        var grid: [[Tile?]] = Array(repeating: Array(repeating: nil, count: gridSize), count: gridSize)
        for tile in tiles {
            grid[tile.position.row][tile.position.col] = tile
        }
        return grid
    }
    
    private func buildTraversals(direction: Direction) -> (rows: [Int], cols: [Int]) {
        let rows = Array(0..<gridSize)
        let cols = Array(0..<gridSize)
        
        switch direction {
        case .up:
            return (rows, cols)
        case .down:
            return (rows.reversed(), cols)
        case .left:
            return (rows, cols)
        case .right:
            return (rows, cols.reversed())
        }
    }
    
    private func findFarthestPosition(from position: Position, direction: Direction, grid: [[Tile?]]) -> Position {
        var previous = position
        var next = getNextPosition(from: position, direction: direction)
        
        while isValidPosition(next) && grid[next.row][next.col] == nil {
            previous = next
            next = getNextPosition(from: next, direction: direction)
        }
        
        return previous
    }
    
    private func getNextPosition(from position: Position, direction: Direction) -> Position {
        switch direction {
        case .up:
            return Position(row: position.row - 1, col: position.col)
        case .down:
            return Position(row: position.row + 1, col: position.col)
        case .left:
            return Position(row: position.row, col: position.col - 1)
        case .right:
            return Position(row: position.row, col: position.col + 1)
        }
    }
    
    private func isValidPosition(_ position: Position) -> Bool {
        return position.row >= 0 && position.row < gridSize &&
               position.col >= 0 && position.col < gridSize
    }
    
    private func getGridTile(at position: Position, grid: [[Tile?]]) -> Tile? {
        guard isValidPosition(position) else { return nil }
        return grid[position.row][position.col]
    }
    
    private func canMove() -> Bool {
        if !getEmptyPositions().isEmpty {
            return true
        }
        
        let grid = createGrid()
        
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                guard let tile = grid[row][col] else { continue }
                
                let directions: [Direction] = [.up, .down, .left, .right]
                for direction in directions {
                    let next = getNextPosition(from: tile.position, direction: direction)
                    if let nextTile = getGridTile(at: next, grid: grid),
                       nextTile.value == tile.value {
                        return true
                    }
                }
            }
        }
        
        return false
    }
}
