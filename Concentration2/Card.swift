//
//  Card.swift
//  Concentration2
//
//  Created by Ирина Пересыпкина on 17/09/2019.
//  Copyright © 2019 Ирина Пересыпкина. All rights reserved.
//

import Foundation

struct Card: Hashable
{
    /*
     У​ Card​ определенно свойства ​isFaceUp​ и ​isMatched ​должны быть ​public​, так как нам нужно знать, лежит ли карта “лицевой” стороной вверх и совпала ли ли она уже со своей парной картой.
     К сожалению, и свойство ​identifier​ должно быть p​ ublic​, потому что в противном случае мы не сможем сказать, совпали ли какие-то две карты.
     */
    var hashValue: Int { return identifier }
    var isFaceUp = false //лицом вверх
    var isMatched = false //совпадение
    private var identifier: Int
    var flipCount = 0
    
    //Оба ​static​ элемента нужно сделать ​private
    private static var identifierFactory = 0
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    //Этот метод получает уникальный идентификатор identifier и возвращает его
    //Каждый раз, когда этот метод вызывается, он будет возвращать другой уникальный идентификатор identifier
    //Потому что вся идея с ​identierFactory​ - это исключительно внутренняя реализация, и у нас нет причин сделать ​static​ элементы ​public
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        //print ("identifier \(identifierFactory)")
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
