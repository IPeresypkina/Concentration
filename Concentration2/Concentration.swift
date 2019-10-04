//
//  Concentration.swift
//  Concentration2
//
//  Created by Ирина Пересыпкина on 17/09/2019.
//  Copyright © 2019 Ирина Пересыпкина. All rights reserved.
//

import Foundation

extension Collection {
    var oneAndOnly: Element?{
        return count == 1 ? first : nil
    }
}

struct Concentration
{
    //Переменная ​cards​ должна быть ​public​, потому что в противном случае мы не сможем показывать на ​UI ​наши карты.
    /*
     Тем не менее переворот карт, определение того, совпадают ли две карты - это моя работа, работа ​М​одели, поэтому я устанавливаю для ​cards​ доступ ​private (set)​. Да, вы можете смотреть на мои карты ​cards​ и использовать их в игре ​Concentration​, но я буду ответственным за установку их свойств ​isFaceUp​ и ​isMatched.​ Вы видите здесь пример очень точного использования доступа ​private (set)​.
     */
    private (set) var cards = [Card]()
    private(set) var matches = 0
    private(set) var score = 0
    private var startTime: Date?
    private var elapsedTime: TimeInterval?
    
    //переменная, которая будет отслеживать ситуацию, когда лежит “лицевой” стороной вверх ОДНА и ТОЛЬКО ОДНА карта
    //переменная​ indexOfTheOneAndOnlyFaceUpCard​ является вычисляемым свойством, которое рассчитывается исходя из свойства ​cards​.
    //нам совсем не нужно, чтобы кто-то знал об этой вычисляемой переменной
    
    private var indexOfFaceUpCard: Int? {
        get {
            let faceUpCardIndices = cards.indices.filter { cards[$0].isFaceUp }
            return faceUpCardIndices.count == 1 ? faceUpCardIndices.first : nil
        } set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): Chosen index out of range.")
        if !cards[index].isMatched {
            if let matchIndex = indexOfFaceUpCard, matchIndex != index {
                stoppTime()
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    matches += 1
                    score += 2
                    if elapsedTime != nil {
                        if elapsedTime! < 0.75 {
                            score += 2
                            //                            print("timeBonus: 2")
                        } else if elapsedTime! < 1.0 {
                            score += 1
                            //                            print("timeBonus: 1")
                        }
                    }
                } else if cards[index].flipCount > 0 || cards[matchIndex].flipCount > 0 {
                    if elapsedTime != nil {
                        if elapsedTime! > 2.25 {
                            score -= 2
                            //                            print("score deduction: -2")
                        }
                    }
                    score -= 1
                }
                cards[index].isFaceUp = true
                cards[index].flipCount += 1
                cards[matchIndex].flipCount += 1
            } else {
                indexOfFaceUpCard = index
            }
        }
        let numberOfFaceUpCards = cards.indices.filter { cards[$0].isFaceUp }.count
        if numberOfFaceUpCards == 1 {
            startTime = Date()
            //            let dateFormatter = DateFormatter()
            //            dateFormatter.dateStyle = .none
            //            dateFormatter.timeStyle = .medium
            //            dateFormatter.string(from: startTime!)
            //            print("Start: \(dateFormatter.string(from: startTime!))")
        } else {
            elapsedTime = nil
        }
    }
    
    /*
     mutating func chooseCard(at index: Int) {
     //если кто-то вызовет этот метод ​ наприемр chooseCard (at: -1)​ то наше приложение завершится аварийно а на консоле высветится сообщение прописанное в  assert
     assert(cards.indices.contains(index), "Concentration.choosesCard(at: \(index)): choosen index not in the cards")
     if !cards[index].isMatched {
     //работа оператора  if let (если matchIndex не nil то выполняем дальше иначе переходим в  else)
     if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
     //проверка если карты совпадают
     if cards[matchIndex] == cards[index] {
     cards[matchIndex].isMatched = true
     cards[index].isMatched = true
     matches += 1
     score += 2
     }
     cards[index].isFaceUp = true
     } else {
     indexOfOneAndOnlyFaceUpCard = index //в этой части выполняется set
     }
     
     }
     }*/
    
    private mutating func stoppTime() {
        if let start = startTime {
            elapsedTime = Date().timeIntervalSince(start)
            //            print("\(Double(elapsedTime!).rounded(by: 3)) sec")
        }
    }
    
    mutating func resetCards() {
        cards.removeAll()
    }
    //наш инициализатор, очевидно, не может быть ​private​, потому что тогда никто не смог бы создать игру game​.
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): You must have at least 1 pair of cards")
        var preShuffledCards = [Card]()
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            preShuffledCards += [card, card]
        }
        for _ in preShuffledCards {
            let randomIndex = preShuffledCards.count.arc4random
            let randomCard = preShuffledCards.remove(at: randomIndex)
            cards.append(randomCard)
            //            print(randomCard)
        }
    }
}
extension Double {
    
    func rounded(by decimalPlaces: Int) -> Double {
        let divisor = pow(10.0, Double(decimalPlaces))
        return (self * divisor).rounded() / divisor
    }
}



