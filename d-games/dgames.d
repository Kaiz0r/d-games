//import libdglights;
import std.stdio, tcm.opthandler, std.algorithm, std.array, std.string, std.process, std.conv, tcm.colours, tcm.strplus;
import std.random, tcm.randplus, tcm.figlet, std.json, std.file, std.path, tcm.fileplus;
import dice, cards;

string defaultDataJson = `{
"rb": {"launcher": "ruby", "name": "Ruby"},
"py": {"launcher": "python3", "name": "Python"},
"js": {"launcher": "node", "name": "Javascript (Node)"},
"stats": {"credits": 0, "wins": {}, "losses": {}}
}`;


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
void printHand(Card[] h, string fmsg){ write(fmsg); foreach(c;h){ write(c.toString.blue); } write("\n"); }
int calculateHand(Card[] h){int i; foreach(c;h){ i += c.value; } return i;}
void playBlackjack(){
  executeShell("clear").output.writeln;
  figlet("blackjack");
  Card[] player;
  Card[] house;
  Card card;
  bool running = true;
  auto d = new Deck();
  d.jokers = 0;
  
  d.reshuffle();
  player ~= d.draw();
  player ~= d.draw();
  house ~= d.draw();
  house ~= d.draw();

  while(running){
    writeln("\n\n\n");
    printHand(player, "You have ");
    writeln("Value of "~calculateHand(player).to!string.blue);
    writeln("House has "~house[0].toString.red~" and a hidden card.");

    write("What do you do? [draw/hit | stand] > ");
    string prompt = readln().strip;
    switch(prompt){
    case "d", "dr", "dra", "draw", "h", "hi", "hit":
	card = d.draw();
	writeln("You drew "~card.toString.blue);
	player ~= card;
	writeln("Total value is now "~player.calculateHand.to!string);
	if(player.calculateHand > 21) {"Bust!".figlet; running=false;}
	if(player.calculateHand == 21) {"You win!".figlet; running=false;}
	break;

    case "s", "st", "sta", "stan", "stand":
	writeln("You stand.");
	break;

    default:
	writeln("What?");
	break;
    }

  }
	
}
class LightsLinear {
  bool[] lights;
  bool loop;
  bool randoms;
  int rnum;
  int rdone;
  
  this(int len = 8, bool loop = false, bool randoms = false, int odds = 50){
    this.loop = loop;
    this.randoms = randoms;
    if(len < 5) len=5;
    this.rnum = randrange(1, len/3);
    this.rdone = 0;
    for(int i = 0; i < len; i++) {
	bool done;
	if(randoms){
	  if(rdone <= rnum){
	    int c = randrange(0, 100);
	    if(c >= odds){
		this.lights ~= true;
		this.rdone++;
		done = true;
	    }
	  }
	}

	if(!done)
	this.lights ~= false;
    }
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

void handleExtJson(string epth){
  auto j = readDotJson(epth);
  writeln(j);
  executeShell("rm "~epth).output.writeln;
 
}
void main(string[] argv){
  auto o = new Opt(argv);
  auto datapath = environment.get("DG_DATA");
  if(datapath == null){datapath = expandTilde("~/.dg_data/");}
  string extpath = datapath~"extensions/";
  string datajson = datapath~"data.json";
  string extjson = datapath~"ext.json";
  if(!datapath.exists){ executeShell("mkdir "~datapath).output.writeln; writeln("Created data directory in "~datapath); }
  if(!extpath.exists){
    executeShell("mkdir "~datapath~"extensions/").output.writeln; writeln("Created extension directory in "~datapath); }
  if(!datajson.exists){auto f = File(datapath~"data.json", "w+");f.writeln(defaultDataJson);writeln("Created data file.");}
  if(extjson.exists){handleExtJson(extjson);}
  string[] lines;
  string line;
  switch(o.command(0, "help")){
  case "help":
    //executeShell("clear").output.writeln;
    figlet("dgames - help");

    "Add -h to command to help.\n".writeln;
    "Games:".writeln;
    "  lights - Try to flip all the lights.".writeln;
    "         - Takes options: --length:num defines how many lights, --loop:true defines if the ends loop around".writeln;

    "\nTools:".writeln;
    
    "  dice - Give a dice notation and roll the dice. (Default: 2d6) ".writeln;
    "  deck [pack] - Opens a simulated deck of cards interface.(Default Pack: standard) ".writeln;
    "  decks - Shows valid packs available for the deck command.".writeln;

    "\nExtensions:".writeln;
    auto e = readDotJson(datajson);
    foreach(f;listdir(extpath)){
	if(!f.endsWith("~")){
	  auto d = "(Unknown)";
	  if(f.contains(".")){
	    if(f.split(".")[1] in e) d = "("~e[f.split(".")[1]]["name"].str~")";
	    if(f.split(".")[0] in e && "description" in e[f.split(".")[0]]) d ~= " - "~e[f.split(".")[0]]["description"].str;
	    writeln("  "~f.split(".")[0]~" "~d);
	  }else{
	    writeln("  "~f~" (Binary)");
	  }

	}
    }
    
    break;
  case "extension", "ext":
    string found = "";
    auto e = readDotJson(datajson);
    foreach(f;listdir(extpath)){
	if(found != "" || f.endsWith("~")) continue;

	if(f.contains(o.command(1))){
	  found = f;
	}
    }

    if(found == ""){"No extension matched.".writeln;}else{
	auto f = File(datapath~"payload.json", "w+");
	f.writeln(`{"signed": `~randrange(10000, 99999).to!string~`}`);
	f.close();
	writeln("Loading extension "~found~"...");
	if(found.contains(".")){
	  if(found.split(".")[1] in e){
	    string launcher = e[found.split(".")[1]]["launcher"].str;
	    string pth = extpath~found;
	    writeln("Executing "~pth~" in "~launcher~"...");
	    auto pid = spawnProcess([launcher, pth, datapath]);
	    auto ex = wait(pid);
	    writeln("Extension closed.");
	    if(extjson.exists){"Processing result...".writeln; handleExtJson(extjson);}

	  } 
	}else{
	  writeln("Executing "~extpath~found~"...");
	}
    }
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
  case "rps": //To finish
    "RPS BATTLE".figlet;
    "BEGIN".figlet;
    string[] options = ["rock", "paper", "scissors"];
    auto rnd = Random(unpredictableSeed);
    auto a = uniform(0, 3, rnd);
    string option = options[a];
    write("[r,p,s] > ");
    string resp = readln().strip;
    writeln("You: "~resp.blue~" | CPU: "~option.blue);

    switch(resp){
    case "r", "ro", "roc", "rock":
	if(option == "rock"){"DRAW".figlet;}
	if(option == "paper"){"LOSE".figlet;}
	if(option == "scissors")"WIN".figlet;
	break;
    case "p", "pa", "pap", "pape", "paper":
	if(option == "rock"){"WIN".figlet;}
	if(option == "paper"){"DRAW".figlet;}
	if(option == "scissors")"LOSE".figlet;
	break;
    case "s", "sc", "sci", "scis", "scissor", "scissors":
	if(option == "rock"){"LOSE".figlet;}
	if(option == "paper"){"WIN".figlet;}
	if(option == "scissors"){"DRAW".figlet;}
	break;
    default:
	"Gave up.".writeln;
	break;
    }
    break;
  case "lights":
    executeShell("clear").output.writeln;
    figlet("lights");
    auto g = new LightsLinear(to!int(o.value("length", "8")), o.flag("loop"), o.flag("randoms"), o.value("odds", "50").to!int);
    writeln("Options:\nlength "~to!string(g.lights.length)~"\nloop "~to!string(g.loop)~"\nrandoms "~to!string(g.randoms)~"\nodds "~o.value("odds", "50")~"\n");
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
