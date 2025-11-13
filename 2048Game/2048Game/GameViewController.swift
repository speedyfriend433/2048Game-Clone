//
//  GameViewController.swift
//  2048Game
//

import UIKit

class GameViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "2048"
        label.font = UIFont.boldSystemFont(ofSize: 48)
        label.textColor = UIColor(red: 119/255, green: 110/255, blue: 101/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scoreContainerView = UIView()
    private let bestScoreContainerView = UIView()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "SCORE"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = UIColor(red: 238/255, green: 228/255, blue: 218/255, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    private let scoreValueLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let bestScoreLabel: UILabel = {
        let label = UILabel()
        label.text = "BEST"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = UIColor(red: 238/255, green: 228/255, blue: 218/255, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    private let bestScoreValueLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let newGameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("New Game", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor(red: 143/255, green: 122/255, blue: 102/255, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let gameBoard: GameBoard = {
        let board = GameBoard()
        board.translatesAutoresizingMaskIntoConstraints = false
        return board
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestures()
        gameBoard.delegate = self
        gameBoard.startNewGame()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 250/255, green: 248/255, blue: 239/255, alpha: 1.0)
        view.addSubview(titleLabel)
        
        setupScoreContainer(scoreContainerView, label: scoreLabel, valueLabel: scoreValueLabel)
        setupScoreContainer(bestScoreContainerView, label: bestScoreLabel, valueLabel: bestScoreValueLabel)
        
        view.addSubview(scoreContainerView)
        view.addSubview(bestScoreContainerView)
        view.addSubview(newGameButton)
        newGameButton.addTarget(self, action: #selector(newGameTapped), for: .touchUpInside)
        
        view.addSubview(gameBoard)
        
        setupConstraints()
    }
    
    private func setupScoreContainer(_ container: UIView, label: UILabel, valueLabel: UILabel) {
        container.backgroundColor = UIColor(red: 187/255, green: 173/255, blue: 160/255, alpha: 1.0)
        container.layer.cornerRadius = 6
        container.translatesAutoresizingMaskIntoConstraints = false
        
        label.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(label)
        container.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 2),
            valueLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            bestScoreContainerView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            bestScoreContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bestScoreContainerView.widthAnchor.constraint(equalToConstant: 80),
            
            scoreContainerView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            scoreContainerView.trailingAnchor.constraint(equalTo: bestScoreContainerView.leadingAnchor, constant: -10),
            scoreContainerView.widthAnchor.constraint(equalToConstant: 80),
            
            newGameButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            newGameButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            newGameButton.widthAnchor.constraint(equalToConstant: 120),
            newGameButton.heightAnchor.constraint(equalToConstant: 44),
            
            gameBoard.topAnchor.constraint(equalTo: newGameButton.bottomAnchor, constant: 20),
            gameBoard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            gameBoard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            gameBoard.heightAnchor.constraint(equalTo: gameBoard.widthAnchor)
        ])
    }
    
    private func setupGestures() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        let direction: Direction
        
        switch gesture.direction {
        case .up:
            direction = .up
        case .down:
            direction = .down
        case .left:
            direction = .left
        case .right:
            direction = .right
        default:
            return
        }
        
        gameBoard.move(direction: direction)
    }
    
    @objc private func newGameTapped() {
        let alert = UIAlertController(title: "New Game", message: "Are you sure you want to start a new game?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "New Game", style: .default) { [weak self] _ in
            self?.gameBoard.startNewGame()
        })
        
        present(alert, animated: true)
    }
}

// MARK: - GameBoardDelegate
extension GameViewController: GameBoardDelegate {
    func didUpdateScore(_ score: Int) {
        scoreValueLabel.text = "\(score)"
    }
    
    func didUpdateBestScore(_ bestScore: Int) {
        bestScoreValueLabel.text = "\(bestScore)"
    }
    
    func didWinGame() {
        let alert = UIAlertController(title: "You Win! 🎉", message: "You reached 2048! Continue playing?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Continue", style: .default))
        alert.addAction(UIAlertAction(title: "New Game", style: .default) { [weak self] _ in
            self?.gameBoard.startNewGame()
        })
        
        present(alert, animated: true)
    }
    
    func didLoseGame() {
        let alert = UIAlertController(title: "Game Over", message: "No more moves available!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "New Game", style: .default) { [weak self] _ in
            self?.gameBoard.startNewGame()
        })
        
        present(alert, animated: true)
    }
}
