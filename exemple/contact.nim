import termkey
import termcurs

type
  FIELD_Win01 {.pure.}= enum
    Fnom,
    Fprenom,
    Fprix
const F1: array[FIELD_Win01, int] = [0,1,2]

# Panel PANEL

var Win01= new(PANEL)

# description
proc dscWin01() = 
  Win01 = newPanel("Win01",1,1,30,100,@[defButton(TKey.F3,"F3"),defButton(TKey.F12,"F12")],line1)

  # LABEL  -> Win01

  Win01.label.add(defTitle("T02002", 2, 2, "TITRE"))
  Win01.label.add(defLabel("L04002", 4, 2, "Nom.....:"))
  Win01.label.add(defLabel("L06002", 6, 2, "Prénom..:"))
  Win01.label.add(defLabel("L08002", 8, 2, "Prix....:"))

  # FIELD -> Win01

  Win01.field.add(defString("Fnom", 4, 11, ALPHA_UPPER,30,"", EMPTY, "", ""))
  Win01.field.add(defString("Fprenom", 6, 11, TEXT_FREE,30,"", EMPTY, "", ""))
  Win01.field.add(defNumeric("Fprix", 8, 11, DECIMAL_SIGNED,5,2,"", FILL, "Obligatoire", "Prix des Livres"))
  setEdtCar(Win01.field[F1[Fprix]], "€")


dscWin01()
initTerm(30,100)
titleTerm("CONTACT")
printPanel(Win01)
displayPanel(Win01)

while true:
 let  key = ioPanel(Win01)
 case key
  of TKey.F3: break
    #....#
  of TKey.F12:
    clearText(Win01)
  else : discard


closeTerm()
