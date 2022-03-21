import json

import termkey
import termcurs
import tables
#import strformat
#import unicode
#import std/[re]

proc beug(nline : int ; text :string ) =
  gotoXY(40, 1); echo "ligne>", nline, " :" , text ; let lcurs = getFunc()

var callQuery: Table[string, proc(fld : var FIELD)]

var combo  = new(GRIDSFL)
#===================================================
proc TblPays(fld : var FIELD) =
  var g_pos : int = -1
  combo  = newGRID("COMBO01",2,100,20,sepStyle)

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
proc toButton(Textkey: string ; text:string; actif = true): BUTTON =
  var bt:BUTTON
  case Textkey:
    of "F1"  : bt.key = TKey.F1
    of "F2"  : bt.key = TKey.F2
    of "F3"  : bt.key = TKey.F3
    of "F4"  : bt.key = TKey.F4
    of "F5"  : bt.key = TKey.F5
    of "F6"  : bt.key = TKey.F6
    of "F7"  : bt.key = TKey.F7
    of "F8"  : bt.key = TKey.F8
    of "F9"  : bt.key = TKey.F9
    of "F10"  : bt.key = TKey.F10
    of "F11"  : bt.key = TKey.F11
    of "F12"  : bt.key = TKey.F12
    of "F13"  : bt.key = TKey.F13
    of "F14"  : bt.key = TKey.F14
    of "F15"  : bt.key = TKey.F15
    of "F16"  : bt.key = TKey.F16
    of "F17"  : bt.key = TKey.F17
    of "F18"  : bt.key = TKey.F18
    of "F19"  : bt.key = TKey.F19
    of "F20"  : bt.key = TKey.F20
    of "F21"  : bt.key = TKey.F21
    of "F22"  : bt.key = TKey.F22
    of "F23"  : bt.key = TKey.F23
    of "F24"  : bt.key = TKey.F24
    else : discard
  bt.text = text
  bt.actif = actif
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




var jsonPanel = %* {
  "titleTerm": "DESIGNER",
  "panel": [
    {
      "name": "TEST",
      "posx": 1,
      "posy": 1,
      "height": 42,
      "width": 132,
      "cadre": "line1",
      "title": "TEST-Panel",
      "button": [
        {
          "Tkey": "F3",
          "txtKey": "Exit",
          "actif": true
        },
        {
          "Tkey": "F9",
          "txtKey": "Add",
          "actif": true
        },
        {
          "Tkey": "F10",
          "txtKey": "Update",
          "actif": true
        },
        {
          "Tkey": "F12",
          "txtKey": "Return",
          "actif": true
        }
      ],
      "label": [
        {
          "defLabel": "Title",
          "name": "T02002",
          "posx": 2,
          "posy": 2,
          "text": "CONTACT"
        },
        {
          "defLabel": "label",
          "name": "L05002",
          "posx": 5,
          "posy": 2,
          "text": "String.....:"
        },
        {
          "defLabel": "label",
          "name": "L07002",
          "posx": 7,
          "posy": 2,
          "text": "Mail.......:"
        },
        {
          "defLabel": "label",
          "name": "L09002",
          "posx": 9,
          "posy": 2,
          "text": "Switch.....:"
        },
        {
          "defLabel": "label",
          "name": "L11002",
          "posx": 11,
          "posy": 2,
          "text": "Date.......:"
        },
        {
          "defLabel": "label",
          "name": "L13002",
          "posx": 13,
          "posy": 2,
          "text": "Numérique..:"
        },
        {
          "defLabel": "label",
          "name": "L15002",
          "posx": 15,
          "posy": 2,
          "text": "Téléphone..:"
        },
        {
          "defLabel": "label",
          "name": "L17002",
          "posx": 17,
          "posy": 2,
          "text": "Fonc-proc..:"
        }
      ],
      "field": [
        {
          "defFld": "defString",
          "name": "vString",
          "posx": 5,
          "posy": 14,
          "reftype": "ALPHA_UPPER",
          "width": 30,
          "empty": false,
          "errmsg": "Invalide",
          "help": "Le Nom est obligatoire",
          "text": "",
          "EdtCar": "",
          "Protect": false,
          "Process": ""
        },j
          "defFld": "defMail",
          "name": "vMail",
          "posx": 7,
          "posy": 14,
          "reftype": "MAIL_ISO",
          "width": 99,
          "empty": false,
          "text": "",
          "errmsg": "Obligatoire",
          "help": "Votre adresse mail",
          "EdtCar": "",
          "Protect": false,
          "Process": ""
        },
        {
          "defFld": "defSwitch",
          "name": "vSWITCH",
          "posx": 9,
          "posy": 14,
          "reftype": "SWITCH",
          "switch": false,
          "empty": true,
          "errmsg": "",j
        },
        {
          "defFld": "defDate",
          "name": "vDATE",
          "posx": 11,
          "posy": 14,
          "reftype": "DATE_FR",
          "empty": false,
          "text": "",
          "errmsg": "Obligatoire",
          "help": "Date FR ex: 1951-12-10",
          "EdtCar": "",
          "Protect": false,
          "Process": ""
        },
        {
          "defFld": "defNumeric",
          "name": "vNUMERIC",
          "posx": 13,
          "posy": 14,
          "reftype": "DECIMAL",
          "width": 15,
          "scal": 2,
          "empty": false,
          "text": "",
          "errmsg": "Obligatoire",
          "help": "Decimal ex: 500.25",
          "EdtCar": "",
          "Protect": false,
          "Process": ""
        },
        {
          "defFld": "defTelephone",
          "name": "vTELEPHONE",
          "posx": 15,
          "posy": 14,
          "reftype": "TELEPHONE",
          "width": 12,
          "empty": true,
          "text": "",
          "errmsg": "",
          "help": "Format (033)123456789",
          "EdtCar": "",
          "Protect": false,
          "Process": ""
        },
        {
          "defFld": "defFproc",
          "name": "vFPROC",
          "posx": 17,
          "posy": 14,
          "reftype": "FPROC",
          "width": 20,
          "empty": false,
          "text": "",
          "errmsg": "obligatoire",
          "help": "appel procedure ex: table pays",
          "EdtCar": "",
          "Protect": false,
          "Process": "TblPays"
        }
      ]
    }
  ]
}
echo $jsonPanel["panel"][0]["button"]

echo len(jsonPanel["panel"][0]["button"])-1
#[
var jsonPanel = %* {
  "titleTerm": "DESIGNER",
  "panel": [] }

var Tj =0 # premier panel ect...
add(jsonPanel["panel"], %* {"name": "TEST", "posx": 1, "posy": 1, "height": 42, "width": 132, "cadre": line1,
            "title": "TEST-Panel",
            "button" :[], "label":[], "field":[]})



add(jsonPanel["panel"][Tj]["button"] , %* {"Tkey": $TKey.F3,"txtKey": "Exit","actif": true})
add(jsonPanel["panel"][Tj]["button"] , %* {"Tkey": $TKey.F9,"txtKey": "Add","actif": true })
add(jsonPanel["panel"][Tj]["button"] , %* {"Tkey": $TKey.F10,"txtKey": "Update","actif": true})
add(jsonPanel["panel"][Tj]["button"] , %* {"Tkey": $TKey.F12,"txtKey": "Return","actif": true })


add(jsonPanel["panel"][Tj]["label"] , %* {"defLabel":"Title", "name" : "T02002", "posx": 2, "posy": 2, "text": "CONTACT" })
add(jsonPanel["panel"][Tj]["label"] , %* {"defLabel":"label", "name" : "L05002", "posx": 5, "posy": 2, "text": "String.....:" })
add(jsonPanel["panel"][Tj]["label"] , %* {"defLabel":"label", "name" : "L07002", "posx": 7,  "posy": 2, "text": "Mail.......:"})
add(jsonPanel["panel"][Tj]["label"] , %* {"defLabel":"label", "name" : "L09002", "posx": 9,  "posy": 2, "text": "Switch.....:"})
add(jsonPanel["panel"][Tj]["label"] , %* {"defLabel":"label", "name" : "L11002", "posx": 11, "posy": 2, "text": "Date.......:"})
add(jsonPanel["panel"][Tj]["label"] , %* {"defLabel":"label", "name" : "L13002", "posx": 13, "posy": 2, "text": "Numérique..:"})
add(jsonPanel["panel"][Tj]["label"] , %* {"defLabel":"label", "name" : "L15002", "posx": 15, "posy": 2, "text": "Téléphone..:"})
add(jsonPanel["panel"][Tj]["label"] , %* {"defLabel":"label", "name" : "L17002", "posx": 17, "posy": 2, "text": "Fonc-proc..:"})


add(jsonPanel["panel"][Tj]["field"] , %* {"defFld":"defString", "name" : "vString", "posx": 5, "posy": 14,
                "reftype": $ALPHA_UPPER, "width": 30, "empty": FILL,
                "errmsg": "Invalide", "help": "Le Nom est obligatoire",
                "text":"",
                "EdtCar": "", "Protect" : false, "Process" : ""})

add(jsonPanel["panel"][Tj]["field"] , %* {"defFld":"defMail",   "name" : "vMail", "posx": 7, "posy": 14,
                "reftype": $MAIL_ISO, "width": 99, "empty": FILL,
                "text":"",
                "errmsg": "Obligatoire", "help": "Votre adresse mail",
                "EdtCar": "", "Protect" : false, "Process" : ""})

add(jsonPanel["panel"][Tj]["field"] , %* {"defFld":"defSwitch", "name" : "vSWITCH", "posx": 9, "posy": 14,
                "reftype": $SWITCH,"switch": false, "empty": EMPTY,
                "errmsg": "", "help": "",
                "EdtCar": "", "Protect" : false, "Process" : ""})

add(jsonPanel["panel"][Tj]["field"] , %* {"defFld":"defDate", "name" : "vDATE", "posx": 11, "posy": 14,
                "reftype": $DATE_FR, "empty": FILL,
                "text":"",
                "errmsg": "Obligatoire", "help": "Date FR ex: 1951-12-10",
                "EdtCar": "", "Protect" : false, "Process" : ""})

add(jsonPanel["panel"][Tj]["field"] , %* {"defFld":"defNumeric", "name" : "vNUMERIC", "posx": 13, "posy": 14,
                "reftype": $DECIMAL, "width": 15, "scal": 2, "empty": FILL,
                "text":"",
                "errmsg": "Obligatoire", "help": "Decimal ex: 500.25",
                "EdtCar": "", "Protect" : false, "Process" : ""})

add(jsonPanel["panel"][Tj]["field"] , %* {"defFld":"defTelephone", "name" : "vTELEPHONE", "posx": 15, "posy": 14,
                "reftype": $TELEPHONE, "width": 12, "empty": EMPTY,
                "text":"",
                "errmsg": "", "help": "Format (033)123456789",
                "EdtCar": "", "Protect" : false, "Process" : ""})

add(jsonPanel["panel"][Tj]["field"] , %* {"defFld":"defFproc", "name" : "vFPROC", "posx": 17, "posy": 14,
                "reftype": $FPROC, "width": 20, "empty": FILL,
                "text":"",
                "errmsg": "obligatoire", "help": "appel procedure ex: table pays",
                "EdtCar": "", "Protect" : false, "Process" : ""})

]#


#quit()

# Panel TEST
var TEST= new(PANEL)

# description
proc dscTEST(t:int) =



  var buttonVal  = newseq[BUTTON]()
  for n in 0..len(jsonPanel["panel"][t]["button"])-1:
    var bton = toButton(jsonPanel["panel"][t]["button"][n]["Tkey"].getStr() ,
                        jsonPanel["panel"][t]["button"][n]["txtKey"].getStr() , jsonPanel["panel"][t]["button"][n]["actif"].getBool())
    buttonVal.add(@[bton])


  beug(370,"Panel")

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
    beug(384,jsonPanel["panel"][t]["label"][n]["name"].getStr())

  # FIELD -> TEST
  for n in 0..len(jsonPanel["panel"][t]["field"])-1:
    beug(388,jsonPanel["panel"][t]["field"][n]["name"].getStr())
    echo toRefType(jsonPanel["panel"][t]["field"][n]["reftype"].getStr())


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



#[
let F001 = open("prettyFile.text", fmWrite)
F001.write(pretty(jsonPanel))
F001.close()

let F002 = open("jsonPanel.text", fmWrite)
F002.write($jsonPanel)
F002.close()

#quit()


# MENU -> TEST
var MH00 = new(MENU)
if hasKey(jsonPanel["panel"][0], "field") == true:
  MH00 = newMenu("MH00", 32, 13, horizontal, @["File ", "Print ", "exit"], line1)

var MVPRINT = new(MENU)
if hasKey(jsonPanel["panel"][t], "field") == true:
  MVPRINT = newMenu("MVPRINT", 34, 19, vertical, @["Contact", "exit"], line1)
]#

offCursor()
initTerm()

dscTEST(0)
printPanel(TEST)
displayPanel(TEST)

#[
if hasKey(jsonPanel["panel"], "menu") == true:
  # ONLY -> TEST
  dspMenuItem(TEST,MH00,0)
  dspMenuItem(TEST,MVPRINT,0)
  let nTest = ioMenu(TEST,MVPRINT,0)
]#
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
