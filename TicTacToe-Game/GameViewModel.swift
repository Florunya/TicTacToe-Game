//
//  GameViewModel.swift
//  TicTacToe-Game
//
//  Created by Флора Гарифуллина on 07.05.2023.
//

import SwiftUI

final class GameViewModel: ObservableObject {

    let colums = [GridItem(.flexible()),
                  GridItem(.flexible()),
                  GridItem(.flexible())]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameboardDisabled = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(for positions: Int) {
        if isCircleOccupated(in: moves, forIndex: positions) {return}
        moves[positions] = Move(player: .human, boardIndex: positions)
        
        //check for win conditions or draw
        if checkWinPossition(for: .human, in: moves) {
            alertItem = AlertContext.humanWin
            return
        }
        
        if checkForDraw(in: moves){
            alertItem = AlertContext.draw
            return
        }
        isGameboardDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){ [self] in
            let computerPosition = determineComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            isGameboardDisabled = false
            
            //check for win conditions or draw
            if checkWinPossition(for: .computer, in: moves) {
                alertItem = AlertContext.computerWin
                return
            }
            if checkForDraw(in: moves){
                alertItem = AlertContext.draw
                return
            }
        }
    }
    
    //MARK: this function check a circle if they alredy mark
    func isCircleOccupated(in moves: [Move?], forIndex index: Int) -> Bool{
        return moves.contains(where: {$0?.boardIndex == index})
    }
    //MARK: simple ai move
    func determineComputerMovePosition(in move: [Move?]) -> Int{
        
        // If AI can win, then win
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let computerMoves = moves.compactMap { $0}.filter{ $0.player == .computer}
        let computerPositions = Set(computerMoves.map{ $0.boardIndex})
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            
            if winPositions.count == 1 {
                let isAvaible = !isCircleOccupated(in: moves, forIndex: winPositions.first!)
                if isAvaible { return winPositions.first!}
            }
        }
        
        // If AI can't win, then block
        let humanMoves = moves.compactMap { $0}.filter{ $0.player == .human}
        let humanPositions = Set(humanMoves.map{ $0.boardIndex})
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            
            if winPositions.count == 1 {
                let isAvaible = !isCircleOccupated(in: moves, forIndex: winPositions.first!)
                if isAvaible { return winPositions.first!}
            }
        }
        
        // If AI can't block, then take middle square
        let centerCircle = 4
        if !isCircleOccupated(in: moves, forIndex: centerCircle) { return centerCircle}
        
        
        //If AI can't take middle square, take random available square
        var movePosition = Int.random(in: 0..<9)
        
        while isCircleOccupated(in: moves, forIndex: movePosition){
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
    
    func checkWinPossition(for player: Player, in moves: [Move?]) -> Bool {

        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let playerMoves = moves.compactMap { $0}.filter{ $0.player == player}
        let playerPositions = Set(playerMoves.map{ $0.boardIndex})
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions){ return true}

        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool{
        return moves.compactMap{ $0 }.count == 9
    }
    
    func resetGame(){
        moves = Array(repeating: nil, count: 9)
    }
}
