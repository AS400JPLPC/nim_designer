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

## return ref_type
proc toOrientation(TextType: string ;):MNUVH =
    case TextType:
      of "vertical" :            result = vertical
      of "horizontal" :          result = horizontal
      else : result = vertical


# field for JSON .dspf  %* {"titleTerm": "","fileTerm":"","panel": [] }
var titleTerm : string
var fileTerm  : string
var jsonPanel = parseJson("{}")

# description
proc loadBASE() =
  fldP.OK = true
  var jText : string
  for t in 0..len(jsonPanel["panel"])-1:

      var buttonVal  = newseq[BUTTON]()
      for n in 0..len(jsonPanel["panel"][t]["button"])-1:
        var bton = toButton(jsonPanel["panel"][t]["button"][n]["Tkey"].getStr() ,
                            jsonPanel["panel"][t]["button"][n]["txtKey"].getStr() ,
                            jsonPanel["panel"][t]["button"][n]["ctrl"].getBool() ,
                            jsonPanel["panel"][t]["button"][n]["actif"].getBool())
        buttonVal.add(@[bton])

      base.add(newPanel( jsonPanel["panel"][t]["name"].getStr(),
                      jsonPanel["panel"][t]["posx"].getInt(),
                      jsonPanel["panel"][t]["posy"].getInt(),
                      jsonPanel["panel"][t]["height"].getInt(),
                      jsonPanel["panel"][t]["width"].getInt(),
                      @buttonVal,toCadre(jsonPanel["panel"][t]["cadre"].getStr()),jsonPanel["panel"][t]["title"].getStr()))

      var b = len(base) - 1
      # LABEL  -> base
      if len(jsonPanel["panel"][t]["label"]) > 0 :
        for n in 0..len(jsonPanel["panel"][t]["label"])-1:

          if jsonPanel["panel"][t]["label"][n]["defLabel"].getStr() == "Title" :
            base[b].label.add(defTitle(jsonPanel["panel"][t]["label"][n]["name"].getStr() ,
                            jsonPanel["panel"][t]["label"][n]["posx"].getInt() ,
                            jsonPanel["panel"][t]["label"][n]["posy"].getInt() ,
                            jsonPanel["panel"][t]["label"][n]["text"].getStr()))
          else :
            base[b].label.add(defLabel(jsonPanel["panel"][t]["label"][n]["name"].getStr() ,
                            jsonPanel["panel"][t]["label"][n]["posx"].getInt() ,
                            jsonPanel["panel"][t]["label"][n]["posy"].getInt() ,
                            jsonPanel["panel"][t]["label"][n]["text"].getStr()))



      # FIELD -> base
      if len(jsonPanel["panel"][t]["field"]) > 0 :
        for n in 0..len(jsonPanel["panel"][t]["field"])-1:

          case jsonPanel["panel"][t]["field"][n]["defFld"].getStr() :

            of "defString" :
                  base[b].field.add(defString(jsonPanel["panel"][t]["field"][n]["name"].getStr() ,
                            jsonPanel["panel"][t]["field"][n]["posx"].getInt() ,
                            jsonPanel["panel"][t]["field"][n]["posy"].getInt() ,
                            toRefType(jsonPanel["panel"][t]["field"][n]["reftype"].getStr()),
                            jsonPanel["panel"][t]["field"][n]["width"].getInt() ,
                            jsonPanel["panel"][t]["field"][n]["text"].getStr() ,
                            jsonPanel["panel"][t]["field"][n]["empty"].getBool(),
                            jsonPanel["panel"][t]["field"][n]["errmsg"].getStr() ,
                            jsonPanel["panel"][t]["field"][n]["help"].getStr(),
                            ))
                  if jsonPanel["panel"][t]["field"][n]["Protect"].getBool() == true :
                    jTEXT=""
                    case  toRefType(jsonPanel["panel"][t]["field"][n]["reftype"].getStr()):
                      of PASSWORD :
                        for n in 1..getWidth(base[b],getIndex(base[b],jsonPanel["panel"][t]["field"][n]["name"].getStr())): jTEXT = jTEXT & "*"
                      else :
                        for n in 1..getWidth(base[b],getIndex(base[b],jsonPanel["panel"][t]["field"][n]["name"].getStr())): jTEXT = jTEXT & "a"
                    setText(base[b],jsonPanel["panel"][t]["field"][n]["name"].getStr(),jTEXT)
                    setProtect(base[b].field[getIndex(base[b],jsonPanel["panel"][t]["field"][n]["name"].getStr())],true)

            of "defMail" :
                  base[b].field.add(defMail(jsonPanel["panel"][t]["field"][n]["name"].getStr() ,
                            jsonPanel["panel"][t]["field"][n]["posx"].getInt() ,
                            jsonPanel["panel"][t]["field"][n]["posy"].getInt() ,
                            toRefType(jsonPanel["panel"][t]["field"][n]["reftype"].getStr()),
                            jsonPanel["panel"][t]["field"][n]["width"].getInt() ,
                            jsonPanel["panel"][t]["field"][n]["text"].getStr() ,
                            jsonPanel["panel"][t]["field"][n]["empty"].getBool(),
                            jsonPanel["panel"][t]["field"][n]["errmsg"].getStr(),
                            jsonPanel["panel"][t]["field"][n]["help"].getStr()
                            ))
                  if jsonPanel["panel"][t]["field"][n]["Protect"].getBool() == true :
                    jTEXT=""
                    for n in 1..getNbrcar(base[b],jsonPanel["panel"][t]["field"][n]["name"].getStr()) - 5: jTEXT = jTEXT & "a"
                    jTEXT = jTEXT & "@gmail"
                    setText(base[b],jsonPanel["panel"][t]["field"][n]["name"].getStr(),jTEXT)
                    setProtect(base[b].field[getIndex(base[b],jsonPanel["panel"][t]["field"][n]["name"].getStr())],true)

            of "defSwitch" :
                  base[b].field.add(defSwitch(jsonPanel["panel"][t]["field"][n]["name"].getStr() ,
                            jsonPanel["panel"][t]["field"][n]["posx"].getInt() ,
                            jsonPanel["panel"][t]["field"][n]["posy"].getInt() ,
                            toRefType(jsonPanel["panel"][t]["field"][n]["reftype"].getStr()),
                            jsonPanel["panel"][t]["field"][n]["switch"].getBool(),
                            jsonPanel["panel"][t]["field"][n]["empty"].getBool(),
                            jsonPanel["panel"][t]["field"][n]["errmsg"].getStr() ,
                            jsonPanel["panel"][t]["field"][n]["help"].getStr()
                            ))
                  if jsonPanel["panel"][t]["field"][n]["Protect"].getBool() == true :
                    setProtect(base[b].field[getIndex(base[b],jsonPanel["panel"][t]["field"][n]["name"].getStr())],true)
            of "defDate" :
                  base[b].field.add(defDate(jsonPanel["panel"][t]["field"][n]["name"].getStr() ,
                            jsonPanel["panel"][t]["field"][n]["posx"].getInt() ,
                            jsonPanel["panel"][t]["field"][n]["posy"].getInt() ,
                            toRefType(jsonPanel["panel"][t]["field"][n]["reftype"].getStr()),
                            jsonPanel["panel"][t]["field"][n]["text"].getStr() ,
                            jsonPanel["panel"][t]["field"][n]["empty"].getBool(),
                            jsonPanel["panel"][t]["field"][n]["errmsg"].getStr() ,
                            jsonPanel["panel"][t]["field"][n]["help"].getStr()
                            ))
                  if jsonPanel["panel"][t]["field"][n]["Protect"].getBool() == true :
                    jTEXT=""
                    case  toRefType(jsonPanel["panel"][t]["field"][n]["reftype"].getStr()):
                      of DATE_ISO : setText(base[b],jsonPanel["panel"][t]["field"][n]["name"].getStr(),"2020-05-18")
                      of DATE_FR : setText(base[b],jsonPanel["panel"][t]["field"][n]["name"].getStr(),"18/05/2020")
                      of DATE_US : setText(base[b],jsonPanel["panel"][t]["field"][n]["name"].getStr(),"05/18/2020")
                      else :discard
                    setProtect(base[b].field[getIndex(base[b],jsonPanel["panel"][t]["field"][n]["name"].getStr())],true)

            of "defNumeric" :
                  base[b].field.add(defNumeric(jsonPanel["panel"][t]["field"][n]["name"].getStr() ,
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
                  if jsonPanel["panel"][t]["field"][n]["Protect"].getBool() == true :
                    jTEXT=""
                    case  toRefType(jsonPanel["panel"][t]["field"][n]["reftype"].getStr()):
                      of DIGIT :
                        for n in 1..getNbrcar(base[b],jsonPanel["panel"][t]["field"][n]["name"].getStr()):
                            jTEXT = jTEXT & $n
                      of DIGIT_SIGNED :
                        jTEXT = "+"
                        for n in 1..getWidth(base[b],getIndex(base[b],jsonPanel["panel"][t]["field"][n]["name"].getStr())):
                            jTEXT = jTEXT & $n
                      of DECIMAL :
                        for n in 1..getNbrcar(base[b],jsonPanel["panel"][t]["field"][n]["name"].getStr()):
                            jTEXT = jTEXT & $n
                        jTEXT = jTEXT & "."
                        for n in 1..getScal(base[b],getIndex(base[b],jsonPanel["panel"][t]["field"][n]["name"].getStr())):
                            jTEXT = jTEXT & $n
                      of DECIMAL_SIGNED :
                        v_TEXT = "+"
                        for n in 1..getWidth(base[b],getIndex(base[b],jsonPanel["panel"][t]["field"][n]["name"].getStr())):
                            jTEXT = jTEXT & $n
                        jTEXT = jTEXT & "."
                        for n in 1..getScal(base[b],getIndex(base[b],jsonPanel["panel"][t]["field"][n]["name"].getStr())):
                            jTEXT = jTEXT & $n
                      else : discard
                    setText(base[b],jsonPanel["panel"][t]["field"][n]["name"].getStr(),jTEXT)
                    setProtect(base[b].field[getIndex(base[b],jsonPanel["panel"][t]["field"][n]["name"].getStr())],true)
            of "defTelephone" :
                  base[b].field.add(defTelephone(jsonPanel["panel"][t]["field"][n]["name"].getStr() ,
                            jsonPanel["panel"][t]["field"][n]["posx"].getInt() ,
                            jsonPanel["panel"][t]["field"][n]["posy"].getInt() ,
                            toRefType(jsonPanel["panel"][t]["field"][n]["reftype"].getStr()),
                            jsonPanel["panel"][t]["field"][n]["width"].getInt() ,
                            jsonPanel["panel"][t]["field"][n]["text"].getStr() ,
                            jsonPanel["panel"][t]["field"][n]["empty"].getBool(),
                            jsonPanel["panel"][t]["field"][n]["errmsg"].getStr() ,
                            jsonPanel["panel"][t]["field"][n]["help"].getStr()
                            ))
                  if jsonPanel["panel"][t]["field"][n]["Protect"].getBool() == true :
                    setText(base[b],jsonPanel["panel"][t]["field"][n]["name"].getStr(),"(000)0-9aZ")
                    setProtect(base[b].field[getIndex(base[b],jsonPanel["panel"][t]["field"][n]["name"].getStr())],true)
            else : discard

          if jsonPanel["panel"][t]["field"][n]["EdtCar"].getStr() != "" :
            setEdtCar(base[b].field[getIndex(base[b],jsonPanel["panel"][t]["field"][n]["name"].getStr())],
                      jsonPanel["panel"][t]["field"][n]["EdtCar"].getStr())

          if jsonPanel["panel"][t]["field"][n]["Protect"].getbool() == true :
            setProtect(base[b].field[getIndex(base[b],jsonPanel["panel"][t]["field"][n]["name"].getStr())],true)

          if jsonPanel["panel"][t]["field"][n]["Process"].getStr() != "" :
            setProcess(base[b].field[getIndex(base[b],jsonPanel["panel"][t]["field"][n]["name"].getStr())],
            jsonPanel["panel"][t]["field"][n]["Process"].getStr() )



  # Menu -> ZMENU

  if len(jsonPanel["menu"]) > 0 :
    var menuz = new(Vmenu)
    for n in 0..len(jsonPanel["menu"])-1:
      menuz.name = jsonPanel["menu"][n]["name"].getStr()
      menuz.posx = jsonPanel["menu"][n]["posx"].getInt()
      menuz.posy = jsonpanel["menu"][n]["posy"].getInt()
      menuz.orientation = toOrientation(jsonPanel["menu"][n]["orientation"].getStr())
      menuz.cadre = toCadre(jsonpanel["menu"][n]["cadre"].getStr())
      for nitem in  0..len(jsonpanel["menu"][n]["item"])-1:
        menuz.item.add(jsonpanel["menu"][n]["item"][nitem].getStr())
      ZMENU.add(menuz)
      menuz = new(Vmenu)


  # SFILE  -> NSFILE
  if len(jsonPanel["sfile"]) > 0 :
    var zsfile : GSFILE
    var zcell : CELL_Sfile
    var zitem : seq[string]

    for n in 0..len(jsonPanel["sfile"])-1:
      zsfile = new(GSFILE)
      zsfile.name   = jsonPanel["sfile"][n]["name"].getStr()
      zsfile.panel  = jsonPanel["sfile"][n]["panel"].getStr()
      zsfile.form  = jsonPanel["sfile"][n]["form"].getStr()
      zsfile.posx   = jsonPanel["sfile"][n]["posx"].getInt()
      zsfile.posy   = jsonpanel["sfile"][n]["posy"].getInt()
      zsfile.nrow   = jsonpanel["sfile"][n]["nrow"].getInt()
      zsfile.sep    = jsonPanel["sfile"][n]["sep"].getStr()

      for ncell in  0..len(jsonpanel["sfile"][n]["cell"])-1:
        zcell = new(CELL_Sfile)
        zcell.text    = jsonpanel["sfile"][n]["cell"][ncell]["colonne"].getStr()
        zcell.long    = jsonpanel["sfile"][n]["cell"][ncell]["long"].getInt()
        zcell.reftyp  = jsonpanel["sfile"][n]["cell"][ncell]["reftyp"].getStr()
        zcell.cellatr = jsonpanel["sfile"][n]["cell"][ncell]["cellatr"].getStr()
        zcell.edtcar  = jsonpanel["sfile"][n]["cell"][ncell]["edtcar"].getStr()
        zsfile.defcell.add(zcell)

      zitem = newSeq[string]()
      for nitem in  0..len(jsonpanel["sfile"][n]["item"])-1:
        zitem = newSeq[string]()
        for i in  0..len(jsonpanel["sfile"][n]["item"][nitem]["citem"])-1:
          zitem.add(jsonpanel["sfile"][n]["item"][nitem]["citem"][i].getStr())
        zsfile.citem.add(zitem)



      NSFILE.add(zsfile)


proc jsonFile() =

  var bt : BUTTON
  var jP : int

  jsonPanel = %* {"titleTerm": titleTerm ,"fileTerm": fileTerm,"panel": [], "menu": [] , "sfile": []}
  for nJ in 1..len(base) - 1:
    jP = nJ - 1

    # Json Panel / Button
    add(jsonPanel["panel"], %* {"name": getPnlName(base[nJ]), "posx": base[nJ].posx, "posy": base[nJ].posy,
            "height": base[nJ].lines, "width": base[nJ].cols, "cadre": base[nJ].cadre,
            "title": getPnlTitle(base[nJ]),
            "button" :[], "label":[], "field":[]})
    for i in 0..len(base[nJ].button) - 1 :
      bt = base[nJ].button[i]
      add(jsonPanel["panel"][jP]["button"] , %* {"Tkey": $bt.key,"txtKey": bt.text, "ctrl": bt.ctrl, "actif": bt.isActif})
    #--------------------

    # Json Label
    for n in 0..len(base[nJ].label) - 1:
      if isTitle(base[nJ], n) :
        add(jsonPanel["panel"][jP]["label"] , %* {"defLabel":"Title", "name" : getNameL(base[nJ],n),
          "posx": getPosxL(base[nJ],n), "posy": getPosyL(base[nJ],n), "text": getTextL(base[nJ],n) })
      else :
        add(jsonPanel["panel"][jP]["label"] , %* {"defLabel":"label", "name" : getNameL(base[nJ],n),
          "posx": getPosxL(base[nJ],n), "posy": getPosyL(base[nJ],n), "text": getTextL(base[nJ],n) })
    #--------------------

    # Json Field
    for n in 0..len(base[nJ].field) - 1:

      case getRefType(base[nJ],n)
        of ALPHA, ALPHA_UPPER,ALPHA_NUMERIC,ALPHA_NUMERIC_UPPER, TEXT_FREE, TEXT_FULL, PASSWORD, YES_NO, FPROC, FCALL :

          add(jsonPanel["panel"][jP]["field"] , %* {"defFld":"defString", "name" : getName(base[nJ],n),
                "posx": getPosx(base[nJ],n), "posy": getPosy(base[nJ],n),
                "reftype": $getRefType(base[nJ],n), "width": getWidth(base[nJ],n), "empty": getEmpty(base[nJ],n),
                "errmsg": getErrmsg(base[nJ],n), "help": getHelp(base[nJ],n),
                "text":"",
                "EdtCar": getEdtcar(base[nJ],n), "Protect" : isProtect(base[nJ].field[n]), "Process" : getProcess(base[nJ],n) })

        #--------------------
        of DIGIT , DIGIT_SIGNED , DECIMAL, DECIMAL_SIGNED  :

          add(jsonPanel["panel"][jP]["field"] , %* {"defFld":"defNumeric", "name" : getName(base[nJ],n),
                "posx": getPosx(base[nJ],n), "posy": getPosy(base[nJ],n),
                "reftype": $getRefType(base[nJ],n), "width": getWidth(base[nJ],n), "scal": getScal(base[nJ],n),
                "empty": getEmpty(base[nJ],n),
                "errmsg": getErrmsg(base[nJ],n), "help": getHelp(base[nJ],n),
                "text":"",
                "EdtCar": getEdtcar(base[nJ],n), "Protect" : isProtect(base[nJ].field[n]), "Process" : getProcess(base[nJ],n)})
        #--------------------
        of TELEPHONE:

          add(jsonPanel["panel"][jP]["field"] , %* {"defFld":"defTelephone", "name" : getName(base[nJ],n),
                "posx": getPosx(base[nJ],n), "posy": getPosy(base[nJ],n),
                "reftype": $getRefType(base[nJ],n), "width": getWidth(base[nJ],n), "empty": getEmpty(base[nJ],n),
                "errmsg": getErrmsg(base[nJ],n), "help": getHelp(base[nJ],n),
                "text":"",
                "EdtCar": getEdtcar(base[nJ],n), "Protect" : isProtect(base[nJ].field[n]), "Process" : getProcess(base[nJ],n)})
        #--------------------
        of DATE_ISO, DATE_FR, DATE_US:

          add(jsonPanel["panel"][jP]["field"] , %* {"defFld":"defDate", "name" : getName(base[nJ],n),
                "posx": getPosx(base[nJ],n), "posy": getPosy(base[nJ],n),
                "reftype": $getRefType(base[nJ],n), "empty": getEmpty(base[nJ],n),
                "errmsg": getErrmsg(base[nJ],n), "help": getHelp(base[nJ],n),
                "text":"",
                "EdtCar": "", "Protect" : isProtect(base[nJ].field[n]), "Process" : getProcess(base[nJ],n)})
        #--------------------
        of MAIL_ISO:

          add(jsonPanel["panel"][jP]["field"] , %* {"defFld":"defMail", "name" : getName(base[nJ],n),
                "posx": getPosx(base[nJ],n), "posy": getPosy(base[nJ],n),
                "reftype": $getRefType(base[nJ],n), "width": getWidth(base[nJ],n), "empty": getEmpty(base[nJ],n),
                "errmsg": getErrmsg(base[nJ],n), "help": getHelp(base[nJ],n),
                "text":"",
                "EdtCar": "", "Protect" : isProtect(base[nJ].field[n]), "Process" : getProcess(base[nJ],n)})
        #-------------------
        of SWITCH :

          add(jsonPanel["panel"][jP]["field"] , %* {"defFld":"defSwitch", "name" : getName(base[nJ],n),
                "posx": getPosx(base[nJ],n), "posy": getPosy(base[nJ],n),
                "reftype": $getRefType(base[nJ],n), "switch": false, "empty": getEmpty(base[nJ],n),
                "errmsg": getErrmsg(base[nJ],n), "help": getHelp(base[nJ],n),
                "text":"",
                "EdtCar": "", "Protect" : isProtect(base[nJ].field[n]), "Process" : getProcess(base[nJ],n)})

  #---------------------- json Menu
  if len(ZMENU) > 0 :
    for n in 0..<len(ZMENU):
      add(jsonPanel["menu"], %* {"name": ZMENU[n].name,
          "posx": ZMENU[n].posx, "posy": ZMENU[n].posy,"orientation": ZMENU[n].orientation, "cadre": ZMENU[n].cadre, "item" : ZMENU[n].item })

   #---------------------- json Menu
  if len(NSFILE) > 0 :
    for n in 0..<len(NSFILE):
      add(jsonPanel["sfile"], %* {"name": NSFILE[n].name,
          "panel": NSFILE[n].panel, "form": NSFILE[n].form,
          "posx": NSFILE[n].posx, "posy": NSFILE[n].posy,
          "nrow": NSFILE[n].nrow, "sep": NSFILE[n].sep,
          "cell":[] , "item":[] })

      for i in 0..len(NSFILE[n].defcell)-1 :
        add(jsonPanel["sfile"][n]["cell"], %*{ "colonne": NSFILE[n].defcell[i].text,
          "long": NSFILE[n].defcell[i].long, "reftyp": NSFILE[n].defcell[i].reftyp,
          "cellatr": NSFILE[n].defcell[i].cellatr, "edtcar": NSFILE[n].defcell[i].edtcar})

      for i in 0..len(NSFILE[n].citem)-1 :
        add(jsonPanel["sfile"][n]["item"], %*{"citem": NSFILE[n].citem[i]})


  #fmt"./{$path.strip()}"

  let F001 = open(fmt"./dspf/{fileTerm}", fmReadWrite)
  F001.write(pretty(jsonPanel))
  F001.close()
