//
//  TileView.swift
//  2048Game
//

import UIKit

class TileView: UIView {
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    var value: Int = 0 {
        didSet {
            updateAppearance()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        layer.cornerRadius = 6
        addSubview(valueLabel)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            valueLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            valueLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9)
        ])
    }
    
    private func updateAppearance() {
        backgroundColor = UIColor.tileColor(for: value)
        valueLabel.textColor = UIColor.textColor(for: value)
        valueLabel.text = value > 0 ? "\(value)" : ""
        
        if value >= 1024 {
            valueLabel.font = UIFont.boldSystemFont(ofSize: 24)
        } else if value >= 128 {
            valueLabel.font = UIFont.boldSystemFont(ofSize: 28)
        } else {
            valueLabel.font = UIFont.boldSystemFont(ofSize: 32)
        }
    }
    
    func appear(animated: Bool = true) {
        if animated {
            transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
                self.transform = .identity
            }
        }
    }
    
    func merge(animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    self.transform = .identity
                }
            }
        }
    }
}
