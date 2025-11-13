//
//  Extensions.swift
//  2048Game
//

import UIKit

extension UIColor {
    static func tileColor(for value: Int) -> UIColor {
        switch value {
        case 2: return UIColor(red: 238/255, green: 228/255, blue: 218/255, alpha: 1.0)
        case 4: return UIColor(red: 237/255, green: 224/255, blue: 200/255, alpha: 1.0)
        case 8: return UIColor(red: 242/255, green: 177/255, blue: 121/255, alpha: 1.0)
        case 16: return UIColor(red: 245/255, green: 149/255, blue: 99/255, alpha: 1.0)
        case 32: return UIColor(red: 246/255, green: 124/255, blue: 95/255, alpha: 1.0)
        case 64: return UIColor(red: 246/255, green: 94/255, blue: 59/255, alpha: 1.0)
        case 128: return UIColor(red: 237/255, green: 207/255, blue: 114/255, alpha: 1.0)
        case 256: return UIColor(red: 237/255, green: 204/255, blue: 97/255, alpha: 1.0)
        case 512: return UIColor(red: 237/255, green: 200/255, blue: 80/255, alpha: 1.0)
        case 1024: return UIColor(red: 237/255, green: 197/255, blue: 63/255, alpha: 1.0)
        case 2048: return UIColor(red: 237/255, green: 194/255, blue: 46/255, alpha: 1.0)
        default: return UIColor(red: 205/255, green: 193/255, blue: 180/255, alpha: 1.0)
        }
    }
    
    static func textColor(for value: Int) -> UIColor {
        return value <= 4 ? UIColor(red: 119/255, green: 110/255, blue: 101/255, alpha: 1.0) : .white
    }
    
    static var boardBackground: UIColor {
        return UIColor(red: 187/255, green: 173/255, blue: 160/255, alpha: 1.0)
    }
    
    static var emptyTile: UIColor {
        return UIColor(red: 205/255, green: 193/255, blue: 180/255, alpha: 0.35)
    }
}

extension UserDefaults {
    private static let bestScoreKey = "bestScore"
    
    var bestScore: Int {
        get {
            return integer(forKey: UserDefaults.bestScoreKey)
        }
        set {
            set(newValue, forKey: UserDefaults.bestScoreKey)
        }
    }
}
