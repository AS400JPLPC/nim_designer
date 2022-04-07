


#===================================================
proc tselection(fld : var FIELD) =
  var Cell_pos : int = -1
  var Xcombo  = newGRID("tselection",2,114,4,sepStyle)
  var Cell_SelectTrie = defCell("SelectTrie",15,TEXT_FREE,"Cyan")
  setHeaders(Xcombo, @[Cell_SelectTrie])
  addRows(Xcombo, @[ "" ])
  addRows(Xcombo, @[ "---" ])
  addRows(Xcombo, @[ "Famille" ])
  addRows(Xcombo, @[ "Amis" ])
  addRows(Xcombo, @[ "Professionnel" ])

  case fld.text
    of "---"   : Cell_pos = 1
    of "Famille"   : Cell_pos = 2
    of "Amis"   : Cell_pos = 3
    of "Professionnel"   : Cell_pos = 4
    else : discard

  while true :
    let (keys, val) = ioGrid(Xcombo,Cell_pos)
    case keys
      of TKey.Enter :
        restorePanel(fecr01,Xcombo)
        fld.text  = $val[0]
        break
      else: discard

callQuery["tselection"] = tselection
#===================================================

#===================================================
proc tcivilite(fld : var FIELD) =
  var Cell_pos : int = -1
  var Xcombo  = newGRID("tcivilite",5,89,2,sepStyle)
  var Cell_Civilité = defCell("Civilité",4,TEXT_FREE,"Cyan")
  setHeaders(Xcombo, @[Cell_Civilité])
  addRows(Xcombo, @[ "M." ])
  addRows(Xcombo, @[ "Mme." ])

  case fld.text
    of "M."   : Cell_pos = 0
    of "Mme."   : Cell_pos = 1
    else : discard

  while true :
    let (keys, val) = ioGrid(Xcombo,Cell_pos)
    case keys
      of TKey.Enter :
        restorePanel(fecr02,Xcombo)
        fld.text  = $val[0]
        break
      else: discard

callQuery["tcivilite"] = tcivilite
#===================================================



#===================================================
proc tcpays(fld : var FIELD) =
  var Cell_pos : int = -1
  var Xcombo  = newGRID("tcpays",2,8,14,sepStyle)
  var Cell_CCPAY = defCell("CPAY",3,TEXT_FREE,"Cyan")
  var Cell_LPAYS = defCell("LPAYS",20,TEXT_FREE,"Cyan")
  setHeaders(Xcombo, @[Cell_CCPAY ,Cell_LPAYS])


  clearDep()
  var columns: DbColumns
  var npos : int = -1
  for rown in dbtb.instantRows(columns,sql "SELECT DISTINCT  CPAYS, LPAYS FROM FCDEP ORDER BY CPAYS;"):
    for x in 0..(rown.len - 1) :
      case columns[x].name
        of "CPAYS"        :    Dep.CPAYS        = rown[x]
        of "LPAYS"        :    Dep.LPAYS        = rown[x]
        else: discard
    inc(npos)
    addRows(Xcombo, @[  Dep.CPAYS , Dep.LPAYS ])
    if Dep.CPAYS == fld.text : Cell_pos = npos


  while true :
    let (keys, val) = ioGrid(Xcombo,Cell_pos)
    case keys
      of TKey.Enter :
        restorePanel(fecr02,Xcombo)
        fld.text  = $val[0]
        setText(fecr02,P2[LPAYS]     ,$val[1])
        printField(fecr02,fecr02.field[P2[LPAYS]])
        displayField(fecr02,fecr02.field[P2[LPAYS]])
        break
      else: discard

callQuery["tcpays"] = tcpays
#===================================================


#===================================================

proc tcptt(fld : var FIELD ) =
  var Cell_pos : int = 0
  var Xcombo  = newGRID("tcptt",1,1,20,sepStyle)
  var Cell_Code = defCell("Code",10,TEXT_FREE,"Cyan")
  var Cell_LCOMMUNE = defCell("Commune",20,TEXT_FREE,"Cyan")
  var Cell_Lpays = defCell("Pays",20,TEXT_FREE,"Cyan")
  setHeaders(Xcombo, @[Cell_Code ,Cell_LCOMMUNE,Cell_Lpays])

  clearDep()
  var columns: DbColumns
  var req : string


  proc selectCommune() =
    resetRows(Xcombo)
    for rown in dbtb.instantRows(columns,sql $req):
      for x in 0..(rown.len - 1) :
        case columns[x].name
          of "CPOSTAL"        :    Dep.CPOSTAL      = rown[x]
          of "LCOMMUNE"       :    Dep.LCOMMUNE     = rown[x]
          of "LPAYS"          :    Dep.LPAYS        = rown[x]
          else: discard
      addRows(Xcombo, @[  Dep.CPOSTAL ,Dep.LCOMMUNE , Dep.LPAYS ])
      clearDep()



  while true :
    let (keys, val) = ioGrid(Xcombo,Cell_pos)
    case keys
      of TKey.Enter :
        restorePanel(fecr02,Xcombo)
        fld.text  = $val[0]
        setText(fecr02,P2[VILLE]     ,$val[1])
        printField(fecr02,fecr02.field[P2[VILLE]])
        displayField(fecr02,fecr02.field[P2[VILLE]])
        break
      of TKey.Escape :
        dscfecr03()
        printPanel(fecr03)
        displayPanel(fecr03)
        while true :
          var  key00 = ioPanel(fecr03)
          case key00:
          of TKey.F2 :
            req = fmt"SELECT CPOSTAL, LCOMMUNE, LPAYS FROM FCDEP WHERE CPAYS = '{getText(fecr02,P2[CPAYS])}' AND LCOMMUNE LIKE '%{getText(fecr03,P3[VILLE2])}%'ORDER BY CPAYS,CPOSTAL;"
            selectCommune()
          of TKey.F12 :
            req = fmt"SELECT CPOSTAL, LCOMMUNE, LPAYS FROM FCDEP WHERE CPAYS = '{getText(fecr02,P2[CPAYS])}' ORDER BY CPAYS,CPOSTAL;"
            selectCommune()
          else : discard
          if key00 == TKey.F2 or key00 == TKey.F12 :
            restorePanel(fecr02,fecr03)
            break
      else: discard

callQuery["tcptt"] = tcptt
#===================================================



#===================================================
proc trelation(fld : var FIELD) =
  var Cell_pos : int = -1
  var Xcombo  = newGRID("trelation",5,101,4,sepStyle)
  var Cell_Relation = defCell("Relation",15,TEXT_FREE,"Cyan")
  setHeaders(Xcombo, @[Cell_Relation])
  addRows(Xcombo, @[ "---" ])
  addRows(Xcombo, @[ "Famille" ])
  addRows(Xcombo, @[ "Amis" ])
  addRows(Xcombo, @[ "Professionnel" ])

  case fld.text
    of "---"   : Cell_pos = 0
    of "Famille"   : Cell_pos = 1
    of "Amis"   : Cell_pos = 2
    of "Professionnel"   : Cell_pos = 3
    else : discard

  while true :
    let (keys, val) = ioGrid(Xcombo,Cell_pos)
    case keys
      of TKey.Enter :
        restorePanel(fecr02,Xcombo)
        fld.text  = $val[0]
        break
      else: discard

callQuery["trelation"] = trelation
#===================================================


#===================================================
proc tcprof(fld : var FIELD) =
  var Cell_pos : int = -1
  var Xcombo  = newGRID("tprof",24,14,5,sepStyle)
  var Cell_Profession = defCell("Profession",20,TEXT_FREE,"Cyan")
  setHeaders(Xcombo, @[Cell_Profession])

  var columns: DbColumns
  var npos : int = -1
  for rown in dbtb.instantRows(columns,sql "SELECT CPROFESSION FROM FCPROF WHERE HS = 0 order by CPROFESSION ;"):
    for x in 0..(rown.len - 1) :
      case columns[x].name
        of "CPROFESSION"     :    Prf.CPROFESSION      = rown[x]
        else: discard
    inc(npos)
    addRows(Xcombo, @[  Prf.CPROFESSION ])
    if Prf.CPROFESSION == fld.text : Cell_pos = npos

  while true :
    let (keys, val) = ioGrid(Xcombo,Cell_pos)
    case keys
      of TKey.Enter :
        restorePanel(fecr02,Xcombo)
        fld.text  = $val[0]
        break
      else: discard

callQuery["tcprof"] = tcprof
#===================================================