#import db_sqlite
#from strutils import Digits, parseInt
#import strformat

type fcontact = ref object
  CID    : int64
  NOM         : string
  PRENOM      : string
  CIVILITE    : string
  RELATION    : string
  TEL         : string
  TELBIS      : string
  MAIL        : string
  DJN         : string
  ADR1        : string
  ADR2        : string
  ADR3        : string
  CPTT        : string
  VILLE       : string
  CPAYS       : string
  LPAYS       : string
  NOTE1       : string
  NOTE2       : string
  NOTE3       : string
  CPROF       : string
  SOCIETE     : string
  TELCIE      : string



type fcdep = ref object
  CID             : int
  CPOSTAL         : string
  LCOMMUNE        : string
  LDEPARTEMENT    : string
  LREGION         : string
  CPAYS           : string
  LPAYS           : string
  TPAYS           : string



type fcprof = ref object
  CPROFESSION     : string
  HS              : bool

type ctrlErr = ref object
    msg         : string



var Adr = new(fcontact)     # Records

var Dep = new(fcdep)        # Records

var Prf = new(fcprof)       # Records

var MsgErr = new(ctrlErr)   # ERROR



var db : DbConn             # table Principale....

var dbtb : DbConn           # read only table



#---------------------------------------
# if exist table
#---------------------------------------
proc isTable(dbx: DbConn; tbl : string ) : bool =
  if 1 ==  parseInt(dbx.getValue(sql"""SELECT
    count(*) FROM sqlite_master WHERE type='table' AND name=?"""
    ,tbl)):
    return true
  else : return false


#---------------------------------------
# clear Adr
#---------------------------------------
proc clearAdr() =
  Adr.CID         =0
  Adr.NOM         =""
  Adr.PRENOM      =""
  Adr.CIVILITE    =""
  Adr.RELATION    =""
  Adr.TEL         =""
  Adr.TELBIS      =""
  Adr.MAIL        =""
  Adr.DJN         =""
  Adr.ADR1        =""
  Adr.ADR2        =""
  Adr.ADR3        =""
  Adr.CPTT        =""
  Adr.VILLE       =""
  Adr.CPAYS       =""
  Adr.LPAYS       =""
  Adr.NOTE1       =""
  Adr.NOTE2       =""
  Adr.NOTE3       =""
  Adr.CPROF       =""
  Adr.SOCIETE     =""
  Adr.TELCIE      =""



#---------------------------------------
# insert Adr
#---------------------------------------

proc insertAdr(dbn: DbConn ) =
  MsgErr.msg = ""
  try:
    Adr.CID =  dbn.insertID(sql """INSERT INTO 'FCONTACT' (
      NOM, PRENOM, CIVILITE, RELATION, TEL, TELBIS, MAIL, DJN, ADR1, ADR2, ADR3, CPTT, VILLE, CPAYS, LPAYS, NOTE1, NOTE2, NOTE3, CPROF, SOCIETE, TELCIE) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);""",
      Adr.NOM, Adr.PRENOM, Adr.CIVILITE, Adr.RELATION, Adr.TEL, Adr.TELBIS, Adr.MAIL, Adr.DJN, Adr.ADR1, Adr.ADR2, Adr.ADR3, Adr.CPTT, Adr.VILLE, Adr.CPAYS, Adr.LPAYS, Adr.NOTE1, Adr.NOTE2, Adr.NOTE3, Adr.CPROF, Adr.SOCIETE, Adr.TELCIE )

  except :
    MsgErr.msg = getCurrentExceptionMsg()

#---------------------------------------
# delete Adr
#---------------------------------------
proc deleteAdr(dbn: DbConn ) =
  MsgErr.msg = ""
  try:
    var requette : string = fmt"DELETE from FCONTACT  WHERE CID = '{Adr.CID}';"
    dbn.exec(sql $requette)
  except:
    MsgErr.msg = getCurrentExceptionMsg()



#---------------------------------------
# insert Adr
#---------------------------------------
proc updateAdr(dbn: DbConn ) =
  MsgErr.msg = ""
  try:
    var requette : string = fmt"UPDATE FCONTACT SET NOM='{Adr.NOM}', PRENOM='{Adr.PRENOM}', CIVILITE='{Adr.CIVILITE}', RELATION='{Adr.RELATION}', TEL='{Adr.TEL}', TELBIS='{Adr.TELBIS}', MAIL='{Adr.MAIL}', DJN='{Adr.DJN}', ADR1='{Adr.ADR1}', ADR2='{Adr.ADR2}', ADR3='{Adr.ADR3}', CPTT='{Adr.CPTT}', VILLE='{Adr.VILLE}', CPAYS='{Adr.CPAYS}', LPAYS='{Adr.LPAYS}', NOTE1='{Adr.NOTE1}', NOTE2='{Adr.NOTE2}', NOTE3='{Adr.NOTE3}', CPROF='{Adr.CPROF}', SOCIETE='{Adr.SOCIETE}', TELCIE='{Adr.TELCIE}' WHERE CID={Adr.CID};"
    dbn.exec(sql $requette)
  except :
    MsgErr.msg = getCurrentExceptionMsg()



#---------------------------------------
# recuperation Field
#---------------------------------------
proc recordAdr(rown : InstantRow ; dbCn: DbColumns ) =

  for x in 0..(rown.len - 1) :
    case dbCn[x].name
      of "CID"      :    Adr.CID        = parseInt(rown[x])
      of "NOM"      :    Adr.NOM        = rown[x]
      of "PRENOM"   :    Adr.PRENOM     = rown[x]
      of "CIVILITE" :    Adr.CIVILITE   = rown[x]
      of "RELATION" :    Adr.RELATION   = rown[x]
      of "TEL"      :    Adr.TEL        = rown[x]
      of "TELBIS"   :    Adr.TELBIS     = rown[x]
      of "MAIL"     :    Adr.MAIL       = rown[x]
      of "DJN"      :    Adr.DJN        = rown[x]
      of "ADR1"     :    Adr.ADR1       = rown[x]
      of "ADR2"     :    Adr.ADR2       = rown[x]
      of "ADR3"     :    Adr.ADR3       = rown[x]
      of "CPTT"     :    Adr.CPTT       = rown[x]
      of "VILLE"    :    Adr.VILLE      = rown[x]
      of "CPAYS"    :    Adr.CPAYS      = rown[x]
      of "LPAYS"    :    Adr.LPAYS      = rown[x]
      of "NOTE1"    :    Adr.NOTE1      = rown[x]
      of "NOTE2"    :    Adr.NOTE2      = rown[x]
      of "NOTE3"    :    Adr.NOTE3      = rown[x]
      of "CPROF"    :    Adr.CPROF      = rown[x]
      of "SOCIETE"  :    Adr.SOCIETE    = rown[x]
      of "TELCIE"   :    Adr.TELCIE     = rown[x]

      else: discard



#---------------------------------------
# read Adr
#---------------------------------------
proc readAdr(dbn: DbConn, sqlreq :string  ) : bool =
  var columns: DbColumns
  for rowx in dbn.instantRows(columns,sql $sqlreq):
    recordAdr(rowx, columns)
    return true
  return false


#---------------------------------------
# clear Dep
#---------------------------------------
proc clearDep() =
  Dep.CID           =0
  Dep.CPOSTAL       =""
  Dep.LCOMMUNE      =""
  Dep.LDEPARTEMENT  =""
  Dep.LREGION       =""
  Dep.CPAYS         =""
  Dep.LPAYS         =""
  Dep.TPAYS         =""
