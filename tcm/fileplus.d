module tcm.fileplus;
import std.stdio, std.json, std.file;
import std.algorithm;
import std.array;
import std.path;

JSONValue readDotJson(string pth){
  auto f = File(pth, "r");
  auto range = f.byLine();
  string txt;
    
  foreach (line; range)
    if (!line.empty) txt ~= line~"\n";
  return parseJSON(txt);
}
void writeDotJson(JSONValue data, string pth){
  auto f = File(pth, "w");

  string txt = data.toString;
  f.writeln(txt);

}

string[] listdir(string pathname)
{

    return std.file.dirEntries(pathname, SpanMode.shallow)
        .filter!(a => a.isFile)
        .map!(a => std.path.baseName(a.name))
        .array;
}
