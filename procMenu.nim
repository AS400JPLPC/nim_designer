#------------------------------------------------
# traitement Menu
#------------------------------------------------
type
  MENU_Label {.pure.}= enum
    Lmnun,
    Lmnux,
    Lmnuy,
    Loption,
    Lcadre,
    Lvh


  MENU_Field {.pure.}= enum
    Fmnun,
    Fmnux,
    Fmnuy,
    Fmnu01,
    Fmnu02,
    Fmnu03,
    Fmnu04,
    Fmnu05,
    Fmnu06,
    Fmnu07,
    Fmnu08,
    Fmnu09,
    Fmnu10,
    Fmnu11,
    Fmnu12,
    Fmnu13,
    Fmnu14,
    Fmnu15,
    Fcadre,
    Fvh

  Vmenu = ref object
    name : string
    posx : int
    posy : int
    orientation :MNUVH
    item : seq[string]
    cadre: CADRE



const L_F2: array[MENU_Label, int] = [0,1,2,3,4,5]
const F_F2: array[MENU_Field, int] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]



var ZMENU : seq[Vmenu]





var pmenu = newPanel("pmenu",1,104,24,26,@[defButton(TKey.F9,"F9 Enrg.",true),defButton(TKey.F12,"Return"),defButton(TKey.CtrlD,""),defButton(TKey.altD,""),defButton(TKey.altS,""),defButton(TKey.CtrlV,"")],line1)


pmenu.label.add(defLabel($Lmnun, 2, 4, "Name.:"))
pmenu.field.add(defString($Fmnun, 2, 4 + len(pmenu.label[L_F2[Lmnun]].text) , ALPHA_NUMERIC,10,"", FILL, "", "Name Menu"))

pmenu.label.add(defLabel($Lmnux, 3, 4, "PosX.....:"))
pmenu.field.add(defNumeric($Fmnux , 3, 4 + len(pmenu.label[L_F2[Lmnux]].text), DIGIT ,
                2, 0, "", FILL, "",""))
setProtect(pmenu.field[F_F2[Fmnux]],true)

pmenu.label.add(defLabel($Lmnuy, 4, 4, "PosY.....:"))
pmenu.field.add(defNumeric($Fmnuy , 4, 4 + len(pmenu.label[L_F2[Lmnuy]].text), DIGIT ,
                3, 0, "", FILL, "" ,""))
setProtect(pmenu.field[F_F2[Fmnuy]],true)


pmenu.label.add(defLabel($Loption, 6, 4, "Option.............."))


# FIELD -> pmenu
pmenu.field.add(defString($Fmnu01, 5, 4, TEXT_FREE,20,"", FILL, "Obligatoire", "Option Menu"))
pmenu.field.add(defString($Fmnu02, 6, 4, TEXT_FREE,20,"", EMPTY, "", "Option menu"))
pmenu.field.add(defString($Fmnu03, 7, 4, TEXT_FREE,20,"", EMPTY, "", "Option menu"))
pmenu.field.add(defString($Fmnu04, 8, 4, TEXT_FREE,20,"", EMPTY, "", "Option menu"))
pmenu.field.add(defString($Fmnu05, 9, 4, TEXT_FREE,20,"", EMPTY, "", "Option Menu"))
pmenu.field.add(defString($Fmnu06, 10, 4, TEXT_FREE,20,"", EMPTY, "","Option Menu"))
pmenu.field.add(defString($Fmnu07, 11, 4, TEXT_FREE,20,"", EMPTY, "","Option Menu"))
pmenu.field.add(defString($Fmnu08, 12, 4, TEXT_FREE,20,"", EMPTY, "","Option Menu"))
pmenu.field.add(defString($Fmnu09, 13, 4, TEXT_FREE,20,"", EMPTY, "","Option Menu"))
pmenu.field.add(defString($Fmnu10, 14, 4, TEXT_FREE,20,"", EMPTY, "","Option Menu"))
pmenu.field.add(defString($Fmnu11, 15, 4, TEXT_FREE,20,"", EMPTY, "","Option Menu"))
pmenu.field.add(defString($Fmnu12, 16, 4, TEXT_FREE,20,"", EMPTY, "","Option Menu"))
pmenu.field.add(defString($Fmnu13, 17, 4, TEXT_FREE,20,"", EMPTY, "","Option Menu"))
pmenu.field.add(defString($Fmnu14, 18, 4, TEXT_FREE,20,"", EMPTY, "","Option Menu"))
pmenu.field.add(defString($Fmnu15, 19, 4, TEXT_FREE,20,"", EMPTY, "","Option Menu"))

pmenu.label.add(defLabel($Lcadre,20, 4, "Cadre....:"))
pmenu.field.add(defString($Fcadre ,20, 4 + len(pmenu.label[L_F2[Lcadre]].text), FPROC,
                5,"", FILL,"Cadre Obligatoire" ,"Type cadre"))
setProcess(pmenu.field[F_F2[Fcadre]],"callCadreMenu")

pmenu.label.add(defLabel($Lvh,21, 4, "Vert/Horz:"))
pmenu.field.add(defString($Fvh ,21, 4 + len(pmenu.label[L_F2[Lvh]].text), FPROC,
                10,"", FILL,"Orientaion Obligatoire" ,"Vert./Horz"))
setProcess(pmenu.field[F_F2[Fvh]],"callVH")

#===================================================
proc callMenu(mnuchx : seq[Vmenu]) : int =
  var g_pos : int = -1
  var Xcombo  = newGRID("COMBO1",1,1,20,sepStyle)
  var g_id    = defCell("ID",3,DIGIT)
  var g_name  = defCell("Name",10,TEXT_FREE)

  setHeaders(Xcombo, @[g_id, g_name])

  var g_numID = 0
  for i in 0..len(mnuchx )-1:
    addRows(Xcombo, @[setID(g_numID), mnuchx[i].name ])


  addRows(Xcombo, @["999", "Add", "Menu"])

  while true :
    let (keys, val) = ioGrid(Xcombo,g_pos)
    case keys
      of TKey.Enter :
        restorePanel(detail ,Xcombo)
        return parseInt($val[0])
      else: discard
#===================================================










#------------------------------------------------
# write Menu


proc writeMenu(mnux:int)=
  var fldM = new(Vmenu)
  SX = X
  SY = Y
  nTest = 0
  var nM: int  = mnux
  var nMi: int = 3

  offMouse()

  gotoXY(terminalHeight(),terminalWidth()-20); stdout.write "      "
  gotoXY(terminalHeight(),terminalWidth()-20); stdout.write "Menu  "


  pmenu.field[F_F2[Fmnun]].text = ""
  pmenu.field[F_F2[Fmnux]].text = $(SX - base[PanelWork].posx + 1 )
  pmenu.field[F_F2[Fmnuy]].text = $(SY - base[PanelWork].posy + 1 )
  pmenu.field[F_F2[Fmnu01]].text = ""
  pmenu.field[F_F2[Fmnu02]].text = ""
  pmenu.field[F_F2[Fmnu03]].text = ""
  pmenu.field[F_F2[Fmnu04]].text = ""
  pmenu.field[F_F2[Fmnu05]].text = ""
  pmenu.field[F_F2[Fmnu06]].text = ""
  pmenu.field[F_F2[Fmnu07]].text = ""
  pmenu.field[F_F2[Fmnu08]].text = ""
  pmenu.field[F_F2[Fmnu09]].text = ""
  pmenu.field[F_F2[Fmnu10]].text = ""
  pmenu.field[F_F2[Fmnu11]].text = ""
  pmenu.field[F_F2[Fmnu12]].text = ""
  pmenu.field[F_F2[Fmnu13]].text = ""
  pmenu.field[F_F2[Fmnu14]].text = ""
  pmenu.field[F_F2[Fmnu15]].text = ""
  pmenu.field[F_F2[Fcadre]].text = ""
  pmenu.field[F_F2[Fvh]].text = ""
  pmenu.index = 0
  if mnux < 999 :
    dec(nM)
    pmenu.field[F_F2[Fmnun]].text = ZMENU[nM].name
    pmenu.field[F_F2[Fmnux]].text = $(ZMENU[nM].posx)
    pmenu.field[F_F2[Fmnuy]].text = $(ZMENU[nM].posy)
    for i in 0.. len(ZMENU[nm].item)-1 :
      pmenu.field[nMi].text = ZMENU[nM].item[i]
      inc(nMi)

    SX = ZMENU[nM].posx
    SY = ZMENU[nM].posy
    pmenu.field[F_F2[Fcadre]].text = $ZMENU[nM].cadre
    pmenu.field[F_F2[Fvh]].text = $ZMENU[nM].orientation
    pmenu.index = 0

  if SX < 24 :
    pmenu.posx = terminalHeight()-30
  else :
    pmenu.posx = 1
  if SY < 30 :
    pmenu.posy = terminalWidth()-30
  else :
    pmenu.posy = 1


  printPanel(pmenu)

  while true:
    #[if  len(ZMENU) > 0 :
      Dspmnu = new(MENU)
      for n in 0..<len(ZMENU):
        Dspmnu = newMenu(ZMENU[n].name,ZMENU[n].posx,ZMENU[n].posy,ZMENU[n].orientation,ZMENU[n].item,ZMENU[n].cadre)
        dspMenuItem(detail,Dspmnu)
    ]#

    gotoXY(SX,SY) ; writeStyled("?", {styleBright,styleBlink})

    let  keyp = ioPanel(pmenu)

    case keyp
      of TKey.PROC:
        if isProcess(pmenu,Index(pmenu)) :
          callQuery[getProcess(pmenu,Index(pmenu))] (pmenu.field[Index(pmenu)])
        printPanel(detail)
        printPanel(pmenu)

      of TKey.F9:
        if isValide(pmenu) :
          if  nTest > 0 :
            if mnux == 999 :
              ZMENU.add(fldM)
            else :
              ZMENU[nM]= fldM
            break

      of TKey.F12:
        break

      # display menu
      of TKey.CtrlP:
        if  nTest > 0 :
          Dspmnu = new(MENU)
          Dspmnu = newMenu(fldM.name,fldM.posx,fldM.posy,fldM.orientation,fldM.item,fldM.cadre)
          dspMenuItem(detail,Dspmnu)
          discard ioMenu(detail,Dspmnu,0)
          restorePanel(detail,Dspmnu)

      # display full MENU
      of TKey.altP:
        if  len(ZMENU) > 0 :
          Dspmnu = new(MENU)
          for n in 0..<len(ZMENU):
            Dspmnu = newMenu(ZMENU[n].name,ZMENU[n].posx,ZMENU[n].posy,ZMENU[n].orientation,ZMENU[n].item,ZMENU[n].cadre)
            dspMenuItem(detail,Dspmnu)
        gotoXY(1,1)
        onMouse()

      of TKey.altS:
        offMouse()
        setTerminal()
        gotoXY(1,1)
        printPanel(detail)
        printPanel(pmenu)
        onCursor()
        onMouse()

      # validation des données
      of TKey.CtrlV:
        if isValide(pmenu)  :
          nTest = 1
          fldM.name = getText(pmenu,F_F2[Fmnun])
          fldM.name = fldM.name.strip(trailing = true)

          fldM.posx = parseInt(getText(pmenu,F_F2[Fmnux]))
          fldM.posy = parseInt(getText(pmenu,F_F2[Fmnuy]))

          fldM.item = newseq[string]()
          for i in countup(3, 17):
            v_TEXT = getText(pmenu,i)
            v_TEXT = v_TEXT.replace(re"#"," ")
            if v_TEXT != "" : fldM.item.add(v_TEXT)

          v_TEXT = getText(pmenu,F_F2[Fcadre])
          if v_TEXT == "line1" : fldM.cadre = CADRE.line1
          else : fldM.cadre = CADRE.line2

          v_TEXT = getText(pmenu,F_F2[Fvh])
          if v_TEXT == "vertical" : fldM.orientation = vertical
          else : fldM.orientation = horizontal

      else : discard


#------------------------------------------------------
# remove menu

proc rmvMenu()=
  setTerminal()
  printPanel(orderZ)
  offMouse()

  Zgrid  = newGrid("GRID01",2,2,30)
  var g_idm      = defCell("ID",3,DIGIT)
  var g_namem    = defCell("Name",10,ALPHA,cellYellow)
  var g_posxm    = defCell("PosX",4,DIGIT)
  var g_posym    = defCell("PosY",4,DIGIT)
  var g_linem    = defCell("line",5,ALPHA)
  var g_typem    = defCell("Type",10,ALPHA)
  setHeaders(Zgrid, @[g_idm, g_namem, g_posxm, g_posym, g_linem, g_typem,])
  var g_numID = - 1

  printGridHeader(Zgrid)
  for n in 0..len(ZMENU)-1:
    addRows(Zgrid, @[setID(g_numID), ZMENU[n].name, $ZMENU[n].posx, $ZMENU[n].posy, $ZMENU[n].cadre, $ZMENU[n].orientation])

  while true :
    let (keys, val) = ioGrid(Zgrid)
    if keys == TKey.Enter :
      for n in 0..len(ZMENU) - 1:
        if ZMENU[n].name == getrowName(Zgrid,getIndexG(Zgrid,val[0])):
          ZMENU.delete(n)
          break
      Zgrid  = newGrid("GRID01",2,2,30)
      setHeaders(Zgrid, @[g_idm, g_namem, g_posxm, g_posym, g_linem, g_typem,])

      printGridHeader(Zgrid)
      for n in 0..len(ZMENU)-1:
        addRows(Zgrid, @[setID(g_numID), ZMENU[n].name, $ZMENU[n].posx, $ZMENU[n].posy, $ZMENU[n].cadre, $ZMENU[n].orientation])

    if keys == TKey.Escape : return