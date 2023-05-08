//
//  GameModel.swift
//  TicTacToe-Game
//
//  Created by Флора Гарифуллина on 07.05.2023.
//

import SwiftUI

enum Player {
    case human, computer
}

struct Move {
    var player: Player
    var boardIndex: Int
    
    var indicator: String{
        return player == .human ? "flame" : "drop"
    }
}
