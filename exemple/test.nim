import termkey
import termcurs
import tables
import json

var callQuery: Table[string, proc(fld : var FIELD)]

var combo  = new(GRIDSFL)
#===================================================
proc TblPays(fld : var FIELD) =
  var g_pos : int = -1
  combo  = newGRID("COMBO01",2,2,10,sepStyle)  # pagup/pagdown = 10   full = 15

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


  case fld.text
    of "FRANCE"               : g_pos = 0
    of "ISRAEL"               : g_pos = 1
    of "ALLEMAGNE"            : g_pos = 2
    of "BELGIQUE"             : g_pos = 3
    of "SUISSE"               : g_pos = 4
    of "ESPAGNE"              : g_pos = 5
    of "ITALIE"               : g_pos = 6
    of "GRECE"                : g_pos = 7
    of "HOLLANDE"             : g_pos = 8
    of "USA"                  : g_pos = 9
    of "CANADA"               : g_pos = 10
    of "CHINE"                : g_pos = 11
    of "CORE-SUD"             : g_pos = 12
    of "JAPON"                : g_pos = 13
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

type
  FIELD_FORM01 {.pure.}= enum
    Vtextfree,
    Valpha,
    Vprotect,
    ValphaUper,
    Valphanum,
    ValphNumUp,
    VtextFull,
    Vdigit,
    VdigitSign,
    Vdecimal,
    VdecmlSign,
    VdateIso,
    VdateFr,
    VdateUs,
    Vtelphone,
    Vmail,
    Vyesno,
    Vswitch,
    Vproc
const P1: array[FIELD_FORM01, int] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18]

# Panel TEST

var FORM01= new(PANEL)

# description
proc dscFORM01() =
  FORM01 = newPanel("FORM01",1,1,42,132,
  @[defButton(TKey.F3,"Exit"), defButton(TKey.F9,"Add",true), defButton(TKey.F10,"Update"),
  defButton(TKey.F12,"F12")],line1,"FORM-01")

  setText(FORM01.button[3],"Abord")

  # LABEL  -> FORM01

  FORM01.label.add(defTitle("T02002", 2,  2, "CONTACT"))
  FORM01.label.add(deflabel("L04002", 4,  2, "Text_Free........:"))
  FORM01.label.add(deflabel("L06002", 6,  2, "Alpha............:"))
  FORM01.label.add(deflabel("L08002", 8,  2, "Alpha_Upper......:"))
  FORM01.label.add(deflabel("L10002", 10, 2, "Alpha_Numéric....:"))
  FORM01.label.add(deflabel("L12002", 12, 2, "Alpha_Num.Upper..:"))
  FORM01.label.add(deflabel("L14002", 14, 2, "Text_Full........:"))
  FORM01.label.add(deflabel("L16002", 16, 2, "Digit............:"))
  FORM01.label.add(deflabel("L18002", 18, 2, "Digit_Signed.....:"))
  FORM01.label.add(deflabel("L20002", 20, 2, "Décimal..........:"))
  FORM01.label.add(deflabel("L22002", 22, 2, "Décimal_Signed...:"))
  FORM01.label.add(deflabel("L24002", 24, 2, "Date_Iso.........:"))
  FORM01.label.add(deflabel("L26002", 26, 2, "Date_Fr..........:"))
  FORM01.label.add(deflabel("L28002", 28, 2, "Date_Us..........:"))
  FORM01.label.add(deflabel("L30002", 30, 2, "Téléphone........:"))
  FORM01.label.add(deflabel("L32002", 32, 2, "Mail_Iso.........:"))
  FORM01.label.add(deflabel("L34002", 34, 2, "Yes_No...........:"))
  FORM01.label.add(deflabel("L36002", 36, 2, "Switch...........:"))
  FORM01.label.add(deflabel("L38002", 38, 2, "Proc.............:"))

  # FIELD -> FORM01

  FORM01.field.add(defString("Vtextfree", 4, 21, TEXT_FREE,10,"", EMPTY, "",
          ""))
  setRegex(FORM01,P1[Vtextfree],"^[A-Z]{1,$1}$")
  setEmpty(FORM01,P1[Vtextfree],false)
  setErrmsg(FORM01,P1[Vtextfree],"Invalide Field requis")
  setHelp(FORM01,P1[Vtextfree],"Upercase A-Z")

  FORM01.field.add(defString("Valpha", 6, 21, ALPHA,30,"", FILL, "Requis",
          "Zone Alpha"))
  FORM01.field.add(defString("Vprotect", 6, 54, ALPHA,30,"", EMPTY, "",
          ""))
  setProtect(FORM01.field[P1[Vprotect]],true)
  FORM01.field.add(defString("ValphaUper", 8, 21, ALPHA_UPPER,20,"", EMPTY, "",
          ""))
  FORM01.field.add(defString("Valphanum", 10, 21, ALPHA_NUMERIC,20,"", EMPTY, "",
          ""))
  FORM01.field.add(defString("ValphNumUp", 12, 21, ALPHA_NUMERIC_UPPER,20,"", EMPTY, "",
          ""))
  FORM01.field.add(defString("VtextFull", 14, 21, TEXT_FULL,30,"cqdf", FILL, "Requis",
          "Zone Libre"))
  FORM01.field.add(defNumeric("Vdigit", 16, 21, DIGIT,10,0,"", FILL, "Requis digit(10) ", "Zone digit 0..3"))
  setRegex(FORM01,P1[Vdigit],"^[0-3]{1,$1}$")

  FORM01.field.add(defNumeric("VdigitSign", 18, 21, DIGIT_SIGNED,10,0,"", EMPTY, "", ""))
  FORM01.field.add(defNumeric("Vdecimal", 20, 21, DECIMAL,10,2,"12345.67", FILL, "Requis decimal(10,2)", "Zone Décimal"))
  setEdtCar(FORM01.field[P1[Vdecimal]], "€")
  FORM01.field.add(defNumeric("VdecmlSign", 22, 21, DECIMAL_SIGNED,10,2,"", EMPTY, "", ""))
  FORM01.field.add(defDate("VdateIso", 24, 21, DATE_ISO,"", EMPTY, "", ""))
  FORM01.field.add(defDate("VdateFr", 26, 21, DATE_FR,"12/10/1951", EMPTY, "", ""))
  FORM01.field.add(defDate("VdateUs", 28, 21, DATE_US,"", EMPTY, "", ""))
  FORM01.field.add(defTelephone("Vtelphone", 30, 21, TELEPHONE,15,"", EMPTY, "format (033)1234567890", ""))
  FORM01.field.add(defMail("Vmail", 32, 21, MAIL_ISO,100,"", EMPTY, "", ""))
  FORM01.field.add(defString("Vyesno", 34, 21, YES_NO,1,"Y", EMPTY, "",
          ""))
  FORM01.field.add(defSwitch("Vswitch", 36, 21, SWITCH, false, EMPTY, "", ""))
  FORM01.field.add(defString("Vproc", 38, 21, FPROC,15,"CHINE", EMPTY, "",
          "Name query table Pays"))
  setProcess(FORM01.field[P1[Vproc]],"TblPays")





  var btn : BUTTON
  var jsonPanel = %* {"titleTerm": "DESIGNER" ,"fileTerm": "prettyFile.dspf","panel": [] }

  var jP = 0

  # Json Panel / Button
  add(jsonPanel["panel"], %* {"name": getPnlName(FORM01), "posx": 1, "posy": 1,
          "height": 42, "width": 132, "cadre": line1,
          "title": getPnlTitle(FORM01),
          "button" :[], "label":[], "field":[]})
  for i in 0..len(FORM01.button) - 1 :
    btn = FORM01.button[i]
    add(jsonPanel["panel"][jP]["button"] , %* {"Tkey": $btn.getName(),"txtKey": btn.getText(), "ctrl": btn.getCtrl(), "actif": btn.isActif})
  #--------------------
  # Json label
  for n in 0..len(FORM01.label) - 1:
    if isTitle(FORM01, n) :
      add(jsonPanel["panel"][jP]["label"] , %* {"defLabel":"Title", "name" : getNameL(FORM01,n),
        "posx": getPosxL(FORM01,n), "posy": getPosyL(FORM01,n), "text": getTextL(FORM01,n) })
    else :
      add(jsonPanel["panel"][jP]["label"] , %* {"defLabel":"label", "name" : getNameL(FORM01,n),
        "posx": getPosxL(FORM01,n), "posy": getPosyL(FORM01,n), "text": getTextL(FORM01,n) })
  #--------------------
  for n in 0..len(FORM01.field) - 1:
    case getRefType(FORM01,n)
    of ALPHA, ALPHA_UPPER,ALPHA_NUMERIC,ALPHA_NUMERIC_UPPER, TEXT_FREE, TEXT_FULL, PASSWORD, YES_NO, FPROC, FCALL:
      # Json field
      add(jsonPanel["panel"][jP]["field"] , %* {"defFld":"defString", "name" : getName(FORM01,n),
            "posx": getPosx(FORM01,n), "posy": getPosy(FORM01,n),
            "reftype": $getRefType(FORM01,n), "width": getWidth(FORM01,n), "empty": getEmpty(FORM01,n),
            "errmsg": getErrmsg(FORM01,n), "help": getHelp(FORM01,n),
            "text":getText(FORM01,n),
            "EdtCar": getEdtcar(FORM01,n), "Protect" : isProtect(FORM01.field[n]), "Process" : getProcess(FORM01,n) })
      #--------------------
    of DIGIT , DIGIT_SIGNED , DECIMAL, DECIMAL_SIGNED  :
      # Json field numeric
      add(jsonPanel["panel"][jP]["field"] , %* {"defFld":"defNumeric", "name" : getName(FORM01,n),
            "posx": getPosx(FORM01,n), "posy": getPosy(FORM01,n),
            "reftype": $getRefType(FORM01,n), "width": getWidth(FORM01,n), "scal": getScal(FORM01,n),
            "empty": getEmpty(FORM01,n),
            "errmsg": getErrmsg(FORM01,n), "help": getHelp(FORM01,n),
            "text":getText(FORM01,n),
            "EdtCar": getEdtcar(FORM01,n), "Protect" : isProtect(FORM01.field[n]), "Process" : getProcess(FORM01,n)})
      #--------------------
    of TELEPHONE:
      # Json telephone
      add(jsonPanel["panel"][jP]["field"] , %* {"defFld":"defTelephone", "name" : getName(FORM01,n),
            "posx": getPosx(FORM01,n), "posy": getPosy(FORM01,n),
            "reftype": $getRefType(FORM01,n), "width": getWidth(FORM01,n), "empty": getEmpty(FORM01,n),
            "errmsg": getErrmsg(FORM01,n), "help": getHelp(FORM01,n),
            "text":getText(FORM01,n),
            "EdtCar": getEdtcar(FORM01,n), "Protect" : isProtect(FORM01.field[n]), "Process" : ""})
    of DATE_ISO, DATE_FR, DATE_US:
      # Json date
      add(jsonPanel["panel"][jP]["field"] , %* {"defFld":"defDate", "name" : getName(FORM01,n),
            "posx": getPosx(FORM01,n), "posy": getPosy(FORM01,n),
            "reftype": $getRefType(FORM01,n), "empty": getEmpty(FORM01,n),
            "errmsg": getErrmsg(FORM01,n), "help": getHelp(FORM01,n),
            "text":getText(FORM01,n),
            "EdtCar": "", "Protect" : isProtect(FORM01.field[n]), "Process" : ""})
      #--------------------
    of MAIL_ISO:
      # Json mail
      add(jsonPanel["panel"][jP]["field"] , %* {"defFld":"defMail", "name" : getName(FORM01,n),
            "posx": getPosx(FORM01,n), "posy": getPosy(FORM01,n),
            "reftype": $getRefType(FORM01,n), "width": getWidth(FORM01,n), "empty": getEmpty(FORM01,n),
            "errmsg": getErrmsg(FORM01,n), "help": getHelp(FORM01,n),
            "text":getText(FORM01,n),
            "EdtCar": "", "Protect" : isProtect(FORM01.field[n]), "Process" : ""})
      #-------------------
    of SWITCH :
      # Json switch
      add(jsonPanel["panel"][jP]["field"] , %* {"defFld":"defSwitch", "name" : getName(FORM01,n),
            "posx": getPosx(FORM01,n), "posy": getPosy(FORM01,n),
            "reftype": $getRefType(FORM01,n), "switch": false, "empty": getEmpty(FORM01,n),
            "errmsg": getErrmsg(FORM01,n), "help": getHelp(FORM01,n),
            "text":"",
            "EdtCar": "", "Protect" : isProtect(FORM01.field[n]), "Process" : ""})
      #-------------------
  let F001 = open("./dspf/prettyFile.dspf", fmWrite)
  F001.write(pretty(jsonPanel))
  F001.close()


offCursor()
initTerm()

dscFORM01()
printPanel(FORM01)
displayPanel(FORM01)








while true:
 let  key = ioPanel(FORM01)

 case key

  of TKey.PROC:
    if isProcess(FORM01,Index(FORM01)) :
      callQuery[getProcess(FORM01,Index(FORM01))] (FORM01.field[Index(FORM01)])
      setTerminal()
      printPanel(FORM01)
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
