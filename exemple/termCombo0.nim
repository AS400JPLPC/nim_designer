import  termkey, termcurs



type
  CELL_Combo = ref object
      text : string
      long  : Natural
      reftyp: REFTYP
      edtcar: string
      cellatr : CELLATRB
  Vcombo = ref object
    name : string
    posx : int
    posy : int
    nrow : int
    sep  : GridStyle
    citem : seq[CELL_Combo]

var cellYellow = new(CELLATRB)
cellYellow.cell_style = {styleDim,styleItalic}
cellYellow.cell_backgr = BackgroundColor.bgblack
cellYellow.cell_backbr = false
cellYellow.cell_foregr = ForegroundColor.fgYellow
cellYellow.cell_forebr = true



var Ncombo = new(Vcombo)

Ncombo.name="combo-01"
Ncombo.posx = 1
Ncombo.posy = 1
Ncombo.nrow = 0
Ncombo.sep  = sepStyle


var fldC = new(CELL_Combo)

fldc.text = "Article"
fldc.long = 10
fldc.reftyp = ALPHA
fldc.edtcar ="€"
fldc.cellatr =cellYellow


Ncombo.citem.add(fldc)
fldC = new(CELL_Combo)

fldc.text = "Depot"
fldc.long = 20
fldc.reftyp = ALPHA
fldc.edtcar =""
Ncombo.citem.add(fldc)

fldC = new(CELL_Combo)

fldc.text = "Depot"
fldc.long = 20
fldc.reftyp = ALPHA
fldc.edtcar =""
Ncombo.citem.add(fldc)

fldC = new(CELL_Combo)

fldc.text = "Type"
fldc.long = 4
fldc.reftyp = ALPHA
fldc.edtcar =""
Ncombo.citem.add(fldc)

fldC = new(CELL_Combo)

fldc.text = "Intitulé"
fldc.long = 30
fldc.reftyp = ALPHA
fldc.edtcar =""
Ncombo.citem.add(fldc)

fldC = new(CELL_Combo)

fldc.text = "Nbr Article"
fldc.long = 20
fldc.reftyp = DIGIT
fldc.edtcar =""
Ncombo.citem.add(fldc)





initTerm(30,100)
#setTerminal() #default color style erase


#===================================================

proc ViewCellCombo(nitem : seq[CELL_Combo])  =
  var keyG : TKey_Grid
  var Xgrid = newGRID("CELLCOMBO",2,2,5,sepStyle)

  var g_text  = defCell("Text",10,TEXT_FREE)
  var g_len   = defCell("len",3 ,DIGIT)
  var g_type  = defCell("type",10 ,ALPHA)

  setHeaders(Xgrid, @[g_text, g_len, g_type])
  printGridHeader(Xgrid)


  for i in 0..len(nitem)-1:
    addRows(Xgrid, @[$nitem[i].text, $nitem[i].long, $nitem[i].reftyp] )


  printGridHeader(Xgrid)
  printGridRows(Xgrid)

  while true :

    let keyC = getFunc()

    case keyC

      of TKey.Escape:
        break

      of TKey.PageUp :
        keyG = pageUpGrid(Xgrid)
        if keyG == TKey_Grid.PGup:
          gotoXY(terminalHeight(),terminalWidth()-10); writeStyled("Prior")
        else:
          gotoXY(terminalHeight(),terminalWidth()-10); writeStyled("Home ")

      of TKey.PageDown :
        keyG = pageDownGrid(Xgrid)
        if keyG == TKey_Grid.PGdown:
          gotoXY(terminalHeight(),terminalWidth()-10); writeStyled("Next ")
        else:
          gotoXY(terminalHeight(),terminalWidth()-10); writeStyled("End  ")

      else : discard

ViewCellCombo(Ncombo.citem)
