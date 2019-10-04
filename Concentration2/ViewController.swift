//
//  ViewController.swift
//  Concentration2
//
//  Created by Ирина Пересыпкина on 17/09/2019.
//  Copyright © 2019 Ирина Пересыпкина. All rights reserved.
//


import UIKit
import Foundation
/*
 У нас 3 структуры данных: класс ​ViewController​, структура ​Card​ и класс ​Concentration​. Начнем с ​ViewController​.
 Переменная ​game​ - это наша Модель
 
 Мы хотим, чтобы М​одель была ​private​ из-за того, что при инициализации нашей игры ​game​ используется переменная ​numberOfPairsOfCards​, которая тесно связана с нашим ​UI​, то есть с числом кнопок на нашем ​UI​.
 Если мы хотим сделать игру ​game​ ​public​, то тогда мы должны также сделать ​public​ ​cardButtons​. Это то, что расположено на нашем маленьком экранном фрагменте в​ Interface Builder​, а мы не можем сделать ​cardButtons ​public​. Мы должны держать наш U​I​ ​private
 */


extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self))) }
        else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

class ViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    var numberOfPairsOfCards: Int {
        return cardButtons.count / 2
    }
    private var themeBackgroundColor: UIColor?
    private var themeCardColor: UIColor?
    private var themeCardTitles: [String]?
    private var emoji = [Card: String]()
    
    private let halloweenTheme = Theme.init(backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), cardColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), cardTitles: ["👻", "🎃", "💀", "😈", "😱", "🦇", "🕷", "🤡", "🕸", "🦉"])
    private let happyTheme = Theme.init(backgroundColor: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), cardColor: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), cardTitles: ["🤗", "😍", "🤣", "😁", "🙆", "😘", "🙆‍♂️", "🎉", "😋", "😛"])
    private let sadTheme = Theme.init(backgroundColor: #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), cardColor: #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1), cardTitles: ["😭", "😢", "🙁", "😔", "🤧", "😩", "😨", "☹️", "😐", "😓"])
    private let foodTheme = Theme.init(backgroundColor: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), cardColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), cardTitles: ["🍕", "🍉", "🍔", "🍟", "🍫", "🌭", "🍖", "🌯", "🍗", "🍝"])
    
    @IBOutlet private weak var matchLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private(set) var cardButtons: [UIButton]!
    @IBOutlet private weak var restartButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTheme()
        updateView()
        restartButton.isHidden = true
    }
    
    private func settingTheme() {
        let themes = [halloweenTheme, happyTheme, sadTheme, foodTheme]
        let randomTheme = themes.count.arc4random
        //        print(themes[randomTheme])
        themeBackgroundColor = themes[randomTheme].backgroundColor
        themeCardColor = themes[randomTheme].cardColor
        themeCardTitles = themes[randomTheme].cardTitles
        view.backgroundColor = themeBackgroundColor
        scoreLabel.textColor = themeCardColor
        matchLabel.textColor = themeCardColor
        restartButton.tintColor = themeCardColor
    }
    
    private func updateView() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = .white
                button.isEnabled = false
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : themeCardColor
                button.isEnabled = true
            }
        }
    }
    
    @IBAction private func selectCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateView()
            UIView.animate(withDuration: 1.5, animations: {
            })
            matchLabel.text = "Matches: \(game.matches)"
            scoreLabel.text = "Score: \(game.score)"
        } else {
            print("Chosen card was not in cardButtons")
        }
        if game.matches == numberOfPairsOfCards {
            restartButton.isHidden = false
        }
    }
    
    @IBAction private func restartButtonPressed(_ sender: UIButton) {
        restartButton.isHidden = true
        game.resetCards()
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        emoji.removeAll()
        settingTheme()
        updateView()
        scoreLabel.text = "Score: \(game.score)"
        matchLabel.text = "Matches: \(game.matches)"
    }
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil && themeCardTitles != nil {
            emoji[card] = themeCardTitles!.remove(at: themeCardTitles!.count.arc4random)
        }
        return emoji[card] ?? "?"
    }
    
}



//lazy означает, что реально переменная не будет инициализироваться до тех пор, пока кто-то не запросит ее
/* private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
 
 //Я не возражаю, если кто-то захочет узнать число парных карт, но установку этого числа я предпочел бы не раскрывать. Можно было бы использовать ​private (set)​, но переменная ​numberOfPairsOfCards​ уже является только ​get{} с​ войством, она рассчитывается исходя из другого свойства, так что мы по определению не можем ее устанавливать, поэтому просто НЕ- ​private
 var numberOfPairsOfCards: Int {
 return (cardButtons.count + 1) / 2
 }
 
 //То же самое с ​flipCount​. Я думаю, что люди могут получать ​flipCount​, но они, определенно, не могут устанавливать ​flipCount​. Это наша внутренняя реализация, когда карта переворачивается.
 private (set) var flipCount = 0 {
 didSet {
 updateFlipCountLabel()
 }
 }
 
 private func updateFlipCountLabel(){
 let attributes: [NSAttributedString.Key: Any] = [
 .strokeWidth: 5.0,//толщина линии обводки
 .strokeColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
 ]
 let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
 
 flipCountLabel.attributedText = attributedString
 }
 
 //Почти всегда наши ​Outlets​ и ​Actions​ будут ​private​, потому что все они относятся к внутренней реализации нашего ​UI​.
 @IBOutlet private var cardButtons: [UIButton]!
 
 @IBOutlet private weak var flipCountLabel: UILabel!{
 didSet {
 updateFlipCountLabel()
 }
 }
 
 @IBAction private func touchCard(_ sender: UIButton) {
 flipCount += 1
 if let cardNumber = cardButtons.firstIndex(of: sender){//возвращает индекс выбранной карты
 game.chooseCard(at: cardNumber)
 updateViewFromModel()
 }
 else{
 print("choosen card was not in cardButtons")
 }
 if game.matches == numberOfPairsOfCards {
 restart.isHidden = false
 }
 }
 
 @IBOutlet private weak var restart: UIButton!
 
 override func viewDidLoad() {
 super.viewDidLoad()
 //settingTheme()
 updateViewFromModel()
 restart.isHidden = true
 }
 
 //private func settingTheme() {
 //        let themes = [halloweenTheme, happyTheme, sadTheme, foodTheme]
 //        let randomTheme = themes.count.arc4random
 //        //        print(themes[randomTheme])
 //        themeBackgroundColor = themes[randomTheme].backgroundColor
 //        themeCardColor = themes[randomTheme].cardColor
 //        themeCardTitles = themes[randomTheme].cardTitles
 //        view.backgroundColor = themeBackgroundColor
 //        scoreLabel.textColor = themeCardColor
 //        matchLabel.textColor = themeCardColor
 //        restartButton.tintColor = themeCardColor
 //        timeBonusLabel.textColor = themeCardColor
 // }
 
 //конечно же, внутренняя реализация, поэтому ​private
 private func updateViewFromModel () {
 for index in cardButtons.indices{
 let button = cardButtons[index]
 let card = game.cards[index]
 if card.isFaceUp {
 button.setTitle(emoji (for: card), for: UIControl.State.normal)
 button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
 }
 else{
 button.setTitle("", for: UIControl.State.normal)
 button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
 }
 }
 }
 
 //Все эти дела с эмоджи - ​private
 //private var emojiChoices = ["🦇", "😱", "🙀", "😈", "🎃", "👻", "🍭", "🍬", "🍎"]
 private var emojiChoices = "🦇😱🙀😈🎃👻🍭🍬🍎"
 
 private var emoji = [Card: String]()
 
 private func emoji(for card: Card) -> String {
 if emoji[card] == nil, emojiChoices.count > 0 {
 let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
 emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
 }
 return emoji[card] ?? "?"
 }*/

