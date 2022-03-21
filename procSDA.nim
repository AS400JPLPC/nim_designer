import termkey
import procCurs
import strformat
import unicode
import std/[re]
from strutils import parseInt,parseEnum,parseBool

import tables
import json
import os ,times

#proc beug(nline : int ; text :string ) =
#  gotoXY(40, 1); echo "ligne>", nline, " :" , text ; discard getFunc()



var cellYellow = new(CELLATRB)
cellYellow.cell_style = {styleDim,styleItalic}
cellYellow.cell_backgr = BackgroundColor.bgblack
cellYellow.cell_backbr = false
cellYellow.cell_foregr = ForegroundColor.fgYellow
cellYellow.cell_forebr = true



#===================================================
# index GRID / COMBO / CALLQRY
func setID*( line : var int ) : string =
  line += 1
  return $line

#===================================================


#===================================================
var NbrPanel: int = 0
var PanelWork: int = 0

# double buffer
var base = newseq[PANEL]()
var detail : PANEL




var Zgrid  : GRIDSFL
var Zdup   : GRIDSFL
var Cell_numIDx : int


var pnLx :PANEL
var pnFx :PANEL

var Dspmnu = new(MENU)


var nTest = 0
var key : TKey = TKey.None
var keyG : TKey_Grid
var nPnl : int  = 0
var nopt : int  = 0
var nchx : int  = 0

let mExit: int  = 4
var X,Y,XX,YY,SX,SY,NY : Natural
var e_TEXT = newSeq[Rune]()
var v_TEXT : string
var maxY, minY : Natural
var maxX, minX : Natural






initTerm()
titleTerm("DESIGNER")
setTerminal() #default color style erase

base.add(newPanel("Base",1,1,terminalHeight(),terminalWidth(), @[defButton(TKey.None,"")]))

detail = newPanel("Detail",1,1,terminalHeight(),terminalWidth(),@[defButton(TKey.None,"")])

var orderZ :PANEL = newPanel("order",1,1,terminalHeight(),terminalWidth(), @[defButton(TKey.None,"")],line1,"Order Label")

var mnuScrn = new(MENU)
mnuScrn = newMenu("Screen" ,1, 5,vertical,@["Panel   ","Zone...","Source " ,"Exit   "],line1 )

var mnuOrder = new(MENU)
mnuOrder = newMenu("Order" ,2, 5,vertical,@["Label ","Field ","Menu "],line1 )

var mnuRmv = new(MENU)
mnuRmv = newMenu("Remove" ,2, 5,vertical,@["Label ","Field ","Menu ","Grid"],line1 )


#--------------------------------------------------
# display table decisionel
include callqry
# source label / field
include procPanel
include procLabel
include procField
include procMenu
include procGrid
include procJson
include procInit    # depend procJson



if LoadInit() == false :
  closeTerm()

while true:

  if nopt == mExit :  closeTerm()

  if nPnl == 0 :
    setTerminal()
    printMenu(base[0],mnuScrn)
    nopt = ioMenu(base[0],mnuScrn,0)
    if nopt >= 1 and nopt < mExit :
      npnl = nopt
      if nopt == 1 : PanelWork = callPanel(base,true)
      if nopt != 1 : PanelWork = callPanel(base,false)
      if PanelWork == 0 : npnl = 0
    elif nopt == 0 : nPnl =0
    setTerminal()






  # definition Panel
  if nPnl == 1 :
    PanelDef()


  # definition Label Field Menu
  if nPnl == 2 :
    if fldP.OK == false :
      nPnl = 0
      setTerminal()
      gotoXY(1,1)
      offCursor()
      continue

    setTerminal()
    clsPanel(detail)
    resetPanel(detail)
    detail = newPanel("Detail",1,1,terminalHeight(),terminalWidth(),@[defButton(TKey.None,"")])
    detail.posx   = base[PanelWork].posx
    detail.posy   = base[PanelWork].posy
    detail.lines  = base[PanelWork].lines
    detail.cols   = base[PanelWork].cols
    detail.backgr  = base[PanelWork].backgr
    detail.backbr  = base[PanelWork].backbr
    detail.foregr  = base[PanelWork].foregr
    detail.forebr  = base[PanelWork].forebr
    detail.style   = base[PanelWork].style

    detail.cadre    = base[PanelWork].cadre

    detail.boxpnl   = base[PanelWork].boxpnl

    detail.index    = 0
    detail.box      = base[PanelWork].box
    detail.label    = base[PanelWork].label
    detail.field    = base[PanelWork].field
    detail.hiden    = base[PanelWork].hiden
    detail.button   = base[PanelWork].button
    detail.funcKey  = base[PanelWork].funcKey
    detail.mouse = false
    detail.setActif(true)

    printPanel(detail)
    gotoXY(detail.posx,detail.posy)
    onCursor()
    onMouse()

    maxY = detail.cols + detail.posy
    if detail.cadre != CADRE.line0 : maxY -= 1
    minY = detail.posy  # func F1...
    if detail.cadre != CADRE.line0 : minY += 1



    maxX = detail.lines + detail.posx
    if detail.cadre != CADRE.line0 : maxX -= 2
    minX= detail.posx
    if detail.cadre != CADRE.line0 : minX += 1



    gotoXY(minX,minY)
    while true :
      getCursor(XX , YY)
      gotoXY(XX,YY)
      onCursor()
      key = getFunc(true)
      case key
        of TKey.CtrlQ:
          offMouse()
          nPnl = 0
          setTerminal()
          gotoXY(minX , minY)
          offCursor()
          break

        of TKey.Mouse :
          let mi = getMouse()
          if mi.action == MouseButtonAction.mbaPressed:
            gotoXY(terminalHeight(),terminalWidth()-20);  stdout.write "      "
            # work this first /.../ bla bla
            case mi.button
            of mbLeft:
              gotoXY(terminalHeight(),terminalWidth()-20); stdout.write fmt"{mi.x},{mi.y}"

            of mbMiddle:
              gotoXY(terminalHeight(),terminalWidth()-20); stdout.write fmt"{mi.x},{mi.y}"

            of mbRight:
              gotoXY(terminalHeight(),terminalWidth()-20); stdout.write fmt"{mi.x},{mi.y}"

            else: discard
          elif mi.action == MouseButtonAction.mbaReleased:
            gotoXY(terminalHeight(),terminalWidth()-20); stdout.write fmt"{mi.x},{mi.y}"
          gotoXY(mi.x,mi.y)

        #--------------
        # def Label
        #--------------
        of TKey.altL:
          getCursor(X , Y)
          if X < minX or X > maxX or Y < minY or Y > maxY :
            gotoXY(minX,minY)
            continue
          labelDef(1)
        #--------------
        # def Label majuscule
        #--------------
        of TKey.altT:
          getCursor(X , Y)
          if X < minX or X > maxX or Y < minY or Y > maxY :
            gotoXY(minX,minY)
            continue
          labelDef(2)


        #--------------
        # def menu
        #--------------
        of TKey.altM:
          getCursor(X , Y)
          if X < minX or X > maxX or Y < minY or Y > maxY :
            gotoXY(minX,minY)
            continue

          writeMenu(callMenu(ZMENU))
          setTerminal()
          printPanel(detail)
          gotoXY(1,1)
          onMouse()




        #--------------
        # def Grid
        #--------------
        of TKey.altG:
          getCursor(X , Y)
          if X < minX or X > maxX or Y < minY or Y > maxY :
            gotoXY(minX,minY)
            continue

          SX = X
          SY = Y
          offMouse()
          #clsPanel(pmenu)
          gotoXY(terminalHeight(),terminalWidth()-20); stdout.write "      "
          gotoXY(terminalHeight(),terminalWidth()-20); stdout.write "GRID  "

          gridDef($base[PanelWork].name)


          setTerminal()
          printPanel(detail)
          gotoXY(1,1)
          onMouse()




        # print screen full MENU
        of TKey.altP:
          if  len(ZMENU) > 0 :
            Dspmnu = new(MENU)
            for n in 0..<len(ZMENU):
              Dspmnu = newMenu(ZMENU[n].name,ZMENU[n].posx,ZMENU[n].posy,ZMENU[n].orientation,ZMENU[n].item,ZMENU[n].cadre)
              dspMenuItem(detail,Dspmnu)
          gotoXY(1,1)
          onMouse()


        #--------------
        # def field
        #--------------
        of TKey.altF:
          getCursor(X,Y)
          if X < minX or X > maxX or Y < minY or Y > maxY :
            gotoXY(minX,minY)
            continue
          fieldDef(callField(detail))

        #--------------
        # select Display LABEL / FIELD / MENU
        #--------------
        of TKey.altD:
          printMenu(detail,mnuOrder)
          nchx = ioMenu(detail,mnuOrder,0)
          case nchx :
            of 0 :
              restorePanel(detail,mnuOrder)
              onMouse()
              onCursor()
              continue
            of 1 :
              Zgrid = newGrid("GRID01",30,1,5)
              var Cell_idl      = defCell("ID",3,DIGIT)
              var Cell_namel    = defCell("Name",10,ALPHA,cellYellow)
              var Cell_posxl    = defCell("PosX",4,DIGIT)
              var Cell_posyl    = defCell("PosY",4,DIGIT)
              var Cell_textl    = defCell("Text",30,TEXT_FREE)
              var Cell_title    = defCell("Title",5,SWITCH)
              Cell_numIDx = - 1
              setHeaders(Zgrid, @[Cell_idl, Cell_namel, Cell_posxl,Cell_posyl,Cell_textl,Cell_title])
              for n in 0..len(base[PanelWork].label)-1:
                addRows(Zgrid, @[setID(Cell_numIDx), getNameL(base[PanelWork],n), $getPosxL(base[PanelWork],n),$getPosyL(base[PanelWork],n),getTextL(base[PanelWork],n),$isTitle(base[PanelWork],n)])
            of 2:
              Zgrid  = newGrid("GRID01",30,2,5)
              var Cell_idf      = defCell("ID",3,DIGIT)
              var Cell_namef    = defCell("Name",10,ALPHA,cellYellow)
              var Cell_posxf    = defCell("PosX",4,DIGIT)
              var Cell_posyf    = defCell("PosY",4,DIGIT)
              var Cell_typef    = defCell("Type",19,ALPHA)
              Cell_numIDx = - 1
              setHeaders(Zgrid, @[Cell_idf, Cell_namef, Cell_posxf, Cell_posyf, Cell_typef])
              for n in 0..len(base[PanelWork].field)-1:
                addRows(Zgrid, @[setID(Cell_numIDx), getName(base[PanelWork],n), $getPosx(base[PanelWork],n),$getPosyL(base[PanelWork],n),$getRefType(base[PanelWork],n)])

            of 3:
              Zgrid  = newGrid("GRID01",30,2,5)
              var Cell_idm      = defCell("ID",3,DIGIT)
              var Cell_namem    = defCell("Name",10,ALPHA,cellYellow)
              var Cell_posxm    = defCell("PosX",4,DIGIT)
              var Cell_posym    = defCell("PosY",4,DIGIT)
              var Cell_typem    = defCell("Type",10,ALPHA)
              Cell_numIDx = - 1
              setHeaders(Zgrid, @[Cell_idm, Cell_namem, Cell_posxm, Cell_posym, Cell_typem])
              for n in 0..len(ZMENU)-1:
                addRows(Zgrid, @[setID(Cell_numIDx), ZMENU[n].name, $ZMENU[n].posx, $ZMENU[n].posy, $ZMENU[n].orientation])
            else : discard
          printGridHeader(Zgrid)
          printGridRows(Zgrid)
          while true :
            offCursor()
            key = getFunc()
            case key
              of TKey.Escape :
                setTerminal()
                clsPanel(detail)
                printPanel(detail)
                onMouse()
                onCursor()
                gotoXY(minX,minY)
                resetGrid(Zgrid)
                break
              of TKey.PageUp :
                keyG = pageUpGrid(Zgrid)
                if keyG == TKey_Grid.PGup:
                  gotoXY(terminalHeight(),terminalWidth()-20); stdout.write "Prior"
                else:
                  gotoXY(terminalHeight(),terminalWidth()-20);  stdout.write "Home "
              of TKey.PageDown :
                keyG = pageDownGrid(Zgrid)
                if keyG == TKey_Grid.PGdown:
                  gotoXY(terminalHeight(),terminalWidth()-20); stdout.write "Next "
                else:
                  gotoXY(terminalHeight(),terminalWidth()-20); stdout.write "End  "
              else : discard

        #--------------
        # select order
        #--------------
        of TKey.altO:
          offMouse()

          setTerminal()
          printMenu(detail,mnuOrder)
          nchx = ioMenu(detail,mnuOrder,0)
          case nchx :
            of 1  :  orderLabel()
            of 2  :  orderField()
            else : discard
          setTerminal()
          clsPanel(detail)
          printPanel(detail)
          gotoXY(minX,minY)
          onCursor()
          onMouse()

        #--------------
        # select remove
        #--------------
        of TKey.altR:
          offMouse()

          setTerminal()
          printMenu(detail,mnuRmv)
          nchx = ioMenu(detail,mnuRmv,0)
          case nchx
            of 1  :  rmvLabel()
            of 2  :  rmvField()
            of 3  :  rmvMenu()
            of 4  :  rmvGrid($base[PanelWork].name)
            else : discard
          setTerminal()
          clsPanel(detail)
          printPanel(detail)
          gotoXY(minX,minY)
          onCursor()
          onMouse()

        #--------------
        # select display terminal
        #--------------
        of TKey.altS:
          offMouse()
          setTerminal()
          printPanel(detail)
          gotoXY(minX,minY)
          onCursor()
          onMouse()

        else : discard
  #--------------
  # write source for pgm
  #--------------
  if nPnl == 3 :
    var nLine = newSeq[string]()
    let f = open("Source.nim", fmWrite)
    var nbr : bool = false
    var v_empty : string
    var zone: string
    var zoneButton : string
    var nbrButton  : bool
    var btn : BUTTON
    var zoneItem :string



    nLine.add("import termkey")
    nLine.add("import termcurs")
    if len(NSFILE) > 0 :
      for n in 0..<len(NSFILE):
        if NSFILE[n].form == "combo" :
          nLine.add(fmt"import tables")
          nLine.add(fmt"")
          nLine.add(fmt"")
          nLine.add(fmt"var callQuery: Table[string, proc(fld : var FIELD)]")
          break
    nLine.add(fmt"")


    for nP in 1..len(base) - 1:
      if len(base[nP].field) > 0 :
        nLine.add(fmt"")
        nLine.add(fmt"type")
        zone="  FIELD_" & getPnlName(base[nP]) & " {.pure.}= enum"
        nLine.add(zone)
      for n in 0..len(base[nP].field) - 1:
        nbr= true
        if n < len(base[nP].field)-1  : nLine.add(fmt"    {getName(base[nP],n)},")
        else: nLine.add(fmt"    {getName(base[nP],n)}")
      if nbr:
        zone = fmt"const P{nP}: array[FIELD_{getPnlName(base[nP])}, int] = ["
        for n in 0..len(base[nP].field) - 1:
            if n < len(base[nP].field)-1  :zone = fmt"{zone}{n},"
            else : zone = fmt"{zone}{n}]"
        nLine.add(zone)

        # write global procédure
    if len(ZMENU) > 0 :
      nLine.add(fmt"")
      nLine.add(fmt"")
      nLine.add(fmt"# MENU -> TEST")
      for n in 0..<len(ZMENU):
        nLine.add(fmt"""var {ZMENU[n].name} = new(MENU)""")
        nLine.add(fmt"""{ZMENU[n].name} = newMenu("{ZMENU[n].name}", {ZMENU[n].posx}, {ZMENU[n].posy}, {ZMENU[n].orientation}, {ZMENU[n].item}, {ZMENU[n].cadre})""")
        nLine.add(fmt"")

    for nP in 1..len(base) - 1:
      nbr = false
      zoneButton = ""
      for i in 0..len(base[nP].button) - 1 :
        nbrButton = true
        btn = base[nP].button[i]
        if i == 0 : zoneButton  = fmt"""@[defButton(TKey.{$btn.key},"{btn.text}",{btn.ctrl},{btn.isActif})"""
        else: zoneButton  = fmt"""{zoneButton}, defButton(TKey.{$btn.key},"{btn.text}",{btn.ctrl},{btn.isActif})"""
      if nbrButton : zoneButton  = fmt"{zoneButton}]"

      nLine.add(fmt"")
      nLine.add(fmt"# Panel {getPnlName(base[nP])}")
      nLine.add(fmt"")
      nLine.add(fmt"var {getPnlName(base[nP])}= new(PANEL)")
      nLine.add(fmt"")
      nLine.add(fmt"# description")
      nLine.add(fmt"proc dsc{getPnlName(base[nP])}() = ")
      nLine.add(fmt"""  {getPnlName(base[nP])} = newPanel("{getPnlName(base[nP])}",{base[nP].posx},{base[nP].posy},{base[nP].lines},{base[nP].cols},{zoneButton},{base[nP].cadre},"{getPnlTitle(base[nP])}")""")

      if len(base[nP].label) > 0 :
        nLine.add(fmt"")
        nLine.add(fmt"  # LABEL  -> {getPnlName(base[nP])}")
        nLine.add(fmt"")

      # label
      for n in 0..len(base[nP].label) - 1:
        if isTitle(base[nP], n) :
          nLine.add(fmt"""  {getPnlName(base[nP])}.label.add(defTitle("{getNameL(base[nP],n)}", {$getPosxL(base[nP],n)}, {$getPosyL(base[nP],n)}, "{getTextL(base[nP],n)}"))""")
        else :
          nLine.add(fmt"""  {getPnlName(base[nP])}.label.add(deflabel("{getNameL(base[nP],n)}", {$getPosxL(base[nP],n)}, {$getPosyL(base[nP],n)}, "{getTextL(base[nP],n)}"))""")
      #--------------------

      if len(base[nP].field) > 0 :
        nLine.add(fmt"")
        nLine.add(fmt"  # FIELD -> {getPnlName(base[nP])}")
        nLine.add(fmt"")
      # field
      for n in 0..len(base[nP].field) - 1:
        if getEmpty(base[nP],n) : v_empty = "EMPTY" else: v_empty = "FILL"

        case getRefType(base[nP],n)
        of ALPHA, ALPHA_UPPER,ALPHA_NUMERIC,ALPHA_NUMERIC_UPPER, TEXT_FREE, TEXT_FULL, PASSWORD, YES_NO, FPROC, FCALL:
          nLine.add(fmt"""  {getPnlName(base[nP])}.field.add(defString("{getName(base[nP],n)}", {$getPosx(base[nP],n)}, {$getPosy(base[nP],n)}, {$getRefType(base[nP],n)},{$getWidth(base[nP],n)},"", {v_empty}, "{getErrmsg(base[nP],n)}","{getHelp(base[nP],n)}"))""")

        of DIGIT , DIGIT_SIGNED , DECIMAL, DECIMAL_SIGNED  :
          nLine.add(fmt"""  {getPnlName(base[nP])}.field.add(defNumeric("{getName(base[nP],n)}", {$getPosx(base[nP],n)}, {$getPosy(base[nP],n)}, {$getRefType(base[nP],n)},{$getWidth(base[nP],n)},{$getScal(base[nP],n)},"", {v_empty},"{getErrmsg(base[nP],n)}", "{getHelp(base[nP],n)}"))""")

        of TELEPHONE:
          nLine.add(fmt"""  {getPnlName(base[nP])}.field.add(defTelephone("{getName(base[nP],n)}", {$getPosx(base[nP],n)}, {$getPosy(base[nP],n)}, {$getRefType(base[nP],n)},{$getWidth(base[nP],n)},"", {v_empty}, "{getErrmsg(base[nP],n)}", "{getHelp(base[nP],n)}"))""")

        of DATE_ISO, DATE_FR, DATE_US:
          nLine.add(fmt"""  {getPnlName(base[nP])}.field.add(defDate("{getName(base[nP],n)}", {$getPosx(base[nP],n)}, {$getPosy(base[nP],n)}, {$getRefType(base[nP],n)},"", {v_empty}, "{getErrmsg(base[nP],n)}", "{getHelp(base[nP],n)}"))""")

        of MAIL_ISO:
          nLine.add(fmt"""  {getPnlName(base[nP])}.field.add(defMail("{getName(base[nP],n)}", {$getPosx(base[nP],n)}, {$getPosy(base[nP],n)}, {$getRefType(base[nP],n)},{$getWidth(base[nP],n)},"", {v_empty}, "{getErrmsg(base[nP],n)}", "{getHelp(base[nP],n)}"))""")

        of SWITCH :
          nLine.add(fmt"""  {getPnlName(base[nP])}.field.add(defSwitch("{getName(base[nP],n)}", {$getPosx(base[nP],n)}, {$getPosy(base[nP],n)}, {$getRefType(base[nP],n)}, false, {v_empty}, "{getErrmsg(base[nP],n)}", "{getHelp(base[nP],n)}"))""")

        if getEdtcar(base[nP],n) != "" :
            nLine.add(fmt"""  setEdtCar({getPnlName(base[nP])}.field[P{nP}[{getName(base[nP],n)}]], "{getEdtcar(base[nP],n)}")""")
        if isProtect(base[nP].field[n]) :
            nLine.add(fmt"""  setProtect({getPnlName(base[nP])}.field[P{nP}[{getName(base[nP],n)}]],true)""")
        if isProcess(base[nP],n) :
            nLine.add(fmt"""  setProcess({getPnlName(base[nP])}.field[P{nP}[{getName(base[nP],n)}]],"{getProcess(base[nP],n)}")""")

      #-------------------- End Field

      #-------------------------------------------------
      # Sous-fichier    combo
      #-------------------------------------------------
      if len(NSFILE) > 0 :

        nLine.add(fmt"")
        nLine.add(fmt"")

        for n in 0..<len(NSFILE):
          if NSFILE[n].form == "combo"  and NSFILE[n].panel == getPnlName(base[nP]):
            nLine.add(fmt"#===================================================")
            nLine.add(fmt"proc { NSFILE[n].name}(fld : var FIELD) =")
            nLine.add(fmt"  var Cell_pos : int = -1")
            nLine.add(fmt"""  var Xcombo  = newGRID("{NSFILE[n].name}",{NSFILE[n].posx},{NSFILE[n].posy},{NSFILE[n].nrow},{NSFILE[n].sep}) """)
            for i in 0..len(NSFILE[n].defcell)-1 :
              nLine.add(fmt"""  var Cell_{NSFILE[n].defcell[i].text} = defCell("{NSFILE[n].defcell[i].text}",{NSFILE[n].defcell[i].long},{NSFILE[n].defcell[i].reftyp},"{NSFILE[n].defcell[i].cellatr}") """)

              if NSFILE[n].defcell[i].edtcar > "" :
                nLine.add(fmt"""  setCellEditCar(Cell_{NSFILE[n].defcell[i].text},"{NSFILE[n].defcell[i].edtcar}")""")


            zoneItem = ""
            for i in 0..len(NSFILE[n].defcell)-1 :
              var u : int
              if u < i : zoneItem = fmt"{zoneItem} ,"
              zoneItem = fmt"{zoneItem}Cell_{NSFILE[n].defcell[i].text}"
              inc(u)

            nLine.add(fmt"  setHeaders(Xcombo, @[{zoneItem}])")

            for i in 0..len(NSFILE[n].citem)-1 :
              zoneItem = ""
              var u : int = 0
              for k in 0..len(NSFILE[n].defcell)-1 :
                if u < k : zoneItem = fmt"{zoneItem},"
                zoneItem = fmt""" {zoneItem}"{NSFILE[n].citem[i][k]}" """

              nLine.add(fmt"  addRows(Xcombo, @[{zoneItem}])")

            nLine.add(fmt"")
            nLine.add(fmt"  printGridHeader(Xcombo)")

            nLine.add(fmt"  case fld.text")
            for i in 0..len(NSFILE[n].citem)-1 :
              nLine.add(fmt"""    of "{$NSFILE[n].citem[i][0]}"   : Cell_pos = {i} """)

            nLine.add(fmt"    else : discard")
            nLine.add(fmt"")
            nLine.add(fmt"  while true :")
            nLine.add(fmt"    let (keys, val) = ioGrid(Xcombo,Cell_pos)")
            nLine.add(fmt"    case keys")
            nLine.add(fmt"      of TKey.Enter :")
            nLine.add(fmt"        restorePanel({$NSFILE[n].panel},Xcombo)")
            nLine.add(fmt"        fld.text  = $val[0]")
            nLine.add(fmt"        break")
            nLine.add(fmt"      else: discard")

            nLine.add(fmt"")
            nLine.add(fmt"""callQuery["{NSFILE[n].name}"] = {NSFILE[n].name} """)

            nLine.add(fmt"#===================================================")

      #-------------------------------------------------
      # Sous-fichier    combo
      #-------------------------------------------------
      if len(NSFILE) > 0 :

        nLine.add(fmt"")
        nLine.add(fmt"")
        for n in 0..<len(NSFILE):
          if NSFILE[n].form == "grid" and NSFILE[n].panel == getPnlName(base[nP]):
              nLine.add(fmt"var G{NSFILE[n].name}: GRIDSFL")

        for n in 0..<len(NSFILE):
          if NSFILE[n].form == "grid"  and NSFILE[n].panel == getPnlName(base[nP]):
            nLine.add(fmt"#===================================================")
            nLine.add(fmt"proc { NSFILE[n].name}() =")
            nLine.add(fmt"""  G{NSFILE[n].name}  = newGRID("{NSFILE[n].name}",{NSFILE[n].posx},{NSFILE[n].posy},{NSFILE[n].nrow},{NSFILE[n].sep}) """)
            for i in 0..len(NSFILE[n].defcell)-1 :
              nLine.add(fmt"""  var Cell_{NSFILE[n].defcell[i].text} = defCell("{NSFILE[n].defcell[i].text}",{NSFILE[n].defcell[i].long},{NSFILE[n].defcell[i].reftyp},"{NSFILE[n].defcell[i].cellatr}") """)

              if NSFILE[n].defcell[i].edtcar > "" :
                nLine.add(fmt"""  setCellEditCar(Cell_{NSFILE[n].defcell[i].text},"{NSFILE[n].defcell[i].edtcar}")""")


            zoneItem = ""
            for i in 0..len(NSFILE[n].defcell)-1 :
              var u : int
              if u < i : zoneItem = fmt"{zoneItem} ,"
              zoneItem = fmt"{zoneItem}Cell_{NSFILE[n].defcell[i].text}"
              inc(u)

            nLine.add(fmt"  setHeaders(G{NSFILE[n].name}, @[{zoneItem}])")

            nLine.add(fmt"#===================================================")


    nLine.add(fmt"")
    nLine.add(fmt"")
    nLine.add(fmt"proc main() =")
    nLine.add(fmt"  initTerm({base[1].lines},{base[1].cols})") # initTerm() = terminal


    nLine.add(fmt"")
    for nP in 1..len(base) - 1:
      nLine.add(fmt"  dsc{getPnlName(base[nP])}()")
      nLine.add(fmt"  printPanel({getPnlName(base[nP])})")
      nLine.add(fmt"  displayPanel({getPnlName(base[nP])})")


      if len(ZMENU) > 0 :
        nLine.add(fmt"")
        nLine.add(fmt"  # ONLY -> FOR TEST")
        for n in 0..<len(ZMENU):
          nLine.add(fmt"  dspMenuItem({getPnlName(base[nP])},{ZMENU[n].name},0)")
        nLine.add(fmt"  let nTest = ioMenu({getPnlName(base[nP])},{ZMENU[len(ZMENU)-1].name},0)")
        nLine.add(fmt"")


      nLine.add(fmt"")

      nLine.add(fmt"  #Exemple ------")
      nLine.add(fmt"")
      nLine.add(fmt"  while true:")
      nLine.add(fmt"    let  key = ioPanel({getPnlName(base[nP])})")

      nLine.add(fmt"    case key")



      for n in 0..len(base[nP].field) - 1:
        if isProcess(base[nP],n) and getReftype(base[nP],n) == FPROC :
          nLine.add(fmt"      of TKey.PROC :  # for field Process")
          nLine.add(fmt"        if isProcess({getPnlName(base[nP])},Index({getPnlName(base[nP])})):")
          nLine.add(fmt"          callQuery[getProcess({getPnlName(base[nP])},Index({getPnlName(base[nP])}))]({getPnlName(base[nP])}.field[Index({getPnlName(base[nP])})])")
          break
      for n in 0..len(base[nP].field) - 1:
        if isProcess(base[nP],n) and getReftype(base[nP],n) == FCALL :
          nLine.add(fmt"      of TKey.CALL :  # for field Process  ex:")
          nLine.add(fmt"        if isProcess({getPnlName(base[nP])},Index({getPnlName(base[nP])})):")
          nLine.add(fmt"""          if getProcess({getPnlName(base[nP])},Index({getPnlName(base[nP])})) == "{getProcess(base[nP],n)}":""")
          nLine.add(fmt"            {getProcess(base[nP],n)}()")
          break
      nbrButton = false
      for i in 0..len(base[nP].button) - 1:
        nbrButton = true
        btn = base[nP].button[i]
        nLine.add(fmt"      of TKey.{$btn.key}:")
        nLine.add(fmt"        break")
      if nbrButton :
        nLine.add(fmt"      else : discard")

    nLine.add(fmt"")
    nLine.add(fmt"  closeTerm()")

    nLine.add(fmt"")
    nLine.add(fmt"")
    nLine.add(fmt"")

    nLine.add(fmt"main()")


    for Tline in nLine:
      f.writeLine(Tline)
    f.close()
    nPnl = 0

    # write File .dspf
    jsonFile()

    setTerminal()
    break
#