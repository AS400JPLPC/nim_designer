import termkey
import termcurs

import db_sqlite
from strutils import Digits,parseInt, parseBool
import strformat


type
  FIELD_fecr01 {.pure.}= enum
    CPROF,
    HS
  BUTTON_fecr01 {.pure.} = enum
      B1F2
      B1F3,
      B1F9,
      B1F10,
      B1F23
const P1: array[FIELD_fecr01, int] = [0,1]
const P1B: array[BUTTON_fecr01, int] = [0,1,2,3,4]

type fcprof = ref object
  CPROFESSION     : string
  HS              : int

type ctrlErr = ref object
    msg         : string


var Prf = new(fcprof)       # Records

var MsgErr = new(ctrlErr)   # ERROR

var db : DbConn             # table Principale....



#---------------------------------------
# if exist table
#---------------------------------------
proc isTable(dbx: DbConn; tbl : string ) : bool =
  if 1 ==  parseInt(dbx.getValue(sql"""SELECT
    count(*) FROM sqlite_master WHERE type='table' AND name=?""",tbl)):
    return true
  else : return false

#---------------------------------------
# clear Adr
#---------------------------------------
proc clearPrf() =
  Prf.CPROFESSION =""
  Prf.HS          =0


#---------------------------------------
# insert Prf
#---------------------------------------

proc insertPrf(dbn: DbConn )=
  MsgErr.msg = ""
  try:
    dbn.exec(sql """INSERT INTO FCPROF (CPROFESSION, HS) VALUES(?, ?);""" , Prf.CPROFESSION, Prf.HS)
    MsgErr.msg = getCurrentExceptionMsg()
  except :
    MsgErr.msg = getCurrentExceptionMsg()

#---------------------------------------
# delete Prf
#---------------------------------------
proc deletePrf(dbn: DbConn )=
  MsgErr.msg = ""
  try:
    var requette : string = fmt"DELETE from FCPROF  WHERE CPROFESSION = '{Prf.CPROFESSION}';"
    dbn.exec(sql $requette)
  except:
    MsgErr.msg = getCurrentExceptionMsg()



#---------------------------------------
# update fcprof
#---------------------------------------
proc updatePrf(dbn: DbConn )=
  MsgErr.msg = ""
  try:
    var requette : string = fmt"UPDATE FCPROF SET HS='{Prf.HS}' WHERE CPROFESSION='{Prf.CPROFESSION}';"
    dbn.exec(sql $requette)
  except :
    MsgErr.msg = getCurrentExceptionMsg()



#---------------------------------------
# recuperation Field
#---------------------------------------
proc recordPrf(rown : InstantRow ; dbCn: DbColumns ) =
  for x in 0..(rown.len - 1) :
    case dbCn[x].name
      of "CPROFESSION"      :    Prf.CPROFESSION  = rown[x]
      of "HS"               :    Prf.HS = parseInt(rown[x])
      else : discard

#---------------------------------------
# read fcproc
#---------------------------------------
proc readPrf(dbn: DbConn, sqlreq :string  ) =
  var columns: DbColumns
  MsgErr.msg = ""
  try:
    for rowx in dbn.instantRows(columns,sql $sqlreq):
      recordPrf(rowx, columns)
  except:
    MsgErr.msg = getCurrentExceptionMsg()



# Panel fecr01

var fecr01= new(PANEL)

# description
proc dscfecr01() =
  fecr01 = newPanel("fecr01",1,1,20,54,@[defButton(TKey.F3,"Exit",false,true),defButton(TKey.F5,"clear",false,true), defButton(TKey.F9,"Add",true,true), defButton(TKey.F10,"Upd",true,true), defButton(TKey.F23,"Dlt",false,true)],line2,"Profession")

  # LABEL  -> fecr01

  fecr01.label.add(deflabel("L02002", 2, 2, "F2:Table"))


  # FIELD -> fecr01

  fecr01.field.add(defString("CPROF", 3, 16, TEXT_FREE,20,"", FILL, "Obligatoire","Profession"))
  fecr01.field.add(defSwitch("HS", 3, 36, SWITCH, false, EMPTY, "", "HS ON/OFF"))




var GSFL01: GRIDSFL
#===================================================
proc defSFL01() =
  GSFL01  = newGRID("SFL01",4,15,12,sepStyle)
  var Cell_Profession = defCell("Profession",20,TEXT_FREE,"Cyan")
  var Cell_HS = defCell("HS",1,SWITCH,"White")
  setHeaders(GSFL01, @[Cell_Profession ,Cell_HS])
#===================================================


# Panel fercMsg
type
  FIELD_fecrMsg {.pure.}= enum
    ERRMSG
const P2: array[FIELD_fecrMsg, int] = [0]

var fecrMsg= new(PANEL)
var idx : int
# description
proc dscfecrMsg() =
  fecrMsg = newPanel("fercMsg",1,1,4,50,@[defButton(TKey.F1,"F1",false,true)],line1,"Message error")

  # FIELD -> fercMsg

  fecrMsg.field.add(defString("ERRMSG", 2, 2, TEXT_FREE,48,"", EMPTY, "",""))
  setProtect(fecrMsg.field[P2[ERRMSG]],true)

proc displayMsg(ecrx: PANEL)=
  if MsgErr.msg > "" :
    printPanel(fecrMsg)
    setText(fecrMsg,P2[ERRMSG],MsgErr.msg)
    displayPanel(fecrMsg)
    discard ioPanel(fecrMsg)
    restorePanel(ecrx,fecrMsg)
    db.exec(sql"ROOLBACK")

proc setColumnSFL01() =
  clearPrf()
  var columns: DbColumns
  resetRows(GSFL01)
  for rown in db.instantRows(columns,sql "SELECT CPROFESSION, HS FROM FCPROF ORDER BY CPROFESSION;"):
    for x in 0..(rown.len - 1) :
      case columns[x].name
        of "CPROFESSION"  :    Prf.CPROFESSION  = rown[x]
        of "HS"           :    Prf.HS = parseInt(rown[x])
        else: discard

    addRows(GSFL01, @[  Prf.CPROFESSION, $Prf.HS ])


proc clearEcr() =
  setActif(fecr01.button[P1B[B1F9]],true)   # add enrg
  setActif(fecr01.button[P1B[B1F10]],false)  # upd enrg
  setActif(fecr01.button[P1B[B1F23]],false)  # del enrg
  setText(fecr01,P1[CPROF]  ,"")
  setProtect(fecr01,P1[CPROF],false)
  setSWITCH(fecr01,P1[HS]     ,false)
  setIndex(fecr01,0)

#===================================================
proc main() =
  initTerm(20,54,"TERMINAL-Profession")
  try:
    db    = open("Table.db", "", "", "")

  except:
    stderr.writeLine(getCurrentExceptionMsg())
    discard getFunc()
    return

  if false == isTable(db,"FCPROF") :
    stderr.writeLine("not exxist table FCPROF")
    discard getFunc()
    return

  dscfecr01()
  dscfecrMsg()
  defSFL01() # init sfl01
  setColumnSFL01()
  clearEcr()
  #Exemple ------ :
  while true:
    poster(fecr01)
    if countRows(GSFL01) > 0 :
      if getIndexG(GSFL01,getText(fecr01,P1[CPROF]),0) > 0 :
        idx = getIndexG(GSFL01,getText(fecr01,P1[CPROF]),0)
      else : idx = -1
    let  (key01, val) = ioFMT(fecr01,GSFL01,true,idx)
    case key01
      of TKey.Mouse :
          setActif(fecr01.button[P1B[B1F9]],false)   # add enrg
          setActif(fecr01.button[P1B[B1F10]],true)  # add enrg
          setActif(fecr01.button[P1B[B1F23]],true)  # del enrg
          setText(fecr01,P1[CPROF]  ,val[0])
          setProtect(fecr01,P1[CPROF],true)
          setSWITCH(fecr01,P1[HS]     ,parseBool(val[1]))

      of TKey.F3:
        break
      of TKey.F5:
        setActif(fecr01.button[P1B[B1F9]],true)   # add enrg
        clearEcr()

      of TKey.F9:
        if getText(fecr01,P1[CPROF]) > "" :
          Prf.CPROFESSION = getText(fecr01,P1[CPROF])
          if true == getSwitch(fecr01,P1[HS]) : Prf.HS = 1 else: Prf.HS = 0
          db.exec(sql"BEGIN")
          insertPrf(db)
          db.exec(sql"COMMIT")
          setColumnSFL01()
          clearEcr()


      of TKey.F10:
        if getText(fecr01,P1[CPROF]) > "" :
          Prf.CPROFESSION = getText(fecr01,P1[CPROF])
          if true == getSwitch(fecr01,P1[HS]) : Prf.HS = 1 else: Prf.HS = 0
          db.exec(sql"BEGIN")
          updatePrf(db)
          db.exec(sql"COMMIT")
          setColumnSFL01()
          clearEcr()


      of TKey.F23:
        if getText(fecr01,P1[CPROF]) > "" :
          readPrf(db,fmt"SELECT CPROFESSION HS from FCPROF  WHERE CPROFESSION = '{Prf.CPROFESSION}';")
          db.exec(sql"BEGIN")
          deletePrf(db)
          db.exec(sql"COMMIT")
          setColumnSFL01()
          clearEcr()

      else : discard


  closeTerm()



main()
