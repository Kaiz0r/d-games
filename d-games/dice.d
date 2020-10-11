module dice;
import std.conv, std.string, std.array, std.random;

int randr(int digits){
  auto rnd = Random(unpredictableSeed);
  auto a = uniform(1, digits+1, rnd);
  return a;
}

class DiceResult{
  string raw;
  int sides;
  int die;
  int plus;

  int[] rolls;
  string result(){
    string output;
    int total;
    
    foreach(r; this.rolls){
	total += r;
	output ~= " ["~to!string(r)~"] ";
    }
    return output~" | Total: "~to!string(total);
  }
  void roll(){
    for(int i = 0;i<this.die;i++){
	this.rolls ~= randr(this.sides)+this.plus;
    }
  }
  this(string notation){
    this.raw = notation;
    if((notation.indexOf("d") >= 0)){
	if((notation.indexOf("+") >= 0)){
	  this.plus = to!int(notation.split("+")[1]);
	  this.die = to!int(notation.split("d")[0]);
	  this.sides = to!int(notation.split("d")[1].split("+")[0]);
	} else{
	  this.die = to!int(notation.split("d")[0]);
	  this.sides = to!int(notation.split("d")[1]);
	}	
    }
  }
}

DiceResult rollDice(string notation){
  auto res = new DiceResult(notation);
  res.roll();
  return res;
}
