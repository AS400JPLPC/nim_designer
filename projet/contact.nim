import termkey
import termcurs
import tables
import db_sqlite
from strutils import Digits, parseInt
import strformat
import osproc

proc beug(nline : int ; text :string ) =
  gotoXY(40, 1); echo "ligne>", nline, " :" , text ; discard getFunc()


include contactSQL

var callQuery: Table[string, proc(fld : var FIELD)]
type
  LABEL_fecr01 {.pure.} = enum
    Lgrid
  FIELD_fecr01 {.pure.}= enum
    SNAME,
    SINDEX,
    SNOM,
    SPRENOM,
    STEL,
    SRELATION
  BUTTON_fecr01 {.pure.} = enum
    B1F3,
    B1F5,
    B1F7,
    B1F9,
    B1F10,
    B1F23
const P1L: array[LABEL_fecr01, int] = [0]
const P1 : array[FIELD_fecr01, int] = [0,1,2,3,4,5]
const P1B: array[BUTTON_fecr01, int] = [0,1,2,3,4,5]

type
  FIELD_fecr02 {.pure.}= enum
    CID,
    NOM,
    PRENOM,
    CIVILITE,
    RELATION,
    TEL,
    TELBIS,
    MAIL,
    DJN,
    ADR1,
    ADR2,
    ADR3,
    CPAYS,
    LPAYS,
    CPTT,
    VILLE,
    NOTE1,
    NOTE2,
    NOTE3,
    CPROF,
    SOCIETE,
    TELCIE
  BUTTON_fecr02 {.pure.} = enum
    B2F3,
    B2F4,
    B2F9,
    B2F10,
    B2F12,
    B2F23
const P2: array[FIELD_fecr02, int] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21]
const P2B: array[BUTTON_fecr02, int] = [0,1,2,3,4,5]

type
  FIELD_fecr03 {.pure.}= enum
    CPAYS2,
    LPAYS2,
    VILLE2
const P3: array[FIELD_fecr03, int] = [0,1,2]


include contactEcr
include contactQry

proc pFECR02(key: TKey) : Tkey

#===================================================

proc setColumnSFL01() =
  clearAdr()
  var columns: DbColumns
  var requette : string
  resetRows(GSFL01)
  if getText(fecr01,P1[SNAME]) == "" :
    requette = "SELECT CID, NOM, PRENOM, TEL, RELATION , LPAYS FROM FCONTACT ORDER BY CPAYS, NOM, CID ;"
  else :
    requette = fmt"SELECT CID, NOM, PRENOM, TEL, RELATION , LPAYS FROM FCONTACT WHERE  NOM LIKE '%{getText(fecr01,P1[SNAME])}%' ORDER BY CPAYS , NOM, CID ;"
  for rown in dbtb.instantRows(columns,sql $requette):
    for x in 0..(rown.len - 1) :
      case columns[x].name
        of "CID"          :    Adr.CID        = parseInt(rown[x])
        of "NOM"          :    Adr.NOM        = rown[x]
        of "PRENOM"       :    Adr.PRENOM     = rown[x]
        of "TEL"          :    Adr.TEL        = rown[x]
        of "RELATION"     :    Adr.RELATION   = rown[x]
        of "LPAYS"        :    Adr.LPAYS      = rown[x]
        else: discard
    addRows(GSFL01, @[  $Adr.CID, Adr.NOM, Adr.PRENOM, Adr.TEL, Adr.RELATION , Adr.LPAYS])

proc main() =
  initTerm(32,132,"TERMINAL-contact")
  try:
    db    = open("Table.db", "", "", "")
    dbtb  = open("Table.db", "", "", "")
  except:
    stderr.writeLine(getCurrentExceptionMsg())
    discard getFunc()
    return

  if false == isTable(db,"FCONTACT") :
    stderr.writeLine("not exxist table FCONTACT")
    discard getFunc()
    return
  if false == isTable(dbtb,"FCDEP") :
    stderr.writeLine("not exxist table FCDEP")
    discard getFunc()
    return
  if false == isTable(dbtb,"FCPROF") :
    stderr.writeLine("not exxist table FCPROF")
    discard getFunc()
    return



  dscfecr01()
  defSFL01() # init sfl01
  var pkey : TKey = TKey.None # return key proc
  var idx : int
  #Exemple ------
  setColumnSFL01()
  while true:
    idx = -1

    # loading buffer print/display Panel
    poster(fecr01)


    # Reposition in the page of the subfile (grid)
    if countRows(GSFL01) > 0 :
      if getIndexG(GSFL01,getText(fecr01,P1[SINDEX]),0) > 0 :
        idx = getIndexG(GSFL01,getText(fecr01,P1[SINDEX]),0)

    # management of the panel with its fields and control of the Gridsfl
    # defaut ioFMT(Panel,Gridsfl) select=false  pos index = -1
    let (key01, val) = ioFMT(fecr01,GSFL01, true, idx)
    case key01

      of TKey.F3:
        break


      # for field Process Combo display and selection
      of TKey.PROC :
        if isProcess(fecr01,Index(fecr01)):
          callQuery[getProcess(fecr01,Index(fecr01))](fecr01.field[Index(fecr01)])

      # In ioFMT processing retrieving values (subfile line) this done with TKey.Mouse
      of TKey.Mouse :
          setText(fecr01,P1[SINDEX]   ,val[0])
          setText(fecr01,P1[SNOM]     ,val[1])
          setText(fecr01,P1[SPRENOM]  ,val[2])
          setText(fecr01,P1[STEL]     ,val[3])

      # refresh flied
      of TKey.F5:
          clearAdr()
          setText(fecr01,P1[SINDEX]   ,"")
          setText(fecr01,P1[SNOM]     ,"")
          setText(fecr01,P1[SPRENOM]  ,"")
          setText(fecr01,P1[STEL]     ,"")

      # Forces the display with selection on the sql LIKE name
      of TKey.F7:
         setColumnSFL01()

      # Add record processing
      of TKey.F9:
        clearAdr()
        pkey = pFECR02(key01)
        if Adr.CID > 0 :
          setText(fecr01,P1[SINDEX]   ,$Adr.CID)
          setText(fecr01,P1[SNOM]     ,Adr.NOM)
          setText(fecr01,P1[SPRENOM]  ,Adr.PRENOM)
          setText(fecr01,P1[STEL]     ,Adr.TEL)
          setTextL(fecr01,P1L[Lgrid] ,"......")
          setColumnSFL01()

      # Update record processing
      of TKey.F10:
        if Adr.CID > 0 :
          discard readAdr(db,$fmt"SELECT * FROM FCONTACT WHERE CID = '{getText(fecr01,P1[SINDEX])}';")
          pkey = pFECR02(key01)
          setText(fecr01,P1[SINDEX]   ,$Adr.CID)
          setText(fecr01,P1[SNOM]     ,Adr.NOM)
          setText(fecr01,P1[SPRENOM]  ,Adr.PRENOM)
          setText(fecr01,P1[STEL]     ,Adr.TEL)
          setTextL(fecr01,P1L[Lgrid] ,"......")
          setColumnSFL01()

      # delete record processing
      of TKey.F23:
        if Adr.CID != 0 :
          discard readAdr(db,$fmt"SELECT * FROM FCONTACT WHERE CID = '{Adr.CID}';")
          pkey = pFECR02(key01)
          setColumnSFL01()
      else : discard

    # exit programme
    if TKey.F3 == key01 or TKey.F3 == pkey :
      closeTerm()
      return



main()



proc pFECR02(key : TKey) : (TKey) =
  dscfecr02()

  case key
    of Tkey.F9 :
      setActif(fecr02.button[P2B[B2F9]],true)   # add enrg

    of Tkey.F10 :
      setActif(fecr02.button[P2B[B2F10]],true)    # upd enrg


    of Tkey.F23 :
      setActif(fecr02.button[P2B[B2F23]],true)  # dlt enrg
    else: discard

  setText(fecr02,P2[CID],       $Adr.CID)
  setText(fecr02,P2[NOM],       Adr.NOM)
  setText(fecr02,P2[PRENOM],    Adr.PRENOM)
  setText(fecr02,P2[CIVILITE],  Adr.CIVILITE)
  setText(fecr02,P2[RELATION],  Adr.RELATION)
  setText(fecr02,P2[TEL],       Adr.TEL)
  setText(fecr02,P2[TELBIS],    Adr.TELBIS)
  setText(fecr02,P2[MAIL],      Adr.MAIL)
  setText(fecr02,P2[DJN],       Adr.DJN)
  setText(fecr02,P2[ADR1],      Adr.ADR1)
  setText(fecr02,P2[ADR2],      Adr.ADR2)
  setText(fecr02,P2[ADR2],      Adr.ADR2)
  setText(fecr02,P2[CPAYS],     Adr.CPAYS)
  setText(fecr02,P2[LPAYS],     Adr.LPAYS)
  setText(fecr02,P2[CPTT],      Adr.CPTT)
  setText(fecr02,P2[VILLE],     Adr.VILLE)
  setText(fecr02,P2[NOTE1],     Adr.NOTE1)
  setText(fecr02,P2[NOTE2],     Adr.NOTE2)
  setText(fecr02,P2[NOTE3],     Adr.NOTE3)
  setText(fecr02,P2[CPROF],     Adr.CPROF)
  setText(fecr02,P2[SOCIETE],   Adr.SOCIETE)
  setText(fecr02,P2[TELCIE],    Adr.TELCIE)


  #Exemple ------

  while true:
    poster(fecr02)
    var key02 = ioPanel(fecr02)
    case key02
      of TKey.PROC :  # for field Process
        if isProcess(fecr02,Index(fecr02)):
          callQuery[getProcess(fecr02,Index(fecr02))](fecr02.field[Index(fecr02)])

      of TKey.F3:
        clearText(fecr02)


      of TKey.F4:

        discard execCmdEx("./Tprofession")


      of TKey.F9:
        Adr.CID         = 0
        Adr.NOM         = getText(fecr02,P2[NOM])
        Adr.PRENOM      = getText(fecr02,P2[PRENOM])
        Adr.CIVILITE    = getText(fecr02,P2[CIVILITE])
        Adr.RELATION    = getText(fecr02,P2[RELATION])
        Adr.TEL         = getText(fecr02,P2[TEL])
        Adr.TELBIS      = getText(fecr02,P2[TELBIS])
        Adr.MAIL        = getText(fecr02,P2[MAIL])
        Adr.DJN         = getText(fecr02,P2[DJN])
        Adr.ADR1        = getText(fecr02,P2[ADR1])
        Adr.ADR2        = getText(fecr02,P2[ADR2])
        Adr.ADR3        = getText(fecr02,P2[ADR3])
        Adr.CPTT        = getText(fecr02,P2[CPTT])
        Adr.VILLE       = getText(fecr02,P2[VILLE])
        Adr.CPAYS       = getText(fecr02,P2[CPAYS])
        Adr.LPAYS       = getText(fecr02,P2[LPAYS])
        Adr.NOTE1       = getText(fecr02,P2[NOTE1])
        Adr.NOTE2       = getText(fecr02,P2[NOTE2])
        Adr.NOTE3       = getText(fecr02,P2[NOTE3])
        Adr.CPROF       = getText(fecr02,P2[CPROF])
        Adr.SOCIETE     = getText(fecr02,P2[SOCIETE])
        Adr.TELCIE      = getText(fecr02,P2[TELCIE])
        db.exec(sql"BEGIN")
        insertAdr(db)
        db.exec(sql"COMMIT")
        clearText(fecr02)


      of TKey.F10:
        Adr.CID    = parseInt(getText(fecr02,P2[CID]))
        Adr.NOM         = getText(fecr02,P2[NOM])
        Adr.PRENOM      = getText(fecr02,P2[PRENOM])
        Adr.CIVILITE    = getText(fecr02,P2[CIVILITE])
        Adr.RELATION    = getText(fecr02,P2[RELATION])
        Adr.TEL         = getText(fecr02,P2[TEL])
        Adr.TELBIS      = getText(fecr02,P2[TELBIS])
        Adr.MAIL        = getText(fecr02,P2[MAIL])
        Adr.DJN         = getText(fecr02,P2[DJN])
        Adr.ADR1        = getText(fecr02,P2[ADR1])
        Adr.ADR2        = getText(fecr02,P2[ADR2])
        Adr.ADR3        = getText(fecr02,P2[ADR3])
        Adr.CPTT        = getText(fecr02,P2[CPTT])
        Adr.VILLE       = getText(fecr02,P2[VILLE])
        Adr.CPAYS       = getText(fecr02,P2[CPAYS])
        Adr.LPAYS       = getText(fecr02,P2[LPAYS])
        Adr.NOTE1       = getText(fecr02,P2[NOTE1])
        Adr.NOTE2       = getText(fecr02,P2[NOTE2])
        Adr.NOTE3       = getText(fecr02,P2[NOTE3])
        Adr.CPROF       = getText(fecr02,P2[CPROF])
        Adr.SOCIETE     = getText(fecr02,P2[SOCIETE])
        Adr.TELCIE      = getText(fecr02,P2[TELCIE])
        db.exec(sql"BEGIN")
        updateAdr(db)
        db.exec(sql"COMMIT")
        clearText(fecr02)


      of TKey.F23:
        Adr.CID    = parseInt(getText(fecr02,P2[CID]))
        db.exec(sql"BEGIN")
        deleteAdr(db)
        db.exec(sql"COMMIT")
        clearText(fecr02)


      of TKey.F12:
        clearText(fecr02)

      else: discard

    if TKey.F4 != key02 :  return key02