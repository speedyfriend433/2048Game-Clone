//
//  GameBoard.swift
//  2048Game
//

import UIKit

protocol GameBoardDelegate: AnyObject {
    func didUpdateScore(_ score: Int)
    func didUpdateBestScore(_ bestScore: Int)
    func didWinGame()
    func didLoseGame()
}

class GameBoard: UIView {
    private let gridSize = 4
    private let spacing: CGFloat = 10
    private var tileViews: [Position: TileView] = [:]
    private var emptyTileViews: [[UIView]] = []
    
    weak var delegate: GameBoardDelegate?
    var gameLogic: GameLogic!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        gameLogic = GameLogic(gridSize: gridSize)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        gameLogic = GameLogic(gridSize: gridSize)
    }
    
    private func setupView() {
        backgroundColor = .boardBackground
        layer.cornerRadius = 6
        setupEmptyTiles()
    }
    
    private func setupEmptyTiles() {
        for row in 0..<gridSize {
            var rowViews: [UIView] = []
            for col in 0..<gridSize {
                let emptyTile = UIView()
                emptyTile.backgroundColor = .emptyTile
                emptyTile.layer.cornerRadius = 6
                addSubview(emptyTile)
                rowViews.append(emptyTile)
            }
            emptyTileViews.append(rowViews)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let totalSpacing = spacing * CGFloat(gridSize + 1)
        let tileSize = (bounds.width - totalSpacing) / CGFloat(gridSize)
        
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let x = spacing + CGFloat(col) * (tileSize + spacing)
                let y = spacing + CGFloat(row) * (tileSize + spacing)
                emptyTileViews[row][col].frame = CGRect(x: x, y: y, width: tileSize, height: tileSize)
            }
        }
        
        for (position, tileView) in tileViews {
            tileView.frame = frameForTile(at: position, tileSize: tileSize)
        }
    }
    
    private func frameForTile(at position: Position, tileSize: CGFloat) -> CGRect {
        let x = spacing + CGFloat(position.col) * (tileSize + spacing)
        let y = spacing + CGFloat(position.row) * (tileSize + spacing)
        return CGRect(x: x, y: y, width: tileSize, height: tileSize)
    }
    
    func startNewGame() {
        tileViews.values.forEach { $0.removeFromSuperview() }
        tileViews.removeAll()
        
        gameLogic.resetGame()
        
        for tile in gameLogic.tiles {
            addTileView(for: tile, animated: true)
        }
        
        updateScores()
    }
    
    func move(direction: Direction) {
        let result = gameLogic.move(direction: direction)
        
        if !result.moved {
            return
        }
        
        animateMove(result: result)
    }
    
    private func animateMove(result: GameLogic.MoveResult) {
        let totalSpacing = spacing * CGFloat(gridSize + 1)
        let tileSize = (bounds.width - totalSpacing) / CGFloat(gridSize)
        
        UIView.animate(withDuration: 0.15, animations: {
            for (oldPos, newPos) in result.movedTiles {
                if let tileView = self.tileViews[oldPos] {
                    tileView.frame = self.frameForTile(at: newPos, tileSize: tileSize)
                }
            }
        }) { _ in
            for (oldPos, newPos) in result.movedTiles {
                if let tileView = self.tileViews.removeValue(forKey: oldPos) {
                    self.tileViews[newPos] = tileView
                }
            }
            
            for position in result.mergedTiles {
                if let tileView = self.tileViews.removeValue(forKey: position) {
                    UIView.animate(withDuration: 0.1, animations: {
                        tileView.alpha = 0
                        tileView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    }) { _ in
                        tileView.removeFromSuperview()
                    }
                }
            }
            
            for tile in self.gameLogic.tiles where tile.isMerged {
                if let tileView = self.tileViews[tile.position] {
                    tileView.value = tile.value
                    tileView.merge(animated: true)
                }
            }
            
            for tile in self.gameLogic.tiles where tile.isNew {
                self.addTileView(for: tile, animated: true)
            }
            
            self.gameLogic.clearFlags()
            self.updateScores()
            self.checkGameState()
        }
    }
    
    private func addTileView(for tile: Tile, animated: Bool) {
        let totalSpacing = spacing * CGFloat(gridSize + 1)
        let tileSize = (bounds.width - totalSpacing) / CGFloat(gridSize)
        
        let tileView = TileView(frame: frameForTile(at: tile.position, tileSize: tileSize))
        tileView.value = tile.value
        addSubview(tileView)
        tileViews[tile.position] = tileView
        
        if animated {
            tileView.appear(animated: true)
        }
    }
    
    private func updateScores() {
        delegate?.didUpdateScore(gameLogic.gameState.score)
        delegate?.didUpdateBestScore(gameLogic.gameState.bestScore)
    }
    
    private func checkGameState() {
        if gameLogic.gameState.hasWon && !gameLogic.hasShownWinMessage {
            gameLogic.hasShownWinMessage = true
            delegate?.didWinGame()
        }
        
        if gameLogic.gameState.isGameOver {
            delegate?.didLoseGame()
        }
    }
}
