#------------------------------------------------
# traitement field
#------------------------------------------------

type

  FIELD_Field {.pure.}= enum
    Fname,
    Fposx,
    Fposy,
    Freftyp,
    Fwidth,
    Fscal,
    Fempty,
    Ferrmsg,
    Fhelp,
    Fedtcar,
    Fprotect,
    Fprocess


  Vfield = ref object
    name : string
    posx : int
    posy : int
    reftyp : REFTYP
    width : Natural
    scal : Natural
    empty :bool
    errmsg : string
    help : string
    edtcar : string
    nbrcar: Natural
    protect: bool
    text : string
    process : string

const F_F1: array[FIELD_Field, int] = [0,1,2,3,4,5,6,7,8,9,10,11]

let fldF = new(Vfield)
var pnFa :PANEL = newPanel("pnFx",1,1,14,70,@[defButton(TKey.F9,"F9 Enrg.",true),defButton(TKey.F12,"F12 return")],line1,"FIELD")


pnFa.label.add(defLabel($Fname, 2, 2, "Name.....:"))
pnFa.field.add(defString($Fname, 2, 2 + len(pnFa.label[F_F1[Fname,]].text), ALPHA_NUMERIC ,
                10, "", FILL, "Value Obligatoire [A-z0-9]","Name Label","^[A-z]{1,1}([A-z0-9]{1,9})$"))

pnFa.label.add(defLabel($Fposx, 3, 2, "PosX.....:"))
pnFa.field.add(defNumeric($Fposx , 3, 2 + len(pnFa.label[F_F1[Fposx]].text), DIGIT ,
                2, 0, "", FILL, "",""))
setProtect(pnFa.field[F_F1[Fposx]],true)

pnFa.label.add(defLabel($Fposy, 3, 20, "PosY.....:"))
pnFa.field.add(defNumeric($Fposy , 3, 20 + len(pnFa.label[F_F1[Fposy]].text), DIGIT ,
                3, 0, "", FILL, "" ,""))
setProtect(pnFa.field[F_F1[Fposy]],true)


pnFa.label.add(defLabel($Freftyp, 4, 2, "Ref.Type.:"))
pnFa.field.add(defString($Freftyp , 4, 2 + len(pnFa.label[F_F1[Freftyp]].text), FPROC,
                19,"", FILL, "" ,""))
setProcess(pnFa.field[F_F1[Freftyp]],"callRefTyp")

pnFa.label.add(defLabel($Fwidth, 4, 35, "With.:"))
pnFa.field.add(defNumeric($Fwidth , 4, 35 + len(pnFa.label[F_F1[Fwidth]].text), DIGIT ,
                3, 0, "", FILL, "Obliatoire",">0"))


pnFa.label.add(defLabel($Fscal, 4, 45,  "Scal.:"))
pnFa.field.add(defNumeric($Fscal , 4, 45 + len(pnFa.label[F_F1[Fscal]].text), DIGIT ,
                2, 0, "", FILL, "Obliatoire" ,">0"))

pnFa.label.add(defLabel($Fempty, 4, 55, "Empty....:"))
pnFa.field.add(defSwitch($Fempty , 4, 55 + len(pnFa.label[F_F1[Fempty]].text), SWITCH ,
                true, EMPTY, "Not Obligatoire" ,"EMPTY True or False"))

pnFa.label.add(defLabel($Ferrmsg, 6, 2, "Error.msg.:"))
pnFa.field.add(defString($Ferrmsg , 6, 2 + len(pnFa.label[F_F1[Ferrmsg]].text) , TEXT_FREE ,
                50, "", EMPTY, "",""))

pnFa.label.add(defLabel($Fhelp, 8, 2, "Help......:"))
pnFa.field.add(defString($Fhelp , 8, 2 + len(pnFa.label[F_F1[Fhelp]].text) , TEXT_FREE ,
                50, "", EMPTY, "",""))

pnFa.label.add(defLabel($Fedtcar, 10, 2, "Edt-Char..:"))
pnFa.field.add(defString($Fedtcar , 10, 2 + len(pnFa.label[F_F1[Fedtcar]].text), TEXT_FREE ,
                1, "", EMPTY, "" ,""))

pnFa.label.add(defLabel($Fprotect, 10, 40, "Protect..:"))
pnFa.field.add(defSwitch($Fprotect , 10, 40 + len(pnFa.label[F_F1[Fprotect]].text), SWITCH ,
                false, EMPTY, "" ,""))

pnFa.label.add(defLabel($Fprocess, 11, 40, "Process..:"))
pnFa.field.add(defString($Fprocess , 11, 40 + len(pnFa.label[F_F1[Fprocess]].text), ALPHA_NUMERIC ,
  20, "", FILL, "Value Obligatoire [A-z0-9]","Name Process","^[A-z]{1,1}([A-z0-9]{1,19})$"))







#------------------------------------------------
# write field

# gotoXY(30,1); echo "l564 ", C ," len >",len(e_TEXT), " text ", v_TEXT , "X,Y>",X,",",Y," SY>",SY ; let l564 = getFunc


proc ioField( pnlSpc :var PANEL): TKey =                       # IO Format
  if not isActif(pnlSpc) : return TKey.None
  offMouse()
  var CountField =  Index(pnlSpc)
  var fld_key:TKey = TKey.Enter
  var reftyp : REFTYP = TEXT_FULL

  proc panelPrint(pnlSpc :var PANEL) =
    pnlSpc.setText(F_F1[Fname], fldF.name)
    pnlSpc.setText(F_F1[Fposx], $fldF.posx)
    pnlSpc.setText(F_F1[Fposy], $fldF.posy)
    pnlSpc.setText(F_F1[Freftyp], $fldF.reftyp)

    setActif(pnFx.label[F_F1[Fprocess]],false)
    setProtect(pnFx.field[F_F1[Fprocess]],true)

    setActif(pnFx.label[F_F1[Fedtcar]],false)
    setProtect(pnFx.field[F_F1[Fedtcar]],true)

    setProtect(pnFx.field[F_F1[Fwidth]],false)
    setProtect(pnFx.field[F_F1[Fscal]],false)
    case fldF.reftyp
      of ALPHA, ALPHA_UPPER,ALPHA_NUMERIC,ALPHA_NUMERIC_UPPER,TEXT_FREE, TEXT_FULL, MAIL_ISO:
        fldF.scal = 0
        fldF.nbrcar = fldF.width
        fldF.edtcar = ""
        setProtect(pnFx.field[F_F1[Fscal]],true)

      of PASSWORD:
        fldF.scal = 0
        fldF.nbrcar = fldF.width
        fldF.edtcar = ""
        setProtect(pnFx.field[F_F1[Fscal]],true)


      of TELEPHONE:
        fldF.scal = 0
        fldF.nbrcar = fldF.width
        fldF.edtcar = ""
        setProtect(pnFx.field[F_F1[Fscal]],true)

      of FPROC, FCALL:
        fldF.scal = 0
        fldF.nbrcar = fldF.width
        setActif(pnFx.label[F_F1[Fprocess]],true)
        setProtect(pnFx.field[F_F1[Fprocess]],false)

      of DIGIT :
        fldF.scal = 0
        fldF.nbrcar = fldF.width
        setProtect(pnFx.field[F_F1[Fscal]],true)
        setActif(pnFx.label[F_F1[Fedtcar]],true)
        setProtect(pnFx.field[F_F1[Fedtcar]],false)

      of DIGIT_SIGNED :
        fldF.scal = 0
        fldF.nbrcar = fldF.width + 1
        setProtect(pnFx.field[F_F1[Fscal]],true)
        setActif(pnFx.label[F_F1[Fedtcar]],true)
        setProtect(pnFx.field[F_F1[Fedtcar]],false)

      of DECIMAL :
        fldF.nbrcar = fldF.width + fldF.scal + 1
        setActif(pnFx.label[F_F1[Fedtcar]],true)
        setProtect(pnFx.field[F_F1[Fedtcar]],false)

      of DECIMAL_SIGNED :
        fldF.scal = 0
        fldF.nbrcar = fldF.width + fldF.scal + 2
        setActif(pnFx.label[F_F1[Fedtcar]],true)
        setProtect(pnFx.field[F_F1[Fedtcar]],false)

      of DATE_ISO, DATE_FR, DATE_US :
        fldF.width = 10
        fldF.scal = 0
        fldF.nbrcar = fldF.width
        fldF.edtcar = ""
        setProtect(pnFx.field[F_F1[Fwidth]],true)
        setProtect(pnFx.field[F_F1[Fscal]],true)

      of YES_NO :
        fldF.width = 1
        fldF.scal = 0
        fldF.nbrcar = fldF.width
        fldF.edtcar = ""
        setProtect(pnFx.field[F_F1[Fwidth]],true)
        setProtect(pnFx.field[F_F1[Fscal]],true)

      of SWITCH :
        fldF.width = 1
        fldF.scal = 0
        fldF.nbrcar = fldF.width
        fldF.edtcar = ""
        setProtect(pnFx.field[F_F1[Fwidth]],true)
        setProtect(pnFx.field[F_F1[Fscal]],true)


    pnlSpc.setText(F_F1[Fwidth], $fldF.width)
    pnlSpc.setText(F_F1[Fscal], $fldF.scal)
    pnlSpc.setSwitch(F_F1[Fempty], fldF.empty)
    pnlSpc.setText(F_F1[Ferrmsg], fldF.errmsg)
    pnlSpc.setText(F_F1[Fhelp], fldF.help)
    pnlSpc.setText(F_F1[Fedtcar], fldF.edtcar)
    if fldF.protect :pnlSpc.setSwitch(F_F1[Fprotect],true)
    else :pnlSpc.setSwitch(F_F1[Fprotect],false)
    pnlSpc.setText(F_F1[Fprocess], fldF.process)
    clsPanel(pnlSpc)
    printPanel(pnlSpc)
    displayPanel(pnlSpc)

  var index = getIndex(pnlSpc,getName(pnlSpc,CountField))

  # check error
  for n in 0..len(pnlSpc.field) - 1:
    if  isError(pnlSpc.field[n]) :
      index = n
      CountField = n
      pnlSpc.index = n
      break

  # check if there are any free field
  func isFieldIOx(pnlSpc :var PANEL):Natural =
    var n : Natural = len(pnlSpc.field)
    var nfield: int = len(pnlSpc.field)

    for i in 0..nfield - 1 :
      if isProtect(pnlSpc.field[i]) or not isActif(pnlSpc.field[i]) : n -= 1
    return n
  #search there first available field
  func isFirstIOx(pnlSpc :var PANEL, idx : Natural):int =
    var i : Natural = idx
    while i < len(pnlSpc.field)-1  :
      if pnlSpc.field[i].isActif:
        if not isProtect(pnlSpc.field[i]) : break
      inc(i)
    return i
  #search there last available field
  func isPriorIOx(pnlSpc :var PANEL, idx : Natural):int =
    var i : int = idx
    while i >= 0 :
      if pnlSpc.field[i].isActif:
        if not isProtect(pnlSpc.field[i]) : break
      dec(i)
    if i < 0 : return 0
    return i

  func fieldNbr(pnlSpc :var PANEL) :int =
    var nbr = -1
    for n in 0..len(pnlSpc.field) - 1:
      if pnlSpc.field[n].isActif :
        if not  isProtect(pnlSpc.field[n]) :  nbr = n
    return nbr

  panelPrint(pnlSpc)
  while true :
    if fldf.reftyp != reftyp :
      panelPrint(pnlSpc)
      reftyp = fldf.reftyp

    #controls the boundary sequence of the field
    if CountField == len(pnlSpc.field)-1  and isFieldIOx(pnlSpc) > 0 :
      CountField = isPriorIOx(pnlSpc,len(pnlSpc.field)-1)
    if CountField == 0  and isFieldIOx(pnlSpc) > 0 :
      CountField = isFirstIOx(pnlSpc,0)

    gotoXY(fldF.posx,fldF.posy) ; writeStyled("?", {styleBright,styleBlink})
    fld_key = ioField(pnlSpc,pnlSpc.field[CountField])   # work input/output Field

    fldF.name = pnlSpc.getText(F_F1[Fname])
    fldF.posx = parseInt(pnlSpc.getText(F_F1[Fposx]))
    fldF.posy = parseInt(pnlSpc.getText(F_F1[Fposy]))
    fldF.reftyp = parseEnum[REFTYP](pnlSpc.getText(F_F1[Freftyp]))
    fldF.width = parseInt(pnlSpc.getText(F_F1[Fwidth]))
    fldF.scal  = parseInt(pnlSpc.getText(F_F1[Fscal]))
    fldF.empty = pnlSpc.getSwitch(F_F1[Fempty])
    fldF.errmsg = pnlSpc.getText(F_F1[Ferrmsg])
    fldF.help = pnlSpc.getText(F_F1[Fhelp])
    fldF.edtcar = pnlSpc.getText(F_F1[Fedtcar])
    if pnlSpc.getSwitch(F_F1[Fprotect]) : fldF.protect = true
    else :fldF.protect =false
    fldF.process = pnlSpc.getText(F_F1[Fprocess])




    if isPanelKey(pnlSpc,fld_key) or fld_key == TKey.PROC:                      # this key sav index field return main
      pnlSpc.index = getIndex(pnlSpc,getName(pnlSpc,CountField))
      for n in 0..len(pnlSpc.field) - 1 :
        setError(pnlSpc.field[n],false)
      return fld_key


    if isFieldIOx(pnlSpc) == 0 :                        # this full protect only work Key active
      fld_key = getFunc()
    else :
      case fld_Key
        of TKey.Escape:                                 # we replay & resume the basic value
          continue
        of TKey.Enter:
          inc(CountField)
          if CountField > fieldNbr(pnlSpc) : CountField = 0
          if isProtect(pnlSpc.field[CountField]):
            CountField = isFirstIOx(pnlSpc,CountField)

        of TKey.Up :
          if CountField > 0 : dec(CountField)
          elif CountField == 0 :  CountField = len(pnlSpc.field)-1
          if isProtect(pnlSpc.field[CountField]) :
            CountField = isPriorIOx(pnlSpc,CountField )

        of TKey.Down:
          inc(CountField)
          if CountField > fieldNbr(pnlSpc) : CountField = 0
          if isProtect(pnlSpc.field[CountField]) :
            CountField = isFirstIOx(pnlSpc,CountField)

        else :discard





proc pField():bool=

  onCursor()
  if fldF.posx < 15 :
    pnFx.posx = terminalHeight()-15
  else :
    pnFx.posx = 1
  while true:
    let keyc = ioField(pnFx)
    case keyc
      of TKey.F12:
        getCursor(X , Y)
        gotoXY(terminalHeight(),terminalWidth()-20);  stdout.write "      "
        gotoXY(terminalHeight(),terminalWidth()-20);  stdout.write "Return"
        gotoXY(X , Y)
        onMouse()
        return false

      of TKey.F9:
        onMouse()
        if isValide(pnFx) : return true

      of TKey.PROC:
          if isProcess(pnFx,Index(pnFx)) :
            callQuery[getProcess(pnFx,Index(pnFx))] (pnFx.field[Index(pnFx)])
            fldF.reftyp = parseEnum[REFTYP](pnFx.getText(F_F1[Freftyp]))
            setTerminal()
            printPanel(base[PanelWork])
      else : discard







#------------------------------------------------------------------
# rename sequence field

proc orderField()=
  setTerminal()
  printPanel(orderZ)
  offMouse()

  Zgrid  = newGrid("GRID01",2,2,30)
  Zdup   = newGrid("GRID02",2,70,30)
  var g_id      = defCell("ID",3,DIGIT)
  var g_name    = defCell("Name",10,ALPHA,cellYellow)
  var g_posx    = defCell("PosX",4,DIGIT)
  var g_posy    = defCell("PosY",4,DIGIT)
  var g_type    = defCell("Type",19,ALPHA)
  var g_numIDx : int = -1
  var g_numID = - 1

  setHeaders(Zgrid, @[g_id, g_name, g_posx, g_posy, g_type])
  setHeaders(Zdup,  @[g_id, g_name, g_posx, g_posy, g_type])
  printGridHeader(Zdup)
  for n in 0..len(detail.field)-1:
    addRows(Zgrid, @[setID(g_numID), getName(detail,n), $getPosx(detail,n), $getPosy(detail,n), $getRefType(detail,n), $getWidth(detail,n), $getScal(detail,n), $getEmpty(detail,n), getErrmsg(detail,n), getHelp(detail,n), getEdtcar(detail,n), $getProtect(detail,n), getProcess(detail,n)])
  while true :
    let (keys, val) = ioGrid(Zgrid)
    if keys == TKey.Enter :
      addRows(Zdup, @[setID(g_numIDx), val[1], val[2], val[3],val[4],val[5],val[6],val[7],val[8],val[9],val[10],val[11], val[12] ])

      printGridRows(Zdup)
      dltRows(Zgrid,getIndexG(Zgrid,val[0]))
    if countRows(Zgrid) == 0 and countRows(Zdup) > 0 :
        base[PanelWork].field = newSeq[FIELD]()
        detail.field = newSeq[FIELD]()
        for n in 0..countRows(Zdup)-1:
          fldF.name   = getrowName(Zdup,n)
          fldF.posx   = getrowPosx(Zdup,n)
          fldF.posy   = getrowPosy(Zdup,n)
          fldF.reftyp = getrowType(Zdup,n)
          fldF.width  = getrowWidth(Zdup,n)
          fldF.scal   = getrowScal(Zdup,n)
          fldF.empty  = getrowEmpty(Zdup,n)
          fldF.errmsg = getrowErrmsg(Zdup,n)
          fldF.help   = getrowHelp(Zdup,n)
          fldF.edtcar = getrowCar(Zdup,n)
          if $isrowProtect(Zdup,n) == "true" : fldF.protect = true
          else : fldF.protect = false
          fldF.process   = getrowProcess(Zdup,n)
          v_TEXT = ""

          case fldF.reftyp
            of ALPHA, ALPHA_UPPER, ALPHA_NUMERIC, ALPHA_NUMERIC_UPPER, TEXT_FREE, TEXT_FULL, MAIL_ISO, YES_NO, FPROC, FCALL:
              if fldF.protect  :
                  for n in 1..fldF.width: v_TEXT = v_TEXT & "a"
              detail.field.add(defString(fldF.name, fldF.posx, fldF.posy,fldF.reftyp,fldF.width, v_TEXT,fldF.empty,fldF.errmsg,fldF.help))
              if fldF.edtcar != ""  : setEdtCar(detail.field[getIndex(detail,fldF.name)],fldF.edtcar)
              if fldF.protect       : setProtect(detail,getIndex(detail,fldF.name),true)
              else :setProtect(detail,getIndex(detail,fldF.name),false)
              if fldF.process != "" : setProcess(detail.field[getIndex(detail,fldF.name)],fldF.process)

              base[PanelWork].field.add(defString(fldF.name, fldF.posx, fldF.posy,fldF.reftyp,fldF.width, v_TEXT,fldF.empty,fldF.errmsg,fldF.help))
              if fldF.edtcar != ""  : setEdtCar(base[PanelWork].field[getIndex(base[PanelWork],fldF.name)],fldF.edtcar)
              if fldF.protect       : setProtect(base[PanelWork],getIndex(base[PanelWork],fldF.name),true)
              else : setProtect(base[PanelWork],getIndex(base[PanelWork],fldF.name),false)
              if fldF.process != "" : setProcess(base[PanelWork].field[getIndex(base[PanelWork],fldF.name)],fldF.process)

            of PASSWORD :
              for n in 1..fldF.width:
                v_TEXT = v_TEXT & "*"
              detail.field.add(defString(fldF.name, fldF.posx, fldF.posy,fldF.reftyp,fldF.width, v_TEXT,fldF.empty,fldF.errmsg,fldF.help))
              if fldF.protect : setProtect(detail,getIndex(detail,fldF.name),true)
              else : setProtect(detail,getIndex(detail,fldF.name),false)

              base[PanelWork].field.add(defString(fldF.name, fldF.posx, fldF.posy,fldF.reftyp,fldF.width, v_TEXT,fldF.empty,fldF.errmsg,fldF.help))
              if fldF.protect : setProtect(base[PanelWork],getIndex(base[PanelWork],fldF.name),true)
              else : setProtect(base[PanelWork],getIndex(base[PanelWork],fldF.name),false)

            of DIGIT, DIGIT_SIGNED, DECIMAL, DECIMAL_SIGNED :
              case fldF.reftyp:
                of DIGIT :
                  for x in 1..fldF.width:
                      v_TEXT = v_TEXT & "0"
                of DIGIT_SIGNED :
                  v_TEXT = "+"
                  for x in 1..fldF.width:
                      v_TEXT = v_TEXT & "0"
                of DECIMAL :
                  for x in 1..fldF.width:
                      v_TEXT = v_TEXT & $x
                  v_TEXT = v_TEXT & "."
                  for x in 1..fldF.scal:
                      v_TEXT = v_TEXT & $x
                of DECIMAL_SIGNED :
                  v_TEXT = "+"
                  for x in 1..fldF.width:
                      v_TEXT = v_TEXT & $x
                  v_TEXT = v_TEXT & "."
                  for x in 1..fldF.scal:
                      v_TEXT = v_TEXT & $x
                else : discard

              detail.field.add(defNumeric(fldF.name, fldF.posx, fldF.posy,fldF.reftyp,fldF.width,fldF.scal, v_TEXT,fldF.empty,fldF.errmsg,fldF.help))
              if fldF.edtcar != "" : setEdtCar(detail.field[getIndex(detail,fldF.name)],fldF.edtcar)
              if fldF.protect : setProtect(detail,getIndex(detail,fldF.name),true)
              else : setProtect(detail,getIndex(detail,fldF.name),false)

              base[PanelWork].field.add(defNumeric(fldF.name, fldF.posx, fldF.posy,fldF.reftyp,fldF.width,fldF.scal, v_TEXT,fldF.empty,fldF.errmsg,fldF.help))
              if fldF.edtcar != "" : setEdtCar(base[PanelWork].field[getIndex(base[PanelWork],fldF.name)],fldF.edtcar)
              if fldF.protect : setProtect(base[PanelWork],getIndex(base[PanelWork],fldF.name),false)
              else: setProtect(base[PanelWork],getIndex(base[PanelWork],fldF.name),false)

            of DATE_ISO, DATE_FR, DATE_US :
              case fldF.reftyp
                of DATE_ISO : v_TEXT = "2020-05-18"
                of DATE_FR : v_TEXT = "18/05/2020"
                of DATE_US : v_TEXT = "05/18/2020"
                else : discard
              detail.field.add(defDate(fldF.name, fldF.posx, fldF.posy,fldF.reftyp, v_TEXT,fldF.empty,fldF.errmsg,fldF.help))
              if fldF.protect : setProtect(detail,getIndex(detail,fldF.name),true)
              else : setProtect(detail,getIndex(detail,fldF.name),false)

              base[PanelWork].field.add(defDate(fldF.name, fldF.posx, fldF.posy,fldF.reftyp, v_TEXT,fldF.empty,fldF.errmsg,fldF.help))
              if fldF.protect : setProtect(base[PanelWork],getIndex(base[PanelWork],fldF.name),true)
              else : setProtect(base[PanelWork],getIndex(base[PanelWork],fldF.name),false)

            of TELEPHONE :
              v_TEXT = "(00)0-9aZ"
              detail.field.add(defTelephone(fldF.name, fldF.posx, fldF.posy,fldF.reftyp,fldF.width, v_TEXT,fldF.empty,fldF.errmsg,fldF.help))
              if fldF.protect : setProtect(detail,getIndex(detail,fldF.name),true)
              else : setProtect(detail,getIndex(detail,fldF.name),false)

              base[PanelWork].field.add(defTelephone(fldF.name, fldF.posx, fldF.posy,fldF.reftyp,fldF.width, v_TEXT,fldF.empty,fldF.errmsg,fldF.help))
              if fldF.protect : setProtect(base[PanelWork],getIndex(base[PanelWork],fldF.name),true)
              else : setProtect(base[PanelWork],getIndex(base[PanelWork],fldF.name),false)

            of SWITCH :
              detail.field.add(defSwitch(fldF.name, fldF.posx, fldF.posy,fldF.reftyp, fldF.protect,fldF.empty,fldF.errmsg,fldF.help))
              if fldF.protect : setProtect(detail,getIndex(detail,fldF.name),true)
              else : setProtect(detail,getIndex(detail,fldF.name),false)

              base[PanelWork].field.add(defSwitch(fldF.name, fldF.posx, fldF.posy,fldF.reftyp, fldF.protect,fldF.empty,fldF.errmsg,fldF.help))
              if fldF.protect : setProtect(base[PanelWork],getIndex(base[PanelWork],fldF.name),true)
              else :setProtect(base[PanelWork],getIndex(base[PanelWork],fldF.name),false)

        Zgrid  = newGrid("GRID01",2,2,30)
        Zdup   = newGrid("GRID02",2,70,30)
        setHeaders(Zgrid, @[g_id, g_name, g_posx, g_posy, g_type])
        setHeaders(Zdup,  @[g_id, g_name, g_posx, g_posy, g_type])
        g_numID = - 1
        g_numIDx = - 1
        for n in 0..len(detail.field)-1:
          addRows(Zgrid, @[setID(g_numID), getName(detail,n), $getPosx(detail,n), $getPosy(detail,n), $getRefType(detail,n), $getWidth(detail,n), $getScal(detail,n), $getEmpty(detail,n), getErrmsg(detail,n), getHelp(detail,n), getEdtcar(detail,n), $getProtect(detail,n), getProcess(detail,n)])
        printGridHeader(Zdup)

    if keys == TKey.Escape : return


#------------------------------------------------------
# remove field

proc rmvField()=
  setTerminal()
  printPanel(orderZ)
  offMouse()

  Zgrid  = newGrid("GRID01",2,2,30)
  var g_id      = defCell("ID",3,DIGIT)
  var g_name    = defCell("Name",10,ALPHA,cellYellow)
  var g_posx    = defCell("PosX",4,DIGIT)
  var g_posy    = defCell("PosY",4,DIGIT) ;
  var g_type    = defCell("Type",19,ALPHA)
  var g_numID = - 1
  setHeaders(Zgrid, @[g_id, g_name, g_posx, g_posy, g_type])
  for n in 0..len(base[PanelWork].field)-1:
        addRows(Zgrid, @[setID(g_numID), getName(detail,n), $getPosx(detail,n), $getPosy(detail,n), $getRefType(detail,n)])


  while true :
    let (keys, val) = ioGrid(Zgrid)
    if keys == TKey.Escape : return
    if keys == TKey.Enter :
      for n in 0..len(base[PanelWork].field) :
        if base[PanelWork].field[n].name == getrowName(Zgrid,getIndexG(Zgrid,val[0])):
          base[PanelWork].field.delete(n)
          break
      for n in 0..len(detail.label) :
        if detail.field[n].name == getrowName(Zgrid,getIndexG(Zgrid,val[0])):
          detail.field.delete(n)
          dltRows(Zgrid,getIndexG(Zgrid,val[0]))
          break



proc fieldDef( fldx:int) =
  var fx = fldx
  SX = X
  SY = Y
  offMouse()
  offCursor()
  e_TEXT = newSeq[Rune]()
  setTerminal()
  printPanel(detail)
  gotoXY(terminalHeight(),terminalWidth()-20); stdout.write "      "
  gotoXY(terminalHeight(),terminalWidth()-20); stdout.write "Field "
  pnFx = pnFa
  gotoXY(minX,minY)
  pnFx.index = 0
  v_TEXT=""

  if fx == 999 :
    fldF.name = ""
    fldF.posx = SX
    fldF.posy = SY
    fldF.text = ""
    fldF.reftyp = TEXT_FREE
    fldF.width = 0
    fldF.scal = 0
    fldF.empty = EMPTY
    fldF.errmsg = ""
    fldF.help = ""
    fldF.edtcar = ""
    fldF.nbrcar = 0
    fldF.protect =false
    fldF.process = ""
  else:
    dec(fx)
    fldF.name = getName(detail,fx)
    fldF.posx = getPosx(detail,fx)
    fldF.posy = getPosy(detail,fx)
    fldF.text = getText(detail,fx)
    fldF.reftyp = getRefType(detail,fx)
    fldF.width  = getWidth(detail,fx)
    fldF.scal   = getScal(detail,fx)
    fldF.empty  = getEmpty(detail,fx)
    fldF.errmsg = getErrmsg(detail,fx)
    fldF.help   = getHelp(detail,fx)
    fldF.edtcar = getEdtcar(detail,fx)
    fldF.protect = getProtect(detail,fx)
    fldF.process = getProcess(detail,fx)

  if pField() == true:

    fldF.posx = fldF.posx - base[PanelWork].posx + 1
    fldF.posy = fldF.posy - base[PanelWork].posy + 1
    ## add Field
    case fldF.reftyp
      of ALPHA, ALPHA_UPPER, ALPHA_NUMERIC, ALPHA_NUMERIC_UPPER, TEXT_FREE, TEXT_FULL, YES_NO, FPROC, FCALL :
        if fldF.protect  :
          for n in 1..fldF.width: v_TEXT = v_TEXT & "a"
        if fx == 999 :
          detail.field.add(defString(fldF.name, fldF.posx, fldF.posy,fldF.reftyp,fldF.width, v_TEXT,fldF.empty,fldF.errmsg,fldF.help))
        else :
          detail.field[fx] = defString(fldF.name, fldF.posx, fldF.posy,fldF.reftyp,fldF.width, v_TEXT,fldF.empty,fldF.errmsg,fldF.help)
        if fldF.protect      : setProtect(detail,getIndex(detail,fldF.name),true)
        else : setProtect(detail,getIndex(detail,fldF.name),false)
        if fldF.process != "" : setProcess(detail.field[getIndex(detail,fldF.name)],fldF.process)

        if fx == 999 :
          base[PanelWork].field.add(defString(fldF.name, fldF.posx, fldF.posy,fldF.reftyp,fldF.width, v_TEXT,fldF.empty,fldF.errmsg,fldF.help))
        else :
          base[PanelWork].field[fx] = defString(fldF.name, fldF.posx, fldF.posy,fldF.reftyp,fldF.width, v_TEXT,fldF.empty,fldF.errmsg,fldF.help)

        if fldF.protect      : setProtect(base[PanelWork],getIndex(base[PanelWork],fldF.name),true)
        else : setProtect(base[PanelWork],getIndex(base[PanelWork],fldF.name),false)
        if fldF.process != "" : setProcess(base[PanelWork].field[getIndex(base[PanelWork],fldF.name)],fldF.process)

      of MAIL_ISO :
        if fldF.protect  :
          for n in 1..fldF.width - 5: v_TEXT = v_TEXT & "a"
          v_TEXT = v_TEXT & "@gmail"
        if fx == 999 :
          detail.field.add(defMail(fldF.name, fldF.posx, fldF.posy,fldF.reftyp,fldF.width, v_TEXT,fldF.empty,fldF.errmsg,fldF.help))
        else :
          detail.field[fx] = defMail(fldF.name, fldF.posx, fldF.posy,fldF.reftyp,fldF.width, v_TEXT,fldF.empty,fldF.errmsg,fldF.help)
        if fldF.protect      : setProtect(detail,getIndex(detail,fldF.name),true)
        else : setProtect(detail,getIndex(detail,fldF.name),false)
        if fldF.process != "" : setProcess(detail.field[getIndex(detail,fldF.name)],fldF.process)

        if fx == 999 :
          base[PanelWork].field.add(defMail(fldF.name, fldF.posx, fldF.posy,fldF.reftyp,fldF.width, v_TEXT,fldF.empty,fldF.errmsg,fldF.help))
        else :
          base[PanelWork].field[fx] = defMail(fldF.name, fldF.posx, fldF.posy,fldF.reftyp,fldF.width, v_TEXT,fldF.empty,fldF.errmsg,fldF.help)
        if fldF.protect      : setProtect(base[PanelWork],getIndex(base[PanelWork],fldF.name),true)
        else : setProtect(base[PanelWork],getIndex(base[PanelWork],fldF.name),false)
        if fldF.process != "" : setProcess(base[PanelWork].field[getIndex(base[PanelWork],fldF.name)],fldF.process)


      of PASSWORD :
        for n in 1..fldF.width:
          v_TEXT = v_TEXT & "*"
        if fx == 999 :
          detail.field.add(defString(fldF.name, fldF.posx, fldF.posy,fldF.reftyp,fldF.width, v_TEXT,fldF.empty,fldF.errmsg,fldF.help))
        else :
          detail.field[fx] = defString(fldF.name, fldF.posx, fldF.posy,fldF.reftyp,fldF.width, v_TEXT,fldF.empty,fldF.errmsg,fldF.help)
        if fldF.protect  : setProtect(detail,getIndex(detail,fldF.name),true)
        else : setProtect(detail,getIndex(detail,fldF.name),false)
        if fx == 999 :
          base[PanelWork].field.add(defString(fldF.name, fldF.posx, fldF.posy,fldF.reftyp,fldF.width, v_TEXT,fldF.empty,fldF.errmsg,fldF.help))
        else :
          base[PanelWork].field[fx] = defString(fldF.name, fldF.posx, fldF.posy,fldF.reftyp,fldF.width, v_TEXT,fldF.empty,fldF.errmsg,fldF.help)
        if fldF.protect      : setProtect(base[PanelWork],getIndex(base[PanelWork],fldF.name),true)
        else : setProtect(base[PanelWork],getIndex(base[PanelWork],fldF.name),false)

      of DIGIT, DIGIT_SIGNED, DECIMAL, DECIMAL_SIGNED :
        case fldF.reftyp:
          of DIGIT :
            for n in 1..fldF.width:
                v_TEXT = v_TEXT & $n
          of DIGIT_SIGNED :
            v_TEXT = "+"
            for n in 1..fldF.width:
                v_TEXT = v_TEXT & $n
          of DECIMAL :
            for n in 1..fldF.width:
                v_TEXT = v_TEXT & $n
            v_TEXT = v_TEXT & "."
            for n in 1..fldF.scal:
                v_TEXT = v_TEXT & $n
          of DECIMAL_SIGNED :
            v_TEXT = "+"
            for n in 1..fldF.width:
                v_TEXT = v_TEXT & $n
            v_TEXT = v_TEXT & "."
            for n in 1..fldF.scal:
                v_TEXT = v_TEXT & $n
          else : discard

        if fx == 999 :
          detail.field.add(defNumeric(fldF.name, fldF.posx, fldF.posy,fldF.reftyp,fldF.width,fldF.scal, v_TEXT,fldF.empty,fldF.errmsg,fldF.help))
        else :
          detail.field[fx] = defNumeric(fldF.name, fldF.posx, fldF.posy,fldF.reftyp,fldF.width,fldF.scal, v_TEXT,fldF.empty,fldF.errmsg,fldF.help)
        if fldF.edtcar != "" : setEdtCar(detail.field[getIndex(detail,fldF.name)],fldF.edtcar)
        if fldF.protect      : setProtect(detail,getIndex(detail,fldF.name),true)
        else : setProtect(detail,getIndex(detail,fldF.name),false)
        if fx == 999 :
          base[PanelWork].field.add(defNumeric(fldF.name, fldF.posx, fldF.posy,fldF.reftyp,fldF.width,fldF.scal, v_TEXT,fldF.empty,fldF.errmsg,fldF.help))
        else :
          base[PanelWork].field[fx] = defNumeric(fldF.name, fldF.posx, fldF.posy,fldF.reftyp,fldF.width,fldF.scal, v_TEXT,fldF.empty,fldF.errmsg,fldF.help)
        if fldF.edtcar != "" : setEdtCar(base[PanelWork].field[getIndex(base[PanelWork],fldF.name)],fldF.edtcar)
        if fldF.protect      : setProtect(base[PanelWork],getIndex(base[PanelWork],fldF.name),true)
        else : setProtect(base[PanelWork],getIndex(base[PanelWork],fldF.name),false)

      of DATE_ISO, DATE_FR, DATE_US :
        case fldF.reftyp
          of DATE_ISO : v_TEXT = "2020-05-18"
          of DATE_FR : v_TEXT = "18/05/2020"
          of DATE_US : v_TEXT = "05/18/2020"
          else : discard
        if fx == 999 :
          detail.field.add(defDate(fldF.name, fldF.posx, fldF.posy,fldF.reftyp, v_TEXT,fldF.empty,fldF.errmsg,fldF.help))
        else :
          detail.field[fx] = defDate(fldF.name, fldF.posx, fldF.posy,fldF.reftyp, v_TEXT,fldF.empty,fldF.errmsg,fldF.help)
        if fldF.protect  : setProtect(detail,getIndex(detail,fldF.name),true)
        else : setProtect(detail,getIndex(detail,fldF.name),false)
        if fx == 999 :
          base[PanelWork].field.add(defDate(fldF.name, fldF.posx, fldF.posy,fldF.reftyp, v_TEXT,fldF.empty,fldF.errmsg,fldF.help))
        else :
          base[PanelWork].field[fx] = defDate(fldF.name, fldF.posx, fldF.posy,fldF.reftyp, v_TEXT,fldF.empty,fldF.errmsg,fldF.help)
        if fldF.protect      : setProtect(base[PanelWork],getIndex(base[PanelWork],fldF.name),true)
        else : setProtect(base[PanelWork],getIndex(base[PanelWork],fldF.name),false)

      of TELEPHONE :
        v_TEXT = "(000)0-9aZ"
        if fx == 999 :
          detail.field.add(defTelephone(fldF.name, fldF.posx, fldF.posy,fldF.reftyp,fldF.width, v_TEXT,fldF.empty,fldF.errmsg,fldF.help))
        else :
          detail.field[fx] = defTelephone(fldF.name, fldF.posx, fldF.posy,fldF.reftyp,fldF.width, v_TEXT,fldF.empty,fldF.errmsg,fldF.help)
        if fldF.edtcar != "" : setEdtCar(detail.field[getIndex(detail,fldF.name)],fldF.edtcar)
        if fldF.protect  : setProtect(detail,getIndex(detail,fldF.name),true)
        else : setProtect(detail,getIndex(detail,fldF.name),false)
        if fx == 999 :
          base[PanelWork].field.add(defTelephone(fldF.name, fldF.posx, fldF.posy,fldF.reftyp,fldF.width, v_TEXT,fldF.empty,fldF.errmsg,fldF.help))
        else :
          base[PanelWork].field[fx] = defTelephone(fldF.name, fldF.posx, fldF.posy,fldF.reftyp,fldF.width, v_TEXT,fldF.empty,fldF.errmsg,fldF.help)
        if fldF.edtcar != "" : setEdtCar(base[PanelWork].field[getIndex(base[PanelWork],fldF.name)],fldF.edtcar)
        if fldF.protect      : setProtect(base[PanelWork],getIndex(base[PanelWork],fldF.name),true)
        else : setProtect(base[PanelWork],getIndex(base[PanelWork],fldF.name),false)

      of SWITCH :
        if fx == 999 :
          detail.field.add(defSwitch(fldF.name, fldF.posx, fldF.posy,fldF.reftyp, true,fldF.empty,fldF.errmsg,fldF.help))
        else :
          detail.field[fx] = defSwitch(fldF.name, fldF.posx, fldF.posy,fldF.reftyp, true,fldF.empty,fldF.errmsg,fldF.help)
        if fldF.protect  : setProtect(detail,getIndex(detail,fldF.name),true)
        setProtect(detail,getIndex(detail,fldF.name),false)
        if fx == 999 :
          base[PanelWork].field.add(defSwitch(fldF.name, fldF.posx, fldF.posy,fldF.reftyp, true,fldF.empty,fldF.errmsg,fldF.help))
        else :
          base[PanelWork].field[fx] = defSwitch(fldF.name, fldF.posx, fldF.posy,fldF.reftyp, true,fldF.empty,fldF.errmsg,fldF.help)
        if fldF.protect      : setProtect(base[PanelWork],getIndex(base[PanelWork],fldF.name),true)
        else : setProtect(base[PanelWork],getIndex(base[PanelWork],fldF.name),false)
  setTerminal()
  clsPanel(detail)
  printPanel(detail)
  gotoXY(minX,minY)
  onMouse()