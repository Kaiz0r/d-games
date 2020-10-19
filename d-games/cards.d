module cards;
import std.stdio, tcm.opthandler, std.algorithm, std.array, std.string, std.process, std.conv, std.json, std.random;

class Card{
  int value;
  string suit;
  string icon;
  string name;
  string[string] variables;
  override string toString(){return " ["~this.name~" "~this.icon~""~this.suit~"] ";}
}
class StandardPlayingCard : Card {}
class TarotNouveau : Card{}
class TarotMinorArcana : Card{}
class TarotMajorArcana : Card{
override string toString(){return " [#"~this.value.to!string~" "~this.name~"] ";}
}

class Deck{
  Card[] cards;
  int jokers;
  string[] packs;
  string[] validPacks;
  void generatePack(string pack = "standard"){
    this.packs ~= pack;
    switch(pack){
    case "standard":
	string[] suits = ["hearts", "diamonds", "clubs", "spades"];
	foreach (suit;suits){
	  for(int i = 0;i<14;i++){
	    auto c = new StandardPlayingCard();
	    c.value = i;
	    if(i == 0) c.name = "ace";
	    else if(i == 11) c.name = "jack";
	    else if(i == 12) c.name = "queen";
	    else if(i == 13) c.name = "king";
	    else c.name = c.value.to!string;
		     
	    if(suit == "hearts") c.icon = "♥";
	    else if(suit == "diamonds") c.icon = "♦";
	    else if(suit == "clubs") c.icon = "♣";
	    else if(suit == "spades") c.icon = "♠";
	    this.cards ~= c;
	  }
	}
	if(this.jokers > 0){
	  int j = 0;
	  while(j < this.jokers){
	    auto joker = new StandardPlayingCard();joker.suit = "*";joker.name = "joker";joker.value = 14;this.cards ~= joker;j++;
	  }
	}
	break;
    case "tarotnouveau", "tarotnv":
	Card c;
	c = new TarotNouveau();
	c.icon="🃡"; c.name="individual"; c.suit="folly";  c.value=1;
	this.cards ~= c;

	c = new TarotNouveau(); 
	c.icon="🃢"; c.name="childhood"; c.suit="the four ages";  c.value=2;
	this.cards ~= c;
	
	c = new TarotNouveau();
	c.icon="🃣"; c.name="youth"; c.suit="the four ages";  c.value=3;
	this.cards ~= c;
	
	c = new TarotNouveau();
	c.icon="🃤"; c.name="maturity"; c.suit="the four ages";  c.value=4;
	this.cards ~= c;
	
	c = new TarotNouveau();
	c.icon="🃥"; c.name="old age"; c.suit="the four ages";  c.value=5;
	this.cards ~= c;

	c = new TarotNouveau();
	c.icon="🃦"; c.name="morning"; c.suit="the four times of day";  c.value=6;
	this.cards ~= c;
	
	c = new TarotNouveau();
	c.icon="🃧"; c.name="afternoon"; c.suit="the four times of day";  c.value=7;
	this.cards ~= c;
	
	c = new TarotNouveau();
	c.icon="🃨"; c.name="evening"; c.suit="the four times of day";  c.value=8;
	this.cards ~= c;
	
	c = new TarotNouveau();
	c.icon="🃩"; c.name="night"; c.suit="the four times of day";  c.value=9;
	this.cards ~= c;

	c = new TarotNouveau();
	c.icon="🃪"; c.name="earth"; c.suit="the four elements";  c.value=10;
	this.cards ~= c;
	
	c = new TarotNouveau();
	c.icon="🃪"; c.name="air"; c.suit="the four elements";  c.value=10;
	this.cards ~= c;
	
	c = new TarotNouveau();
	c.icon="🃫"; c.name="water"; c.suit="the four elements";  c.value=11;
	this.cards ~= c;
	
	c = new TarotNouveau();
	c.icon="🃫"; c.name="fire"; c.suit="the four elements";  c.value=11;
	this.cards ~= c;


	c = new TarotNouveau();
	c.icon="🃬"; c.name="dance"; c.suit="the four leisures";  c.value=12;
	this.cards ~= c;
	
	c = new TarotNouveau();
	c.icon="🃭"; c.name="shopping"; c.suit="the four leisures";  c.value=13;
	this.cards ~= c;
	
	c = new TarotNouveau();
	c.icon="🃮"; c.name="open air"; c.suit="the four leisures";  c.value=14;
	this.cards ~= c;
	
	c = new TarotNouveau();
	c.icon="🃯"; c.name="visual arts"; c.suit="the four leisures";  c.value=15;
	this.cards ~= c;

	c = new TarotNouveau();
	c.icon="🃰"; c.name="spring"; c.suit="the four seasons";  c.value=16;
	this.cards ~= c;
	
	c = new TarotNouveau();
	c.icon="🃱"; c.name="summer"; c.suit="the four seasons";  c.value=17;
	this.cards ~= c;
	
	c = new TarotNouveau();
	c.icon="🃲"; c.name="autumn"; c.suit="the four seasons";  c.value=18;
	this.cards ~= c;
	
	c = new TarotNouveau();
	c.icon="🃳"; c.name="winter"; c.suit="the four seasons";  c.value=19;
	this.cards ~= c;
	
	c = new TarotNouveau();
	c.icon="🃴"; c.name="the game"; c.suit="the game";  c.value=20;
	this.cards ~= c;
	
	c = new TarotNouveau();
	c.icon="🃵"; c.name="collective"; c.suit="folly";  c.value=21;
	this.cards ~= c;
	break;
    case "frenchstripped":
	string[] suits = ["hearts", "diamonds", "clubs", "spades"];
	foreach (suit;suits){
	  for(int i = 0;i<10;i++){
	    auto c = new StandardPlayingCard();
	    c.value = i;
	    if(i == 0) c.name = "ace";
	    else c.name = c.value.to!string;
	    if(suit == "hearts") c.icon = "♥";
	    else if(suit == "diamonds") c.icon = "♦";
	    else if(suit == "clubs") c.icon = "♣";
	    else if(suit == "spades") c.icon = "♠";
	    this.cards ~= c;
	  }
	}
	break;
    case "majorarcana":
	Card c;
	c = new TarotMajorArcana(); c.name = "the fool"; c.value=0; this.cards ~= c;
	c = new TarotMajorArcana(); c.name = "the magician"; c.value=1; this.cards ~= c;
	c = new TarotMajorArcana(); c.name = "the high priestess"; c.value=2; this.cards ~= c;
	c = new TarotMajorArcana(); c.name = "the empress"; c.value=3; this.cards ~= c;
	c = new TarotMajorArcana(); c.name = "the emperor"; c.value=4; this.cards ~= c;
	c = new TarotMajorArcana(); c.name = "the heirophant"; c.value=5; this.cards ~= c;
	c = new TarotMajorArcana(); c.name = "the lovers"; c.value=6; this.cards ~= c;
	c = new TarotMajorArcana(); c.name = "chariot"; c.value=7; this.cards ~= c;
	c = new TarotMajorArcana(); c.name = "justice"; c.value=8; this.cards ~= c;
	c = new TarotMajorArcana(); c.name = "hermit"; c.value=9; this.cards ~= c;
	c = new TarotMajorArcana(); c.name = "wheel of fortune"; c.value=10; this.cards ~= c;
	c = new TarotMajorArcana(); c.name = "strength"; c.value=11; this.cards ~= c;
	c = new TarotMajorArcana(); c.name = "the hanged man"; c.value=12; this.cards ~= c;
	c = new TarotMajorArcana(); c.name = "death"; c.value=13; this.cards ~= c;
	c = new TarotMajorArcana(); c.name = "temperance"; c.value=14; this.cards ~= c;
	c = new TarotMajorArcana(); c.name = "the devil"; c.value=15; this.cards ~= c;
	c = new TarotMajorArcana(); c.name = "the tower"; c.value=16; this.cards ~= c;
	c = new TarotMajorArcana(); c.name = "the star"; c.value=17; this.cards ~= c;
	c = new TarotMajorArcana(); c.name = "the moon"; c.value=18; this.cards ~= c;
	c = new TarotMajorArcana(); c.name = "the sun"; c.value=19; this.cards ~= c;
	c = new TarotMajorArcana(); c.name = "judgement"; c.value=20; this.cards ~= c;
	c = new TarotMajorArcana(); c.name = "the world"; c.value=21; this.cards ~= c;
	break;
    case "minorarcana":
	string[] suits = ["wands", "pentacles", "swords", "cups"];
	foreach (suit;suits){
	  for(int i = 0;i<15;i++){
	    auto c = new TarotMinorArcana();
	    c.value = i;
	    if(i == 0) c.name = "ace";
	    else if(i == 11) c.name = "page";
	    else if(i == 12) c.name = "knight";
	    else if(i == 13) c.name = "queen";
	    else if(i == 14) c.name = "king";
	    else c.name = c.value.to!string;
	    this.cards ~= c;
	  }
	}
	break;

    default:
	this.generatePack("standard");
    }
  }
  this(string pack = "standard"){
    this.jokers = 4;
    if(pack != "none") this.generatePack(pack);
    this.validPacks = ["standard", "frenchstripped", "tarotnv", "minorarcana", "majorarcana"];

  }
  void shuffle(){this.cards = this.cards.randomShuffle();}
  Card draw(){
    auto card = this.cards[0];
    this.cards = this.cards.remove(0);
    return card;
  }
  void reshuffle(string pack = "standard"){
    this.cards = [];
    this.packs = [];
    this.generatePack(pack);
    this.cards = this.cards.randomShuffle();
   
  }
}
