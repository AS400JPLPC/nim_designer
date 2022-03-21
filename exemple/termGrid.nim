import termkey
import termcurs
type
  LABEL_FMT1 {.pure.} = enum
    Lnom,
    Lanimal,
    Lprix,
    LGrid
  FIELD_FMT1 {.pure.}= enum
    Nom,
    Animal,
    Prix

const P_L1: array[LABEL_FMT1, int] = [0,1,2,3]

const P_F1: array[FIELD_FMT1, int] = [0,1,2]

#init panel Forms
var pnlF1  = new(PANEL)

# init grid
var g_numID : int
var key : TKey
var keyG : TKey_Grid
var grid : GRIDSFL

func setID*( line : var int ) : string =
  line += 1
  return $line

#define panel
proc defForms() =
  pnlF1 = newPanel("Forms",1,1,terminalHeight(),terminalWidth(),
  @[defButton(TKey.F3,"Exit"),defButton(TKey.F2,"Init-Grid"),defButton(TKey.F9,"Add Row"),
  defButton(TKey.F23,"Delete All"),defButton(TKey.CtrlX,"Select"),defButton(TKey.CtrlP,"Pos"),defButton(TKey.F1,"echo"),
  defButton(TKey.PageUP,""),defButton(TKey.PageDown,"")],CADRE.line0)

  pnlF1.label.add(defLabel($Nom, 2, 5,   "Nom.....:"))
  pnlF1.field.add(defString($Nom, 2, 5+(len(pnlF1.label[P_L1[Lnom]].text)), ALPHA, 20, "",FILL, "Nom Obligatoire", "Type Alpha a-Z"))

  pnlF1.label.add(defLabel($Animal, 4, 5,  "Animal..:"))
  pnlF1.field.add(defString($Animal, 4, 5+(len(pnlF1.label[P_L1[Lanimal]].text)), TEXT_FULL,30, "",FILL, "Animale Obligatoire", "Type Full Text"))

  pnlF1.label.add(defLabel($Prix, 6, 5, "Prix....:"))
  pnlF1.field.add(defNumeric($Prix, 6, 5+(len(pnlF1.label[P_L1[Lprix]].text)), DECIMAL,5,2,"",FILL, "Animale Obligatoire", "Type Decimal 00000,00"))

  pnlF1.label.add(defLabel($Lgrid, 30, 95, ""))
  printPanel(pnlF1)


proc defGrid() =
  grid = newGrid("GRID01",10,1,5)
  var g_id      = defCell("ID",3,DIGIT)
  var g_name    = defCell("Name",getNbrcar(pnlF1,$Nom),ALPHA)
  var g_animal  = defCell("Animal",getNbrcar(pnlF1,$Animal),ALPHA)
  var g_prix    = defCell("Prix",getNbrcar(pnlF1,$Prix),DECIMAL)
  setCellEditCar(g_prix,"€")
  setHeaders(grid, @[g_id, g_name, g_animal,g_prix])







proc main() =
  initTerm(30,100)

  defForms()
  defGrid()

  while true:
    # print grid positioning
    displayLabel(pnlF1,pnlF1.label[P_L1[Lgrid]])

    key = ioPanel(pnlF1)

    case key

    of TKey.F3:
      #[
        close program
        Provide for the correct closing of the database
      ]#
      closeTerm()


    #exemple init value GRID
    of TKey.F2:
      resetRows(grid)
      g_numID = - 1
      addRows(grid, @[setID(g_numID), "Adam", "Aigle","50.00"])
      addRows(grid, @[setID(g_numID), "Eve" , "Papillon","50.00"])
      addRows(grid, @[setID(g_numID), "Roger", "Singe","50.00"])
      addRows(grid, @[setID(g_numID), "Ginette" , "Chien","50.00"])
      addRows(grid, @[setID(g_numID), "Maurice", "Dauphin","50.00"])
      addRows(grid, @[setID(g_numID), "Elisabhet" , "Oiseaux","50.00"])
      addRows(grid, @[setID(g_numID), "Eric", "Poisson","50.00"])
      addRows(grid, @[setID(g_numID), "Daniel" ,"Insect","50.00"])
      addRows(grid, @[setID(g_numID), "Mendi", "Chien","50.00"])
      addRows(grid, @[setID(g_numID), "Simon" ,"Scorpion","50.00"])
      addRows(grid, @[setID(g_numID), "JPL" ,"Chat","50.00"])
      printGridHeader(grid)
      printGridRows(grid)
      pnlF1.label[P_L1[Lgrid]].text = "Home  "

    # exemple add row from FORMS
    of TKey.F9:
      addRows(grid,@[setID(g_numID), pnlF1.getText($Nom), pnlF1.getText($Animal),pnlF1.getText($Prix)])
      # position last page
      setLastPage(grid)
      # clear and display border and label
      printGridHeader(grid)
      # print rows first page
      printGridRows(grid)
      pnlF1.label[P_L1[Lgrid]].text = "End   "

    # exemple erase rows to GRID
    of TKey.F23:
      if countRows(grid) > 0 :
        # clear full rows
        resetRows(grid)
        # clear and display border and label
        printGridHeader(grid)
        # inti compeur ID
        g_numID = - 1


    # exemple pagination anf display first page ...
    of TKey.PageUp :
      if countRows(grid) > 0 :
        keyG = pageUpGrid(grid)
        if keyG == TKey_Grid.PGup:
          pnlF1.label[P_L1[Lgrid]].text = "Prior "
        else:
          pnlF1.label[P_L1[Lgrid]].text = "Home  "

    of TKey.PageDown :
      if countRows(grid) > 0 :
        keyG = pageDownGrid(grid)
        if keyG == TKey_Grid.PGdown:
          pnlF1.label[P_L1[Lgrid]].text = "Next  "
        else:
          pnlF1.label[P_L1[Lgrid]].text = "End   "


    # exemple select row form GRID to FORMS
    of TKey.Ctrlx :
      if countRows(grid) > 0 :
        pnlF1.label[P_L1[Lgrid]].text ="select"
        displayLabel(pnlF1,pnlF1.label[P_L1[Lgrid]])
        let (keys, val) = ioGrid(grid)
        #gotoXY(40,1) ; echo "99", keys, " val :", $val ; let n99 = getFunc();
        #gotoXy(40,1) ; echo "                                                                                                 "
        if keys == TKey.Enter :
          pnlF1.field[P_F1[Nom]].text = val[1]
          pnlF1.field[P_F1[Animal]].text = val[2]
          pnlF1.field[P_F1[Prix]].text = val[3]
          displayField(pnlF1, pnlF1.field[P_F1[Nom]])
          displayField(pnlF1, pnlF1.field[P_F1[Animal]])
          displayField(pnlF1, pnlF1.field[P_F1[Prix]])
          pnlF1.label[P_L1[Lgrid]].text = "select"
        elif keys == TKey.Escape:
          printGridRows(grid)
          pnlF1.label[P_L1[Lgrid]].text = "      "


    # exemple position and select row form GRID to FORMS
    of TKey.CtrlP :
      if countRows(grid) > 0 :
        # change value label
        pnlF1.label[P_L1[Lgrid]].text = "Pos   "
        displayLabel(pnlF1,pnlF1.label[P_L1[Lgrid]])

        # work grid
        let (keys, val) = ioGrid(grid,getIndexG(grid,getText(pnlF1,$Nom), 1 ))

        if keys == TKey.Enter :
          pnlF1.field[P_F1[Nom]].text = val[1]
          pnlF1.field[P_F1[Animal]].text = val[2]
          pnlF1.field[P_F1[Prix]].text = val[3]
          displayField(pnlF1, pnlF1.field[P_F1[Nom]])
          displayField(pnlF1, pnlF1.field[P_F1[Animal]])
          displayField(pnlF1, pnlF1.field[P_F1[Prix]])
          pnlF1.label[P_L1[Lgrid]].text = "select"
        elif keys == TKey.Escape:
          printGridRows(grid)
          pnlF1.label[P_L1[Lgrid]].text = "      "

    # exemple retrived Headers form GRID
    of Tkey.F1 :
      gotoXY(20,1);      echo "getHeadersName >", getHeadersName(grid,1) ,"<"
      gotoXY(21,1);      echo "getHeadersPosy >", getHeadersPosy(grid,1) ,"<"
      gotoXY(22,1);      echo "getHeadersType >", getHeadersType(grid,1) ,"<"
      gotoXY(23,1);      echo "getHeadersCar >", getHeadersCar(grid,1) ,"<"

      gotoXY(25,1);      echo "getHeadersName >", getHeadersName(grid,3) ,"<"
      gotoXY(26,1);      echo "getHeadersPosy >", getHeadersPosy(grid,3) ,"<"
      gotoXY(27,1);      echo "getHeadersType >", getHeadersType(grid,3) ,"<"
      gotoXY(28,1);      echo "getHeadersCar >", getHeadersCar(grid,3) ,"<"
    else : discard

main()