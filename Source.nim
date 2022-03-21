import termkey
import termcurs
import tables


var callQuery: Table[string, proc(fld : var FIELD)]


type
  FIELD_Fcli00a {.pure.}= enum
    cliNom,
    decimal,
    tproc
const P1: array[FIELD_Fcli00a, int] = [0,1,2]

# Panel Fcli00a

var Fcli00a= new(PANEL)

# description
proc dscFcli00a() = 
  Fcli00a = newPanel("Fcli00a",1,1,32,132,@[defButton(TKey.F3,"F3",false,true), defButton(TKey.F9,"F9",true,true), defButton(TKey.F10,"F10",true,true)],line1,"Fiche Client")

  # LABEL  -> Fcli00a

  Fcli00a.label.add(defTitle("L02002", 2, 2, "Fiche Client"))
  Fcli00a.label.add(deflabel("L04002", 4, 2, "Nom.......:"))
  Fcli00a.label.add(deflabel("L06002", 6, 2, "Décimal...:"))
  Fcli00a.label.add(deflabel("L09002", 9, 2, "Proc......:"))

  # FIELD -> Fcli00a

  Fcli00a.field.add(defString("cliNom", 4, 14, ALPHA_UPPER,30,"", FILL, "Obligatoire","Nom du client"))
  Fcli00a.field.add(defNumeric("decimal", 6, 14, DECIMAL,9,2,"", EMPTY,"", ""))
  setEdtCar(Fcli00a.field[P1[decimal]], "€")
  Fcli00a.field.add(defString("tproc", 9, 14, FPROC,10,"", EMPTY, "","appel procedure"))
  setProcess(Fcli00a.field[P1[tproc]],"myproc")


#===================================================
proc myproc(fld : var FIELD) =
  var Cell_pos : int = -1
  var Xcombo  = newGRID("myproc",9,14,14,sepStyle) 
  var Cell_Pays = defCell("Pays",10,TEXT_FREE,"Cyan") 

  setHeaders(Xcombo, @[Cell_Pays])
  addRows(Xcombo, @[ "France" ])
  addRows(Xcombo, @[ "Espagne" ])
  addRows(Xcombo, @[ "Italie" ])

  printGridHeader(Xcombo)
  case fld.text
    of "France"   : Cell_pos = 0 
    of "Espagne"   : Cell_pos = 1 
    of "Italie"   : Cell_pos = 2 
    else : discard

  while true :
    let (keys, val) = ioGrid(Xcombo,Cell_pos)
    case keys
      of TKey.Enter :
        restorePanel(Fcli00a,Xcombo)
        fld.text  = $val[0]
        break
      else: discard

callQuery["myproc"] = myproc 
#===================================================




proc main() =
  initTerm(32,132)

  dscFcli00a()
  printPanel(Fcli00a)
  displayPanel(Fcli00a)

  #Exemple ------

  while true:
    let  key = ioPanel(Fcli00a)
    case key
      of TKey.PROC :  # for field Process
        if isProcess(Fcli00a,Index(Fcli00a)):
          callQuery[getProcess(Fcli00a,Index(Fcli00a))](Fcli00a.field[Index(Fcli00a)])
      of TKey.F3:
        break
      of TKey.F9:
        break
      of TKey.F10:
        break
      else : discard

  closeTerm()



main()
