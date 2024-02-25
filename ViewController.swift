//
//  ViewController.swift
//  cardGame
//
//  Created by Turing on 10/5/23.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //displayCard(cardID : "7_of_clubs")
        lblWin.isHidden = !lblWin.isHidden
        lblWin.isHidden = true
        lblDealerScore.isHidden = true
        lblPlayerScore.isHidden = true
        hitBtn.isHidden = true
        stayBtn.isHidden = true
        resetBtn.isHidden = true
    }
    
    @IBOutlet weak var resetBtn: UIButton!
    
    func startGame(){
        //resetting the game
        removeCards()
        
        hitCount = 0
        
        lblDealerScore.text = "Dealer Score: 0"
        lblPlayerScore.text = "Player Score: 0"
        lblWin.isHidden = true
        
        startBtn.isHidden = !startBtn.isHidden
        startBtn.isHidden = true
        resetBtn.isHidden = false
        
        lblDealerScore.isHidden = false
        lblPlayerScore.isHidden = false
        hitBtn.isHidden = false
        stayBtn.isHidden = false
        
        
        deck.resetDrawCount()
        
        //initializing player and dealer
        let player : Hand = Hand(deck : &deck)
        let dealer : Hand = Hand(deck : &deck)
        
        
        deck.shuffle()
        
        //draw intial two cards for player and dealer
        dealer.drawCardToHand()
        dealer.drawCardToHand()
        player.drawCardToHand()
        player.drawCardToHand()
        
        //updating scores
        let dealerValue : Int = dealer.calculateValue()
        let playerValue : Int = player.calculateValue()
        
        updateScores(dealer: dealerValue, player: playerValue)
        
        displayCards(hand: player, y : 600)
        displayCards(hand: dealer, y : 180)
    }
    
    private var deck : Deck = Deck()
    private var hitCount : Int = 0
    
    
    @IBOutlet weak var hitBtn: UIButton!
    
    @IBOutlet weak var stayBtn: UIButton!
    
    @IBAction func btnReset(_ sender: UIButton) {
        startGame()
    }
    
    @IBOutlet weak var startBtn: UIButton!
    @IBAction func btnStart(_ sender: UIButton) {
        startGame()
    }
    
    
    @IBOutlet weak var lblDealerScore: UILabel!
    
    @IBOutlet weak var lblPlayerScore: UILabel!
    
    
    func updateScores(dealer : Int, player : Int){
        lblDealerScore.text = "Dealer Score: \(dealer)"
        lblPlayerScore.text = "Player Score: \(player)"
    }
    
    @IBAction func btnHit(_ sender: UIButton) {
        //playerGlobal.drawCardToHand()
        let player : Hand = Hand(deck : &deck)
        let dealer : Hand = Hand(deck : &deck)
        
        deck.resetDrawCount()
        
        //draw intial two cards for player and dealer
        dealer.drawCardToHand()
        dealer.drawCardToHand()
        player.drawCardToHand()
        player.drawCardToHand()
        
        
        
        for _ in 0...hitCount{
            player.drawCardToHand()
        }
        
        hitCount += 1
        
        var dealerValue : Int = dealer.calculateValue()
        var playerValue : Int = player.calculateValue()
        
        updateScores(dealer: dealerValue, player: playerValue)
        
        displayCards(hand: player, y : 600)
        displayCards(hand: dealer, y : 180)
        
        //if player busts
        if(playerValue>21)
        {
            print("dealer wins")
            lblWin.text = "Dealer Wins!"
            lblWin.isHidden = false
            startBtn.setTitle("Play Again?", for: .normal)
            startBtn.isHidden = false
            hitBtn.isHidden = true
            stayBtn.isHidden = true
            
        }
    }
    
    @IBAction func btnStay(_ sender: UIButton) {
        
        hitBtn.isHidden = true
        stayBtn.isHidden = true
        
        let player : Hand = Hand(deck : &deck)
        let dealer : Hand = Hand(deck : &deck)
        
        deck.resetDrawCount()
        
        //draw intial two cards for player and dealer
        dealer.drawCardToHand()
        dealer.drawCardToHand()
        player.drawCardToHand()
        player.drawCardToHand()
        
        
        if hitCount>0{
            for _ in 0...hitCount-1{
                player.drawCardToHand()
            }
        }
        
        //dealer turn: dealer must hit until 17
        while(dealer.calculateValue()<17){
            //dealer continues to hit..
            dealer.drawCardToHand()
        }
        
        //displays dealers cards
        displayCards(hand: dealer, y : 180)
        
        //getting the hand values of both dealer and player
        var dealerValue : Int = dealer.calculateValue()
        var playerValue : Int = player.calculateValue()
        
        //updating scores on front end and back end
        updateScores(dealer: dealerValue, player: playerValue)
        print("Dealers hand: ")
        dealer.printHand()
        print(dealerValue)
        
        print()
        print("Players hand: ")
        player.printHand()
        print(playerValue)
        
        //win conditions
        if(player.isBusted() && dealer.isBusted()){
            print("nobody wins")
            lblWin.text = "Nobody Wins!"
        }else if (player.isBusted() && !dealer.isBusted())
        {
            print("dealer wins")
            lblWin.text = "Dealer Wins!"
        }else if (!player.isBusted() && dealer.isBusted()){
            print("Player wins")
            lblWin.text = "Player Wins!"
        }else{
            if(playerValue == dealerValue){
                print("Tie")
                lblWin.text = "Tie!"
            }else if(playerValue > dealerValue){
                print("Player wins")
                lblWin.text = "Player Wins!"
            }else{
                print("Dealer wins")
                lblWin.text = "Dealer Wins!"
            }
        }
        
        //hiding and showing desired buttons
        lblWin.isHidden = false
        startBtn.setTitle("Play Again?", for: .normal)
        startBtn.isHidden = false
        hitBtn.isHidden = true
        stayBtn.isHidden = true
    }
    
    @IBOutlet weak var lblWin: UILabel!
    
    
    //displays a hand of cards
    private func displayCards(hand: Hand, y : Int){
        let handLen = hand.getHandLen()
        
        for i in 0...handLen-1{
            displayCard(card: hand.getCard(index: i).getCardImage(), x : 100+(50*i), y : y)
        }
    }
    
    //displays a card
    private func displayCard(card : UIImage, x : Int, y : Int){
        
        let cardTag : Int = deck.getDrawCount() + 1000
        
        let testImageView : UIImageView = UIImageView()
        
        
        testImageView.image = card
        testImageView.tag = cardTag
        
        testImageView.frame = CGRect(x: x, y: y, width: 100, height: 180)

        view.addSubview(testImageView)
        
    }
    
    //removes all cards from view
    func removeCards(){
        for subview in view.subviews{
            if(subview is UIImageView){
                subview.removeFromSuperview()
            }
            
        }
    }
    
    //Class for the card object
    private class Card{
        //contains information such as id, suit, and value of the card
        var ident : String
        var suit : String
        var amount : Int
        var suits : [String] = ["spades", "clubs", "hearts", "diamonds"]
        var image : UIImage
        
        //Initializer
        init(amount:Int) {
            self.suit = suits[0]
            
            //uses counting method to determine suit
            if(amount > 39){
                self.suit = suits[3]
            }else if(amount > 26)
            {
                self.suit = suits[2]
            }else if(amount > 13){
                self.suit = suits[1]
            }
            
            // using modulus 13% to determine value
            self.amount = amount % 13
            
            //initializing id
            self.ident = ("\(self.amount)_of_\(suit)")
            
            //altering id if royal
            if(self.amount == 1)
            {
                self.ident = ("ace_of_\(suit)")
                self.amount = 11
            }else if(self.amount == 11){
                self.ident = ("jack_of_\(suit)")
                self.amount = 10
            }else if(self.amount == 12){
                self.ident = ("queen_of_\(suit)")
                self.amount = 10
            }else if(self.amount == 0){
                self.ident = ("king_of_\(suit)")
                self.amount = 10
            }
            
            image = UIImage(named: self.ident)!
        }
        
        //returns id of card
        func getID() -> String{
            return self.ident
        }
        
        //returns card's in game value
        func getAmount()->Int{
            return self.amount
        }
        
        //changes the card's in game value
        func setAmount(newValue:Int){
            self.amount = newValue
        }
        
        //gets image
        func getCardImage()->UIImage{
            return self.image
        }
    }

    //Class for deck
    private class Deck {
        //array of card objects and a tracker for how many cards that have been drawn
        private var deck : [Card] = []
        private var drawCount : Int = 0
        
        //initializer
        init() {
            //populating deck with cards
            for i in 1...52{
                var newCard : Card = Card(amount : i)
                deck.append(newCard)
            }
        }
        
        //Calling the getID in the card class based on index at deck
        func getCardIDAtIndex(index : Int)->String{
            return self.deck[index].getID()
        }
        
        //shuffles cards necessary because Deck is private
        func shuffle(){
            self.deck.shuffle()
        }
        
        //Incriments draw count and returns card object in array based on draw counter
        func drawCard()->Card{
            
            self.drawCount+=1
            return self.deck[drawCount-1]
        }
        
        //returns draw count
        func getDrawCount()->Int{
            return self.drawCount
        }
        
        //resets card count
        func resetDrawCount(){
            self.drawCount = 0
        }
    }

    //Class for player/dealer hand
    private class Hand {
        //array for cards and hand and pointer value to point at the deck
        private var hand : [Card] = []
        private var deckPtr : UnsafePointer<Deck>
        private var isOnTurn : Bool = true
        
        
        
        //initializer for hand inputs deck to use as pointer
        init(deck: UnsafePointer<Deck>){
            self.deckPtr = deck
        }
        
        //returns size of hand
        func getHandLen()->Int{
            return hand.count
        }
        
        //uses the drawCard() function from the current deck and puts it in the hand[] array
        func drawCardToHand(){
            self.hand.append(self.deckPtr.pointee.drawCard())
        }
        
        //prints all cards in hand
        func printHand() {
            for i in 0...self.hand.count-1{
                print(self.hand[i].getID())
            }
            
        }
        
        func getCard(index : Int) -> Card{
            return self.hand[index]
        }
        
        
        //calculate hand's value
        func calculateValue()->Int{
            //initializing sum and number of aces in hand
            var sum = 0
            var aceNum = self.getNumOfAces()
            
            for i in 0...self.hand.count-1{
                sum+=self.hand[i].getAmount()
                //print(self.hand[i].getID())
            }
            
            //converting aces to ones if sum > 21
            while (aceNum > 0){
                //checking that sum is greater than 21 and there is more than one ace to subtract 10
                if (sum > 21 && aceNum > 0){
                    sum-=10
                    aceNum-=1
                }else{
                    break
                }
            }
            return sum
        }
        
        //returns the number of aces in the hand
        func getNumOfAces()->Int{
            //counter for aces
            var aceCount : Int = 0
            
            //iterating through each card in hand
            for i in 0...self.hand.count-1{
                //checking to see if the card is an ace
                if(self.hand[i].getID().localizedStandardContains("Ace")){
                    aceCount+=1
                }
            }
            return aceCount
        }
        
      
        
        //checks to see if player is busted
        func isBusted()->Bool{
            if(self.calculateValue() <= 21){
                return false
            }else {
                return true
            }
        }
        
    }

    
}

