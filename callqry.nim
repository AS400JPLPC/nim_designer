var callQuery: Table[string, proc(fld : var FIELD)]

#var Xcombo  = new(GRIDSFL)
#===================================================
proc callRefTyp(fld : var FIELD) =
  var g_pos : int = -1
  var Xcombo  = newGRID("COMBO1",2,2,20,sepStyle)

  var g_type  = defCell("Ref.Type",19,TEXT_FREE)

  setHeaders(Xcombo, @[g_type])
  addRows(Xcombo, @["TEXT_FREE"])
  addRows(Xcombo, @["ALPHA"])
  addRows(Xcombo, @["ALPHA_UPPER"])
  addRows(Xcombo, @["ALPHA_NUMERIC"])
  addRows(Xcombo, @["ALPHA_NUMERIC_UPPER"])
  addRows(Xcombo, @["TEXT_FULL"])
  addRows(Xcombo, @["PASSWORD"])
  addRows(Xcombo, @["DIGIT"])
  addRows(Xcombo, @["DIGIT_SIGNED"])
  addRows(Xcombo, @["DECIMAL"])
  addRows(Xcombo, @["DECIMAL_SIGNED"])
  addRows(Xcombo, @["DATE_ISO"])
  addRows(Xcombo, @["DATE_FR"])
  addRows(Xcombo, @["DATE_US"])
  addRows(Xcombo, @["TELEPHONE"])
  addRows(Xcombo, @["MAIL_ISO"])
  addRows(Xcombo, @["YES_NO"])
  addRows(Xcombo, @["SWITCH"])
  addRows(Xcombo, @["FPROC"])
  addRows(Xcombo, @["FCALL"])
  #printGridHeader(Xcombo)

  case fld.text
    of "TEXT_FREE"            : g_pos = 0
    of "ALPHA"                : g_pos = 1
    of "ALPHA_UPPER"          : g_pos = 2
    of "ALPHA_NUMERIC"        : g_pos = 3
    of "ALPHA_NUMERIC_UPPER"  : g_pos = 4
    of "TEXT_FULL"            : g_pos = 5
    of "PASSWORD"             : g_pos = 6
    of "DIGIT"                : g_pos = 7
    of "DIGIT_SIGNED"         : g_pos = 8
    of "DECIMAL"              : g_pos = 9
    of "DECIMAL_SIGNED"       : g_pos = 10
    of "DATE_ISO"             : g_pos = 11
    of "DATE_FR"              : g_pos = 12
    of "DATE_US"              : g_pos = 13
    of "TELEPHONE"            : g_pos = 14
    of "MAIL_ISO"             : g_pos = 15
    of "YES_NO"               : g_pos = 16
    of "SWITCH"               : g_pos = 17
    of "FPROC"                : g_pos = 18
    of "FCALL"                : g_pos = 19
    else : discard

  while true :
    let (keys, val) = ioGrid(Xcombo,g_pos)

    case keys
      of TKey.Enter :
        restorePanel(detail,Xcombo)
        fld.text  = $val[0]
        break
      else: discard

callQuery["callRefTyp"] = callRefTyp


#===================================================
proc callVH(fld : var FIELD)=
  var g_pos : int = 0
  var Xcombo  = newGRID("COMBO2",2,2,2,sepStyle)

  var g_line  = defCell("Type Menu",10,TEXT_FREE)

  setHeaders(Xcombo, @[g_line])
  addRows(Xcombo, @["vertical"])
  addRows(Xcombo, @["horizontal"])
  #printGridHeader(Xcombo)

  case fld.text
    of "vertical"  : g_pos = 0
    of "horizontal"  : g_pos = 1


  while true :
    let (keys, val) = ioGrid(Xcombo,g_pos)

    case keys
      of TKey.Enter :
        restorePanel(detail,Xcombo)
        fld.text  = $val[0]
        break
      else: discard

callQuery["callVH"] = callVH


#===================================================
proc callCadreMenu(fld : var FIELD)=
  var g_pos : int = 0
  var Xcombo  = newGRID("COMBO3",2,2,2,sepStyle)

  var g_line  = defCell("Cadre",5,TEXT_FREE)

  setHeaders(Xcombo, @[g_line])
  addRows(Xcombo, @["line1"])
  addRows(Xcombo, @["line2"])
  #printGridHeader(Xcombo)

  case fld.text
    of "line1"  : g_pos = 1
    of "line2"  : g_pos = 2


  while true :
    let (keys, val) = ioGrid(Xcombo,g_pos)

    case keys
      of TKey.Enter :
        restorePanel(detail,Xcombo)
        fld.text  = $val[0]
        break
      else: discard

callQuery["callCadreMenu"] = callCadreMenu




#===================================================
proc callCadre(fld : var FIELD)=
  var g_pos : int = 0
  var Xcombo  = newGRID("COMBO4",2,2,3,sepStyle)

  var g_line  = defCell("Cadre",5,TEXT_FREE)

  setHeaders(Xcombo, @[g_line])
  addRows(Xcombo, @["line0"])
  addRows(Xcombo, @["line1"])
  addRows(Xcombo, @["line2"])
  #printGridHeader(Xcombo)

  case fld.text
    of "line0"  : g_pos = 0
    of "line1"  : g_pos = 1
    of "line2"  : g_pos = 2


  while true :
    let (keys, val) = ioGrid(Xcombo,g_pos)

    case keys
      of TKey.Enter :
        restorePanel(detail,Xcombo)
        fld.text  = $val[0]
        break
      else: discard

callQuery["callCadre"] = callCadre

#===================================================

proc callPanel(pnlchx : seq[PANEL]; crtpnl : bool) : int =
  var g_pos : int = -1
  var Xcombo  = newGRID("COMBO5",1,1,20,sepStyle)
  var g_id    = defCell("ID",3,DIGIT)
  var g_name  = defCell("Name",10,TEXT_FREE,cellYellow)
  var g_title = defCell("Title",15,TEXT_FREE)
  setHeaders(Xcombo, @[g_id, g_name, g_title])

  var g_numID = 0
  for i in 1..len(pnlchx )-1:
    addRows(Xcombo, @[setID(g_numID), getPnlName(pnlchx[i]), getPnlTitle(pnlchx[i])] )

  if crtpnl : addRows(Xcombo, @["999", "Add", "Panel"])

  while true :
    let (keys, val) = ioGrid(Xcombo,g_pos)
    case keys
      of TKey.Enter :
        restorePanel(detail,Xcombo)
        return parseInt($val[0])
      of TKey.Escape :
        restorePanel(detail,Xcombo)
        return 0
      else: discard

#===================================================
proc callField(pfield : PANEL) : int =
  var g_pos : int = -1
  var Xcombo : GRIDSFL
  if X < 12 :
    Xcombo  = newGRID("COMBO6",terminalHeight()-12,1,10,sepStyle)
  else:
    Xcombo  = newGRID("COMBO07",1,1,10,sepStyle)
  var g_id      = defCell("ID",3,DIGIT)
  var g_name    = defCell("Name",10,ALPHA,cellYellow)
  var g_posx    = defCell("PosX",4,DIGIT)
  var g_posy    = defCell("PosY",4,DIGIT)
  var g_type    = defCell("Type",19,ALPHA)
  var g_len     = defCell("len" ,4,DIGIT)
  var g_scal    = defCell("scal",4,DIGIT)

  setHeaders(Xcombo, @[g_id, g_name, g_posx, g_posy, g_type, g_len, g_scal ])

  var g_numID = 0
  for i in 0..len(pfield.field )-1:
    addRows(Xcombo, @[setID(g_numID), getName(pfield,i), $getPosx(pfield,i), $getPosy(pfield,i), $getRefType(pfield,i), $getWidth(pfield,i), $getScal(pfield,i) ])


  addRows(Xcombo, @["999", "Add", "Field","","","",""])

  while true :
    let (keys, val) = ioGrid(Xcombo,g_pos)
    case keys
      of TKey.Enter :
        restorePanel(detail,Xcombo)
        return parseInt($val[0])
      else: discard