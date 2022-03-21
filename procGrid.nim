#------------------------------------------------
# traitement SFILE
#------------------------------------------------


#===================================================

#===================================================
type
  FIELD_Sfile {.pure.}= enum
    Sform,
    Sname,
    Sposx,
    Sposy,
    Snrow,
    Ssep



  FIELD_Sfile_Cell {.pure.}= enum
    Ctext,
    Clong,
    Ctype,
    Catr,
    Cedtcar

  CELL_Sfile = ref object
      text  : string
      long  : Natural
      reftyp: string
      cellatr : string
      edtcar: string

  GSFILE = ref object
    panel:string
    form : string
    name : string
    posx : int
    posy : int
    nrow : int
    sep  : string
    defcell : seq[CELL_Sfile]
    citem : seq[seq[string]]       # value combo for  form = 'combo'

const F_S0: array[FIELD_Sfile, int] = [0,1,2,3,4,5]
const F_S1: array[FIELD_Sfile_Cell, int] = [0,1,2,3,4]

var Dsfile : GSFILE
var NSFILE = newseq[GSFILE]()
var g_index : int = - 1

var SpnlSfile = newPanel("PNLSFILE",1,1,4,100,@[defButton(TKey.F9,"Enrg",true),defButton(TKey.F12,"return")],line1,"Grid")
# LABEL  -> CELL
SpnlSfile.label.add(deflabel("L02002", 2, 2,  "Form.:"))
SpnlSfile.label.add(deflabel("L02002", 2, 14, "Name.:"))
SpnlSfile.label.add(deflabel("L02020", 2, 32, "Posx.:"))
SpnlSfile.label.add(deflabel("L02031", 2, 42, "Posy.:"))
SpnlSfile.label.add(deflabel("L02051", 2, 62, "Rows.:"))
SpnlSfile.label.add(deflabel("L02061", 2, 72, "Sep..:"))
# FIELD -> SFILE
SpnlSfile.field.add(defString($Sform, 2, 8, FPROC,5,"", FILL, "Obligatoire", "combo|grid"))
setProcess(SpnlSfile.field[F_S0[Sform]],"queryForm")
SpnlSfile.field.add(defString($Sname, 2, 20, TEXT_FREE,10,"", FILL, "Obligatoire", "Name SFILE"))
SpnlSfile.field.add(defNumeric($Sposx, 2,38, DIGIT,2,0,"", EMPTY, "",""))
setProtect(SpnlSfile.field[F_S0[Sposx]],true)
SpnlSfile.field.add(defNumeric($Sposy, 2,48, DIGIT,3,0,"", EMPTY, "",""))
setProtect(SpnlSfile.field[F_S0[Sposy]],true)
SpnlSfile.field.add(defNumeric($Snrow, 2, 68, DIGIT,2,0,"", FILL, "Obligatoire", "Nombre Rows"))
SpnlSfile.field.add(defString($Ssep, 2, 78, FPROC,8,"", FILL, "Obligatoire", "sepStyle > '|'  noStyle >' ' "))
setProcess(SpnlSfile.field[F_S0[Ssep]],"querySeparatorCell")


var SpnlCell  :PANEL = newPanel("SFLCELL",1,1,5,100,@[defButton(TKey.F9,"Add",true),defButton(TKey.Escape,"Abort")],line1,"column ")
# LABEL  -> CELL
SpnlCell.label.add(deflabel("L02002", 2, 2,  "Text.:"))
SpnlCell.label.add(deflabel("L02020", 3, 21, "Long.:"))
SpnlCell.label.add(deflabel("L02031", 3, 31, "Type.:"))
SpnlCell.label.add(deflabel("L02051", 3, 51, "Color:"))
SpnlCell.label.add(deflabel("L02051", 3, 71, "Car..:"))

# FIELD -> CELL
SpnlCell.field.add(defString($Ctext, 2, 8, TEXT_FREE,30,"", FILL, "Obligatoire", "Text CELL"))
SpnlCell.field.add(defNumeric($Clong, 3, 27, DIGIT,3,0,"", FILL, "obligatoire", "len field display"))
SpnlCell.field.add(defString($Ctype, 3, 37, FPROC,14,"", FILL, "", "type DIGIT TEXT_FREE DECIMAL SWITCH"))
setProcess(SpnlCell.field[F_S1[Ctype]],"queryTypeCell")
SpnlCell.field.add(defString($Catr, 3, 57, FPROC,10,"", FILL, "", "Color foreground"))
setProcess(SpnlCell.field[F_S1[Catr]],"queryColorCell")
SpnlCell.field.add(defString($Cedtcar, 3, 77, TEXT_FREE,1,"", EMPTY, "", "Car:'€%£$¥ '"))
setRegex(SpnlCell,$Cedtcar,"^[€%£$¥ ]")


#===================================================
proc queryForm(fld : var FIELD) =
  var g_pos : int = -1
  var Xcombo  = newGRID("COMBO20",2,2,3,sepStyle)

  var g_type  = defCell("Ref.Type",10,TEXT_FREE)

  setHeaders(Xcombo, @[g_type])
  addRows(Xcombo, @["combo"])
  addRows(Xcombo, @["grid"])


  printGridHeader(Xcombo)

  case fld.text
    of "combo"            : g_pos = 0
    of "grid"             : g_pos = 1
    else : discard

  while true :
    let (keys, val) = ioGrid(Xcombo,g_pos)

    case keys
      of TKey.Enter :
        restorePanel(detail,Xcombo)
        fld.text  = $val[0]
        break
      else: discard

callQuery["queryForm"] = queryForm

#===================================================
proc querySeparatorCell(fld : var FIELD) =
  var g_pos : int = -1
  var Xcombo  = newGRID("COMBO21",2,2,3,sepStyle)

  var g_type  = defCell("Ref.Type",10,TEXT_FREE)

  setHeaders(Xcombo, @[g_type])
  addRows(Xcombo, @["sepStyle"])
  addRows(Xcombo, @["noStyle"])


  printGridHeader(Xcombo)

  case fld.text
    of "sepStyle"            : g_pos = 0
    of "noStyle"             : g_pos = 1
    else : discard

  while true :
    let (keys, val) = ioGrid(Xcombo,g_pos)

    case keys
      of TKey.Enter :
        restorePanel(detail,Xcombo)
        fld.text  = $val[0]
        break
      else: discard

callQuery["querySeparatorCell"] = querySeparatorCell

#===================================================
proc queryTypeCell(fld : var FIELD) =
  var g_pos : int = -1
  var Xcombo  = newGRID("COMBO22",2,2,7,sepStyle)

  var g_type  = defCell("Ref.Type",14,TEXT_FREE)

  setHeaders(Xcombo, @[g_type])
  addRows(Xcombo, @["TEXT_FREE"])
  addRows(Xcombo, @["DIGIT"])
  addRows(Xcombo, @["DIGIT_SIGNED"])
  addRows(Xcombo, @["DECIMAL"])
  addRows(Xcombo, @["DECIMAL_SIGNED"])

  printGridHeader(Xcombo)

  case fld.text
    of "TEXT_FREE"            : g_pos = 0
    of "DIGIT"                : g_pos = 1
    of "DIGIT_SIGNED"         : g_pos = 2
    of "DECIMAL"              : g_pos = 3
    of "DECIMAL_SIGNED"       : g_pos = 4

    else : discard

  while true :
    let (keys, val) = ioGrid(Xcombo,g_pos)

    case keys
      of TKey.Enter :
        restorePanel(detail,Xcombo)
        fld.text  = $val[0]
        break
      else: discard

callQuery["queryTypeCell"] = queryTypeCell


#===================================================
proc queryColorCell(fld : var FIELD) =
  var g_pos : int = -1
  var Xcombo  = newGRID("COMBO23",2,2,8,sepStyle)

  var g_type  = defCell("Foreground",10,TEXT_FREE)

  setHeaders(Xcombo, @[g_type])
  addRows(Xcombo, @["Black"])
  addRows(Xcombo, @["Red"])
  addRows(Xcombo, @["Green"])
  addRows(Xcombo, @["Yellow"])
  addRows(Xcombo, @["Blue"])
  addRows(Xcombo, @["Magenta"])
  addRows(Xcombo, @["Cyan"])
  addRows(Xcombo, @["White"])
  printGridHeader(Xcombo)


  case fld.text
    of "Black"            : g_pos = 0
    of "Red"              : g_pos = 1
    of "Green"            : g_pos = 2
    of "Yellow"           : g_pos = 3
    of "Blue"             : g_pos = 4
    of "Magenta"          : g_pos = 5
    of "Cyan"             : g_pos = 6
    of "White"            : g_pos = 7
    else : g_pos = 7

  while true :
    let (keys, val) = ioGrid(Xcombo,g_pos)

    case keys
      of TKey.Enter :
        restorePanel(detail,Xcombo)
        fld.text  = $val[0]
        break
      else: discard

callQuery["queryColorCell"] = queryColorCell




## return color
proc toRefColor(TextColor: string ;):CELLATRB =
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
  result = cellcolor



# var interne
proc toRefStyle(CellStyle: string ;):GridStyle =
  case CellStyle
    of "sepStyle"         : result = GridStyle( colSeparator:"│")
    of "noStyle"          : result = GridStyle( colSeparator:" ")
    else : result = GridStyle( colSeparator:"│")


## return ref_type
proc toCellType(TextType: string ;):REFTYP =
    case TextType:
      of "TEXT_FREE" :            result = TEXT_FREE
      of "ALPHA" :                result = ALPHA
      of "ALPHA_UPPER" :          result = ALPHA_UPPER
      of "ALPHA_NUMERIC" :        result = ALPHA_NUMERIC
      of "ALPHA_NUMERIC_UPPER" :  result = ALPHA_NUMERIC_UPPER
      of "TEXT_FULL" :            result = TEXT_FULL
      of "PASSWORD" :             result = PASSWORD
      of "DIGIT" :                result = DIGIT
      of "DIGIT_SIGNED" :         result = DIGIT_SIGNED
      of "DECIMAL" :              result = DECIMAL
      of "DECIMAL_SIGNED" :       result = DECIMAL_SIGNED
      of "DATE_ISO" :             result = DATE_ISO
      of "DATE_FR" :              result = DATE_FR
      of "DATE_US" :              result = DATE_US
      of "TELEPHONE" :            result = TELEPHONE
      of "MAIL_ISO" :             result = MAIL_ISO
      of "YES_NO" :               result = YES_NO
      of "SWITCH" :               result = SWITCH
      of "FPROC" :                result = FPROC
      of "FCALL" :                result = FCALL
      else : result = TEXT_FREE

#===================================================

proc callSfile(sfl : seq[GSFILE]; namePanel: string; crtsfl : bool) : int =
  var g_pos : int = -1
  var Xcombo  = newGRID("COMBO24",1,1,20,sepStyle)
  var g_id    = defCell("ID",3,DIGIT)
  var g_name  = defCell("Name",10,TEXT_FREE,cellYellow)
  setHeaders(Xcombo, @[g_id, g_name])

  var g_numID = 0
  for i in 0..len(sfl )-1:
    if sfl[i].panel == namePanel :
      addRows(Xcombo, @[setID(g_numID), sfl[i].name] )

  if crtsfl : addRows(Xcombo, @["999", "Add", "SFILE"])

  while true :
    let (keys, val) = ioGrid(Xcombo,g_pos)
    case keys
      of TKey.Enter :
        g_numID = parseInt($val[0])
        if g_numId < 999 : g_numID.dec
        restorePanel(detail,Xcombo)
        return g_numID
      of TKey.Escape :
        restorePanel(detail,Xcombo)
        return -1
      else: discard

#===================================================

proc ViewCellSfile(nitem : seq[CELL_Sfile]) =

  var Xgrid  = newGRID("CELLCOMBO",1,1,5,sepStyle)

  var g_id    = defCell("ID",3,DIGIT)
  var g_text  = defCell("Text",10,TEXT_FREE)
  var g_len   = defCell("len",3 ,DIGIT)
  var g_type  = defCell("type",10 ,DIGIT)
  var g_color = defCell("color",6 ,TEXT_FREE)

  setHeaders(Xgrid, @[g_id, g_text, g_len, g_type, g_color])

  var g_numID = 0
  for i in 0..len(nitem)-1:
    addRows(Xgrid, @[setID(g_numID), $nitem[i].text, $nitem[i].long, $nitem[i].reftyp,$nitem[i].cellatr] )

  printGridHeader(Xgrid)
  printGridRows(Xgrid)

  while true :
    let keys = getFunc(true)
    case keys
      of TKey.Escape :
        setTerminal()         # specifique grid > panel
        printPanel(detail)
        onMouse()
        onCursor()
        gotoXY(minX,minY)
        break
      of TKey.PageUp :
        keyG = pageUpGrid(Xgrid)
        if keyG == TKey_Grid.PGup:
          gotoXY(terminalHeight(),terminalWidth()-10); stdout.write "Prior"
        else:
          gotoXY(terminalHeight(),terminalWidth()-10);  stdout.write "Home "
      of TKey.PageDown :
        keyG = pageDownGrid(Xgrid)
        if keyG == TKey_Grid.PGdown:
          gotoXY(terminalHeight(),terminalWidth()-10); stdout.write "Next "
        else:
          gotoXY(terminalHeight(),terminalWidth()-10); stdout.write "End  "
      else : discard

#===================================================

proc rmvGrid (namePanel: string)=
  var g_pos : int = -1
  var Xcombo  = newGRID("COMBO24",1,1,20,sepStyle)
  var g_id    = defCell("ID",3,DIGIT)
  var g_name  = defCell("Name",10,TEXT_FREE,cellYellow)
  var g_row   = defCell("row",3,DIGIT)

  var index : int # table grid
  setHeaders(Xcombo, @[g_id, g_name,g_row])

  var g_numID = 0
  for i in 0..len(NSFILE)-1:
    if NSFILE[i].panel == namePanel :
      addRows(Xcombo, @[setID(g_numID),NSFILE[i].name,$i] )


  while true :
    let (keys, val) = ioGrid(Xcombo,g_pos)
    case keys
      of TKey.Enter :
        index = parseInt($val[2])
        NSFILE.delete(index)
        index = parseInt($val[0])
        Xcombo.dltRows(index)
      of TKey.Escape :
        setTerminal()         # specifique grid > panel
        printPanel(detail)
        break
      else: discard

#===================================================


proc RmvCellSfile(nitem : var seq[CELL_Sfile]) =

  var Xgrid  = newGRID("GRIDCOMBO",1,1,30,sepStyle)

  var g_id    = defCell("ID",3,DIGIT)
  var g_text  = defCell("Text",10,TEXT_FREE)
  var g_len   = defCell("len",2 ,DIGIT)
  var g_type  = defCell("type",10 ,DIGIT)
  var g_color = defCell("color",6 ,TEXT_FREE)

  setHeaders(Xgrid, @[g_id, g_text, g_len, g_type, g_color])
  printGridHeader(Xgrid)

  var g_numID = 0
  for i in 0..len(nitem)-1:
    addRows(Xgrid, @[setID(g_numID), $nitem[i].text, $nitem[i].long, $nitem[i].reftyp, $nitem[i].cellatr] )

  while true :
    let (keys, val) = ioGrid(Xgrid)
    if keys == TKey.Enter :
      for n in 0..len(nitem) - 1:
        if nitem[n].text == getrowName(Xgrid,getIndexG(Xgrid,val[0])):
          nitem.delete(n)
          # clear item combo
          if len(Dsfile.citem) > 0:
            if n <= len(Dsfile.citem[0]):
              for i in 0..len(Dsfile.citem)-1:
                if len(Dsfile.citem[0]) > 1 :
                  Dsfile.citem[i].delete(n)
                else :
                  Dsfile.citem.delete(i)
          break
      Xgrid  = newGrid("GRIDCOMBO",1,1,30)
      setHeaders(Xgrid, @[g_id, g_text, g_len, g_type, g_color])
      printGridHeader(Xgrid)

      for i in 0..len(nitem)-1:
        addRows(Xgrid, @[setID(g_numID), $nitem[i].text, $nitem[i].long, $nitem[i].reftyp, $nitem[i].cellatr] )

    if keys == TKey.Escape :
      setTerminal()         # specifique grid > panel
      printPanel(detail)
      onMouse()
      onCursor()
      gotoXY(minX,minY)
      return



#===================================================

proc ViewSfile() =
  var g_pos : int = -1
  var Xgrid = newGRID(Dsfile.name,Dsfile.posx,Dsfile.posy,Dsfile.nrow,toRefStyle(Dsfile.sep))

  var cellColonne:seq[CELL]
  var cellRows:seq[string]
  var cellString : string
  for n in 0..len(Dsfile.defcell)-1:
    cellColonne.add(defCell(Dsfile.defcell[n].text, Dsfile.defcell[n].long, toCellType(Dsfile.defcell[n].reftyp),
                toRefColor(Dsfile.defcell[n].cellatr)))
    if Dsfile.defcell[n].edtcar > "" : setCellEditCar(cellColonne[n],Dsfile.defcell[n].edtcar)

  setHeaders(Xgrid,cellColonne)
  printGridHeader(Xgrid)

  for n in 0..len(Dsfile.defcell)-1:
    if Dsfile.form == "grid" :
      cellString =""

      case toCellType(Dsfile.defcell[n].reftyp):
        of DIGIT :
          for i in 0..Dsfile.defcell[n].long-1 : cellString &= "5"
          cellRows.add(cellString)
        of DIGIT_SIGNED :
          cellString = "+"
          for i in 0..Dsfile.defcell[n].long-2 : cellString &= "5"
          cellRows.add(cellString)
        of DECIMAL :
          for i in 0..Dsfile.defcell[n].long-3 : cellString &= "7"
          cellString = cellString & "."
          cellString = cellString & "7"
          cellRows.add(cellString)
        of DECIMAL_SIGNED :
          cellString = "+"
          for i in 0..Dsfile.defcell[n].long-4 : cellString &= "7"
          cellString = cellString & "."
          cellString = cellString & "7"
          cellRows.add(cellString)
        else :
          for i in 0..Dsfile.defcell[n].long-1 : cellString &= "A"
          cellRows.add(cellString)

  if Dsfile.form == "grid" :
    for i in 0..Dsfile.nrow-1:
        addRows(Xgrid, cellRows)
  else :
    for n in 0..len(Dsfile.citem) - 1:
      if len(Dsfile.citem[n]) >= len(Dsfile.defcell) :
        addRows(Xgrid,Dsfile.citem[n])




  while true :
    let keys = ioGridGen(Xgrid,g_pos)

    case keys
      of TKey.Escape :
        setTerminal()         # specifique grid > panel
        printPanel(detail)
        onMouse()
        onCursor()
        gotoXY(minX,minY)
        break
      else : discard

#===================================================
proc WorkItem() =
  var XGridItem = newGRID(Dsfile.name,Dsfile.posx,Dsfile.posy,Dsfile.nrow,toRefStyle(Dsfile.sep))

  var cellColonne:seq[CELL]
  var cellRows:seq[string]
  var gridlen :Natural = 1
  var keyp:TKey = TKey.None
  var nameField :string
  for n in 0..len(Dsfile.defcell)-1:
    cellColonne.add(defCell(Dsfile.defcell[n].text, Dsfile.defcell[n].long, toCellType(Dsfile.defcell[n].reftyp),
                toRefColor(Dsfile.defcell[n].cellatr)))
    setCellEditCar(cellColonne[n],Dsfile.defcell[n].edtcar)
    gridlen += Dsfile.defcell[n].long + 1

  setHeaders(XGridItem,cellColonne)
  printGridHeader(XGridItem)

  if g_index < 999 :
    for n in 0..len(Dsfile.citem)-1:
      addRows(XGridItem,Dsfile.citem[n])

  printGridRows(XGridItem)


  var XItem :PANEL = newPanel("ITEM",Dsfile.posx + 2,Dsfile.posy,4,gridlen,@[defButton(TKey.F9,"Add",true),defButton(TKey.Escape,"")],line1)

  # FIELD -> CELL
  var ypos = 2
  for n in 0..counColumns(XGridItem)-1:
    nameField = fmt"item{n}"
    XItem.field.add(defString($nameField, 2, ypos, TEXT_FREE, Dsfile.defcell[n].long,"", FILL, "Obligatoire", "Text CELL"))
    ypos = ypos + 1 + Dsfile.defcell[n].long
    case Dsfile.defcell[n].reftyp
      of "DIGIT"                : setRegex(XItem,$nameField,"^[0-9]{1,}$")
      of "DIGIT_SIGNED"         : setRegex(XItem,$nameField,"^[+-]?([0-9]{1,})$")
      of "DECIMAL"              : setRegex(XItem,$nameField,"^[+-]?([0-9]{1,})[.]([0-9]{1,})$")
      of "DECIMAL_SIGNED"       : setRegex(XItem,$nameField,"^[+-]?([0-9]{1,})[.]([0-9]{1,})$")
      else: discard

  while true:
    for n in 0..len(Dsfile.defcell)-1:
      XItem.setText(n,"")
    while true:
      printPanel(XItem)
      keyp = ioPanel(XItem)
      case keyp
        of TKey.F9:
          if isValide(XItem) :
            cellRows = newSeq[string]()
            for n in 0..len(Dsfile.defcell)-1:
              cellRows.add($XItem.getText(fmt"item{n}"))

            Dsfile.citem.add(cellRows)
            addRows(XGridItem,cellRows)
            break

        else: discard
      if keyp == TKey.Escape : break

    printGridHeader(XGridItem)
    printGridRows(XGridItem)


    while true :
      let keys = getFunc(true)
      case keys
        of TKey.Escape :
          setTerminal()         # specifique grid > panel
          printPanel(detail)
          onMouse()
          onCursor()
          gotoXY(minX,minY)
          return
        of TKey.PageUp :
          keyG = pageUpGrid(XGridItem)
          if keyG == TKey_Grid.PGup:
            gotoXY(terminalHeight(),terminalWidth()-10); stdout.write "Prior"
          else:
            gotoXY(terminalHeight(),terminalWidth()-10);  stdout.write "Home "
        of TKey.PageDown :
          keyG = pageDownGrid(XGridItem)
          if keyG == TKey_Grid.PGdown:
            gotoXY(terminalHeight(),terminalWidth()-10); stdout.write "Next "
          else:
            gotoXY(terminalHeight(),terminalWidth()-10); stdout.write "End  "
        else : break

#------------------------------------------------
# write Sfile


proc gridDef(Tpanel:string)=
  var fldsfl = new(CELL_Sfile)
  var sok:bool
  var keyp:TKey = TKey.None
  g_index  = callSfile(NSFILE,Tpanel,true) # index -> nombre sfile and add=999
  if g_index == -1 : return
  printPanel(detail)
  if g_index < 999  :
    Dsfile = NSFILE[g_index]
    sok =true
    gotoXY(Dsfile.posx,Dsfile.posy) ;
    getCursor(SX,SY)
  else :
    sok =false
    Dsfile = new(GSFILE)
    Dsfile.panel = Tpanel


  keyp = Tkey.altS
  gotoXY(SX,SY) ; writeStyled("?", {styleBright,styleBlink})

  setText(SpnlSfile,F_S0[Sposx],$SX)
  setText(SpnlSfile,F_S0[Sposy],$SY)
  while true:

    case keyp

      of Tkey.altS:     # def cell SourceFile-> grid
        if not sok :
          SpnlSfile.setText(F_S0[Sform],"")
          SpnlSfile.setText(F_S0[Sname],"")
          SpnlSfile.setText(F_S0[Snrow],"")
          SpnlSfile.setText(F_S0[Ssep],"sepStyle")
        else :
          SpnlSfile.setText(F_S0[Sform],Dsfile.form)
          SpnlSfile.setText(F_S0[Sname],Dsfile.name)
          SpnlSfile.setText(F_S0[Snrow],$Dsfile.nrow)
          SpnlSfile.setText(F_S0[Ssep],Dsfile.sep)
        SpnlSfile.index = 0
        printPanel(SpnlSfile)
        while true:
          keyp = ioPanel(SpnlSfile)
          case keyp
            of TKey.PROC:
              if isProcess(SpnlSfile,Index(SpnlSfile)) :
                callQuery[getProcess(SpnlSfile,Index(SpnlSfile))] (SpnlSfile.field[Index(SpnlSfile)])
              #printPanel(detail)
              printPanel(SpnlSfile)

            of TKey.F9 :
              if isValide(SpnlSfile) :
                Dsfile.form = SpnlSfile.getText(F_S0[Sform])
                Dsfile.name = SpnlSfile.getText(F_S0[Sname])
                Dsfile.posx = parseInt(SpnlSfile.getText(F_S0[Sposx]))
                Dsfile.posy = parseInt(SpnlSfile.getText(F_S0[Sposy]))
                Dsfile.nrow = parseInt(SpnlSfile.getText(F_S0[Snrow]))
                Dsfile.sep = SpnlSfile.getText(F_S0[Ssep])
                sok =true

            else: discard
          if keyp == TKey.F9 :
            restorePanel(detail,SpnlSfile)
            break
          if keyp == TKey.F12 :
            restorePanel(detail,SpnlSfile)
            return

      of Tkey.altC:     # def cell  header Grid
        SpnlCell.setText(F_S1[Ctext],"")
        SpnlCell.setText(F_S1[Clong],"")
        SpnlCell.setText(F_S1[Ctype],"")
        SpnlCell.setText(F_S1[Cedtcar],"")
        if Dsfile.form == "combo" : SpnlCell.setText(F_S1[Catr],"Cyan")
        else: SpnlCell.setText(F_S1[Catr],"")
        SpnlCell.index = 0
        printPanel(SpnlCell)
        while true:
          keyp = ioPanel(SpnlCell)
          case keyp
            of TKey.PROC:
              if isProcess(SpnlCell,Index(SpnlCell)) :
                callQuery[getProcess(SpnlCell,Index(SpnlCell))] (SpnlCell.field[Index(SpnlCell)])
              printPanel(detail)
              printPanel(SpnlCell)

            of TKey.F9:
              if isValide(SpnlCell) :
                fldsfl.text = SpnlCell.getText(F_S1[Ctext])
                fldsfl.long = parseInt(SpnlCell.getText(F_S1[Clong]))
                fldsfl.reftyp = SpnlCell.getText(F_S1[Ctype])
                fldsfl.edtcar = SpnlCell.getText(F_S1[Cedtcar])
                fldsfl.cellatr = SpnlCell.getText(F_S1[Catr])
                Dsfile.defcell.add(fldsfl)
                fldsfl = new(CELL_Sfile)
                restorePanel(detail,SpnlCell)
                if len(Dsfile.citem) > 0 :
                  Dsfile.citem = newSeq[seq[string]]()
            else: discard

          if keyp ==  TKey.F9 or keyp == TKey.Escape :
            restorePanel(detail,SpnlCell)
            break


      of Tkey.altI:     # def item for combo
        if Dsfile.form == "combo" and Dsfile.defcell.len > 0 :
          WorkItem()

      of TKey.altP:
        if   Dsfile.defcell.len > 0 :
          ViewCellSfile(Dsfile.defcell)

      of TKey.altR:
        if Dsfile.defcell.len > 0 :
          RmvCellSfile(Dsfile.defcell)

      of TKey.altD:
        if   Dsfile.defcell.len > 0 :
          ViewSfile()

      # validation des données
      of TKey.CtrlV:
        if   Dsfile.defcell.len > 0 :
          if g_index < 999  : NSFILE[g_index] = Dsfile
          else: NSFILE.add(Dsfile)
        if   Dsfile.defcell.len == 0 and  g_index < 999  : NSFILE.del(g_index)
        return

      # end GRID
      of TKey.CtrlQ:
        return

      else : discard

    keyp = getFunc(true)