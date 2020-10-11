import std.stdio, tcm.colours;

void main(){
  auto c = new Colours();
  writeln(c.blue~"hello there"~c.reset);
  writeln(c.fg("125")~"hello there"~c.reset);
}
