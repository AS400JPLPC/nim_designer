#------------------------------------------------
# traitement label
#------------------------------------------------
type
  FIELD_Label {.pure.}= enum
    Lname,
    Lposx,
    Lposy,
    Ltitle

  Vlabel = ref object
    name : string
    posx : int
    posy : int
    text : string
    title: bool
const L_F1: array[FIELD_Label, int] = [0,1,2,3]

var pnLa :PANEL = newPanel("pnLx",1,1,7,35,@[defButton(TKey.F9,"F9 Enrg.",true),defButton(TKey.F12,"F12 return",true)],line1,"LABEL")
let fldL = new(Vlabel)

pnLa.label.add(defLabel($Lname, 2, 2, "Name.....:"))
pnLa.field.add(defString($Lname, 2, 2 + len(pnLa.label[L_F1[Lname,]].text), ALPHA_NUMERIC ,
                10, "", FILL, "Value Obligatoire [A-z0-9]","Name Label","^[A-z]{1,1}([A-z0-9]{1,9})$"))

pnLa.label.add(defLabel($Lposx, 3, 2, "PosX.....:"))
pnLa.field.add(defNumeric($Lposx , 3, 2 + len(pnLa.label[L_F1[Lposx]].text), DIGIT ,
                2, 0, "", FILL, "",""))
setProtect(pnLa.field[L_F1[Lposx]],true)

pnLa.label.add(defLabel($Lposy, 4, 2, "PosY.....:"))
pnLa.field.add(defNumeric($Lposy , 4, 2 + len(pnLa.label[L_F1[Lposy]].text), DIGIT ,
                3, 0, "", FILL, "" ,""))
setProtect(pnLa.field[L_F1[Lposy]],true)

pnLa.label.add(defLabel($Ltitle, 5, 2, "Title.....:"))
pnLa.field.add(defSwitch($Ltitle , 5, 2 + len(pnLa.label[L_F1[Ltitle]].text), SWITCH ,
                false,EMPTY, "" ,""))
setProtect(pnLa.field[L_F1[Ltitle]],true)


#------------------------------------------------
# write label
proc writeLabel(title :int):bool=
  onCursor()
  onMouse()
  var keyc : TKey = TKey.None
  var chr : string
  var vINT : Natural
  while true:
    gotoXY(X , Y)
    (keyc, chr)  = getTKey()
    case keyc
      of TKey.F12:
        getCursor(X , Y)
        gotoXY(terminalHeight(),terminalWidth()-20);  stdout.write "               "
        gotoXY(terminalHeight(),terminalWidth()-20);  stdout.write "Return         "
        gotoXY(X , Y)
        onMouse()
        break

      of TKey.Mouse :
        let mi = getMouse()
        if mi.action == MouseButtonAction.mbaPressed:

          # work this first /.../ bla bla
          case mi.button
          of mbLeft:
            gotoXY(terminalHeight(),terminalWidth()-20); stdout.write "               "
            gotoXY(terminalHeight(),terminalWidth()-20); stdout.write fmt"len:{len(e_TEXT)} {mi.x},{mi.y}"

          of mbMiddle:
            gotoXY(terminalHeight(),terminalWidth()-20); stdout.write "               "
            gotoXY(terminalHeight(),terminalWidth()-20); stdout.write fmt"len:{len(e_TEXT)} {mi.x},{mi.y}"

          of mbRight:
            gotoXY(terminalHeight(),terminalWidth()-20); stdout.write "               "
            gotoXY(terminalHeight(),terminalWidth()-20); stdout.write fmt"len:{len(e_TEXT)} {mi.x},{mi.y}"

          else: discard
        elif mi.action == MouseButtonAction.mbaReleased:
            gotoXY(terminalHeight(),terminalWidth()-20); stdout.write "               "
            gotoXY(terminalHeight(),terminalWidth()-20); stdout.write fmt"len:{len(e_TEXT)} {mi.x},{mi.y}"
        gotoXY(X,Y)

      of TKey.CtrlV:
        gotoXY(terminalHeight(),terminalWidth()-20);  stdout.write "               "
        v_TEXT = strip($e_TEXT,trailing = true)
        if len(e_TEXT) == 0 : return false
        else : return true


      of TKey.Char:
        gotoXY(X , Y)
        if Y < maxY and len(e_TEXT) < base[PanelWork].cols :
          if title == 1  :
            setBackgroundColor(bgBlack,false)
            setForegroundColor(fgGreen,true)
            writeStyled(chr,{styleDim,styleItalic})
          if title == 2  :
            setBackgroundColor(bgBlack,false)
            setForegroundColor(fgCyan,true)
            writeStyled(chr,{styleBright})
          vINT = Y - SY
          getCursor(X , Y)

          if len(e_TEXT) == vINT : e_TEXT.add(chr.runeAt(0))
          else : e_TEXT[vINT]=chr.runeAt(0)
          NY = SY + len(e_TEXT)
          gotoXY(terminalHeight(),terminalWidth()-20); stdout.write "               "
          gotoXY(terminalHeight(),terminalWidth()-20); stdout.write fmt"len:{len(e_TEXT)} ({X},{Y})"
          gotoXY(X , Y)


      of TKey.Left:
        getCursor(X , Y)
        if SX != X :
          cursorBackward()
          gotoXY(terminalHeight(),terminalWidth()-20); stdout.write "               "
          gotoXY(terminalHeight(),terminalWidth()-20); stdout.write fmt"len:{len(e_TEXT)} {SX},{SY}"
          gotoXY(SX,SY)
        elif SY < Y  :
          dec(Y)
          cursorBackward()
          gotoXY(terminalHeight(),terminalWidth()-20); stdout.write "               "
          gotoXY(terminalHeight(),terminalWidth()-20); stdout.write fmt"len:{len(e_TEXT)} {X},{Y}"  # {Y-1}
          gotoXY(X,Y)

      of TKey.Right:
        getCursor(X , Y)
        if SX != X :
          cursorBackward()
          gotoXY(terminalHeight(),terminalWidth()-20); stdout.write "               "
          gotoXY(terminalHeight(),terminalWidth()-20); stdout.write fmt"len:{len(e_TEXT)} {SX},{NY}"
          gotoXY(SX,NY)
        elif Y < NY :
          inc(Y)
          cursorForward()
          gotoXY(terminalHeight(),terminalWidth()-20); stdout.write "               "
          gotoXY(terminalHeight(),terminalWidth()-20); stdout.write fmt"len:{len(e_TEXT)} {X},{Y}"
          gotoXY(X,Y)

      else : discard
  if keyc == TKey.F12 : return false
  if keyc == TKey.CtrlV : return true

#------------------------------------------------------------------
# definition label

proc labelDef(majuscule : int)=
  SX = X
  SY = Y
  NY = Y
  offMouse()
  offCursor()
  e_TEXT = newSeq[Rune]()
  setTerminal()
  printPanel(detail)
  gotoXY(terminalHeight(),terminalWidth()-20); stdout.write "      "
  if majuscule == 1 :
    gotoXY(terminalHeight(),terminalWidth()-20); stdout.write "Label "
  else :
    gotoXY(terminalHeight(),terminalWidth()-20); stdout.write "Title "

  gotoXY(X , Y)
  if writeLabel(majuscule) == true:
    pnLx = pnLa
    if SX  < 15 :
      pnLx.posx = terminalHeight()-10
    else :
      pnLx.posx = 1

    pnLx.field[L_F1[Lname]].text = "L" & align($( SX - base[PanelWork].posx + 1), 2 ,"0".runeAt(0)) & align($(SY - base[PanelWork].posy + 1), 3 ,"0".runeAt(0))
    pnLx.field[L_F1[Lposx]].text = $(SX - base[PanelWork].posx + 1 )
    pnLx.field[L_F1[Lposy]].text = $(SY - base[PanelWork].posy + 1 )
    if majuscule == 1 :
      pnLx.field[L_F1[Ltitle]].switch = false
    else :
      pnLx.field[L_F1[Ltitle]].switch = true
    printPanel(pnLx)
    if majuscule == 1 :
      gotoXY(SX,SY); writeStyled(v_TEXT,{styleDim,styleItalic,styleUnderscore})
    else :
      gotoXY(SX,SY); writeStyled(v_TEXT,{styleBright,styleUnderscore})

    while true :
      key = ioPanel(pnLx)
      if key == TKey.F9 :
        fldL.name = getText(pnLx,L_F1[Lname])
        ## Contrôle  Format Panel full Field defTitle
        if isValide(pnlx)  :
          if majuscule == 1 :
            detail.label.add(defLabel(fldL.name, SX - base[PanelWork].posx + 1 , SY - base[PanelWork].posy + 1, v_TEXT))
            base[PanelWork].label.add(defLabel(fldL.name, SX - base[PanelWork].posx + 1, SY - base[PanelWork].posy + 1, v_TEXT))
          else :
            detail.label.add(defTitle(fldL.name, SX - base[PanelWork].posx + 1 , SY - base[PanelWork].posy + 1, v_TEXT))
            base[PanelWork].label.add(defTitle(fldL.name, SX - base[PanelWork].posx + 1, SY - base[PanelWork].posy + 1, v_TEXT))

          break
      if key == TKey.Escape : break

  setTerminal()
  printPanel(detail)
  gotoXY(minX,minY)
  onMouse()



#------------------------------------------------------------------
# rename sequence label

proc orderLabel()=
  setTerminal()
  printPanel(orderZ)
  offMouse()

  Zgrid  = newGrid("GRID01",2,2,20)
  Zdup   = newGrid("GRID02",2,65,20)
  var g_id      = defCell("ID",3,DIGIT)
  var g_name    = defCell("Name",10,ALPHA,cellYellow)
  var g_posx    = defCell("PosX",4,DIGIT)
  var g_posy    = defCell("PosY",4,DIGIT)
  var g_txt     = defCell("....",30,ALPHA)
  var g_title   = defCell("Title",5,SWITCH)
  var v_txt :string
  var g_numIDx : int = -1
  var g_numID = - 1

  setHeaders(Zgrid, @[g_id, g_name, g_posx, g_posy, g_txt, g_title])
  setHeaders(Zdup,  @[g_id, g_name, g_posx, g_posy, g_txt, g_title])
  printGridHeader(Zdup)
  for n in 0..len(base[PanelWork].label)-1:
    if runeLen(getTextL(base[PanelWork],n)) >= getcellLen(g_txt) : v_txt = runeSubStr(getTextL(base[PanelWork],n), 0 ,getcellLen(g_txt) )
    else : v_txt = getTextL(base[PanelWork],n)
    addRows(Zgrid, @[setID(g_numID), getNameL(base[PanelWork],n), $getPosxL(base[PanelWork],n),$getPosyL(base[PanelWork],n), v_txt, $isTitle(base[PanelWork],n), $getTextL(base[PanelWork],n)])
  while true :
    let (keys, val) = ioGrid(Zgrid)
    if keys == TKey.Enter :
      addRows(Zdup, @[setID(g_numIDx), val[1], val[2], val[3], val[4], val[5], val[6]])
      printGridRows(Zdup)
      dltRows(Zgrid,getIndexG(Zgrid,val[0]))

    if countRows(Zgrid) == 0 and countRows(Zdup) > 0 :
        base[PanelWork].label = newSeq[LABEL]()
        detail.label = newSeq[LABEL]()
        for n in 0..countRows(Zdup) - 1:
          if not isrowTitle(Zdup ,n) :
            detail.label.add(defLabel(getrowName(Zdup,n), getrowPosx(Zdup,n), getrowPosy(Zdup,n), getrowText(Zdup,n)))
            base[PanelWork].label.add(defLabel(getrowName(Zdup,n), getrowPosx(Zdup,n), getrowPosy(Zdup,n), getrowText(Zdup,n)))
          else:
            detail.label.add(defTitle(getrowName(Zdup,n), getrowPosx(Zdup,n), getrowPosy(Zdup,n), getrowText(Zdup,n)))
            base[PanelWork].label.add(  defTitle(getrowName(Zdup,n), getrowPosx(Zdup,n), getrowPosy(Zdup,n), getrowText(Zdup,n)))

        Zgrid  = newGrid("GRID01",2,2,30)
        Zdup   = newGrid("GRID02",2,65,30)
        setHeaders(Zgrid, @[g_id, g_name, g_posx, g_posy, g_txt, g_title])
        setHeaders(Zdup,  @[g_id, g_name, g_posx, g_posy, g_txt, g_title])
        printGridHeader(Zdup)
        g_numID = - 1
        g_numIDx = - 1
        for n in 0..len(base[PanelWork].label)-1:
          if runeLen(getTextL(base[PanelWork],n)) >= getcellLen(g_txt) : v_txt = runeSubStr(getTextL(base[PanelWork],n), 0 ,getcellLen(g_txt) )
          else : v_txt = getTextL(base[PanelWork],n)
          addRows(Zgrid, @[setID(g_numID), getNameL(base[PanelWork],n), $getPosxL(base[PanelWork],n), $getPosyL(base[PanelWork],n), v_txt, $isTitle(base[PanelWork],n), getTextL(base[PanelWork],n)])

    if keys == TKey.Escape : return

#------------------------------------------------------
# remove label

proc rmvLabel()=
  setTerminal()
  printPanel(orderZ)
  offMouse()

  Zgrid  = newGrid("GRID01",2,2,20)
  var g_id      = defCell("ID",3,DIGIT)
  var g_name    = defCell("Name",10,ALPHA,cellYellow)
  var g_posx    = defCell("PosX",4,DIGIT)
  var g_posy    = defCell("PosY",4,DIGIT)
  var g_txt     = defCell("....",30,ALPHA)
  var g_title   = defCell("Title",5,SWITCH)
  var v_txt :string
  var g_numID = - 1

  setHeaders(Zgrid, @[g_id, g_name, g_posx, g_posy, g_txt, g_title])
  for n in 0..len(base[PanelWork].label)-1:
    if runeLen(getTextL(base[PanelWork],n)) >= getcellLen(g_txt) : v_txt = runeSubStr(getTextL(base[PanelWork],n), 0 ,getcellLen(g_txt) )
    else : v_txt = getTextL(base[PanelWork],n)
    addRows(Zgrid, @[setID(g_numID), getNameL(base[PanelWork],n), $getPosxL(base[PanelWork],n), $getPosyL(base[PanelWork],n), v_txt, $isTitle(base[PanelWork],n), getTextL(base[PanelWork],n)])

  while true :
    let (keys, val) = ioGrid(Zgrid)
    if keys == TKey.Enter :
      for n in 0..len(base[PanelWork].label) - 1:
        if base[PanelWork].label[n].name == getrowName(Zgrid,getIndexG(Zgrid,val[0])):
          base[PanelWork].label.delete(n)
          break
      for n in 0..len(detail.label) - 1:
        if detail.label[n].name == getrowName(Zgrid,getIndexG(Zgrid,val[0])):
          detail.label.delete(n)
          dltRows(Zgrid,getIndexG(Zgrid,val[0]))
          break

    if keys == TKey.Escape : return
