module tcm.figlet;
import std.stdio, std.process;
bool useFigletBanner = true;
void figlet(string banner){
  if(useFigletBanner){
    auto c = executeShell("figlet -c -k '"~banner~"'");
    if (c.status != 0){ useFigletBanner = false; writeln("Figlet missing, using standard stdio output."); }
    else writeln(c.output);
  }else banner.writeln;
}
