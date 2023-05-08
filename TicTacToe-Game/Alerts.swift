//
//  Alerts.swift
//  TicTacToe-Game
//
//  Created by Флора Гарифуллина on 05.05.2023.
//

import SwiftUI

struct AlertItem: Identifiable{
    var id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You Win!"),
                             message: Text("Computer is upset((("),
                             buttonTitle: Text("Hell yeah!"))
    static let computerWin = AlertItem(title: Text("You Lost!"),
                             message: Text("Computer is happy!"),
                             buttonTitle: Text("Rematch"))
    static let draw = AlertItem(title: Text("Draw!"),
                             message: Text("What a battle..."),
                             buttonTitle: Text("Try Again"))
}
