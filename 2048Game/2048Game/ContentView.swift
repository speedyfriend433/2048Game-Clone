//
//  ContentView.swift
//  2048Game
//
//  Created by 이지안 on 11/14/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GameViewControllerRepresentable()
            .ignoresSafeArea()
    }
}

struct GameViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> GameViewController {
        return GameViewController()
    }
    
    func updateUIViewController(_ uiViewController: GameViewController, context: Context) {
        // nothing in here lmao
    }
}

#Preview {
    ContentView()
}
