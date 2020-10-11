//import libdglights;
import std.stdio, tcm.opthandler, std.algorithm, std.array, std.string, std.process, std.conv, dice, cards, tcm.colours, tcm.strplus;

bool useFigletBanner = true;

void figlet(string banner){
  if(useFigletBanner){
    auto c = executeShell("figlet -c -k '"~banner~"'");
    if (c.status != 0){ useFigletBanner = false; writeln("Figlet missing, using standard stdio output."); }
    else writeln(c.output);
  }else banner.writeln;
}
void deckSim(string pack){
  auto clr = new Colours();
  executeShell("clear").output.writeln;
  figlet("cards");
  auto deck = new Deck(pack);
  writeln("Commands: ["~clr.yellow~"draw (optional number)"~clr.reset~"] ["~clr.yellow~"hand"~clr.reset~"] ["~clr.yellow~"shuffle"~clr.reset~"] ["~clr.yellow~"reshuffle (optional new pack)"~clr.reset~"] ["~clr.yellow~"deck"~clr.reset~"] ["~clr.yellow~"combine"~clr.reset~"] ["~clr.yellow~"clear"~clr.reset~"] "~clr.red~"(ctrl-c to exit)"~clr.reset~"");
  Card[] hand;
    Card[] discards;
    string line;
    write("> ");
    while((line = readln()) !is null){
	line = line.replace("\n", "");
	string com = line.split(" ")[0];
	string p;
	if(line.contains(" ")){
	  p = line.split(" ")[1..$].join(" ");
	}
	switch(com){
	case "clear":
	  executeShell("clear").output.writeln;
	  figlet("cards");
	  writeln("Commands: ["~clr.yellow~"draw (optional number)"~clr.reset~"] ["~clr.yellow~"hand"~clr.reset~"] ["~clr.yellow~"shuffle"~clr.reset~"] ["~clr.yellow~"reshuffle (optional new pack)"~clr.reset~"] ["~clr.yellow~"deck"~clr.reset~"] ["~clr.yellow~"combine"~clr.reset~"] ["~clr.yellow~"clear"~clr.reset~"] "~clr.red~"(ctrl-c to exit)"~clr.reset~"");
	  break;
	case "draw":
	  int num = 1;
	  if(p != ""){
	    num = p.to!int;
	  }
	  for(int i = 0;i<num;i++){
	    auto c = deck.draw();
	    writeln("Drew "~c.toString());
	    hand ~= c;
	  }

	  break;
	case "hand":
	  foreach(c; hand){writeln(" "~c.toString()~" ");}
	  break;
	case "deck":
	  foreach(c; deck.cards){writeln(" "~c.toString()~" ");}
	  write("Packs: ");
	  writeln(deck.packs.join(" | "));
	  writeln("Cards: "~deck.cards.length.to!string);
	  break;
	case "shuffle":
	  deck.shuffle();
	  break;
	case "reshuffle":
	  hand = []; discards = [];
	  if(p != "") deck.reshuffle(p); else deck.reshuffle(pack);
	  break;
	case "combine":
	  writeln(deck.validPacks.join(" | "));
	  write("Add in which pack? > ");
	  deck.generatePack(readln().strip);
	  break;
	default:
	  writeln("What?");
	}
	write("> ");
    }
}
void playBlackjack(){

}
class LightsLinear {
  bool[] lights;
  bool loop;
  
  this(int len = 8, bool loop = false){
    this.loop = loop;
    for(int i = 0; i < len; i++) this.lights ~= false;
  }
  
  void flipLight(int index){
    if(index >= this.lights.length){"Index out of bounds...".writeln; return;} 
    if(index == 0){
	if(this.loop){
	  this.lights[$-1] = !this.lights[$-1];
	}
    } else this.lights[index-1] = !this.lights[index-1];
    
    this.lights[index] = !this.lights[index];
    if(index == this.lights.length-1){
	if(this.loop){
	  this.lights[0] = !this.lights[0];
	}
    } else this.lights[index+1] = !this.lights[index+1];
  }

  string outputLights(string onString = "[X]", string offString = "[ ]", string seperator = " ", string ruler = " * "){
    string o;
    string r;
    int i;

    foreach (l; this.lights){
	o ~= seperator;
	r ~= seperator;
	r ~= ruler.replace("*", to!string(i));
	if(l){
	  o ~= onString;
	} else o ~= offString;
	    i++;
    }
    o ~= seperator;
    r ~= seperator;

    return r~"\n"~o;
  }
  
}

void main(string[] argv){
  auto o = new Opt(argv);
  string[] lines;
  string line;
  switch(o.command(0, "help")){
  case "help":
    executeShell("clear").output.writeln;
    figlet("dgames");
    "DGAMES - Help".writeln;

    "
Games:
    lights - Try to flip all the lights.
           - Takes options: --length:num defines how many lights, --loop:true defines if the ends loop around

Tools:
    dice - Give a dice notation and roll the dice. (Default: 2d6) 


Plans:
    RNG commands, coin flip, random number generator
    generic deck of cards simulation, deck <pack name>, opens sub-loop for commands, pull/draw, shuffle, re-shuffle hand in to deck, new card pack;  keep track of Deck, Hand, Discards
    number guessing game
     - set a range, ask it a number, it'll tell you how
    minesweeper
     - 2d array, lengths and # of bombs defined by config
     - input coordinates to check or sweep
    picross
     - 2d array, filled squares from config
    solitaire?
     - object that simulates card placement
    blackjack
     - should be simple
    lights grid
     - 2d array, config size all start empty, fill all squares, pushing one square flips all adjacent
    ".writeln;
    break;
  case "deck":
    deckSim(o.command(1, "standard"));
    break;
  case "decks":
    auto deck = new Deck("none");
    writeln(deck.validPacks.join(" | "));
    break;
  case "dice":
    rollDice(o.command(1, "2d6")).result.writeln;
    break;
  case "blackjack":
    playBlackjack();
    break;
  case "lights":
    executeShell("clear").output.writeln;
    figlet("lights");
    auto g = new LightsLinear(to!int(o.value("length", "8")), to!bool(o.value("loop", "false")));
    writeln("Options:\nlength "~to!string(g.lights.length)~"\nloop "~to!string(g.loop)~"\n");
    writeln("Enter index numbers to flip the lights:");
    g.outputLights.writeln;
    while((line = readln()) !is null){
	line = line.stripRight("\n");
	g.flipLight(to!int(line));
	g.outputLights.writeln;
    }
    break;
  default:
    "What?".writeln;
  }

}
