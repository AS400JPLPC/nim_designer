import json

import termkey
import termcurs
import tables


#proc beug(nline : int ; text :string ) =
  #gotoXY(40, 1); echo "ligne>", nline, " :" , text ; let lcurs = getFunc()

var callQuery: Table[string, proc(fld : var FIELD)]

var combo  = new(GRIDSFL)
#===================================================
proc TblPays(fld : var FIELD) =
  var g_pos : int = -1
  combo  = newGRID("COMBO01",2,30,5,sepStyle)

  var g_type  = defCell("PAYS",19,TEXT_FREE)

  setHeaders(combo, @[g_type])
  addRows(combo, @["FRANCE"])
  addRows(combo, @["ISRAEL"])
  addRows(combo, @["ALLEMAGNE"])
  addRows(combo, @["BELGIQUE"])
  addRows(combo, @["SUISSE"])
  addRows(combo, @["ESPAGNE"])
  addRows(combo, @["ITALIE"])
  addRows(combo, @["GRECE"])
  addRows(combo, @["HOLLANDE"])
  addRows(combo, @["USA"])
  addRows(combo, @["CANADA"])
  addRows(combo, @["CHINE"])
  addRows(combo, @["CORE-SUD"])
  addRows(combo, @["JAPON"])
  printGridHeader(combo)

  case fld.text
    of "FRANCE"     : g_pos = 0
    of "ISRAEL"     : g_pos = 1
    of "ALLEMAGNE"  : g_pos = 2
    of "BELGIQUE"   : g_pos = 3
    of "SUISSE"     : g_pos = 4
    of "ESPAGNE"    : g_pos = 5
    of "ITALIE"     : g_pos = 6
    of "GRECE"      : g_pos = 7
    of "HOLLANDE"   : g_pos = 8
    of "USA"        : g_pos = 9
    of "CANADA"     : g_pos = 10
    of "CHINE"      : g_pos = 11
    of "CORE-SUD"   : g_pos = 12
    of "JAPON"      : g_pos = 13

    else : discard

  while true :
    let (keys, val) = ioGrid(combo,g_pos)

    case keys
      of TKey.Enter :
        fld.text  = $val[0]
        break
      else: discard

callQuery["TblPays"] = TblPays


#===================================================











## return BUTTON
proc toButton(Textkey: string ; text:string; ctrl:bool; actif: bool): BUTTON =
  var bt:BUTTON
  case Textkey:
    of "F1"  : bt = defButton(TKey.F1,text,ctrl,actif)
    of "F2"  : bt = defButton(TKey.F2,text,ctrl,actif)
    of "F3"  : bt = defButton(TKey.F3,text,ctrl,actif)
    of "F4"  : bt = defButton(TKey.F4,text,ctrl,actif)
    of "F5"  : bt = defButton(TKey.F5,text,ctrl,actif)
    of "F6"  : bt = defButton(TKey.F6,text,ctrl,actif)
    of "F7"  : bt = defButton(TKey.F7,text,ctrl,actif)
    of "F8"  : bt = defButton(TKey.F8,text,ctrl,actif)
    of "F9"  : bt = defButton(TKey.F9,text,ctrl,actif)
    of "F10"  : bt = defButton(TKey.F10,text,ctrl,actif)
    of "F11"  : bt = defButton(TKey.F11,text,ctrl,actif)
    of "F12"  : bt = defButton(TKey.F12,text,ctrl,actif)
    of "F13"  : bt = defButton(TKey.F13,text,ctrl,actif)
    of "F14"  : bt = defButton(TKey.F14,text,ctrl,actif)
    of "F15"  : bt = defButton(TKey.F15,text,ctrl,actif)
    of "F16"  : bt = defButton(TKey.F16,text,ctrl,actif)
    of "F17"  : bt = defButton(TKey.F17,text,ctrl,actif)
    of "F18"  : bt = defButton(TKey.F18,text,ctrl,actif)
    of "F19"  : bt = defButton(TKey.F19,text,ctrl,actif)
    of "F20"  : bt = defButton(TKey.F20,text,ctrl,actif)
    of "F21"  : bt = defButton(TKey.F21,text,ctrl,actif)
    of "F22"  : bt = defButton(TKey.F22,text,ctrl,actif)
    of "F23"  : bt = defButton(TKey.F23,text,ctrl,actif)
    of "F24"  : bt = defButton(TKey.F24,text,ctrl,actif)
    else : discard

  return bt


## return cadre
proc toCadre(Textcadre: string ;):CADRE =
    case Textcadre:
      of "line1"  : result = line1
      of "line2"  : result = line2
      else : result = line0

## return ref_type
proc toRefType(TextType: string ;):REFTYP =
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


var jsonPanel= parseFile ("./dspf/prettyFile.dspf" )

#echo $jsonPanel["panel"][0]["button"]

#echo len(jsonPanel["panel"][0]["button"])-1

#var fileTerm : string  = jsonPanel["fileTerm"].getStr()

#echo fileTerm
#quit()

# Panel TEST
var TEST= new(PANEL)

# description
proc dscTEST(t:int) =



  var buttonVal  = newseq[BUTTON]()
  for n in 0..len(jsonPanel["panel"][t]["button"])-1:
    var bton = toButton(jsonPanel["panel"][t]["button"][n]["Tkey"].getStr() ,
                            jsonPanel["panel"][t]["button"][n]["txtKey"].getStr() ,
                            jsonPanel["panel"][t]["button"][n]["ctrl"].getBool() ,
                            jsonPanel["panel"][t]["button"][n]["actif"].getBool())
    buttonVal.add(@[bton])


  #beug(370,"Panel")

  TEST = newPanel( jsonPanel["panel"][t]["name"].getStr(),
                  jsonPanel["panel"][t]["posx"].getInt(),
                  jsonPanel["panel"][t]["posy"].getInt(),
                  jsonPanel["panel"][t]["height"].getInt(),
                  jsonPanel["panel"][t]["width"].getInt(),
                  @buttonVal,toCadre(jsonPanel["panel"][t]["cadre"].getStr()),jsonPanel["panel"][t]["title"].getStr())




# LABEL  -> TEST
  for n in 0..len(jsonPanel["panel"][t]["label"])-1:
    if jsonPanel["panel"][t]["label"][n]["defLabel"].getStr() == "Title" :
      TEST.label.add(defTitle(jsonPanel["panel"][t]["label"][n]["name"].getStr() ,
                      jsonPanel["panel"][t]["label"][n]["posx"].getInt() ,
                      jsonPanel["panel"][t]["label"][n]["posy"].getInt() ,
                      jsonPanel["panel"][t]["label"][n]["text"].getStr()))
    else :
      TEST.label.add(defLabel(jsonPanel["panel"][t]["label"][n]["name"].getStr() ,
                      jsonPanel["panel"][t]["label"][n]["posx"].getInt() ,
                      jsonPanel["panel"][t]["label"][n]["posy"].getInt() ,
                      jsonPanel["panel"][t]["label"][n]["text"].getStr()))
    #beug(384,jsonPanel["panel"][t]["label"][n]["name"].getStr())

  # FIELD -> TEST
  for n in 0..len(jsonPanel["panel"][t]["field"])-1:
    #beug(388,jsonPanel["panel"][t]["field"][n]["name"].getStr())
    #echo toRefType(jsonPanel["panel"][t]["field"][n]["reftype"].getStr())


    case jsonPanel["panel"][t]["field"][n]["defFld"].getStr() :

      of "defString" :
            TEST.field.add(defString(jsonPanel["panel"][t]["field"][n]["name"].getStr() ,
                      jsonPanel["panel"][t]["field"][n]["posx"].getInt() ,
                      jsonPanel["panel"][t]["field"][n]["posy"].getInt() ,
                      toRefType(jsonPanel["panel"][t]["field"][n]["reftype"].getStr()),
                      jsonPanel["panel"][t]["field"][n]["width"].getInt() ,
                      jsonPanel["panel"][t]["field"][n]["text"].getStr() ,
                      jsonPanel["panel"][t]["field"][n]["empty"].getBool(),
                      jsonPanel["panel"][t]["field"][n]["errmsg"].getStr() ,
                      jsonPanel["panel"][t]["field"][n]["help"].getStr()
                      ))

      of "defMail" :
            TEST.field.add(defMail(jsonPanel["panel"][t]["field"][n]["name"].getStr() ,
                      jsonPanel["panel"][t]["field"][n]["posx"].getInt() ,
                      jsonPanel["panel"][t]["field"][n]["posy"].getInt() ,
                      toRefType(jsonPanel["panel"][t]["field"][n]["reftype"].getStr()),
                      jsonPanel["panel"][t]["field"][n]["width"].getInt() ,
                      jsonPanel["panel"][t]["field"][n]["text"].getStr() ,
                      jsonPanel["panel"][t]["field"][n]["empty"].getBool(),
                      jsonPanel["panel"][t]["field"][n]["errmsg"].getStr(),
                      jsonPanel["panel"][t]["field"][n]["help"].getStr()
                      ))

      of "defSwitch" :
            TEST.field.add(defSwitch(jsonPanel["panel"][t]["field"][n]["name"].getStr() ,
                      jsonPanel["panel"][t]["field"][n]["posx"].getInt() ,
                      jsonPanel["panel"][t]["field"][n]["posy"].getInt() ,
                      toRefType(jsonPanel["panel"][t]["field"][n]["reftype"].getStr()),
                      jsonPanel["panel"][t]["field"][n]["switch"].getBool(),
                      jsonPanel["panel"][t]["field"][n]["empty"].getBool(),
                      jsonPanel["panel"][t]["field"][n]["errmsg"].getStr() ,
                      jsonPanel["panel"][t]["field"][n]["help"].getStr()
                      ))

      of "defDate" :
            TEST.field.add(defDate(jsonPanel["panel"][t]["field"][n]["name"].getStr() ,
                      jsonPanel["panel"][t]["field"][n]["posx"].getInt() ,
                      jsonPanel["panel"][t]["field"][n]["posy"].getInt() ,
                      toRefType(jsonPanel["panel"][t]["field"][n]["reftype"].getStr()),
                      jsonPanel["panel"][t]["field"][n]["text"].getStr() ,
                      jsonPanel["panel"][t]["field"][n]["empty"].getBool(),
                      jsonPanel["panel"][t]["field"][n]["errmsg"].getStr() ,
                      jsonPanel["panel"][t]["field"][n]["help"].getStr()
                      ))

      of "defNumeric" :
            TEST.field.add(defNumeric(jsonPanel["panel"][t]["field"][n]["name"].getStr() ,
                      jsonPanel["panel"][t]["field"][n]["posx"].getInt() ,
                      jsonPanel["panel"][t]["field"][n]["posy"].getInt() ,
                      toRefType(jsonPanel["panel"][t]["field"][n]["reftype"].getStr()),
                      jsonPanel["panel"][t]["field"][n]["width"].getInt() ,
                      jsonPanel["panel"][t]["field"][n]["scal"].getInt() ,
                      jsonPanel["panel"][t]["field"][n]["text"].getStr() ,
                      jsonPanel["panel"][t]["field"][n]["empty"].getBool(),
                      jsonPanel["panel"][t]["field"][n]["errmsg"].getStr() ,
                      jsonPanel["panel"][t]["field"][n]["help"].getStr()
                      ))

      of "defTelephone" :
            TEST.field.add(defTelephone(jsonPanel["panel"][t]["field"][n]["name"].getStr() ,
                      jsonPanel["panel"][t]["field"][n]["posx"].getInt() ,
                      jsonPanel["panel"][t]["field"][n]["posy"].getInt() ,
                      toRefType(jsonPanel["panel"][t]["field"][n]["reftype"].getStr()),
                      jsonPanel["panel"][t]["field"][n]["width"].getInt() ,
                      jsonPanel["panel"][t]["field"][n]["text"].getStr() ,
                      jsonPanel["panel"][t]["field"][n]["empty"].getBool(),
                      jsonPanel["panel"][t]["field"][n]["errmsg"].getStr() ,
                      jsonPanel["panel"][t]["field"][n]["help"].getStr()
                      ))

      of "defFproc" :
            TEST.field.add(defString(jsonPanel["panel"][t]["field"][n]["name"].getStr() ,
                      jsonPanel["panel"][t]["field"][n]["posx"].getInt() ,
                      jsonPanel["panel"][t]["field"][n]["posy"].getInt() ,
                      toRefType(jsonPanel["panel"][t]["field"][n]["reftype"].getStr() ),
                      jsonPanel["panel"][t]["field"][n]["width"].getInt() ,
                      jsonPanel["panel"][t]["field"][n]["text"].getStr() ,
                      jsonPanel["panel"][t]["field"][n]["empty"].getBool(),
                      jsonPanel["panel"][t]["field"][n]["errmsg"].getStr() ,
                      jsonPanel["panel"][t]["field"][n]["help"].getStr()
                      ))

      else : discard

    if jsonPanel["panel"][t]["field"][n]["EdtCar"].getStr() != "" :
      setEdtCar(TEST.field[getIndex(TEST,jsonPanel["panel"][t]["field"][n]["name"].getStr())],
                jsonPanel["panel"][t]["field"][n]["EdtCar"].getStr())

    if jsonPanel["panel"][t]["field"][n]["Protect"].getbool() == true :
      setProtect(TEST.field[getIndex(TEST,jsonPanel["panel"][t]["field"][n]["name"].getStr())],true)

    if jsonPanel["panel"][t]["field"][n]["Process"].getStr() != "" :
      setProcess(TEST.field[getIndex(TEST,jsonPanel["panel"][t]["field"][n]["name"].getStr())],
      jsonPanel["panel"][t]["field"][n]["Process"].getStr() )




# exemple out Json
let F002 = open("jsonPanel.dspf", fmWrite)
F002.write($jsonPanel)
F002.close()

#quit()



offCursor()
initTerm()

dscTEST(0)
printPanel(TEST)
displayPanel(TEST)

while true:
 let  key = ioPanel(TEST)

 case key
  of TKey.PROC:
    if isProcess(TEST,Index(TEST)) :
      callQuery[getProcess(TEST,Index(TEST))] (TEST.field[Index(TEST)])
      setTerminal()
      printPanel(TEST)

  of TKey.F3:
    #....#
    break
  of TKey.F9:
    #....#
    break
  of TKey.F11:
    #....#
    break
  of TKey.F12:
    #....#
    break
  else : discard




closeTerm()
