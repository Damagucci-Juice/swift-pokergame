//
//  Playable.swift
//  PokerGameApp
//
//  Created by YEONGJIN JANG on 2022/02/28.
//

import Foundation

protocol Playable {
    //TODO: 프로토콜에선 private 선언을 못하는 이유?
    func addCard(deck: CardDeck, round: Int) -> Card
    func showUpCards() -> String
    func openAllCards() -> String
}