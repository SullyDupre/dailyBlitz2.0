//
//  cards.swift
//  dailyBlitz2.0
//
//  Created by Sullivan Dupre on 6/5/20.
//  Copyright © 2020 ASU. All rights reserved.
//

import Foundation


class cards {
    
    var deckOfCards:[card] = []
    var drawnCards:[card] = []
    
    var middleCards:[card] = []
    var p1Cards:[card] = []
    var p2Cards:[card] = []
    
    var combination1Cards:[card] = []
    var combination2Cards:[card] = []
    
    var listOfSuits = ["Spades","Clubs","Diamonds","Hearts"]
    var listOfValues = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]
    init() {
        var individualIndex = 1
        for suit in listOfSuits {
            var strength = 2
            for value in listOfValues{
                let newcard = card(su: suit, val: value, s: strength, ii: individualIndex)
                deckOfCards.append(newcard)
                
                individualIndex += 1
                strength += 1
            }
        }
    }
    
    func getAvailableCardCount()->Int
    {
        let countAvail = (deckOfCards.count-drawnCards.count)
        return countAvail
    }
    
    func getCard() -> card {
        var selectedCard = card(su: "Empty", val: "Empty", s: 0, ii: 0)

        if getAvailableCardCount() > 0{
            repeat {
                var duplicate = false
                let selectedNum = Int.random(in: 0...51)

                for cardPicked in drawnCards {
                    if deckOfCards[selectedNum].individualIndex == cardPicked.individualIndex
                    {
                        duplicate = true
                    }
                }
                if duplicate == false{
                    selectedCard = deckOfCards[selectedNum]
                }
            } while selectedCard.suit == "Empty"
            
            drawnCards.append(selectedCard)
                        
            return selectedCard
        }
        else
        {
            print("Deck Empty")
            return selectedCard
        }
    }
    
    func drawAllCards()
    {
        for _ in 1...52{
            let cardDrawnHere = getCard()
            let suitSel = cardDrawnHere.suit ?? ""
            let valSel = cardDrawnHere.value ?? ""
            
            print("\(suitSel) of \(valSel)\n")
        }
    }
    func dealCards(){
        var CommunityCards = "Community: "
        var player1 = "Player 1: "
        var player2 = "Player 2: "
        
        refillDeck()
        fillCommunity()
        fillPlayer1()
        fillPlayer2()
        
        
        for number in 0...4 {
            let cardDrawnHere = middleCards[number]
            let suitSel = cardDrawnHere.suit ?? ""
            let valSel = cardDrawnHere.value ?? ""
            CommunityCards += "\(valSel) of \(suitSel), "
        }
        /*
        for number in 0...1 {
            let cardDrawnHere = p1Cards[number]
            let suitSel = cardDrawnHere.suit ?? ""
            let valSel = cardDrawnHere.value ?? ""
            player1 += "\(valSel) of \(suitSel), "
        }
        for number in 0...1 {
            let cardDrawnHere = p2Cards[number]
            let suitSel = cardDrawnHere.suit ?? ""
            let valSel = cardDrawnHere.value ?? ""
            player2 += "\(valSel) of \(suitSel), "
        }
        */
        
        for number in 0...6 {
            let cardDrawnHere = combination1Cards[number]
            let suitSel = cardDrawnHere.suit ?? ""
            let valSel = cardDrawnHere.value ?? ""
            player1 += "\(valSel) of \(suitSel), "
        }
        for number in 0...6 {
            let cardDrawnHere = combination2Cards[number]
            let suitSel = cardDrawnHere.suit ?? ""
            let valSel = cardDrawnHere.value ?? ""
            player2 += "\(valSel) of \(suitSel), "
        }
        
        print(CommunityCards)
        print(player1)
        print(player2)
        
        //print(combination1Cards)
        //print(combination2Cards)
        print(getRankings(arrayOfSeven: combination1Cards))
        print(getRankings(arrayOfSeven: combination2Cards))
    }
    
    func refillDeck()
    {
        drawnCards.removeAll()
        print("\nDeck refilled")
    }

    
    func fillCommunity(){
        middleCards.removeAll()
        for _ in 0...4 {
            middleCards.append(getCard())
        }
    }
    
    func fillPlayer1(){
        p1Cards.removeAll()
        combination1Cards.removeAll()
        for _ in 0...1 {
            p1Cards.append(getCard())
        }
        combination1Cards = p1Cards + middleCards
    }
    
    func fillPlayer2(){
        p2Cards.removeAll()
        combination2Cards.removeAll()
        for _ in 0...1 {
            p2Cards.append(getCard())
        }
        combination2Cards = p2Cards + middleCards
    }
    
    func pairsTriplesFours(arrayOfSeven: Array<card>) -> Int {
        var highestResult = 1
        var numberOfEachSuit = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        var index = 0
        for value in listOfValues{
            for cardInArray in arrayOfSeven{
                if cardInArray.value == value{
                    numberOfEachSuit[index] += 1
                }
            }
            index += 1
        }
        highestResult = numberOfEachSuit.max()!
        return highestResult
    }
    
    func isFlush(arrayOfSeven: Array<card>) -> Bool {
        var result = false
        var numberOfEachSuit = [0,0,0,0]
        var index = 0
        for suit in listOfSuits{
            for cardInArray in arrayOfSeven{
                if cardInArray.suit == suit{
                    numberOfEachSuit[index] += 1
                }
            }
            if numberOfEachSuit[index] >= 5
            {
                result = true
            }
            index += 1
        }
        return result
    }
    
    func whichFlush(arrayOfSeven: Array<card>) -> Array<card> {

        var result = ""
        var newArray: [card] = []
        var aceExists = false
        if isFlush(arrayOfSeven: arrayOfSeven) {
            var numberOfEachSuit = [0,0,0,0]
            var index = 0
            for suit in listOfSuits{
                for cardInArray in arrayOfSeven{
                    if cardInArray.suit == suit{
                        numberOfEachSuit[index] += 1
                    }
                }
                if numberOfEachSuit[index] >= 5
                {
                    result = suit
                }
                index += 1
            }
            for cardInArray in arrayOfSeven{
                if cardInArray.suit == result{
                    newArray.append(cardInArray)
                }
                if cardInArray.strength == 14{
                    aceExists = true
                }
            }
            for index in 0..<(newArray.count-1){
                for innerIndex in 0..<(newArray.count - index - 1){
                    let tempCard1 = newArray[innerIndex]
                    let tempCard2 = newArray[innerIndex + 1]
                    let strength1 = tempCard1.strength ?? 0
                    let strength2 = tempCard2.strength ?? 0
                    if strength1 > strength2
                    {
                        newArray.swapAt(innerIndex, innerIndex + 1)
                    }
                }
            }
            if aceExists
            {
                newArray.insert(card(su: result, val: "A", s: 1, ii: 0), at: 0)
            }
        }
        return newArray
    }
    
    func isTwoPair(arrayOfSeven: Array<card>) -> Bool
    {
        var numberOfMultiples = 0
        var twoPairPossible = false
        
        var numberOfEachSuit = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        var index = 0
        for suit in listOfSuits{
            for cardInArray in arrayOfSeven{
                
                if cardInArray.value == suit{
                    numberOfEachSuit[index] += 1
                    if numberOfEachSuit[index] == 2
                    {
                        numberOfMultiples+=1
                    }
                }
            }
            index += 1
        }
        if numberOfMultiples >= 2
        {
            twoPairPossible = true
        }
        else{
            twoPairPossible = false
        }
        
        return twoPairPossible
    }
    
    func isFullHouse(arrayOfSeven: Array<card>) -> Bool
    {
        var numberOfMultiples = 0
        var numberOfTriples = 0
        
        var fullHousePossible = false
        var numberOfEachSuit = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        var index = 0
        for suit in listOfSuits{
            for cardInArray in arrayOfSeven{
                if cardInArray.value == suit
                {
                    numberOfEachSuit[index] += 1
                    if numberOfEachSuit[index] == 2
                    {
                        numberOfMultiples+=1
                    }
                    if numberOfEachSuit[index] == 3
                    {
                        numberOfTriples += 1
                        numberOfMultiples-=1
                    }
                }
            }
            index += 1
        }
        if ((numberOfMultiples >= 1 && numberOfTriples >= 1) || (numberOfTriples >= 2))
        {
            fullHousePossible = true
        }
        else{
            fullHousePossible = false
        }
        return fullHousePossible
    }
    
    func isStraightFlushPossible(arrayOfSeven: Array<card>) -> Bool{
        var copiedArray : [card] = []
        var index = 0
       
        var straightStatus = false
        
        for cardSelected in arrayOfSeven {
            copiedArray.append(card(su: "Some", val: "E", s: 0, ii: 0))
            copiedArray[index] = cardSelected
            index += 1
        }
        
        if isFlush(arrayOfSeven: copiedArray){
            copiedArray = (whichFlush(arrayOfSeven: copiedArray))
            if isStraightPossible(arrayOfSeven: copiedArray){
                straightStatus = true
            }
        }
        return straightStatus
    }
    
    func isStraightPossible(arrayOfSeven: Array<card>) -> Bool{
        var copiedArray : [Int] = [0,0,0,0,0,0,0]
        var index = 0
        var aceExists = false
        var consecutives = 0
        var straightStatus = false
        
        for cardSelected in arrayOfSeven {
            copiedArray[index] = cardSelected.strength!
            if cardSelected.strength == 14{
                aceExists = true
            }
            index += 1
        }
                
        for index in 0..<(copiedArray.count-1){
            for innerIndex in 0..<(copiedArray.count - index - 1){
                if copiedArray[innerIndex] > copiedArray[innerIndex + 1]{
                    copiedArray.swapAt(innerIndex, innerIndex + 1)
                }
            }
        }
        
        if aceExists {
            copiedArray.insert(1, at: 0)
        }

        for index in 0..<(copiedArray.count-1){
            if index != copiedArray.count
            {
                if ((copiedArray[index+1]-copiedArray[index]) == 1)
                {
                    consecutives += 1
                    if consecutives > 3{
                        straightStatus = true
                    }
                    
                }
                else if (copiedArray[index+1] != copiedArray[index])
                {
                    consecutives = 0
                }
            }
        }
        return straightStatus
    }
    
    func getRankings(arrayOfSeven: Array<card>){
        if (isStraightFlushPossible(arrayOfSeven: arrayOfSeven)){
            print("Straight Flush Status For 1: True" )
        }
        else{
            print("Straight Flush Status For 1: False" )
        }
        if (pairsTriplesFours(arrayOfSeven: arrayOfSeven) == 4){
            print("Four Kind Status For 1: True" )
        }
        else{
            print("Four Kind Status For 1: False" )
        }
        
        if (isFullHouse(arrayOfSeven: arrayOfSeven)){
            print("Full House Status For 1: True" )
        }
        else{
            print("Full House Status For 1: False" )
        }
        
        if (isFlush(arrayOfSeven: arrayOfSeven)){
            print("Flush Status For 1: True" )
        }
        else{
            print("Flush Status For 1: False" )
        }
        if (isStraightPossible(arrayOfSeven: arrayOfSeven)){
            print("Straight Status For 1: True" )
        }
        else{
            print("Straight Status For 1: False" )
        }
        if (pairsTriplesFours(arrayOfSeven: arrayOfSeven)==3){
            print("Three Kind Status For 1: True" )
        }
        else{
            print("Three Kind Status For 1: False")
        }
        if (isTwoPair(arrayOfSeven: arrayOfSeven)){
            print("Two-Pair Status For 1: True")
        }
        else{
            print("Two-Pair Status For 1: False" )
        }
        if (pairsTriplesFours(arrayOfSeven: arrayOfSeven)==2){
            print("One-Pair Status For 1: True")
        }
        else{
            print("One-Pair Status For 1: False")
        }
    }
    func HighestCombo(arrayOfSeven: Array<card>) -> Array<card>{
        var newArray: [card] = []
        if (isStraightFlushPossible(arrayOfSeven: arrayOfSeven)){
            
        }
        else if pairsTriplesFours(arrayOfSeven: arrayOfSeven) == 4{
            
        }
    }
}

class card
{
    var suit: String?
    var value: String?
    var strength: Int?
    var individualIndex: Int?
    
    init(su: String, val: String, s: Int, ii: Int) {
        suit = su
        value = val
        strength = s
        individualIndex = ii
    }
}

//copiedArray = [card(su: "Diamonds", val: "9", s: 9, ii: 0), card(su: "Spades", val: "3", s: 3, ii: 0), card(su: "Diamonds", val: "J", s: 11, ii: 0), card(su: "Spades", val: "A", s: 14, ii: 0), card(su: "Diamonds", val: "7", s: 7, ii: 0), card(su: "Diamonds", val: "8", s: 8, ii: 0) , card(su: "Diamonds", val: "10", s: 10, ii: 0)]
