import os ,times , strformat
import termkey
initTerm(35,100)



gotoXY(2,10); echo fmt"""dir-exist dspf ->, {$dirExists("dspf")}"""

if not dirExists("dspf") : createDir("dspf")

gotoXY(4,10); echo "dir-exist dspfxxx ->" , $dirExists("dspfxxx")

gotoXY(6,10); echo "./dspf/prettyFile.dspf ->" ,fileExists("./dspf/prettyFile.dspf")


gotoXY(8,10);
echo "Time file was last accessed"
gotoXY(9,10);
echo getLastAccessTime("./dspf/prettyFile.dspf").format("yyyy-MM-dd  hh:mm")       ## Time file was last accessed.

gotoXY(10,10);
echo "Time file was last modified/written to"
gotoXY(11,10);
echo getLastModificationTime("./dspf/prettyFile.dspf").format("yyyy-MM-dd  hh:mm")  ## Time file was last modified/written to.

gotoXY(15,10); echo "-------------"

gotoXY(16,10);
echo "Time file was last accessed"
gotoXY(17,10);
echo $getLastAccessTime("./dspf/prettyFile.dspf").format("yyyy-MM-dd  hh:mm")
gotoXY(18,10);
echo "Time file was last modified/written to"
gotoXY(19,10);
echo $getLastModificationTime("./dspf/prettyFile.dspf").format("yyyy-MM-dd  hh:mm")

let timeGet = getTime()
gotoXY(22,10);
echo fmt"""Time Day : , {timeGet.format("yyyy-MM-dd  h:m")}"""

var X: Natural = 25
var Y :Natural
for kind, path in walkDir("dspf"):
  inc(X)
  gotoXY(X,10);
  echo $kind, $path

getCursor(X,Y)
gotoXY(X+1,10);
echo "TEST-DIR", "\n"
discard  getFunc(true)
closeTerm()