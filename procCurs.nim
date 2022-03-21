#-------------------------------------------------------
## TERMCURS
## curse TERMINAL inspired 5250/3270 done only width nim
#-------------------------------------------------------

import termkey
from strformat import alignString, fmt
from strutils import `%`,isDigit,parseInt,parseEnum,parseBool,parseFloat
import std/[re]  , math
import unicode

#proc beug(nline : int ; text :string ) =
#  gotoXY(40, 1); echo "ligne>", nline, " :" , text ; let lcurs = getFunc()





const
  EMPTY*:bool = true
  FILL*:bool = false

type
  REFTYP* {.pure.} = enum       # type de Field
    TEXT_FREE,
    ALPHA,
    ALPHA_UPPER,
    ALPHA_NUMERIC,
    ALPHA_NUMERIC_UPPER,
    TEXT_FULL,
    PASSWORD,
    DIGIT,
    DIGIT_SIGNED,
    DECIMAL,
    DECIMAL_SIGNED,
    DATE_ISO,
    DATE_FR,
    DATE_US,
    TELEPHONE,
    MAIL_ISO,
    YES_NO,
    SWITCH,
    FPROC,
    FCALL


# FPROC appel d'une fonction interne "proc" --> Simulation KEYBOARD PROC
# FCALL appel d'une externe  "programe" --> Simulation KEYBOARD CALL


  CADRE* {.pure.} = enum
    line0,
    line1,
    line2

  MNUVH* {.pure.} = enum
    vertical = 0  ,
    horizontal

  TKey_Grid* {.pure.} = enum
    PGUp,
    PGDown,
    PGHome,
    PGEnd





  MNUATRB* = ref object
    style* : set[Style]
    backgr*: BackgroundColor
    backbr*: bool
    foregr*: ForegroundColor
    forebr*: bool
    styleCell* : set[Style]

  BOXATRB* = ref object
    style* : set[Style]
    backgr*: BackgroundColor
    backbr*: bool
    foregr*: ForegroundColor
    forebr*: bool
    title_style* : set[Style]
    title_backgr*: BackgroundColor
    title_backbr*: bool
    title_foregr*: ForegroundColor
    title_forebr*: bool

  ZONATRB* = ref object
    style* : set[Style]
    backgr*: BackgroundColor
    backbr*: bool
    foregr*: ForegroundColor
    forebr*: bool

  GRIDATRB* = ref object
    style* : set[Style]
    backgr*: BackgroundColor
    backbr*: bool
    foregr*: ForegroundColor
    forebr*: bool
    title_style* : set[Style]
    title_backgr*: BackgroundColor
    title_backbr*: bool
    title_foregr*: ForegroundColor
    title_forebr*: bool

  CELLATRB* = ref object
    cell_style* : set[Style]
    cell_backgr*: BackgroundColor
    cell_backbr*: bool
    cell_foregr*: ForegroundColor
    cell_forebr*: bool




  BTNSPACE* = ref object
    space* : Natural


  FIELD* = object
    name*: string
    posx: Natural
    posy: Natural
    style : set[Style]
    backgr: BackgroundColor
    backbr: bool
    foregr: ForegroundColor
    forebr: bool

    pstyle : set[Style]
    pbackgr: BackgroundColor
    pbackbr: bool
    pforegr: ForegroundColor
    pforebr: bool


    reftyp: REFTYP            # / ALPHA...SWITCH
    width: Natural
    scal: Natural
    nbrcar: Natural           # / nbrcar DECIMAL = (precision+scale + 1'.' ) + 1 this signed || other nbrcar =  ALPA..DIGIT..

    empty : bool              # / EMPTY or FULL
    protect: bool             # / only display

    pading: bool              # / pading blank
    edtcar: string            # / edtcar for monnaie		€ $ ¥ ₪ £ or %

    regex: string             # / contrôle regex
    errmsg: string            # / message this field

    help: string              # / help this field

    text*: string
    switch* : bool            # / CTRUE CFALSE

    process:string           # / name proc
    err: bool                # / force error
    actif: bool              # / zone active True



  HIDEN* = object             # / field block out
    name: string
    reftyp: REFTYP            # / ALPHA...SWITCH
    text*: string
    switch* : bool


  LABEL* = object
    name*: string
    posx: Natural
    posy: Natural
    style : set[Style]
    backgr: BackgroundColor
    backbr: bool
    foregr: ForegroundColor
    forebr: bool
    text*: string
    title: bool
    actif: bool


  BOX* = object
    name : string
    posx : Natural
    posy : Natural
    lines: Natural
    cols : Natural

    cadre: CADRE

    style : set[Style]
    backgr: BackgroundColor
    backbr: bool
    foregr: ForegroundColor
    forebr: bool

    title*: string
    titlebackgr: BackgroundColor
    titlebackbr: bool
    titleforegr: ForegroundColor
    titleforebr: bool
    titlestyle:  set[Style]
    actif: bool



  BUTTON* = object
    key* : TKey
    text*: string
    ctrl*: bool
    actif: bool


  MENU* = ref object
    name : string
    posx : Natural
    posy : Natural
    lines: Natural
    cols : Natural

    cadre: CADRE
    mnuvh : MNUVH

    style : set[Style]
    styleCell:set[Style]
    backgr: BackgroundColor
    backbr: bool
    foregr: ForegroundColor
    forebr: bool

    item: seq[string]
    selMenu : Natural
    actif: bool

  TerminalChar* = object
    ch: Rune                  # char
    bg: BackgroundColor       # color
    bgb: bool                 # brigth
    fg: ForegroundColor       # color
    fgb: bool                 # brigth
    style: set[Style]         # style
    on:bool                   # on = true -> cell active

  PANEL* = ref object
    name*: string
    posx*: Natural
    posy*: Natural
    lines*: Natural
    cols*:  Natural

    backgr*:   BackgroundColor
    backbr*:   bool
    foregr*:   ForegroundColor
    forebr*:   bool
    style*:    set[Style]

    cadre*:    CADRE
    boxpnl*:   BOX

    box*:     seq[BOX]
    label*:   seq[LABEL]
    field*:   seq[FIELD]
    hiden*:   seq[HIDEN]

    button*:  seq[BUTTON]
    index*:    Natural

    funcKey*:  seq[TKey]

    mouse*:  bool

    buf:seq[TerminalChar]

    actif:    bool

  # GRID

  GridStyle* = object
    colSeparator*: string


  CELL* = object
    text* : string
    long*  : Natural
    reftyp*: REFTYP
    posy  : Natural
    edtcar: string
    cellatr : CELLATRB

  GRIDSFL* = ref object
    name : string
    posx: Natural
    posy: Natural
    lines: Natural
    cols : Natural
    pagerows: Natural
    rows: seq[seq[string]]
    nrow: seq[int]
    headers: seq[CELL]
    separator: GridStyle
    gridatr : GRIDATRB
    actif: bool
    lignes: int
    pages: int
    cursligne:int
    curspage:int
    buf:seq[TerminalChar]

# var interne
let sepStyle* = GridStyle( colSeparator:"│")
let noStyle* = GridStyle( colSeparator:" ")


var pnlatr* = new(ZONATRB)
pnlatr.style  = {styleDim}
pnlatr.backgr = BackgroundColor.bgBlack
pnlatr.backbr = false
pnlatr.foregr = ForegroundColor.fgWhite
pnlatr.forebr = false

var scratr* = new(ZONATRB)
scratr.style  = {styleDim}
scratr.backgr = BackgroundColor.bgBlack
scratr.backbr = false
scratr.foregr = ForegroundColor.fgWhite
scratr.forebr = false


var mnuatr* = new(MNUATRB)
mnuatr.style  = {styleDim}
mnuatr.backgr = BackgroundColor.bgWhite
mnuatr.backbr = true
mnuatr.foregr = ForegroundColor.fgBlue
mnuatr.forebr = true
mnuatr.styleCell  = {styleReverse,styleItalic}

var mnuatrCadre* = new(MNUATRB)
mnuatrCadre.style  = {styleDim}
mnuatrCadre.backgr = BackgroundColor.bgBlack
mnuatrCadre.backbr = false
mnuatrCadre.foregr = ForegroundColor.fgWhite
mnuatrCadre.forebr = true
mnuatrCadre.styleCell  = {styleReverse,styleItalic}

var boxatr* = new(BOXATRB)
boxatr.style  = {styleDim}
boxatr.backgr = BackgroundColor.bgBlack
boxatr.backbr = false
boxatr.foregr = ForegroundColor.fgRed
boxatr.forebr = true
boxatr.title_style = {styleDim}
boxatr.title_backgr = BackgroundColor.bgWhite
boxatr.title_backbr = false
boxatr.title_foregr = ForegroundColor.fgBlack
boxatr.title_forebr = false

var lblatr* = new(ZONATRB)
lblatr.style  = {styleDim,styleItalic}
lblatr.backgr = BackgroundColor.bgBlack
lblatr.backbr = false
lblatr.foregr = ForegroundColor.fgGreen
lblatr.forebr = true

var ttlatr* = new(ZONATRB)
ttlatr.style  = {styleBright}
ttlatr.backgr = BackgroundColor.bgBlack
ttlatr.backbr = false
ttlatr.foregr = ForegroundColor.fgCyan
ttlatr.forebr = true


var fldatr* = new(ZONATRB)
fldatr.style  = {styleDim}
fldatr.backgr = BackgroundColor.bgWhite
fldatr.backbr = false
fldatr.foregr = ForegroundColor.fgBlue
fldatr.forebr = true

var prtatr* = new(ZONATRB)
prtatr.style  = {styleDim,styleItalic}
prtatr.backgr = BackgroundColor.bgBlack
prtatr.backbr = false
prtatr.foregr = ForegroundColor.fgYellow
prtatr.forebr = true

var swtatr* = new(ZONATRB)
swtatr.style  = {styleBright}
swtatr.backgr = BackgroundColor.bgblack
swtatr.backbr = false
swtatr.foregr = ForegroundColor.fgWhite
swtatr.forebr = false

var msgatr* = new(ZONATRB)
msgatr.style  = {styleDim}
msgatr.backgr = BackgroundColor.bgBlack
msgatr.backbr = false
msgatr.foregr = ForegroundColor.fgRed
msgatr.forebr = true

var hlpatr* = new(ZONATRB)
hlpatr.style  = {styleDim,styleItalic}
hlpatr.backgr = BackgroundColor.bgBlack
hlpatr.backbr = false
hlpatr.foregr = ForegroundColor.fgYellow
hlpatr.forebr = true

var btnatr* = new(BOXATRB)
btnatr.style  = {styleDim}
btnatr.backgr = BackgroundColor.bgBlack
btnatr.backbr = false
btnatr.foregr = ForegroundColor.fgRed
btnatr.forebr = false
btnatr.title_style = {styleDim,styleItalic,styleUnderscore}
btnatr.title_backgr = BackgroundColor.bgBlack
btnatr.title_backbr = false
btnatr.title_foregr = ForegroundColor.fgCyan
boxatr.title_forebr = false

var btnspc* = new(BTNSPACE)
btnspc.space = 3


var gridatr* = new(GRIDATRB)
gridatr.style  = {styleDim}
gridatr.backgr = BackgroundColor.bgblack
gridatr.backbr = false
gridatr.foregr = ForegroundColor.fgWhite
gridatr.forebr = false
gridatr.title_style = {styleDim,styleUnderscore}
gridatr.title_backgr = BackgroundColor.bgblack
gridatr.title_backbr = false
gridatr.title_foregr = ForegroundColor.fgGreen
gridatr.title_forebr = false



var cellatr* = new(CELLATRB)
cellatr.cell_style = {styleDim,styleItalic}
cellatr.cell_backgr = BackgroundColor.bgblack
cellatr.cell_backbr = false
cellatr.cell_foregr = ForegroundColor.fgCyan
cellatr.cell_forebr = false


## define type cursor
proc defCursor*(e_curs: Natural = 0) =
  const CSIcurs = 0x1b.chr & "[?25h"
  const CSIcurs0 = 0x1b.chr & "[0 q" #  0 → not blinking block
  case e_curs
  of 0:
    stdout.write(CSIcurs0)
    stdout.write(CSIcurs)
  of 1:
    const CSIcurs1 = 0x1b.chr & "[1 q" #  1 → blinking block
    stdout.write(CSIcurs1)
    stdout.write(CSIcurs)
  of 2:
    const CSIcurs2 = 0x1b.chr & "[2 q" #  2 → steady block
    stdout.write(CSIcurs2)
    stdout.write(CSIcurs)
  of 3:
    const CSIcurs3 = 0x1b.chr & "[3 q" #  3 → blinking underlines
    stdout.write(CSIcurs3)
    stdout.write(CSIcurs)
  of 4:
    const CSIcurs4 = 0x1b.chr & "[4 q" #  4 → steady underlines
    stdout.write(CSIcurs4)
    stdout.write(CSIcurs)
  of 5:
    const CSIcurs5 = 0x1b.chr & "[5 q" #  5 → blinking bar
    stdout.write(CSIcurs5)
    stdout.write(CSIcurs)
  of 6:
    const CSIcurs6 = 0x1b.chr & "[6 q" #  6 → steady bar
    stdout.write(CSIcurs6)
    stdout.write(CSIcurs)
  else:
    stdout.write(CSIcurs0)
    stdout.write(CSIcurs)
  stdout.flushFile()
  stdin.flushFile()





## Erase and color and style default
proc setTerminal*(termatr : ZONATRB = scratr) =
  setStyle(scratr.style)
  setBackgroundColor(scratr.backgr,scratr.backbr)
  setForegroundColor(scratr.foregr,scratr.forebr)
  eraseTerm()
  offCursor()


## return BUTTON
proc defButton*(key: TKey; text:string; ctrl:bool = false ; actif:bool = true): BUTTON =
  var bt:BUTTON
  bt.key = key
  bt.text = text
  bt.ctrl = ctrl
  bt.actif = actif
  return bt





## Define BOX
proc defBox*( name:string ; posx:Natural; posy:Natural; lines :Natural; cols:Natural;
              cadre :CADRE; title: string; box_atr: BOXATRB = boxatr ;actif: bool = true) : BOX =

  var box : BOX
  box.name  = name
  box.posx  = posx
  box.posy  = posy
  box.lines = lines
  box.cols  = cols

  box.cadre = cadre

  box.style  = box_atr.style
  box.backgr = box_atr.backgr
  box.backbr = box_atr.backbr
  box.foregr = box_atr.foregr
  box.forebr = box_atr.forebr

  box.title = title
  box.titlestyle  = box_atr.title_style
  box.titlebackgr = box_atr.title_backgr
  box.titlebackbr = box_atr.title_backbr
  box.titleforegr = box_atr.title_foregr
  box.titleforebr = box_atr.title_forebr

  box.actif = actif
  return box




## assigne BOX to matrice for display
proc printBox*(pnl: var PANEL; box:BOX) =

  if CADRE.line0 == box.cadre : return
  let ACS_Hlines     = "─"
  let ACS_Vlines     = "│"
  let ACS_UCLEFT    = "┌"
  let ACS_UCRIGHT   = "┐"
  let ACS_LCLEFT    = "└"
  let ACS_LCRIGHT   = "┘"

  let ACS_Hline2    = "═"
  let ACS_Vline2    = "║"
  let ACS_UCLEFT2   = "╔"
  let ACS_UCRIGHT2  = "╗"
  let ACS_LCLEFT2   = "╚"
  let ACS_LCRIGHT2  = "╝"

  var trait:string = ""
  var edt :bool
  var
    x: Natural = box.posx
    row: Natural = 1
    y: Natural
    col: Natural
    npos: Natural
    n: Natural
  while row <= box.lines:

    y = box.posy
    col = 1
    while col <= box.cols:
      edt = false

      if row == 1:
        if col == 1:
          if CADRE.line1 == box.cadre : trait = ACS_UCLEFT
          else: trait = ACS_UCLEFT2
          edt = true

        if col == box.cols:
          if CADRE.line1 == box.cadre : trait = ACS_UCRIGHT
          else : trait = ACS_UCRIGHT2
          edt = true

        if col > Natural(1) and col < box.cols:
          if CADRE.line1 == box.cadre : trait = ACS_Hlines
          else : trait = ACS_Hline2
          edt = true

      elif row == box.lines:
        if col == Natural(1) :
          if CADRE.line1 == box.cadre : trait = ACS_LCLEFT
          else : trait = ACS_LCLEFT2
          edt = true

        if col == box.cols:
          if CADRE.line1 == box.cadre : trait = ACS_LCRIGHT
          else : trait = ACS_LCRIGHT2
          edt = true

        if col > Natural(1) and col < box.cols:
          if CADRE.line1 == box.cadre : trait = ACS_Hlines
          else : trait = ACS_Hline2
          edt = true

      elif row > Natural(1) and row < box.lines:
        if col == Natural(1) or col == box.cols:
          if CADRE.line1 == box.cadre : trait = ACS_Vlines
          else : trait = ACS_Vline2
          edt = true

      if edt:
        npos = box.cols * x
        n =  npos + y
        pnl.buf[n].ch = trait.runeAt(0)
        pnl.buf[n].bg  =  box.backgr
        pnl.buf[n].bgb =  box.backbr
        pnl.buf[n].fg  =  box.foregr
        pnl.buf[n].fgb =  box.forebr
        pnl.buf[n].style = box.style
        pnl.buf[n].on = true
      inc(y)
      inc(col)
    inc(x)
    inc(row)

  if box.title > "" :

    if len(box.title) > box.cols - 2: return

    npos = box.cols * box.posx
    n =  npos + (((box.cols - len(box.title) ) div 2) + box.posy)
    for ch in runes(box.title):
      pnl.buf[n].ch = ch
      pnl.buf[n].bg  =  box.titlebackgr
      pnl.buf[n].bgb =  box.titlebackbr
      pnl.buf[n].fg  =  box.titleforegr
      pnl.buf[n].fgb =  box.titleforebr
      pnl.buf[n].style = box.titlestyle
      pnl.buf[n].on = true
      inc(n)





## Define Menu
proc newMenu*( name:string ; posx:Natural; posy:Natural;
              mnuvh: MNUVH ; item : seq[string] ;cadre :CADRE = CADRE.line0 ; mnu_atr : MNUATRB = mnuatr ;  actif: bool = true) :MENU =

  var menu = new(MENU)
  menu.name  = name
  menu.posx  = posx
  menu.posy  = posy
  menu.cadre = cadre
  menu.mnuvh = mnuvh
  var i : Natural = 0

  menu.cols = 0
  while  i <  len(item):
    if mnuvh == MNUVH.vertical  :
      if menu.cols < len(item[i]) : menu.cols = runeLen(item[i])
    if mnuvh == MNUVH.horizontal  : menu.cols +=  runeLen(item[i])
    inc(i)


  if mnuvh == MNUVH.vertical:
    if menu.cadre == CADRE.line1 or menu.cadre == CADRE.line2 :
      menu.lines = len(item) + 1
      menu.cols  += 1
    else :
      menu.lines = len(item) + 1

  if mnuvh == MNUVH.horizontal:
    if menu.cadre == CADRE.line1 or menu.cadre == CADRE.line2 :
      menu.lines = 2
      menu.cols  += 1

  menu.style  = mnu_atr.style
  menu.styleCell  = mnu_atr.styleCell
  menu.backgr = mnu_atr.backgr
  menu.backbr = mnu_atr.backbr
  menu.foregr = mnu_atr.foregr
  menu.forebr = mnu_atr.forebr
  menu.item = item
  menu.actif = actif
  return menu




##  assigne MENU to matrice for display
proc printMenu*(pnl: PANEL; mnu:MENU) =
  var row: Natural
  var col: Natural
  if CADRE.line1 == mnu.cadre  or CADRE.line2 == mnu.cadre:
    let ACS_Hlines     = "─"
    let ACS_Vlines     = "│"
    let ACS_UCLEFT    = "┌"
    let ACS_UCRIGHT   = "┐"
    let ACS_LCLEFT    = "└"
    let ACS_LCRIGHT   = "┘"


    let ACS_Hline2    = "═"
    let ACS_Vline2    = "║"
    let ACS_UCLEFT2   = "╔"
    let ACS_UCRIGHT2  = "╗"
    let ACS_LCLEFT2   = "╚"
    let ACS_LCRIGHT2  = "╝"

    var trait:string = ""
    var edt :bool
    row = 0
    while row <= mnu.lines:
      col = 0
      while col <= mnu.cols:
        edt = false

        if row == 0:
          if col == 0:
            if CADRE.line1 == mnu.cadre : trait = ACS_UCLEFT
            else: trait = ACS_UCLEFT2
            edt = true

          if col == mnu.cols:
            if CADRE.line1 == mnu.cadre : trait = ACS_UCRIGHT
            else : trait = ACS_UCRIGHT2
            edt = true

          if col > Natural(0) and col < mnu.cols:
            if CADRE.line1 == mnu.cadre : trait = ACS_Hlines
            else : trait = ACS_Hline2
            edt = true

        elif row == mnu.lines:
          if col == Natural(0) :
            if CADRE.line1 == mnu.cadre : trait = ACS_LCLEFT
            else : trait = ACS_LCLEFT2
            edt = true

          if col == mnu.cols:
            if CADRE.line1 == mnu.cadre : trait = ACS_LCRIGHT
            else : trait = ACS_LCRIGHT2
            edt = true

          if col > Natural(0) and col < mnu.cols:
            if CADRE.line1 == mnu.cadre : trait = ACS_Hlines
            else : trait = ACS_Hline2
            edt = true

        elif row > Natural(0) and row < mnu.lines:
          if col == Natural(0) or col == mnu.cols:
            if CADRE.line1 == mnu.cadre : trait = ACS_Vlines
            else : trait = ACS_Vline2
            edt = true

        if edt:
          gotoXY(row + mnu.posx + pnl.posx - 1  , col + mnu.posy + pnl.posy - 1)

          setBackgroundColor(mnu.backgr,mnu.backbr)
          setForegroundColor(mnu.foregr,mnu.forebr)
          writeStyled(trait,mnu.style)
        else:
          gotoXY(row + mnu.posx + pnl.posx - 1 , col + mnu.posy + pnl.posy - 1)
          setBackgroundColor(mnu.backgr,mnu.backbr)
          setForegroundColor(mnu.foregr,mnu.forebr)
          writeStyled(" ",mnu.style)
        stdout.flushFile()
        inc(col)
      inc(row)

  else : # no cadre

    if mnu.mnuvh == MNUVH.vertical:
      row = 0
      while row <= mnu.lines:
        col = 0
        while col <= mnu.cols:
          gotoXY(row + mnu.posx  + pnl.posx - 1,mnu.posy + pnl.posy - 1)
          setBackgroundColor(mnu.backgr,mnu.backbr)
          setForegroundColor(mnu.foregr,mnu.forebr)
          writeStyled(" ",mnu.style)
          stdout.flushFile()
          inc(col)
        inc(row)
    if mnu.mnuvh == MNUVH.horizontal:
      col = 0
      while col < mnu.cols:
        gotoXY(mnu.posx  + pnl.posx - 1, col + mnu.posy + pnl.posy - 1)
        setBackgroundColor(mnu.backgr,mnu.backbr)
        setForegroundColor(mnu.foregr,mnu.forebr)
        writeStyled(" ",mnu.style)
        stdout.flushFile()
        inc(col)

proc dspMenuItem*(pnl: PANEL; mnu:MENU)  =
  var pos : Natural = 0
  var n , h   : Natural

  printMenu(pnl, mnu)

  onMouse()
  offCursor()
  stdout.flushFile()
  if pos > len(mnu.item) or pos < 0 : pos = 0

  n = 0
  h = 0
  for cell in  mnu.item :
    if mnu.mnuvh == MNUVH.vertical :
      if mnu.cadre == CADRE.line0 :
        gotoXY(mnu.posx + pnl.posx  + n - 1 , mnu.posy + pnl.posy - 1)
      else :
        gotoXY(mnu.posx + pnl.posx  + n, mnu.posy + pnl.posy)

    if mnu.mnuvh == MNUVH.horizontal :
      if mnu.cadre == CADRE.line0 :
        gotoXY(mnu.posx + pnl.posx  - 1 , h  + mnu.posy + pnl.posy - 1)
      else :
        gotoXY(mnu.posx + pnl.posx  , h +  mnu.posy + pnl.posy )

    setBackgroundColor(mnu.backgr,mnu.backbr)
    setForegroundColor(mnu.foregr,mnu.forebr)
    if pos == n :
      writeStyled(cell.strip(),mnu.styleCell)
    else :
      writeStyled(cell.strip(),mnu.style)
    inc(n)
    h += runeLen(cell)
  stdout.flushFile()







## Define Label
proc defLabel*(name:string ; posx:Natural; posy:Natural; text: string;
                lbl_atr : ZONATRB = lblatr ; actif: bool = true) :LABEL =

  var lbl : LABEL

  lbl.name        = name
  lbl.posx        = posx
  lbl.posy        = posy
  lbl.text        = text
  lbl.title       = false
  lbl.actif       = actif

  lbl.style  = lbl_atr.style
  lbl.backgr = lbl_atr.backgr
  lbl.backbr = lbl_atr.backbr
  lbl.foregr = lbl_atr.foregr
  lbl.forebr = lbl_atr.forebr
  return lbl

## Define Title
proc defTitle*(name:string ; posx:Natural; posy:Natural; text: string;
                ttl_atr : ZONATRB = ttlatr ; actif: bool = true) :LABEL =

  var lbl : LABEL

  lbl.name        = name
  lbl.posx        = posx
  lbl.posy        = posy
  lbl.text        = text
  lbl.title       = true
  lbl.actif       = actif

  lbl.style  = ttl_atr.style
  lbl.backgr = ttl_atr.backgr
  lbl.backbr = ttl_atr.backbr
  lbl.foregr = ttl_atr.foregr
  lbl.forebr = ttl_atr.forebr
  return lbl


## assigne LABEL to matrice for display
proc printLabel*(pnl: var PANEL, lbl : LABEL ) =
  var npos = pnl.cols * lbl.posx
  var n =  npos + lbl.posy
  for ch in runes(lbl.text):
    if lbl.actif == true :
      pnl.buf[n].ch = ch
      pnl.buf[n].bg  = lbl.backgr
      pnl.buf[n].bgb = lbl.backbr
      pnl.buf[n].fg  = lbl.foregr
      pnl.buf[n].fgb = lbl.forebr
      pnl.buf[n].style = lbl.style
      pnl.buf[n].on = true
    else :
      pnl.buf[n].ch = " ".runeAt(0)
      pnl.buf[n].bg  = pnl.backgr
      pnl.buf[n].bgb = pnl.backbr
      pnl.buf[n].fg  = pnl.foregr
      pnl.buf[n].fgb = pnl.forebr
      pnl.buf[n].style =  pnl.style
      pnl.buf[n].on = false
    inc(n)






## Define Field String Standard
proc defString*(name:string ; posx:Natural; posy:Natural; reftyp: REFTYP;
              width: Natural;text: string; empty: bool;
              errmsg: string   ; help: string;
              regex: string = "";
              fld_atr : ZONATRB = fldatr ;protect_atr : ZONATRB = prtatr ;
              actif: bool = true) : FIELD =

  var fld : FIELD

  fld.name        = name
  fld.posx        = posx
  fld.posy        = posy
  fld.reftyp      = reftyp      # / ALPHA...SWITCH
  fld.width        = width
  fld.scal        = 0
  fld.nbrcar      = width
  fld.text        = text
  fld.empty       = empty
  fld.protect     = false       # / only display
  fld.pading      = true        # / pading blank
  fld.edtcar      = ""          # / edtcar for monnaie		€ $ ¥ ₪ £ or %
  fld.regex       = regex       # / contrôle regex
  fld.errmsg      = errmsg      # / message this field
  fld.help        = help        # / help this field
  fld.switch      = false       # / CTRUE CFALSE
  fld.err         = false       # / zone error False
  fld.actif       = actif       # / zone active True

  fld.process     = ""          # / name calls proc or pgm

  fld.style  = fld_atr.style
  fld.backgr = fld_atr.backgr
  fld.backbr = fld_atr.backbr
  fld.foregr = fld_atr.foregr
  fld.forebr = fld_atr.forebr

  fld.pstyle  = protect_atr.style
  fld.pbackgr = protect_atr.backgr
  fld.pbackbr = protect_atr.backbr
  fld.pforegr = protect_atr.foregr
  fld.pforebr = protect_atr.forebr
  return fld





## Define Field Mail
proc defMail*(name:string ; posx:Natural; posy:Natural; reftyp: REFTYP;
              width: Natural;text: string; empty: bool;
              errmsg: string   ; help: string;
              fld_atr : ZONATRB = fldatr ;protect_atr : ZONATRB = prtatr ;
              actif: bool = true) :FIELD =

  var fld : FIELD

  fld.name        = name
  fld.posx        = posx
  fld.posy        = posy
  fld.reftyp      = reftyp     # / ALPHA...SWITCH
  fld.width        = width
  fld.scal        = 0
  fld.nbrcar      = width
  fld.text        = text
  fld.empty       = empty
  fld.protect     = false       # / only display
  fld.pading      = true        # / pading blank
  fld.edtcar      = ""          # / edtcar for monnaie		€ $ ¥ ₪ £ or %

  fld.regex       ="""(?:[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])"""
  # / contrôle regex  [ABNF] [RFC 2822]
  fld.errmsg      = errmsg      # / message this field
  fld.help        = help        # / help this field
  fld.switch      = false       # / CTRUE CFALSE
  fld.err         = false       # / zone error False
  fld.actif       = actif       # / zone active True

  fld.process     = ""          # / name calls proc or pgm

  fld.style  = fld_atr.style
  fld.backgr = fld_atr.backgr
  fld.backbr = fld_atr.backbr
  fld.foregr = fld_atr.foregr
  fld.forebr = fld_atr.forebr

  fld.pstyle  = protect_atr.style
  fld.pbackgr = protect_atr.backgr
  fld.pbackbr = protect_atr.backbr
  fld.pforegr = protect_atr.foregr
  fld.pforebr = protect_atr.forebr
  return fld



## Define Field switch
proc defSwitch*(name:string ; posx:Natural; posy:Natural; reftyp: REFTYP;
              switch: bool;  empty: bool;
              errmsg: string ; help: string;
              swt_atr : ZONATRB = swtatr ;protect_atr : ZONATRB = prtatr ;
              actif: bool = true): FIELD =

  var fld : FIELD
  fld.name        = name
  fld.posx        = posx
  fld.posy        = posy
  fld.reftyp      = reftyp      # / ALPHA...SWITCH
  fld.width       = 1
  fld.scal        = 0
  fld.nbrcar      = 1
  fld.text        = ""
  fld.empty       = empty
  fld.protect     = false       # / only display
  fld.pading      = false       # / pading blank
  fld.edtcar      = ""          # / edtcar for monnaie		€ $ ¥ ₪ £ or %
  fld.regex       = ""          # / contrôle regex
  fld.errmsg      = errmsg      # / message this field
  fld.help        = help        # / help this field
  fld.switch      = switch      # / CTRUE CFALSE
  fld.err         = false       # / zone error False
  fld.actif       = actif       # / zone active True

  fld.process     = ""          # / name calls proc or pgm

  fld.style  = swt_atr.style
  fld.backgr = swt_atr.backgr
  fld.backbr = swt_atr.backbr
  fld.foregr = swt_atr.foregr
  fld.forebr = swt_atr.forebr

  fld.pstyle  = protect_atr.style
  fld.pbackgr = protect_atr.backgr
  fld.pbackbr = protect_atr.backbr
  fld.pforegr = protect_atr.foregr
  fld.pforebr = protect_atr.forebr
  return fld




## Define Field date ISO
proc defDate*(name:string ; posx:Natural; posy:Natural; reftyp: REFTYP;
              text: string; empty: bool;
              errmsg: string   ; help: string;
              fld_atr : ZONATRB = fldatr ; protect_atr : ZONATRB = prtatr ;
              actif: bool = true): FIELD =

  var fld : FIELD

  fld.name        = name
  fld.posx        = posx
  fld.posy        = posy
  fld.reftyp      = reftyp      # / ALPHA...SWITCH
  fld.width       = 10
  fld.scal        = 0
  fld.nbrcar      = 10
  fld.text        = text
  fld.empty       = empty
  fld.protect     = false       # / only display
  fld.pading      = false       # / pading blank
  fld.edtcar      = ""          # / edtcar for monnaie		€ $ ¥ ₪ £ or %
  if reftyp == DATE_ISO:
    fld.regex       = """^(?:(?:(?:(?:(?:[1-9]\d)(?:0[48]|[2468][048]|[13579][26])|(?:(?:[2468][048]|[13579][26])00))(|-|)(?:0?2\1(?:29)))|(?:(?:[1-9]\d{3})(|-|)(?:(?:(?:0?[13578]|1[02])\2(?:31))|(?:(?:0?[13-9]|1[0-2])\2(?:29|30))|(?:(?:0?[1-9])|(?:1[0-2]))\2(?:0?[1-9]|1\d|2[0-8])))))$"""   # / contrôle regex  YYYY-MM-DD

  if reftyp == DATE_US:
    fld.regex       ="""^(((0[13-9]|1[012])[/]?(0[1-9]|[12][0-9]|30)|(0[13578]|1[02])[/]?31|02[/]?(0[1-9]|1[0-9]|2[0-8]))[/]?[0-9]{4}|
    02[/]?29[/]?([0-9]{2}(([2468][048]|[02468][48])|[13579][26])|([13579][26]|[02468][048]|0[0-9]|1[0-6])00))$"""

  if reftyp == DATE_FR:
    fld.regex       ="""^(((0[1-9]|[12][0-9]|30)[/]?(0[13-9]|1[012])|31[/]?(0[13578]|1[02])|(0[1-9]|1[0-9]|2[0-8])[/]?02)[/]?[0-9]{4}|
    29[/]?02[/]?([0-9]{2}(([2468][048]|[02468][48])|[13579][26])|([13579][26]|[02468][048]|0[0-9]|1[0-6])00))$"""


  fld.errmsg      = errmsg      # / message this field
  fld.help        = help        # / help this field
  fld.switch      = false       # / CTRUE CFALSE
  fld.err         = false       # / zone error False
  fld.actif       = actif       # / zone active True

  fld.process     = ""          # / name calls proc or pgm

  fld.style  = fld_atr.style
  fld.backgr = fld_atr.backgr
  fld.backbr = fld_atr.backbr
  fld.foregr = fld_atr.foregr
  fld.forebr = fld_atr.forebr

  fld.pstyle  = protect_atr.style
  fld.pbackgr = protect_atr.backgr
  fld.pbackbr = protect_atr.backbr
  fld.pforegr = protect_atr.foregr
  fld.pforebr = protect_atr.forebr
  return fld




## Define Field Numeric
proc defNumeric*(name:string ; posx:Natural; posy:Natural; reftyp: REFTYP;
              width: Natural;  scal: Natural;  text: string; empty:bool;
              errmsg: string   ; help: string;
              fld_atr : ZONATRB = fldatr ;protect_atr : ZONATRB = prtatr ;
              actif: bool = true) : FIELD =

  var fld : FIELD

  fld.name        = name
  fld.posx        = posx
  fld.posy        = posy
  fld.reftyp      = reftyp      # / ALPHA...SWITCH
  fld.width       = width
  fld.scal        = scal
  fld.nbrcar      = width + scal
  if scal > 0 : inc(fld.nbrcar)
  fld.text        = text
  fld.empty       = empty
  fld.protect     = false       # / only display
  fld.pading      = true        # / pading blank
  fld.edtcar      = ""          # / edtcar for monnaie		€ $ ¥ ₪ £ or %
  fld.regex       = ""          # / contrôle


  if fld.reftyp == DIGIT:
    fld.regex = "^[0-9]{1,$1}$" % [$width]
  elif fld.reftyp == DIGIT_SIGNED:
    inc(fld.nbrcar)
    fld.regex = "^[+-]?[0-9]{1,$1}$" % [$width]


  if fld.reftyp == DECIMAL:
    if (scal == 0 ) :
        fld.regex = "^[0-9]{1,$1}$" % [$width]
    else :
        fld.regex = "^[0-9]{1,$1}[.]([0-9]{$2,$2})$" % [$width,$scal,$scal]
  elif fld.reftyp == DECIMAL_SIGNED:
    inc(fld.nbrcar)
    if (scal == 0 ) :
        fld.regex = "^[+-]?[0-9]{1,$1}$" % [$width]
    else :
        fld.regex = "^[+-]?[0-9]{1,$1}[.]([0-9]{$2,$2})$" % [$width,$scal,$scal]

  fld.errmsg      = errmsg      # / message this field
  fld.help        = help        # / help this field
  fld.switch      = false       # / CTRUE CFALSE
  fld.err         = false       # / zone error False
  fld.actif       = actif       # / zone active True

  fld.process     = ""          # / name calls proc or pgm


  fld.style  = fld_atr.style
  fld.backgr = fld_atr.backgr
  fld.backbr = fld_atr.backbr
  fld.foregr = fld_atr.foregr
  fld.forebr = fld_atr.forebr

  fld.pstyle  = protect_atr.style
  fld.pbackgr = protect_atr.backgr
  fld.pbackbr = protect_atr.backbr
  fld.pforegr = protect_atr.foregr
  fld.pforebr = protect_atr.forebr
  return fld

## Define Field Numeric
proc defTelephone*(name:string ; posx:Natural; posy:Natural; reftyp: REFTYP;
              width: Natural;  text: string; empty:bool;
              errmsg: string   ; help: string;
              fld_atr : ZONATRB = fldatr ;protect_atr : ZONATRB = prtatr ;
              actif: bool = true) : FIELD =

  var fld : FIELD

  fld.name        = name
  fld.posx        = posx
  fld.posy        = posy
  fld.reftyp      = reftyp      # / ALPHA...SWITCH
  fld.width       = width
  fld.scal        = 0
  fld.nbrcar      = width + 2
  fld.text        = text
  fld.empty       = empty
  fld.protect     = false       # / only display
  fld.pading      = true        # / pading blank
  fld.edtcar      = ""          # / edtcar for monnaie		€ $ ¥ ₪ £ or %
  fld.regex = "^[+]*[(]{0,1}[0-9]{1,3}[)]{0,1}[-\\s\\./0-9]*$"
  if errmsg == "" : fld.errmsg = "format (033)1234567890"
  else : fld.errmsg      = errmsg      # / message this field
  fld.help        = help        # / help this field
  fld.switch      = false       # / CTRUE CFALSE
  fld.err         = false       # / zone error False
  fld.actif       = actif       # / zone active True

  fld.process     = ""          # / name calls proc or pgm


  fld.style  = fld_atr.style
  fld.backgr = fld_atr.backgr
  fld.backbr = fld_atr.backbr
  fld.foregr = fld_atr.foregr
  fld.forebr = fld_atr.forebr

  fld.pstyle  = protect_atr.style
  fld.pbackgr = protect_atr.backgr
  fld.pbackbr = protect_atr.backbr
  fld.pforegr = protect_atr.foregr
  fld.pforebr = protect_atr.forebr
  return fld

## Hiden bloc out
proc defStringH*( name:string ; reftyp: REFTYP;text: string;) : HIDEN =
  var hdn : HIDEN
  hdn.name        = name
  hdn.reftyp      = reftyp      # / ALPHA...SWITCH
  hdn.text        = text
  hdn.switch      = false       # / CTRUE CFALSE
  return hdn
##switch
proc defSwitchH*( name:string; reftyp: REFTYP;  switch: bool;) : HIDEN =
  var hdn : HIDEN
  hdn.name        = name
  hdn.reftyp      = reftyp      # / ALPHA...SWITCH
  hdn.text       = ""
  hdn.switch      = switch      # / CTRUE CFALSE
  return hdn



##  get lines/COLS PANEL
proc Lines*(pnl: PANEL) :Natural =
  result = pnl.lines

proc Cols*(pnl: PANEL) :Natural =
  result = pnl.cols

## return index actived from panel this getField
proc Index*(pnl: PANEL): Natural =
  result = pnl.index

## Define PANEL
proc newPanel*(name:string;posx,posy,height,width,:Natural;button: seq[(BUTTON)];
              cadre : CADRE = line0; title : string = "",pnl_atr : ZONATRB = pnlatr) : PANEL =
  var pnl = new(PANEL)
  pnl.name  = name
  pnl.posx  = posx
  pnl.posy  = posy
  pnl.lines  = height
  pnl.cols  = width
  pnl.backgr  = pnl_atr.backgr
  pnl.backbr  = pnl_atr.backbr
  pnl.foregr  = pnl_atr.foregr
  pnl.forebr  = pnl_atr.forebr
  pnl.style   = pnl_atr.style

  pnl.cadre   = cadre

  if pnl.cadre == CADRE.line1 or pnl.cadre == CADRE.line2 :
    pnl.boxpnl  = defBox(name, 1 , 1 ,pnl.lines, pnl.cols, cadre, title)


  pnl.box  = newseq[BOX]()
  pnl.label  = newseq[LABEL]()
  pnl.field  = newseq[FIELD]()
  pnl.hiden  = newseq[HIDEN]()
  pnl.index = 0
  pnl.button  = newseq[BUTTON](len(button))
  pnl.button   = button
  pnl.funcKey = newseq[TKey](len(button))

  for i,btn in pnl.button :
    pnl.funcKey[i] = btn.key

  pnl.mouse = false
  pnl.buf = newSeq[TerminalChar]((pnl.lines+1)*(pnl.cols+1))

  pnl.actif = true
  return pnl

proc updPanel*(pnl :var PANEL; name:string;posx,posy,height,width,:Natural;button: seq[(BUTTON)];
              cadre : CADRE = line0; title : string = "",pnl_atr : ZONATRB = pnlatr) =
  pnl.name  = name
  pnl.posx  = posx
  pnl.posy  = posy
  pnl.lines  = height
  pnl.cols  = width
  pnl.backgr  = pnl_atr.backgr
  pnl.backbr  = pnl_atr.backbr
  pnl.foregr  = pnl_atr.foregr
  pnl.forebr  = pnl_atr.forebr
  pnl.style   = pnl_atr.style

  pnl.cadre   = cadre

  if pnl.cadre == CADRE.line1 or pnl.cadre == CADRE.line2 :
    pnl.boxpnl  = defBox(name, 1 , 1 ,pnl.lines, pnl.cols, cadre, title)

  pnl.index = 0

  pnl.button  = newseq[BUTTON](len(button))
  pnl.button   = button
  pnl.funcKey = newseq[TKey](len(button))
  for i,btn in pnl.button :
    pnl.funcKey[i] = btn.key

  pnl.mouse = false

  pnl.buf = newSeq[TerminalChar]((pnl.lines+1)*(pnl.cols+1))

  pnl.actif = true







## assigne FIELD to matrice for display
proc printField*(pnl: var PANEL, fld : Field) =
  var i: Natural = 0

  var e_FIELD : string = fld.text

  if fld.reftyp == DATE_ISO or fld.reftyp == DATE_US or fld.reftyp == DATE_FR :
    i = 0
    if e_FIELD == "" :
      while i < 10:
        e_FIELD = e_FIELD & " "
        inc(i)


  if fld.reftyp == PASSWORD:
    i = 0
    e_FIELD = ""
    while i < runeLen(fld.text):
        e_FIELD = e_FIELD & "*"
        inc(i)
  if fld.text != "":
    if fld.reftyp == DIGIT_SIGNED or fld.reftyp == DECIMAL_SIGNED:
      if isDigit(char(fld.text[0])):
        e_FIELD = "+" & fld.text

  if  fld.pading and fld.reftyp == DIGIT or
      fld.pading and fld.reftyp == DIGIT_SIGNED or
      fld.pading and fld.reftyp == DECIMAL or
      fld.pading and fld.reftyp == DECIMAL_SIGNED:
        e_FIELD = align(e_FIELD,fld.nbrcar)
  elif fld.pading :   e_FIELD = alignString(e_FIELD,fld.nbrcar)


  if fld.reftyp == SWITCH:
    if fld.switch == true:
      e_FIELD = "◉"
    else:
      e_FIELD = "◎"

  if fld.edtcar != "":
    e_FIELD = e_FIELD & fld.edtcar

  var npos = pnl.cols * fld.posx
  var n =  npos + fld.posy
  for ch in runes(e_FIELD):
    if fld.actif == true :
      pnl.buf[n].ch = ch
      if fld.protect :
        pnl.buf[n].bg  = fld.pbackgr
        pnl.buf[n].bgb = fld.pbackbr
        pnl.buf[n].fg  = fld.pforegr
        pnl.buf[n].fgb = fld.pforebr
        pnl.buf[n].style =  fld.pstyle
        pnl.buf[n].on = true
      else:
        pnl.buf[n].bg  = fld.backgr
        pnl.buf[n].bgb = fld.backbr
        pnl.buf[n].fg  = fld.foregr
        pnl.buf[n].fgb = fld.forebr
        pnl.buf[n].style =  fld.style
        pnl.buf[n].on = true
    else :
        pnl.buf[n].ch = " ".runeAt(0)
        pnl.buf[n].bg  = pnl.backgr
        pnl.buf[n].bgb = pnl.backbr
        pnl.buf[n].fg  = pnl.foregr
        pnl.buf[n].fgb = pnl.forebr
        pnl.buf[n].style =  pnl.style
        pnl.buf[n].on = false
    inc(n)





## assigne BUTTON matrice for display
proc printButton*(pnl: var PANEL; btn_esp : BTNSPACE = btnspc )  =
  var x,y :Natural
  if pnl.cadre == CADRE.line0 :
    x = Lines(pnl)
    y = 1
  else:
    x = Lines(pnl) - int(1)
    y = 2

  var npos = pnl.cols * x
  var s : string
  var n =  npos + y

  for i,btn in pnl.button:
    s = $btn.key
    if btn.text > "" :
      if btn.actif :
        for ch in runes(s):
          pnl.buf[n].ch = ch
          pnl.buf[n].bg  = btnatr.backgr
          pnl.buf[n].bgb = btnatr.backbr
          pnl.buf[n].fg  = btnatr.foregr
          pnl.buf[n].fgb = btnatr.forebr
          pnl.buf[n].style = btnatr.style
          pnl.buf[n].on = true
          inc(n)
        n += 1
        for ch in runes(btn.text):
          pnl.buf[n].ch = ch
          pnl.buf[n].bg  = btnatr.title_backgr
          pnl.buf[n].bgb = btnatr.title_backbr
          pnl.buf[n].fg  = btnatr.title_foregr
          pnl.buf[n].fgb = btnatr.title_forebr
          pnl.buf[n].style = btnatr.title_style
          pnl.buf[n].on = true
          inc(n)
      else :
        for ch in runes(s):
          pnl.buf[n].ch = " ".runeAt(0)
          pnl.buf[n].bg  = pnl.backgr
          pnl.buf[n].bgb = pnl.backbr
          pnl.buf[n].fg  = pnl.foregr
          pnl.buf[n].fgb = pnl.forebr
          pnl.buf[n].style =  pnl.style
          pnl.buf[n].on = false
          inc(n)
        n += 1
        for ch in runes(btn.text):
          pnl.buf[n].ch = " ".runeAt(0)
          pnl.buf[n].bg  = pnl.backgr
          pnl.buf[n].bgb = pnl.backbr
          pnl.buf[n].fg  = pnl.foregr
          pnl.buf[n].fgb = pnl.forebr
          pnl.buf[n].style =  pnl.style
          pnl.buf[n].on = false
          inc(n)

      n += btn_esp.space



## display matrice PANEL
proc displayPanel*(pnl: PANEL) =
  if not pnl.actif : return
  var npos :int =0
  for x in 1..pnl.lines:
    npos = pnl.cols * x
    for y in 1..pnl.cols:
      inc(npos)
      gotoXY(x + pnl.posx - 1 , y + pnl.posy - 1)
      if pnl.buf[npos].on :
        setBackgroundColor(pnl.buf[npos].bg,pnl.buf[npos].bgb)
        setForegroundColor(pnl.buf[npos].fg,pnl.buf[npos].fgb)
        writeStyled($pnl.buf[npos].ch,pnl.buf[npos].style)
      else :
        setStyle(pnl.style)
        setBackgroundColor(pnl.backgr,pnl.backbr)
        setForegroundColor(pnl.foregr,pnl.forebr)
        writeStyled(" ",pnl.style)
  stdout.flushFile()





## assigne PANEL and all OBJECT to matrice for display
proc printPanel*(pnl: var PANEL)=
  if pnl.cadre == CADRE.line1 or pnl.cadre == CADRE.line2 :
    printBox(pnl,pnl.boxpnl)

  for i in 0..len(pnl.box)-1:
    if pnl.box[i].actif    : printBox(pnl,pnl.box[i])

  for i in 0..len(pnl.label)-1:
    if pnl.label[i].actif : printLabel(pnl,pnl.label[i])

  for i in 0..len(pnl.field)-1:
    if pnl.field[i].actif : printField(pnl,pnl.field[i])

  printButton(pnl)
  displayPanel(pnl)



## vide object PANEL / box/label/fld/proc
proc resetPanel*(pnl: var PANEL)=
  pnl.name  = ""
  pnl.posx  = 0
  pnl.posy  = 0
  pnl.lines = 0
  pnl.cols  = 0
  pnl.box    = newseq[BOX]()
  pnl.label  = newseq[LABEL]()
  pnl.field  = newseq[FIELD]()
  pnl.hiden  = newseq[HIDEN]()
  pnl.index  = 0
  pnl.button= newseq[BUTTON]()
  pnl.funcKey = newseq[TKey]()
  pnl.buf = newSeq[TerminalChar]()
  pnl.actif = false





## vide object MENU
proc resetMenu*(mnu: var MENU)=
  mnu.selMenu  = 0
  mnu.item = newseq[string]()
  mnu.actif = false





## cls Label
proc clsLabel*(pnl: var PANEL, lbl : Label) =
  var npos = pnl.cols * lbl.posx
  var n =  npos + lbl.posy
  for i in 0..<runeLen(lbl.text):
    pnl.buf[n].ch = " ".runeAt(0)
    pnl.buf[n].bg  = pnl.backgr
    pnl.buf[n].bgb = pnl.backbr
    pnl.buf[n].fg  = pnl.foregr
    pnl.buf[n].fgb = pnl.forebr
    pnl.buf[n].style =  pnl.style
    pnl.buf[n].on = false
    inc(n)



## csl Field
proc clsField*(pnl: var PANEL, fld : Field) =
  var npos = pnl.cols * fld.posx
  var n =  npos + fld.posy
  for i in 0..<fld.nbrcar:
    pnl.buf[n].ch = " ".runeAt(0)
    pnl.buf[n].bg  = pnl.backgr
    pnl.buf[n].bgb = pnl.backbr
    pnl.buf[n].fg  = pnl.foregr
    pnl.buf[n].fgb = pnl.forebr
    pnl.buf[n].style =  pnl.style
    pnl.buf[n].on = false
    inc(n)




## cls Panel
proc clsPanel*(pnl: var PANEL) =
  var n =  0
  for x in 1..pnl.lines:
    for y in 1..pnl.cols:
      gotoXY(x + pnl.posx - 1 , y + pnl.posy - 1)
      setBackgroundColor(pnl.backgr,pnl.backbr)
      setForegroundColor(pnl.foregr,pnl.forebr)
      writeStyled(" ",pnl.style)
      pnl.buf[n].on = false
      inc(n)
  stdout.flushFile()







## display matrice only LABEL
proc displayLabel*(pnl: var PANEL; lbl: Label) =
  if not pnl.actif :
    return
  if not lbl.actif : clsLabel(pnl, lbl)
  else : printLabel(pnl , lbl)

  var npos :int = pnl.cols * lbl.posx
  var n =  npos + lbl.posy
  for y in 0..<runeLen(lbl.text):
    gotoXY(lbl.posx + pnl.posx - 1 , y + pnl.posy + lbl.posy - 1)
    if pnl.buf[n].on :
      setBackgroundColor(pnl.buf[n].bg,pnl.buf[n].bgb)
      setForegroundColor(pnl.buf[n].fg,pnl.buf[n].fgb)
      writeStyled($pnl.buf[n].ch,pnl.buf[n].style)
    else :
      setBackgroundColor(pnl.backgr,pnl.backbr)
      setForegroundColor(pnl.foregr,pnl.forebr)
      writeStyled(" ",pnl.style)
    inc(n)
  stdout.flushFile()





## display matrice only FIELD
proc displayField*(pnl: var  PANEL; fld: FIELD) =
  if not pnl.actif : return
  if not fld.actif : clsField(pnl, fld)
  else : printField(pnl,fld)

  var npos :int = pnl.cols * fld.posx
  var n =  npos + fld.posy
  for y in 0..<fld.nbrcar:
    gotoXY(fld.posx + pnl.posx - 1 , y + pnl.posy + fld.posy - 1)
    if pnl.buf[n].on :
      setBackgroundColor(pnl.buf[n].bg,pnl.buf[n].bgb)
      setForegroundColor(pnl.buf[n].fg,pnl.buf[n].fgb)
      writeStyled($pnl.buf[n].ch,pnl.buf[n].style)
    else :
      setStyle(pnl.style)
      setBackgroundColor(pnl.backgr,pnl.backbr)
      setForegroundColor(pnl.foregr,pnl.forebr)
      writeStyled(" ",pnl.style)
    inc(n)
  stdout.flushFile()





## display matrice only BUTTON
proc displayButton*(pnl: var PANEL;) =
  if not pnl.actif : return

  printButton(pnl)
  var x,y :Natural
  if pnl.cadre == CADRE.line0 :
    x = Lines(pnl)
    y = 1
  else:
    x = Lines(pnl) - int(1)
    y = 2

  var npos = pnl.cols * x

  var n =  npos + y
  for y in 0..<pnl.cols:
    gotoXY(x + pnl.posx - 1 , y + pnl.posy  - 1)
    if pnl.buf[n].on :
      setBackgroundColor(pnl.buf[n].bg,pnl.buf[n].bgb)
      setForegroundColor(pnl.buf[n].fg,pnl.buf[n].fgb)
      writeStyled($pnl.buf[n].ch,pnl.buf[n].style)
    else :
      setStyle(pnl.style)
      setBackgroundColor(pnl.backgr,pnl.backbr)
      setForegroundColor(pnl.foregr,pnl.forebr)
      writeStyled(" ",pnl.style)
    inc(n)
  stdout.flushFile()





## restore the base occupied by pnl
proc restorePanel*(dst: PANEL; src:var PANEL) =
  if not dst.actif : return

  if src.posx <= dst.posx  and  src.posy >= dst.posy:
    clsPanel(src)
    displayPanel(dst)
    return

  var npos :int =0
  var n = src.posx - dst.posx

  for x in 0..src.lines:
    npos = dst.cols * n + src.posy - dst.posy
    for y in 0..src.cols:
      inc(npos)
      gotoXY(x + src.posx - 1, y  + src.posy )
      if dst.buf[npos].on :
        setStyle(dst.buf[npos].style)
        setBackgroundColor(dst.buf[npos].bg,dst.buf[npos].bgb)
        setForegroundColor(dst.buf[npos].fg,dst.buf[npos].fgb)
        writeStyled($dst.buf[npos].ch,dst.buf[npos].style)
      else :
        setStyle(dst.style)
        setBackgroundColor(dst.backgr,dst.backbr)
        setForegroundColor(dst.foregr,dst.forebr)
        writeStyled(" ",dst.style)
    inc(n)
  stdout.flushFile()





## restore the base occupied by mnu
proc restorePanel*(dst: PANEL; mnu: MENU) =
  if not dst.actif : return
  var npos :int =0
  var n = mnu.posx
  for x in 0..mnu.lines:
    npos = dst.cols * n + mnu.posy - 1
    for y in 0..mnu.cols:
      inc(npos)
      gotoXY(x + mnu.posx + dst.posx - 1 , y + mnu.posy + dst.posy - 1 )
      if dst.buf[npos].on :
        setBackgroundColor(dst.buf[npos].bg,dst.buf[npos].bgb)
        setForegroundColor(dst.buf[npos].fg,dst.buf[npos].fgb)
        writeStyled($dst.buf[npos].ch,dst.buf[npos].style)
      else :
        setBackgroundColor(dst.backgr,dst.backbr)
        setForegroundColor(dst.foregr,dst.forebr)
        writeStyled(" ",dst.style)
    inc(n)
  stdout.flushFile()




## restore the base occupied by grid
proc restorePanel*(dst: PANEL; grid: GRIDSFL) =
  if not dst.actif : return
  var npos :int =0
  var n = grid.posx
  for x in 0..grid.lines + 1:
    npos = dst.cols * n + grid.posy - 1
    for y in 0..grid.cols:
      inc(npos)
      gotoXY(x + grid.posx + dst.posx - 1 , y + grid.posy + dst.posy - 1 )
      if dst.buf[npos].on :
        setBackgroundColor(dst.buf[npos].bg,dst.buf[npos].bgb)
        setForegroundColor(dst.buf[npos].fg,dst.buf[npos].fgb)
        writeStyled($dst.buf[npos].ch,dst.buf[npos].style)
      else :
        setBackgroundColor(dst.backgr,dst.backbr)
        setForegroundColor(dst.foregr,dst.forebr)
        writeStyled(" ",dst.style)
    inc(n)
  stdout.flushFile()


## restore the lines occupied by the error message
proc restorePanel*(pnl: PANEL; lines, posy : Natural) =
  if not pnl.actif : return
  var npos :int =0
  var x = lines
  npos = (pnl.cols * x)
  for y in 1..pnl.cols:
    inc(npos)
    gotoXY(x + pnl.posx - 1 , y + pnl.posy  - 1)
    if pnl.buf[npos].on  :
      setBackgroundColor(pnl.buf[npos].bg,pnl.buf[npos].bgb)
      setForegroundColor(pnl.buf[npos].fg,pnl.buf[npos].fgb)
      writeStyled($pnl.buf[npos].ch,pnl.buf[npos].style)
    else :
      setBackgroundColor(pnl.backgr,pnl.backbr)
      setForegroundColor(pnl.foregr,pnl.forebr)
      writeStyled(" ",pnl.style)
  stdout.flushFile()


## return name From Panel
proc getPnlName*(pnl: PANEL): string  =
  result = pnl.name
## return Title From Panel
proc getPnlTitle*(pnl: PANEL): string  =
  return pnl.boxpnl.title



## return index Sequence Label from name
proc getIndexL*(pnl: PANEL; name: string): int  =
  for i in 0..len(pnl.label)-1:
    if pnl.label[i].name == name : return i
  return - 1
## return name label Sequence Field
proc getNameL*(pnl: PANEL; index: int): string  =
  if index < 0 or index > len(pnl.label)-1 : return "NAN"
  return pnl.label[index].name
## return Posx label Sequence Field
proc getPosxL*(pnl: PANEL; index: int): int  =
  if index < 0 or index > len(pnl.label)-1 : return -1
  return pnl.label[index].posx
## return Posy label Sequence Field
proc getPosyL*(pnl: PANEL; index: int): int  =
  if index < 0 or index > len(pnl.label)-1 : return -1
  return pnl.label[index].posy
## return value label Sequence Label
proc getTextL*(pnl: PANEL; index: int): string  =
  if index < 0 or index > len(pnl.label)-1 : return "NAN"
  return pnl.label[index].text
## test Title label Sequence Label
proc isTitle*(pnl: PANEL; index: int): bool  =
  if index < 0 or index > len(pnl.label)-1 : return false
  return pnl.label[index].title

## return value Label Sequence from name
proc getTextL*(pnl: PANEL; name: string): string  =
  for i in 0..len(pnl.label)-1 :
    if pnl.label[i].name == name :
      return pnl.label[i].text
  return "NAN"
## set value Label Sequence Label
proc setTextL*(pnl: PANEL; name: string; val : string)=
  for i in 0..len(pnl.label)-1 :
    if pnl.label[i].name == name :
      pnl.label[i].text = val
      break
## set value Label Sequence Label
proc setTextL*(pnl: PANEL; index: int; val : string) =
  if index < 0 or index > len(pnl.label)-1 : return
  pnl.label[index].text = val
## set value Label Sequence Label
proc setTitle*(pnl: PANEL; index: int; val : bool) =
  if index < 0 or index > len(pnl.label)-1 : return
  pnl.label[index].title = val
##  delete Label Sequence Label
proc dltLabel*(pnl: PANEL; idx : Natural) =
  if idx >= 0 or idx <= len(pnl.label)-1 :
    pnl.label.del(idx)





## clear value ALL FIELD
proc clearText*(pnl: var PANEL)=
  for i in 0..len(pnl.field)-1:
    pnl.field[i].text = ""

## return name field from panel this getField
proc getName*(pnl: PANEL): string =
  result = pnl.field[pnl.index].name



## return callVoid Field Sequence Field
proc getProcess*(pnl: PANEL; index: int): string  =
  if index < 0 or index > len(pnl.field)-1 : return ""
  return pnl.field[index].process
## return name Field Sequence Field
proc getName*(pnl: PANEL; index: int): string  =
  if index < 0 or index > len(pnl.field)-1 : return "NAN"
  return pnl.field[index].name
## return Posx Field Sequence Field
proc getPosx*(pnl: PANEL; index: int): int  =
  if index < 0 or index > len(pnl.field)-1 : return 0
  return pnl.field[index].posx
## return Posy Field Sequence Field
proc getPosy*(pnl: PANEL; index: int): int  =
  if index < 0 or index > len(pnl.field)-1 : return 0
  return pnl.field[index].posy
## return Type Field Sequence Field
proc getRefType*(pnl: PANEL; index: int): REFTYP  =
  if index < 0 or index > len(pnl.field)-1 : return ALPHA
  return pnl.field[index].reftyp
## return width Field Sequence Field
proc getWidth*(pnl: PANEL; index: int): int  =
  if index < 0 or index > len(pnl.field)-1 : return 0
  return pnl.field[index].width
## return Scal Field Sequence Field
proc getScal*(pnl: PANEL; index: int): int  =
  if index < 0 or index > len(pnl.field)-1 : return 0
  return pnl.field[index].scal
## return Empty Field Sequence Field
proc getEmpty*(pnl: PANEL; index: int): bool  =
  if index < 0 or index > len(pnl.field)-1 : return true
  return pnl.field[index].empty
## return errmsg Field Sequence Field
proc getErrmsg*(pnl: PANEL; index: int): string  =
  if index < 0 or index > len(pnl.field)-1 : return "NAN"
  return pnl.field[index].errmsg
## return help Field Sequence Field
proc getHelp*(pnl: PANEL; index: int): string  =
  if index < 0 or index > len(pnl.field)-1 : return "NAN"
  return pnl.field[index].help
## return Edtcar Field Sequence Field
proc getEdtcar*(pnl: PANEL; index: int): string  =
  if index < 0 or index > len(pnl.field)-1 : return "NAN"
  return pnl.field[index].edtcar
## return Protect Field Sequence Field
proc getProtect*(pnl: PANEL; index: int): bool =
  if index < 0 or index > len(pnl.field)-1 : return false
  return pnl.field[index].protect
## return value Field Sequence Field
proc getText*(pnl: PANEL; index: int): string  =
  if index < 0 or index > len(pnl.field)-1 : return "NAN"
  return pnl.field[index].text
## return value Field Sequence Field
proc getSwitch*(pnl : PANEL ; index: int): bool  =
  if index < 0 or index > len(pnl.field)-1 : return false
  return pnl.field[index].switch




## return value Field Sequence Field
proc getText*(pnl: PANEL; name: string): string  =
  for i in 0..len(pnl.field)-1 :
    if pnl.field[i].name == name :
      return pnl.field[i].text
  return "NAN"
## return value Field Sequence Field
proc getSwitch*(pnl : PANEL ; name: string): bool  =
  for i in 0..len(pnl.hiden)-1 :
    if pnl.field[i].name == name :
      return pnl.field[i].switch
  return false
## return index Field Sequence Field
proc getIndex*(pnl: PANEL; name: string): int  =
  for i in 0..len(pnl.field)-1:
    if pnl.field[i].name == name : return i
  return - 1






## set name Field Sequence Field
proc setName*(pnl: PANEL; index: int; val : string) =
  if index < 0 or index > len(pnl.field)-1 : return
  pnl.field[index].name = val
## set posx Field Sequence Field
proc setName*(pnl: PANEL; index: int; val : Natural) =
  if index < 0 or index > len(pnl.field)-1 : return
  pnl.field[index].posx = val
## set posy Field Sequence Field
proc setPosy*(pnl: PANEL; index: int; val : Natural) =
  if index < 0 or index > len(pnl.field)-1 : return
  pnl.field[index].posy = val
## set Type Field Sequence Field
proc setType*(pnl: PANEL; index: int ; val : REFTYP) =
  if index < 0 or index > len(pnl.field)-1 : return
  pnl.field[index].reftyp = val
## set width Field Sequence Field
proc setWidth*(pnl: PANEL; index: int; val : Natural) =
  if index < 0 or index > len(pnl.field)-1 : return
  pnl.field[index].width = val
## set Scal Field Sequence Field
proc setScal*(pnl: PANEL; index: int; val : Natural) =
  if index < 0 or index > len(pnl.field)-1 : return
  pnl.field[index].scal = val
## set Empty Field Sequence Field
proc setEmpty*(pnl: PANEL; index: int; val: bool ) =
  if index < 0 or index > len(pnl.field)-1 : return
  pnl.field[index].empty = val
## set errmsg Field Sequence Field
proc setErrmsg*(pnl: PANEL; index: int; val : string) =
  if index < 0 or index > len(pnl.field)-1 : return
  pnl.field[index].errmsg = val
## set help Field Sequence Field
proc setHelp*(pnl: PANEL; index: int; val : string) =
  if index < 0 or index > len(pnl.field)-1 : return
  pnl.field[index].help = val
## set Edtcar Field Sequence Field
proc setEdtcar*(pnl: PANEL; index: int; val : string) =
  if index < 0 or index > len(pnl.field)-1 : return
  pnl.field[index].edtcar = val
proc setProtect*(pnl: PANEL; index: int; val: bool )=
  if index < 0 or index > len(pnl.field)-1 : return
  pnl.field[index].protect = val

## set value Field Sequence Field
proc setText*(pnl: PANEL; name: string; val : string)=
  for i in 0..len(pnl.field)-1 :
    if pnl.field[i].name == name :
      pnl.field[i].text = val
      break

## set regex Field Sequence Field
proc setRegex*(pnl: PANEL; name: string; val : string)=
  for i in 0..len(pnl.field)-1 :
    if pnl.field[i].name == name :
      pnl.field[i].regex = val
      break

## set value Field Sequence Fiel
proc setSwitch*(pnl : PANEL ; name: string; val : bool): bool  =
  for i in 0..len(pnl.hiden)-1 :
    if pnl.field[i].name == name :
      pnl.field[i].switch = val

## set value Field Sequence Field
proc setText*(pnl: PANEL; index: int; val : string) =
  if index < 0 or index > len(pnl.field)-1 : return
  pnl.field[index].text = val

## set regex Field Sequence Field
proc setRegex*(pnl: PANEL; index: int; val : string) =
  if index < 0 or index > len(pnl.field)-1 : return
  pnl.field[index].regex = val

## setvalue Field Sequence Fiel
proc setSwitch*(pnl : PANEL ; index: int; val : bool)  =
  if index < 0 or index > len(pnl.field)-1 : return
  pnl.field[index].switch = val

## delete Field Sequence Field
proc dltField*(pnl: PANEL; idx : Natural) =
  if idx >= 0 or idx <= len(pnl.field)-1 :
    pnl.field.del(idx)

proc isProcess*(pnl: PANEL; index: int): bool  =
  if index < 0 or index > len(pnl.field)-1 : return false
  if pnl.field[index].process != "" : return true
  return false



## return name from index
proc getNameH*(hdn: PANEL,index: int): string =
  result = hdn.hiden[index].name
## return index from Name
proc getIndexH*(hdn : PANEL; name: string): int  =
  for i in 0..len(hdn.hiden)-1:
    if hdn.hiden[i].name == name : return i
  return - 1
## return value Field from name
proc getTextH*(hdn : PANEL ; name: string): string  =
  for i in 0..len(hdn.hiden)-1 :
    if hdn.hiden[i].name == name :
      return hdn.hiden[i].text
  return "NAN"
## return value Field from name
proc getSwitchH*(hdn : PANEL ; name: string): bool  =
  for i in 0..len(hdn.hiden)-1 :
    if hdn.hiden[i].name == name :
      return hdn.hiden[i].switch
  return false
## return value Field from index
proc getTextH*(hdn : PANEL ; index: int): string  =
  if index < 0 or index > len(hdn.hiden)-1 : return "NAN"
  return hdn.hiden[index].text
## return value Field from index
proc getSwitchH*(hdn : PANEL ; index: int): bool  =
  if index < 0 or index > len(hdn.field)-1 : return false
  return hdn.hiden[index].switch

## delete Field Sequence Field
proc dltFieldH*(hdn : PANEL; idx : Natural) =
  if idx >= 0 or idx <= len(hdn.hiden)-1 :
    hdn.hiden.del(idx)





## return nbrCar Field
proc getNbrcar*(pnl: PANEL; name: string): int  =
  for i in 0..len(pnl.field)-1 :
    if pnl.field[i].name == name : return pnl.field[i].nbrcar
  return -1                                                 # Warning possibility out of sequence
## return nbrCar Field
proc getReftype*(pnl: PANEL; name: string): REFTYP  =
  for i in 0..len(pnl.field)-1 :
    if pnl.field[i].name == name : return pnl.field[i].reftyp
  return TEXT_FREE


##  set attribut display label
proc setColor*(lbl : var LABEL  ; lbl_atr : ZONATRB)=
  lbl.style  = lbl_atr.style
  lbl.backgr = lbl_atr.backgr
  lbl.backbr = lbl_atr.backbr
  lbl.foregr = lbl_atr.foregr
  lbl.forebr = lbl_atr.forebr

##  set attribut display field
proc setColor*(fld : var FIELD ; fld_atr : ZONATRB)=
  fld.style  = fld_atr.style
  fld.backgr = fld_atr.backgr
  fld.backbr = fld_atr.backbr
  fld.foregr = fld_atr.foregr
  fld.forebr = fld_atr.forebr
proc setColorProtect*(fld : var FIELD ; protect_atr : ZONATRB)=
  fld.pstyle  = protect_atr.style
  fld.pbackgr = protect_atr.backgr
  fld.pbackbr = protect_atr.backbr
  fld.pforegr = protect_atr.foregr
  fld.pforebr = protect_atr.forebr
##  set on  = display ONLY
proc setProtect*(fld : var FIELD ; protect : bool)= fld.protect = protect
proc setEdtCar*(fld : var FIELD ; Car : string)=    fld.edtcar = Car
proc setError*(fld : var FIELD; val :bool )=        fld.err = val

## Enables or disables FIELD / LABEL / BOX / MENU / PANEL
proc setActif*(fld : var FIELD ; actif : bool)= fld.actif = actif
proc setActif*(lbl : var LABEL ; actif : bool)= lbl.actif = actif
proc setActif*(box : var BOX ; actif : bool)=   box.actif = actif
proc setActif*(mnu : var MENU ; actif : bool)=  mnu.actif = actif
proc setActif*(pnl : var PANEL ; actif : bool)= pnl.actif = actif
proc setMouse*(pnl : var PANEL ; actif : bool)= pnl.actif = actif
proc setProcess*(fld : var FIELD ; process : string)=  fld.process = process

## BUTTON
proc setActif*(btn : var BUTTON; actif : bool) = btn.actif = actif
proc setCtrl*(btn : var BUTTON; ctrl : bool) = btn.ctrl = ctrl
proc setText*(btn :var BUTTON; val : string) = btn.text = val
proc getText*(btn :var BUTTON) : string = result = btn.text
proc getCtrl*(btn : var BUTTON) : bool = result = btn.ctrl
proc getName*(btn : var BUTTON) : TKey = result = btn.key



## Test if KEYs must be managed by the programmer
proc isPanelKey*(pnl: PANEL; e_key:TKey): bool =
  var i = 0
  var ok :bool = false
  while i < len(pnl.funcKey):
    if e_key == pnl.funcKey[i] : ok = true
    inc(i)
  return ok

##  if on/off  FIELD / LABEL / BOX / MENU / PANEL
proc isProtect*(fld : var FIELD): bool = return fld.protect
proc isError*(fld : var FIELD): bool = return fld.err
proc isActif*(fld : var FIELD)  : bool = return fld.actif
proc isActif*(lbl : var LABEL ) : bool = return lbl.actif
proc isActif*(box : var BOX)    : bool = return box.actif
proc isActif*(mnu : var MENU)   : bool = return mnu.actif
proc isActif*(btn : var BUTTON) : bool = return btn.actif
proc isActif*(pnl : var PANEL)  : bool = return pnl.actif
proc isMouse*(pnl : var PANEL)  : bool = return pnl.mouse


#--------------------------------------------------------
## management grid
## ----------------
## PadingField()
## calculPosCell()
## setPageGrid()
## setLastPage()
## newGrid()
## setActif()
## isActif()
## resetGrid()
## countColumns()
## setHeaders()
## defCell()
## setCellEditCar()
## getcellLen()
## getcellName()
## getIndexG()
## addRows()
## dltRows()
## countRows()
## resetRows()
##
## getrowName()
## getrowPosx()
## getrowPosy()
## isrowlTitle()
## getrowText()
##
## getRowsText()
##
## GridBox()
## printGridHeader()
## printGridRows()
## setPageGrid()
## pageUpGrid()
## pageDownGrid()
## ioGrid()
#--------------------------------------------------------

proc padingCell(text: string; cell:CELL;) :string =
  var i: Natural = 0

  var e_FIELD : string = text

  if cell.reftyp == PASSWORD:
    i = 0
    e_FIELD = ""
    while i < runeLen(text):
        e_FIELD = e_FIELD & "*"
        inc(i)

  if cell.reftyp == DIGIT_SIGNED or cell.reftyp == DECIMAL_SIGNED:
    if isDigit(char(text[0])):
      e_FIELD = "+" & text

  if  cell.reftyp == DIGIT or
      cell.reftyp == DIGIT_SIGNED or
      cell.reftyp == DECIMAL or
      cell.reftyp == DECIMAL_SIGNED:
        e_FIELD = align(e_FIELD,cell.long)
  else: e_FIELD = alignString(e_FIELD,cell.long)


  if cell.reftyp == SWITCH:
    if text == "true" or text == "1":
      e_FIELD = "◉"
    else:
      e_FIELD = "◎"

  if cell.edtcar != "":
    e_FIELD = e_FIELD & cell.edtcar
  return e_FIELD



proc calculPosCell(this: GRIDSFL) =
  var n : Natural = 1 # this.posy = separator "|"
  var pos : Natural = this.posy - 1

  for i in 0..<len(this.headers):
    if i == 0 : this.headers[i].posy = 1
    else : this.headers[i].posy = pos
    if this.headers[i].edtcar == "" :pos = this.headers[i].posy + this.headers[i].long  + n
    else : pos = this.headers[i].posy + this.headers[i].long  + n  + 1
    this.cols = pos




proc setPageGrid*(this :GRIDSFL)=
  this.lignes = len(this.rows)
  if this.lignes <= this.pagerows  :
    this.pages = 1
  else :
    this.pages = this.lignes.div(int(this.pagerows))
    if  this.lignes.floorMod(int(this.pagerows)) > 0 : this.pages += 1

proc setLastPage*(this :GRIDSFL)=
  this.curspage = this.pages

proc newGrid*(name:string ; posx:Natural; posy:Natural; pageRows :Natural;
                  separator: GridStyle = sepStyle ; grid_atr : GRIDATRB = gridatr , actif : bool = true): GRIDSFL =

  var Ngrid = new GRIDSFL
  Ngrid.name  = name
  Ngrid.posx  = posx
  Ngrid.posy  = posy
  Ngrid.lines = pagerows + 1 #  row per page line  + header
  Ngrid.separator = separator
  Ngrid.pageRows = pagerows
  Ngrid.rows = newSeq[seq[string]]()
  Ngrid.nrow = newSeq[int]()
  Ngrid.headers = newSeq[CELL]()
  Ngrid.actif = actif
  Ngrid.gridatr = grid_atr
  Ngrid.lignes  = 0
  Ngrid.pages  = 0
  Ngrid.cursligne  = -1
  Ngrid.curspage  = 1


  return Ngrid


proc isActif*(this: GRIDSFL)  : bool = return this.actif
proc setActif*(this: GRIDSFL; actif : bool) = this.actif = actif

proc resetGrid*(this: GRIDSFL) =
  this.name  = ""
  this.posx  = 0
  this.posy  = 0
  this.lines = 0
  this.cols  = 0
  this.separator = sepStyle
  this.pageRows = 0
  this.rows = newSeq[seq[string]]()
  this.nrow = newSeq[int]()
  this.headers = newSeq[CELL]()
  this.lignes  = 0
  this.pages  = 0
  this.cursligne  = 0
  this.curspage  = 0



proc counColumns*(this:  GRIDSFL): int =
  result = this.headers.len

proc countRows*(this : GRIDSFL) : int =
  result = len(this.rows)

proc setHeaders*(this: GRIDSFL, headers: seq[CELL]) =
  for cell in headers:
    this.headers.add(cell)
  calculPosCell(this)

  # this.lines + 2 = cadre + header    cols + separator  pensez interval
  this.buf = newSeq[TerminalChar]((this.lines + 2 )*(this.cols + 1))



proc defCell*(text: string; long : Natural;reftyp: REFTYP; cell_atr : CELLATRB = cellatr): CELL =
  var cell : CELL
  if text.len > long : cell.long = text.len
  else :  cell.long    = long
  cell.reftyp = reftyp
  cell.text   = text
  cell.edtcar = ""
  cell.posy   = 0
  cell.cellatr = cell_atr
  return cell

proc defCell*(text: string; long : Natural;reftyp: REFTYP; cell_ForegroundColor : string): CELL =
  var cell : CELL

  ## return color
  func toRefColor(TextColor: string ;):CELLATRB =
    var cellcolor = new(CELLATRB)
    cellcolor.cell_style = {styleDim,styleItalic}
    cellcolor.cell_backgr = BackgroundColor.bgblack
    cellcolor.cell_backbr = false
    cellcolor.cell_forebr = true

    case TextColor
      of "Black"            : cellcolor.cell_foregr = ForegroundColor.fgBlack
      of "Red"              : cellcolor.cell_foregr = ForegroundColor.fgRed
      of "Green"            : cellcolor.cell_foregr = ForegroundColor.fgGreen
      of "Yellow"           : cellcolor.cell_foregr = ForegroundColor.fgYellow
      of "Blue"             : cellcolor.cell_foregr = ForegroundColor.fgBlue
      of "Magenta"          : cellcolor.cell_foregr = ForegroundColor.fgMagenta
      of "Cyan"             : cellcolor.cell_foregr = ForegroundColor.fgCyan
      of "White"            : cellcolor.cell_foregr = ForegroundColor.fgWhite
      else : cellcolor.cell_foregr = ForegroundColor.fgCyan
    result = cellcolor



  if text.len > long : cell.long = text.len
  else :  cell.long    = long
  cell.reftyp = reftyp
  cell.text   = text
  cell.edtcar = ""
  cell.posy   = 0
  cell.cellatr = toRefColor(cell_ForegroundColor)
  return cell




proc setCellEditCar*(cell : var CELL; edtcar :string =""; )=
  cell.edtcar = edtcar



## return len from cell
proc getcellLen*(cell : var CELL): int  = return cell.long

## return index from grid,name
proc getIndexG*(this: GRIDSFL, name: string, idx : Natural = 0): int  =
  for i in 0..len(this.rows)-1:
    if this.rows[i][idx] == name : return i
  return - 1

## return name from grid,headers
proc getHeadersName*(this : GRIDSFL,r :int) : string =
  result = this.headers[r].text
## return posy from grid,headers
proc getHeadersPosy*(this : GRIDSFL,r :int) : int =
  result = this.headers[r].posy
## return type from grid,headers
proc getHeadersType*(this : GRIDSFL,r :int) : REFTYP =
  result = this.headers[r].reftyp
## return Car from grid,headers
proc getHeadersCar*(this : GRIDSFL,r :int) : string =
  result = $this.headers[r].edtcar


proc getRowsText*(this : GRIDSFL;r :int, i:int ) : string =
  ## get text from grid,rows
  result = this.rows[r][i]

##----------------------------------------------------
## ONLY for generator label or field
##----------------------------------------------------
proc getrowName*(this : GRIDSFL,r :int) : string =
  ## get name from grid,rows
  result = this.rows[r][1]

proc getrowPosx*(this : GRIDSFL,r :int) : int=
  ## get posx from grid,rows
  result = parseInt(this.rows[r][2])

proc getrowPosy*(this : GRIDSFL,r :int) : int =
  ## get posy from grid,rows
  result = parseInt(this.rows[r][3])

proc getrowType*(this : GRIDSFL,r :int) : REFTYP =
  ## get type from grid,rows
  result = parseEnum[REFTYP](this.rows[r][4])

proc isrowTitle*(this : GRIDSFL; r :int) : bool =
  ## get isTitle from grid,rows
  result = parseBool(this.rows[r][5])

proc getrowText*(this : GRIDSFL;r :int) : string =
  ## get text from grid,rows
  result = this.rows[r][6]

proc getrowWidth*(this : GRIDSFL,r :int) : int =
  ## get Width from grid,rows
  result = parseInt(this.rows[r][5])

proc getrowScal*(this : GRIDSFL,r :int) : int =
  ## get scal from grid,rows
  result = parseInt(this.rows[r][6])

proc getrowEmpty*(this : GRIDSFL,r :int) : bool =
  ## get Empty from grid,rows
  result = parseBool(this.rows[r][7])

proc getrowErrmsg*(this : GRIDSFL,r :int) : string =
  ## get errmsg from grid,rows
  result = this.rows[r][8]

proc getrowHelp*(this : GRIDSFL,r :int) : string =
  ## get help from grid,rows
  result = this.rows[r][9]

proc getrowCar*(this : GRIDSFL,r :int) : string =
  ## get Car from grid,rows
  result = this.rows[r][10]

proc isrowProtect*(this : GRIDSFL; r :int) : bool =
  ## get isProtect from grid,rows
  result = parseBool(this.rows[r][11])

proc getrowProcess*(this : GRIDSFL,r :int) : string =
  ## get Process from grid,rows
  result = this.rows[r][12]
#----------------------------------------------------





proc addRows*(this: GRIDSFL; rows:seq[string]) =
  this.rows.add(@(rows))
  setPageGrid(this)

proc dltRows*(this: GRIDSFL; idx : Natural) =
  for n in 0..len(this.rows) - 1 :
    if n >= idx and n < len(this.rows) - 1 : this.rows[n] = this.rows[n+1]
  this.rows.del(len(this.rows) - 1 )
  setPageGrid(this)


proc resetRows*(this: GRIDSFL;) =
  this.rows = newSeq[seq[string]]()
  this.nrow = newSeq[int]()
  this.lignes  = 0
  this.pages  = 0
  this.cursligne  = -1
  this.curspage  = 1



# assigne BOX to matrice for display
proc GridBox(this:GRIDSFL ;lines , cols : int ;cadre : CADRE) =
  if CADRE.line0 == cadre : return
  let ACS_Hlines     = "─"
  let ACS_Vlines     = "│"
  let ACS_UCLEFT    = "┌"
  let ACS_UCRIGHT   = "┐"
  let ACS_LCLEFT    = "└"
  let ACS_LCRIGHT   = "┘"

  let ACS_Hline2    = "═"
  let ACS_Vline2    = "║"
  let ACS_UCLEFT2   = "╔"
  let ACS_UCRIGHT2  = "╗"
  let ACS_LCLEFT2   = "╚"
  let ACS_LCRIGHT2  = "╝"

  var trait:string = ""
  var edt :bool
  var

    row: Natural = 1
    ncols: Natural
    col: Natural
    n: Natural
  while row <= lines :
    col = 1
    while col <= cols:
      edt = false

      if row == 1:
        if col == 1:
          if CADRE.line1 == cadre : trait = ACS_UCLEFT
          else: trait = ACS_UCLEFT2
          edt = true

        if col == cols:
          if CADRE.line1 == cadre : trait = ACS_UCRIGHT
          else : trait = ACS_UCRIGHT2
          edt = true

        if col > Natural(1) and col < cols:
          if CADRE.line1 == cadre : trait = ACS_Hlines
          else : trait = ACS_Hline2
          edt = true

      elif row == lines:
        if col == Natural(1) :
          if CADRE.line1 == cadre : trait = ACS_LCLEFT
          else : trait = ACS_LCLEFT2
          edt = true

        if col == cols:
          if CADRE.line1 == cadre : trait = ACS_LCRIGHT
          else : trait = ACS_LCRIGHT2
          edt = true

        if col > Natural(1) and col < cols:
          if CADRE.line1 == cadre : trait = ACS_Hlines
          else : trait = ACS_Hline2
          edt = true

      elif row > Natural(1) and row < lines:
        if col == Natural(1) or col == cols:
          if CADRE.line1 == cadre : trait = ACS_Vlines
          else : trait = ACS_Vline2
          edt = true

      if edt:
        if row == 1:
          n = col - 1
        if row > 1 :
          n =  ncols + col - 1

        this.buf[n].ch = trait.runeAt(0)
        this.buf[n].bg  =  this.gridatr.backgr
        this.buf[n].bgb =  this.gridatr.backbr
        this.buf[n].fg  =  this.gridatr.foregr
        this.buf[n].fgb =  this.gridatr.forebr
        this.buf[n].style = this.gridatr.style
        this.buf[n].on = true
      inc(col)
    ncols = ncols  +  ( cols )
    inc(row)
  stdout.flushFile()


proc printGridHeader*(this: GRIDSFL) =
  if not this.actif : return
  var buf : string
  var n : int
  let Blan : Rune = " ".runeAt(0)
  let Sep : Rune = this.separator.colSeparator.runeAt(0)

  for n in 0..<len(this.headers):
    if this.headers[n].edtcar == "" :buf &= $Sep  & $Blan.repeat(this.headers[n].long )
    else : buf &= $Sep  & $Blan.repeat(this.headers[n].long ) & $Blan
  buf = buf & $Sep

  var gridlen: int = runeLen(buf)

  for x in 1..this.lines :
    n = this.cols * x
    for ch in runes(buf):
      this.buf[n].ch = ch
      this.buf[n].bg  = this.gridatr.backgr
      this.buf[n].bgb = this.gridatr.backbr
      this.buf[n].fg  = this.gridatr.foregr
      this.buf[n].fgb = this.gridatr.forebr
      this.buf[n].style = this.gridatr.style
      this.buf[n].on = true
      inc(n)

  for i in 0..<len(this.headers):
    n = this.cols
    n =  n + this.headers[i].posy

    if this.headers[i].reftyp  == DIGIT or
      this.headers[i].reftyp == DIGIT_SIGNED or
      this.headers[i].reftyp == DECIMAL or
      this.headers[i].reftyp == DECIMAL_SIGNED:
        buf = $Blan.repeat(this.headers[i].long - runeLen(this.headers[i].text) ) & this.headers[i].text
        if this.headers[i].edtcar != "" : buf = buf  & $Blan
    else : buf = this.headers[i].text & $Blan.repeat(this.headers[i].long - runeLen(this.headers[i].text) )

    for ch in runes(buf):

      this.buf[n].ch = ch
      this.buf[n].bg  = this.gridatr.title_backgr
      this.buf[n].bgb = this.gridatr.title_backbr
      this.buf[n].fg  = this.gridatr.title_foregr
      this.buf[n].fgb = this.gridatr.title_forebr
      this.buf[n].style = this.gridatr.title_style
      this.buf[n].on = true
      inc(n)

  # this.lines + 2 = cadre + header
  GridBox(this, this.lines + 2 ,gridlen, line1 )
  for x in 0..this.lines + 1:
    n = this.cols * x
    for y in 1..this.cols:
      gotoXY(x + this.posx  , y + this.posy - 1)
      setBackgroundColor(this.buf[n].bg,this.buf[n].bgb)
      setForegroundColor(this.buf[n].fg,this.buf[n].fgb)
      writeStyled($this.buf[n].ch,this.buf[n].style)
      inc(n)
  stdout.flushFile()




proc printGridRows*(this: GRIDSFL ) =
  if not this.actif : return
  var n : int
  var start : int = 0
  this.nrow = newSeq[int]()
  if this.curspage == 0 : start = 0
  else: start = this.pagerows * (this.curspage - 1 )

  for r in 0..<this.pagerows:
    var l = r + start
    if l < this.lignes  :
      var buf :seq[string] = this.rows[l]
      this.nrow.add(l)

      for h in 0..<len(this.headers):
        n = this.cols * (2 + r)
        n =  n + this.headers[h].posy
        for ch in runes(padingCell(buf[h],this.headers[h])):
          this.buf[n].ch = ch
          this.buf[n].bg  = this.headers[h].cellatr.cell_backgr
          this.buf[n].bgb = this.headers[h].cellatr.cell_backbr
          this.buf[n].fg  = this.headers[h].cellatr.cell_foregr
          this.buf[n].fgb = this.headers[h].cellatr.cell_forebr

          if this.cursligne == r  :
            this.buf[n].style = {styleReverse}
          else :
            this.buf[n].style = this.headers[h].cellatr.cell_style
          this.buf[n].on = true
          inc(n)


    for x in 2..this.lines:
      n = this.cols * x
      for y in 1..this.cols:
        gotoXY(x + this.posx  , y + this.posy - 1)
        setBackgroundColor(this.buf[n].bg,this.buf[n].bgb)
        setForegroundColor(this.buf[n].fg,this.buf[n].fgb)
        writeStyled($this.buf[n].ch,this.buf[n].style)
        inc(n)
    stdout.flushFile()

proc setPageGrid(this: GRIDSFL; pos : Natural) =
  var vline = pos
  var start : int = 0
  if vline > len(this.rows) - 1 :
    vline = 0
  if this.lignes <= this.pagerows  :
    this.pages = 1
  else :
    this.curspage = vline.div(int(this.pagerows))
    if  vline.floorMod(int(this.pagerows)) > 0 : this.curspage += 1


  if this.curspage == 0 : start = 0
  else: start = this.pagerows * (this.curspage - 1 )
  for r in 0..<this.pagerows:
    var l = r + start
    if l == vline :
      this.cursligne = r
      break


proc pageUpGrid*(this: GRIDSFL): TKey_Grid =
  if this.curspage > 0 :
    dec(this.curspage)
    if this.curspage == 0 : this.curspage = 1
    this.cursligne = -1
    printGridHeader(this)
    printGridRows(this)
  if this.curspage == 1 : return PGHome
  else : return PGUp


proc pageDownGrid*(this: GRIDSFL): TKey_Grid =
  if this.curspage < this.pages :
    inc(this.curspage)
    if this.curspage > this.pages : this.curspage = this.pages
    this.cursligne = -1
    printGridHeader(this)
    printGridRows(this)
  if this.curspage == this.pages: return PGEnd
  else : return PGDown







#-----------------------------------------------------------------
## Management GRID enter = select  1..n 0 = abort (Escape)
## Turning on the mouse
## UP DOWn PageUP PageDown
## Automatic alignment based on the type reference
#-----------------------------------------------------------------

proc ioGrid*(this: GRIDSFL, pos: int = -1 ): (TKey , seq[string]) =        # IO Format
  var buf :seq[string]
  if not this.actif : return (TKey.None, buf)
  var grid_key:TKey = TKey.None
  var CountLigne = 0
  this.cursligne = 0
  printGridHeader(this)
  if pos >= 0 :
    setPageGrid(this,pos)
    CountLigne = this.cursligne
  offCursor()
  onMouse()
  while true :
    buf = newseq[string]()
    printGridRows(this)


    stdin.flushFile()
    grid_key = getFunc()

    if grid_key == TKey.Mouse :
      let gridMouse = getMouse()
      grid_key = TKey.None
      if gridMouse.action == MouseButtonAction.mbaPressed:
        if gridMouse.scroll and gridMouse.scrollDir == ScrollDirection.sdUp   :
          grid_key = TKey.Up
        if gridMouse.scroll and gridMouse.scrollDir == ScrollDirection.sdDown :
          grid_key = TKey.Down

        if  gridMouse.button ==  MouseButton.mbLeft : grid_key = TKey.Enter
        if  gridMouse.button ==  MouseButton.mbRight : grid_key = TKey.Enter

      if grid_key == TKey.None : continue

    case grid_Key
      of TKey.Escape :

        this.cursligne = -1
        return (TKey.Escape,buf)
      of TKey.Enter:
        if this.lignes > 0  :
          this.cursligne = -1
          buf = this.rows[this.nrow[CountLigne]]
          offMouse()
          return (TKey.Enter,buf)
        else : return (TKey.None,buf)
      of TKey.Up :
        if CountLigne > 0 :
          dec(CountLigne)
          this.cursligne = CountLigne
      of TKey.Down :
        if CountLigne < len(this.nrow) - 1  :
          inc(CountLigne)
          this.cursligne = CountLigne

      of TKey.PageUp :
        if this.curspage > 0 :
          dec(this.curspage)
          this.cursligne = 0
          CountLigne = 0
          printGridHeader(this)
      of TKey.PageDown :
        if this.curspage < this.pages :
          inc(this.curspage)
          this.cursligne = 0
          CountLigne = 0
          printGridHeader(this)


      else :discard

#-----------------------------------------------------------------
## Management GRID enter = select  1..n 0 = abort (Escape) only for generator
## only emulation combo or grid
#-----------------------------------------------------------------
proc ioGridGen*(this: GRIDSFL, pos: int = -1 ): (TKey ) =        # IO Format
  var buf :seq[string]
  if not this.actif : return (TKey.None)
  var grid_key:TKey = TKey.None
  var CountLigne = 0
  this.cursligne = 0
  printGridHeader(this)
  if pos >= 0 :
    setPageGrid(this,pos)
    CountLigne = this.cursligne
  offCursor()
  onMouse()
  while true :
    buf = newseq[string]()
    printGridRows(this)


    stdin.flushFile()
    grid_key = getFunc()

    if grid_key == TKey.Mouse :
      let gridMouse = getMouse()
      grid_key = TKey.None
      if gridMouse.action == MouseButtonAction.mbaPressed:
        if gridMouse.scroll and gridMouse.scrollDir == ScrollDirection.sdUp   :
          grid_key = TKey.Up
        if gridMouse.scroll and gridMouse.scrollDir == ScrollDirection.sdDown :
          grid_key = TKey.Down

        if  gridMouse.button ==  MouseButton.mbLeft : grid_key = TKey.Enter
        if  gridMouse.button ==  MouseButton.mbRight : grid_key = TKey.Enter

      if grid_key == TKey.None : continue

    case grid_Key
      of TKey.Escape :

        this.cursligne = -1
        return (TKey.Escape)
      of TKey.Enter:
        if this.lignes > 0  :
          this.cursligne = -1
          buf = this.rows[this.nrow[CountLigne]]
          offMouse()
          return (TKey.Enter)
        else : return (TKey.None)
      of TKey.Up :
        if CountLigne > 0 :
          dec(CountLigne)
          this.cursligne = CountLigne
      of TKey.Down :
        if CountLigne < len(this.nrow) - 1  :
          inc(CountLigne)
          this.cursligne = CountLigne
      else :discard

#-----------------------------------------------------------------
## traiement des menus enter = select  1..n 0 = abort (Escape)
## Turning on the mouse
## UP DOWN LEFT RIGHT
## movement width the wheel and validation width the clik
#-----------------------------------------------------------------
proc ioMenu*(pnl: PANEL; mnu:MENU; npos: Natural) : MENU.selMenu =
  var pos : Natural = npos
  var n , h   : Natural
  onMouse()
  offCursor()
  stdout.flushFile()
  if pos > len(mnu.item) or pos < 0 : pos = 0

  while true:
    n = 0
    h = 0
    for cell in  mnu.item :

      if mnu.mnuvh == MNUVH.vertical :
        if mnu.cadre == CADRE.line0 :
          gotoXY(mnu.posx + pnl.posx  + n - 1 , mnu.posy + pnl.posy - 1)
        else :
          gotoXY(mnu.posx + pnl.posx  + n, mnu.posy + pnl.posy)

      if mnu.mnuvh == MNUVH.horizontal :
        if mnu.cadre == CADRE.line0 :
          gotoXY(mnu.posx + pnl.posx  - 1 , h  + mnu.posy + pnl.posy - 1)
        else :
          gotoXY(mnu.posx + pnl.posx  , h +  mnu.posy + pnl.posy )

      setBackgroundColor(mnu.backgr,mnu.backbr)
      setForegroundColor(mnu.foregr,mnu.forebr)
      if pos == n :
        writeStyled(cell.strip(),mnu.styleCell)
      else :
        writeStyled(cell.strip(),mnu.style)
      inc(n)
      h += runeLen(cell)
    stdout.flushFile()
    var key  = getFunc()

    if key == TKey.Mouse :
      let mnuMouse = getMouse()
      key = TKey.None
      if mnuMouse.action == MouseButtonAction.mbaPressed:
        if mnuMouse.scroll and mnuMouse.scrollDir == ScrollDirection.sdUp   :
          if mnu.mnuvh == MNUVH.vertical :    key = TKey.Up
          if mnu.mnuvh == MNUVH.horizontal :  key = TKey.Left
        if mnuMouse.scroll and mnuMouse.scrollDir == ScrollDirection.sdDown :
          if mnu.mnuvh == MNUVH.vertical :    key = TKey.Down
          if mnu.mnuvh == MNUVH.horizontal :  key = TKey.Right
        if  mnuMouse.button ==  MouseButton.mbLeft : key = TKey.Enter
        if  mnuMouse.button ==  MouseButton.mbRight : key = TKey.Enter
    case key

      of TKey.Escape:
        result = 0
        if not pnl.mouse : offMouse()
        break
      of TKey.Enter:
        result = pos + 1
        if not pnl.mouse : offMouse()
        break
      of TKey.Down:
        if pos < (len(mnu.item) - 1) : inc(pos)
      of TKey.Up:
        if pos > 0 : dec(pos)
      of TKey.Right:
        if pos < (len(mnu.item) - 1) : inc(pos)
      of TKey.Left:
        if pos > 0 : dec(pos)
      else: discard





#-----------------------------------------------------==
## Input buffer management modeled on 5250/3270
## inspiration ncurse
## application hold principe and new langage
## use termkey.nim
#-----------------------------------------------------==
proc ioField*(pnl : PANEL ; fld : var FIELD) : (TKey )=

  if fld.protect : return TKey.Enter
  var e_key:TKey

  var e_posx :Natural = pnl.posx + fld.posx - 1
  var e_posy :Natural = pnl.posy + fld.posy - 1
  var e_curs :Natural = e_posy

  var e_FIELD = toRunes(fld.text)
  var e_switch = fld.switch
  let e_reftyp = fld.reftyp
  let e_nbrcar:int  = fld.nbrcar
  var e_count :int  = 0
  var e_str   :string
  var statusCursInsert : bool = false


  #format the area
  for i in 0 .. e_nbrcar - len(e_FIELD) - 1  :
    e_FIELD.add(" ".runeAt(0))

  #prepare the switch edition
  if fld.reftyp == SWITCH:
    if e_switch == true:
      e_FIELD[e_count] = "◉".runeAt(0)
    else:
      e_FIELD[e_count] = "◎".runeAt(0)


  func isNumber(s: string): bool =
    case s
      of "1","2","3","4","5","6","7","8","9","0":
        result = true
      else : result = false

  func isPunct(s: string): bool =
    case s
      of ".",":",",","!","'","-","(",")","<",">":       # not ";" etc reserved communication commercial ex csv
        result = true
      else : result = false

  func isCarPwd(s: string): bool =
    case s
      of  "~","!","?","@","#","$","£","€","%","^","&","*",
          "-","+","=","(",")","{","}","[","]","<",">":      # specifique password
        result = true
      else : result = false

  func isEmpty(v:seq[Rune], fld :FIELD) : bool =
    var s_field : string = $v
    s_field = s_field.strip(trailing = true)
    if s_field  == "" : return true
    case fld.reftyp
    of DIGIT , DIGIT_SIGNED:
      if s_field == "" : return false
      return false
    of DECIMAL, DECIMAL_SIGNED:
      if s_field == "" : return false
      return false
    else :
      var i = 0
      var ok = true
      while i < len(v):
        if v[i] != " ".runeAt(0) : ok = false
        inc(i)
      return ok



  func nbrRune(s:seq[Rune]): Natural =
    if len(s) > 0:
      var i : Natural = len(s)-1
      while i > 0:
          if s[i] != " ".runeAt(0) : return i   # last not blank
          dec(i)
    result = 0

  func isfuncKey(e_key:TKey): bool =
    var i = 0
    var ok :bool = false
    while i < len(pnl.funcKey):
      if e_key == pnl.funcKey[i] : ok = true
      inc(i)
    return ok


  # check if KEYs force control field
  func isPanelKeyCtrl(pnl: PANEL; e_key:TKey): bool =
    var i = 0
    while i < len(pnl.funcKey):
      if e_key == pnl.funcKey[i] and pnl.button[i].ctrl : return true
      inc(i)
    return false



  func insert() =
    if nbrRune(e_FIELD) < e_nbrcar - 1 :
      var i: Natural = e_count
      let s_FIELD = toRunes($e_FIELD)
      while i < e_nbrcar - 1:
        if i == e_count : e_FIELD[i] = e_str.runeAt(0)
        e_FIELD[i+1] = s_FIELD[i]
        inc(i)


  func delete() =
    if e_count < e_nbrcar :
      var i: int = e_count
      var s_FIELD = toRunes($e_FIELD)
      while i < e_nbrcar - 1:
        e_FIELD[i] = s_FIELD[i + 1]
        inc(i)
      e_FIELD[e_nbrcar - 1] = " ".runeAt(0)


  func password(s:seq[Rune]): string =
    var i = 0
    var buf : string = ""
    while i < len(s):
        if s[i] != " ".runeAt(0): buf = buf & "*"
        else : buf = buf & " "
        inc(i)
    return buf

  #----------------------------------------------------------------
  # Definition of the panel (window) on a lines
  # Message display
  # to exit press the Escape key
  # restoration of the original panel lines
  #----------------------------------------------------------------

  proc msgErr(pnl: PANEL ; info:string) =

    setBackgroundColor(msgatr.backgr,msgatr.backbr)
    setForegroundColor(msgatr.foregr,msgatr.forebr)
    gotoXY(e_posx,e_posy)
    if e_reftyp == PASSWORD:
      writeStyled(password(e_FIELD),{styleUnderscore})
    else : writeStyled($e_FIELD,{styleUnderscore})


    var pnlmsg  = new(PANEL)
    var button: BUTTON
    button.key   = TKey.None
    button.text  = ""

    var lcols = pnl.cols
    var msg : string   = info
    if lcols < (len(info) + 6) :  msg = info.substr(0, pnl.cols - 6)
    if lcols > (len(msg) + 6) : lcols = len(msg) + 6

    pnlmsg = new_Panel("msg",pnl.lines + pnl.posx - 1 ,pnl.posy,1,lcols,@[button],CADRE.line0)
    pnlmsg.label.add(defLabel( "msg", 1, 1,"Info :" & msg, msgatr))
    printLabel(pnlmsg,pnlmsg.label[0])
    displayPanel(pnlmsg)
    stdout.flushFile()
    while true:
      e_key = getFunc()
      case e_key
        of TKey.Escape:
          break
        else :discard
    restorePanel(pnl,pnl.lines,pnl.posy)




  # display message Help
  proc msgHelp(pnl: PANEL ; info:string) =
    setBackgroundColor(hlpatr.backgr,hlpatr.backbr)
    setForegroundColor(hlpatr.foregr,hlpatr.forebr)
    gotoXY(e_posx,e_posy)
    if e_reftyp == PASSWORD:
      writeStyled(password(e_FIELD),{styleUnderscore})
    else : writeStyled($e_FIELD,{styleUnderscore})

    var pnlmsg  = new(PANEL)
    var button: BUTTON
    button.key   = TKey.None
    button.text  = ""

    var lcols = pnl.cols
    var msg : string   = info
    if lcols < (len(info) + 6) :  msg = info.substr(0, pnl.cols - 6)
    if lcols > (len(msg) + 6) : lcols = len(msg) + 6

    pnlmsg = new_Panel("msg",pnl.lines + pnl.posx - 1 ,pnl.posy,1,lcols,@[button],CADRE.line0)
    pnlmsg.label.add(defLabel( "msg", 1, 1,"Info :" & msg, hlpatr))

    printLabel(pnlmsg,pnlmsg.label[0])
    displayPanel(pnlmsg)
    stdout.flushFile()
    while true:
      e_key = getFunc()
      case e_key
        of TKey.Escape:
          break
        else :discard
    restorePanel(pnl,pnl.lines,pnl.posy)

  if fld.err :            #  display error
          msgErr(pnl,fld.errmsg)
          fld.err = false
  #--------------------------------------------------
  # field buffer management
  #--------------------------------------------------
  while true :
    setBackgroundColor(fld.backgr,fld.backbr)
    setForegroundColor(fld.foregr,fld.forebr)

    gotoXY(e_posx,e_posy)

    if fld.reftyp == PASSWORD:
      writeStyled(password(e_FIELD),fld.style)
    else : writeStyled($e_FIELD,fld.style)

    gotoXY(e_posx,e_curs)

    if statusCursInsert: defCursor(5) else: defCursor(0) # CHANGE CURSOR FORM BAR/BLOCK

    onCursor()
    # read keyboard
    (e_key,e_str) = getTKey()

    # control transfert panel
    if isfuncKey(e_key) :
      if isPanelKeyCtrl(pnl,e_key) :
        if fld.regex != "" and false == match(strip($e_FIELD,trailing = true) ,re(fld.regex)) and not isEmpty(e_Field,fld) or
            isEmpty(e_Field,fld) and fld.empty == FILL :
            msgErr(pnl,fld.errmsg)
            continue
        else :
          fld.text  = $e_FIELD
          fld.text = fld.text.strip(trailing = true)
          result = e_key
          offCursor()
          break
      else:
        result = e_key
        offCursor()
        break

    # work key based 5250/3270
    case e_key

      of TKey.Escape:
        result = e_key           #release  buffer
        break
      of TKey.CtrlH:             # touche .Help for Field
        if fld.help > "" :
          msgHelp(pnl,fld.help)

      of TKey.Up , TKey.Down:     # next Field
        if fld.regex != "" and false == match(strip($e_FIELD,trailing = true) ,re(fld.regex)) and not isEmpty(e_Field,fld) or
            isEmpty(e_Field,fld) and fld.empty == FILL :
            msgErr(pnl,fld.errmsg)
        else :
          fld.text  = $e_FIELD
          fld.text = fld.text.strip(trailing = true)
          fld.switch = e_switch
          result = e_key
          break
      of TKey.Stab:              # next Field
        if fld.regex != "" and false == match(strip($e_FIELD,trailing = true) ,re(fld.regex)) and not isEmpty(e_Field,fld) or
            isEmpty(e_Field,fld) and fld.empty == FILL :
            msgErr(pnl,fld.errmsg)
        else :
          fld.text  = $e_FIELD
          fld.text = fld.text.strip(trailing = true)
          fld.switch = e_switch
          result = TKey.Up
          break
      of TKey.Tab:               # next Field
        if fld.regex != "" and false == match(strip($e_FIELD,trailing = true) ,re(fld.regex)) and not isEmpty(e_Field,fld) or
            isEmpty(e_Field,fld) and fld.empty == FILL :
            msgErr(pnl,fld.errmsg)
        else :
          fld.text  = $e_FIELD
          fld.text = fld.text.strip(trailing = true)
          fld.switch = e_switch
          result = TKey.Down
          break
      of TKey.Enter :            # enrg to Field
        if ( fld.regex != "" and false == match(strip($e_FIELD,trailing = true) ,re(fld.regex)) and not isEmpty(e_Field,fld) ) or
            isEmpty(e_Field,fld) and fld.empty == FILL :
            msgErr(pnl,fld.errmsg)
        else :
          fld.text  = $e_FIELD
          fld.text = fld.text.strip(trailing = true)
          fld.switch = e_switch
          result = e_key
          break



      of TKey.Home:              # pos cursor home/field
        e_count = 0
        e_curs = e_posy

      of TKey.End:               # pos cursor End/field last not blank
        e_count = nbrRune(e_FIELD)
        e_curs = e_posy + nbrRune(e_FIELD)


      of TKey.Right:             # move cursor
        if e_count < e_nbrcar - 1:
          inc(e_count)
          inc(e_curs)

      of TKey.Left:              # move cursor
        if e_curs > e_posy:
          dec(e_curs)
          dec(e_count)

      of TKey.Backspace:         # delete char
        if e_curs > e_posy:
          dec(e_curs)
          dec(e_count)
          delete()
          if e_curs > e_posy + e_count:
            dec(e_count)
            e_curs = e_posy + e_count

      of TKey.Delete:            # delete char
        delete()
        if e_curs > e_posy + e_count:
          dec(e_count)
          e_curs = e_posy + e_count

      of TKey.Insert:            # insert char
        if statusCursInsert : statusCursInsert = false else : statusCursInsert = true

#--------------------------------------------------------------------------------
# work buffer
#--------------------------------------------------------------------------------
      of TKey.Char:

        case ord(fld.reftyp)         ## Standard treatment of FIELD TYPE

          of ord(ALPHA), ord(ALPHA_UPPER):
            if e_count < e_nbrcar and isAlpha(e_str) or (e_str == "-" and e_count > 0)  or
              (isSpace(e_str) and e_count > 0 and e_count < e_nbrcar):
              if statusCursInsert: insert()
              else:
                if fld.reftyp == ALPHA:
                  e_FIELD[e_count] = e_str.runeAt(0)
                else:
                  e_str = e_str.toUpper()
                  e_FIELD[e_count] = e_str.runeAt(0)
              inc(e_count)
              inc(e_curs)
              if e_count == e_nbrcar:
                dec(e_count)
                dec(e_curs)

          of ord(PASSWORD):
            if e_count < e_nbrcar and (isAlpha(e_str) or isNumber(e_str) or isCarPwd(e_str)) :
              if statusCursInsert: insert()
              else : e_FIELD[e_count] = e_str.runeAt(0)
              inc(e_count)
              inc(e_curs)
              if e_count == e_nbrcar:
                dec(e_count)
                dec(e_curs)

          of ord(ALPHA_NUMERIC), ord(ALPHA_NUMERIC_UPPER)  :
            if e_count < e_nbrcar and (isAlpha(e_str) or isNumber(e_str) or e_str == "-") or
              (isSpace(e_str) and e_count > 0 and e_count < e_nbrcar):
              if statusCursInsert: insert()
              else:
                if fld.reftyp == ALPHA_NUMERIC:
                  e_FIELD[e_count] = e_str.runeAt(0)
                else:
                  e_str = e_str.toUpper()
                  e_FIELD[e_count] = e_str.runeAt(0)
              inc(e_count)
              inc(e_curs)
              if e_count == e_nbrcar:
                dec(e_count)
                dec(e_curs)

          of ord(TEXT_FREE):
            if e_count < e_nbrcar and e_str != " " and e_str != "\"" or
              (isSpace(e_str) and e_count > 0 and e_count < e_nbrcar):
              if statusCursInsert: insert()
              else : e_FIELD[e_count] = e_str.runeAt(0)
              inc(e_count)
              inc(e_curs)
              if e_count == e_nbrcar:
                dec(e_count)
                dec(e_curs)

          of ord(TEXT_FULL):
            if e_count < e_nbrcar and (isAlpha(e_str) or isNumber(e_str) or isPunct(e_str)) or
              (isSpace(e_str) and e_count > 0 and e_count < e_nbrcar):
              if statusCursInsert: insert()
              else : e_FIELD[e_count] = e_str.runeAt(0)
              inc(e_count)
              inc(e_curs)
              if e_count == e_nbrcar:
                dec(e_count)
                dec(e_curs)

          of ord(DIGIT):
            if e_count < e_nbrcar and isNumber(e_str):
              if statusCursInsert: insert()
              else : e_FIELD[e_count] = e_str.runeAt(0)
              inc(e_count)
              inc(e_curs)
              if e_count == e_nbrcar:
                dec(e_count)
                dec(e_curs)

          of ord(DIGIT_SIGNED):
            if e_count < e_nbrcar and isNumber(e_str) or
              (e_str == "+" and e_count == 0) or (e_str == "-" and e_count == 0):
              if statusCursInsert and e_count > 0 : insert()
              else : e_FIELD[e_count] = e_str.runeAt(0)
              inc(e_count)
              inc(e_curs)
              if e_count == e_nbrcar:
                dec(e_count)
                dec(e_curs)

          of ord(DECIMAL):
            if e_count < e_nbrcar and isNumber(e_str) or
              (e_str == "." and e_count > 0 and e_count < e_nbrcar):
                if statusCursInsert: insert()
                else : e_FIELD[e_count] = e_str.runeAt(0)
                inc(e_count)
                inc(e_curs)
                if e_count == e_nbrcar:
                  dec(e_count)
                  dec(e_curs)

          of ord(DECIMAL_SIGNED):
            if e_count < e_nbrcar and isNumber(e_str) or
              (e_str == "." and e_count > 0 and e_count < e_nbrcar) or
              (e_str == "+" and e_count == 0) or (e_str == "-" and e_count == 0):
                if statusCursInsert and e_count > 0 : insert()
                else : e_FIELD[e_count] = e_str.runeAt(0)
                inc(e_count)
                inc(e_curs)
                if e_count == e_nbrcar:
                  dec(e_count)
                  dec(e_curs)

          of ord(TELEPHONE)  :
            if e_count < e_nbrcar :
              if statusCursInsert: insert()
              else:
                e_str = e_str.toUpper()
                e_FIELD[e_count] = e_str.runeAt(0)
              inc(e_count)
              inc(e_curs)
              if e_count == e_nbrcar:
                dec(e_count)
                dec(e_curs)

          of ord(DATE_ISO):
            if ( e_count < e_nbrcar and
              (e_count != 4 and isNumber(e_str)) and
              (e_count != 7 and isNumber(e_str)) or
              ( e_str == "-" and e_count == 4) or
              ( e_str == "-" and e_count == 7) ) :
              if statusCursInsert: insert()
              else : e_FIELD[e_count] = e_str.runeAt(0)
              inc(e_count)
              inc(e_curs)
              if e_count == e_nbrcar:
                dec(e_count)
                dec(e_curs)


          of ord(DATE_US), ord(DATE_FR):
            if ( e_count < e_nbrcar and
              (e_count != 2 and isNumber(e_str)) and
              (e_count != 5 and isNumber(e_str)) or
              ( e_str == "/" and e_count == 2) or
              ( e_str == "/" and e_count == 5)) :
              if statusCursInsert: insert()
              else : e_FIELD[e_count] = e_str.runeAt(0)
              inc(e_count)
              inc(e_curs)
              if e_count == e_nbrcar:
                dec(e_count)
                dec(e_curs)

          of ord(MAIL_ISO):
            if e_count < e_nbrcar:
              if statusCursInsert: insert()
              else : e_FIELD[e_count] = e_str.runeAt(0)
              inc(e_count)
              inc(e_curs)
              if e_count == e_nbrcar:
                dec(e_count)
                dec(e_curs)

          of ord(YES_NO):
            if e_count < e_nbrcar and (e_str == "y" or e_str == "Y" or e_str == "n" or e_str == "N"  ) :
              e_str = e_str.toUpper()
              e_FIELD[e_count] = e_str.runeAt(0)
              inc(e_count)
              inc(e_curs)
              if e_count == e_nbrcar:
                dec(e_count)
                dec(e_curs)

          of ord(SWITCH):
            if e_count < e_nbrcar and e_str == " ":
              if e_switch == false:
                e_FIELD[e_count] = "◉".runeAt(0)
                e_switch = true
              else:
                e_FIELD[e_count] = "◎".runeAt(0)
                e_switch = false

          of ord(FPROC):
            result = TKey.PROC
            offCursor()
            break

          of ord(FCALL):
            result = TKey.CALL
            offCursor()
            break

          else : discard
      else : discard
    stdout.flushFile()






## Contrôle  Format Panel full Field
proc isValide*(pnl:var PANEL): bool =
  if not pnl.actif : return false

  var e_FIELD :seq[Rune]

  func isEmpty(v:seq[Rune], fld :FIELD) : bool =
    var s_field : string = $v
    s_field = s_field.strip(trailing = true)
    if s_field  == "" : return true
    case fld.reftyp
    of DIGIT , DIGIT_SIGNED:
      if s_field == "" : return true
      return false
    of DECIMAL, DECIMAL_SIGNED:
      if s_field == "" : return true

      return false
    else :
      var i = 0
      var ok = true
      while i < len(v):
        if v[i] != " ".runeAt(0) : ok = false
        inc(i)
      return ok

  # check error
  for n in 0..len(pnl.field) - 1:
    if pnl.field[n].actif and not pnl.field[n].protect :
      e_FIELD = toRunes(pnl.field[n].text)

      #prepare the switch
      if pnl.field[n].reftyp == SWITCH:
        if pnl.field[n].switch == false and pnl.field[n].empty == FILL:
            pnl.index = n
            pnl.field[n].err = true
            return false
      elif  ( pnl.field[n].regex != "" and false == match(strip($e_FIELD,trailing = true) ,re(pnl.field[n].regex)) and not isEmpty(e_Field,pnl.field[n]) ) or
          isEmpty(e_FIELD ,pnl.field[n]) and pnl.field[n].empty == FILL:
            pnl.index = n
            pnl.field[n].err = true
            return false
  return true







#-------------------------------------------------------
## Format management including zones
## keyboard proction keys are returned to the calling procedure
##
## only the key CtrlA = Aide / Help for field
## F1 is reserved for complex help programming
##
## Reserved keys for FIELD management
## traditionally  UP, DOWN, TAB, STAB, CtrlA,
## ENTER, HOME, END, RIGTH, LEFt, BACKSPACE, DELETE, INSERT
## predefined and customizable REGEX control
#-------------------------------------------------------

proc ioPanel*(pnl:var PANEL): TKey =                       # IO Format
  if not pnl.actif : return TKey.None

  var CountField = pnl.index
  var fld_key:TKey = TKey.Enter
  var index = getIndex(pnl,pnl.field[CountField].name)

  # check error
  for n in 0..len(pnl.field) - 1:
    if  pnl.field[n].err :
      index = n
      CountField = n
      pnl.index = n
      break

  # check if KEYs force control field
  func isPanelKeyCtrl(pnl: PANEL; e_key:TKey): bool =
    var i = 0
    while i < len(pnl.funcKey):
      if e_key == pnl.funcKey[i] and pnl.button[i].ctrl : return true
      inc(i)
    return false


  # check if there are any free field
  func isFieldIO(pnl: PANEL):Natural =
    var n : Natural = len(pnl.field)
    var nfield: int = len(pnl.field)
    for i in 0..nfield - 1 :
      if pnl.field[i].protect  or not pnl.field[i].actif: n -= 1
    return n
  #search there first available field
  func isFirstIO(pnl: PANEL, idx : Natural):int =
    var i : Natural = idx
    while i < len(pnl.field)-1  :
      if pnl.field[i].actif:
        if not pnl.field[i].protect : break
      inc(i)
    return i
  #search there last available field
  func isPriorIO(pnl: PANEL, idx : Natural):int =
    var i : int = idx
    while i >= 0 :
      if pnl.field[i].actif :
        if not pnl.field[i].protect : break
      dec(i)
    if i < 0 : return 0
    return i

  func fieldNbr(pnl :var PANEL) :int =
    var nbr = -1
    for n in 0..len(pnl.field) - 1:
      if  isActif(pnl.field[n]) :
        if not  isProtect(pnl.field[n]) :  nbr = n
    return nbr



  #displays width framing the field
  if not pnl.field[CountField].protect and pnl.field[index].actif :
    printField(pnl,pnl.field[index])
    displayField(pnl,pnl.field[index])

  while true :

    #controls the boundary sequence of the field
    if CountField == len(pnl.field)-1  and isFieldIO(pnl) > 0 :
      CountField = isPriorIO(pnl,len(pnl.field)-1)
    if CountField == 0  and isFieldIO(pnl) > 0 :
      CountField = isFirstIO(pnl,0)

    if not pnl.field[CountField].protect and pnl.field[CountField].actif:

      fld_key = ioField(pnl,pnl.field[CountField])   # work input/output Field
      printField(pnl,pnl.field[CountField])
      displayField(pnl,pnl.field[CountField])



    if isPanelKey(pnl,fld_key) or fld_key == TKey.PROC :   # this key sav index field return main
      if isPanelKeyCtrl(pnl,fld_key) and not isValide(pnl) :
        CountField = pnl.index
        fld_key = TKey.Escape
      else :
        pnl.index = getIndex(pnl,pnl.field[CountField].name)
        return fld_key

    if isFieldIO(pnl) == 0 :                          # this full protect only work Key active
      fld_key = getFunc()
    else :
      case fld_Key
        of TKey.Escape :                               # we replay & resume the basic value
          continue
        of TKey.Enter:
          inc(CountField)
          if CountField > fieldNbr(pnl) : CountField = 0
          if pnl.field[CountField].protect :
            CountField = isFirstIO(pnl,CountField)

        of TKey.Up :
          if CountField > 0 : dec(CountField)
          elif CountField == 0 :  CountField = len(pnl.field)-1
          if pnl.field[CountField].protect  :
            CountField = isPriorIO(pnl,CountField )

        of TKey.Down:
          inc(CountField)
          if CountField > fieldNbr(pnl) : CountField = 0
          if pnl.field[CountField].protect :
            CountField = isFirstIO(pnl,CountField)
        else :discard