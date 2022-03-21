#------------------------------------------------
# traitement field
#------------------------------------------------


type
  FIELD_Panel {.pure.}= enum
    Pname,
    Pposx,
    Pposy,
    Pheight,
    Pwidth,
    Pcadre,
    Ptitle,
    PxF1,
    PxF2,
    PxF3,
    PxF4,
    PxF5,
    PxF6,
    PxF7,
    PxF8,
    PxF9,
    PxF10,
    PxF11,
    PxF12,
    PxF13,
    PxF14,
    PxF15,
    PxF16,
    PxF17,
    PxF18,
    PxF19,
    PxF20,
    PxF21,
    PxF22,
    PxF23,
    PxF24,
    PcF1,
    PcF2,
    PcF3,
    PcF4,
    PcF5,
    PcF6,
    PcF7,
    PcF8,
    PcF9,
    PcF10,
    PcF11,
    PcF12,
    PcF13,
    PcF14,
    PcF15,
    PcF16,
    PcF17,
    PcF18,
    PcF19,
    PcF20,
    PcF21,
    PcF22,
    PcF23,
    PcF24

  Vpanel = ref object
    name : string
    posx : int
    posy : int
    height : int
    width : int
    cadrex : CADRE
    title : string
    f1  : bool
    f2  : bool
    f3  : bool
    f4  : bool
    f5  : bool
    f6  : bool
    f7  : bool
    f8  : bool
    f9  : bool
    f10  : bool
    f11  : bool
    f12  : bool
    f13  : bool
    f14  : bool
    f15  : bool
    f16  : bool
    f17  : bool
    f18  : bool
    f19  : bool
    f20  : bool
    f21  : bool
    f22  : bool
    f23  : bool
    f24  : bool
    chk1  : bool
    chk2  : bool
    chk3  : bool
    chk4  : bool
    chk5  : bool
    chk6  : bool
    chk7  : bool
    chk8  : bool
    chk9  : bool
    chk10  : bool
    chk11  : bool
    chk12  : bool
    chk13  : bool
    chk14  : bool
    chk15  : bool
    chk16  : bool
    chk17  : bool
    chk18  : bool
    chk19  : bool
    chk20  : bool
    chk21  : bool
    chk22  : bool
    chk23  : bool
    chk24  : bool
    button : seq[BUTTON]
    OK : bool

const P_L1: array[FIELD_Panel, int] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54]
const P_F1: array[FIELD_Panel, int] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54]


var pnl :PANEL = newPanel("panel",1,1,15,90,
  @[defButton(TKey.F9,"Init",true),defButton(TKey.F10,"Update",true),defButton(TKey.F12,"Return")],CADRE.line1)


pnl.label.add(defLabel($Pname, 2, 2, "Name.....:"))
pnl.field.add(defString($Pname, 2, 2 + len(pnl.label[P_L1[Pname,]].text), ALPHA_NUMERIC ,
                10, "", FILL, "Value Obligatoire [A-z]","Name Panel","^[A-z0-9]*$"))


pnl.label.add(defLabel($Pposx, 3, 2, "PosX.....:"))
pnl.field.add(defNumeric($Pposx , 3, 2 + len(pnl.label[P_L1[Pposx]].text), DIGIT ,
                2, 0, "", FILL, "Value 1.." & $terminalHeight(),"Position X"))


pnl.label.add(defLabel($Pposx, 4, 2, "PosY.....:"))
pnl.field.add(defNumeric($Pposx , 4, 2 + len(pnl.label[P_L1[Pposx]].text), DIGIT ,
                2, 0, "", FILL, "Value 1.." & $terminalWidth(),"Position Y"))


pnl.label.add(defLabel($Pheight, 5, 2, "Heights..:"))
pnl.field.add(defNumeric($Pheight , 5, 2 + len(pnl.label[P_L1[Pheight]].text), DIGIT ,
                2, 0, "Value Obligatoire", FILL, "Value 1.." & $terminalHeight(),"Hauteur"))


pnl.label.add(defLabel($Pwidth, 6, 2, "Width....:"))
pnl.field.add(defNumeric($Pwidth , 6, 2 + len(pnl.label[P_L1[Pwidth]].text), DIGIT ,
                3, 0, "Value Obligatoire", FILL, "Value 1.." & $terminalWidth(),"Largeur"))



pnl.label.add(defLabel($Pcadre, 7, 2, "Cadre....:"))
pnl.field.add(defString($Pcadre , 7, 2 + len(pnl.label[P_L1[Pcadre]].text), FPROC,
                5,"", FILL,"Cadre Obligatoire" ,"Type cadre"))
setProcess(pnl.field[P_F1[Pcadre]],"callCadre")


pnl.label.add(defLabel($Ptitle, 8, 2, "Title....:"))
pnl.field.add(defString($Ptitle , 8, 2 + len(pnl.label[P_L1[Ptitle]].text), TEXT_FULL ,
                15, "", EMPTY, "Not Obligatoire","Nom du Panel"))

pnl.label.add(defLabel($PxF1,  10, 2, "F1"))
pnl.label.add(defLabel($PxF2,  10, 5, "F2"))
pnl.label.add(defLabel($PxF3,  10, 8, "F3"))
pnl.label.add(defLabel($PxF4,  10, 11, "F4"))
pnl.label.add(defLabel($PxF5,  10, 14, "F5"))
pnl.label.add(defLabel($PxF6,  10, 17, "F6"))
pnl.label.add(defLabel($PxF7,  10, 20, "F7"))
pnl.label.add(defLabel($PxF8,  10, 23, "F8"))
pnl.label.add(defLabel($PxF9,  10, 26, "F9"))
pnl.label.add(defLabel($PxF10, 10, 30, "F10"))
pnl.label.add(defLabel($PxF11, 10, 34, "F11"))
pnl.label.add(defLabel($PxF12, 10, 38, "F12"))
pnl.label.add(defLabel($PxF13, 10, 42, "F13"))
pnl.label.add(defLabel($PxF14, 10, 46, "F14"))
pnl.label.add(defLabel($PxF15, 10, 50, "F15"))
pnl.label.add(defLabel($PxF16, 10, 54, "F16"))
pnl.label.add(defLabel($PxF17, 10, 58, "F17"))
pnl.label.add(defLabel($PxF18, 10, 62, "F18"))
pnl.label.add(defLabel($PxF19, 10, 66, "F19"))
pnl.label.add(defLabel($PxF20, 10, 70, "F20"))
pnl.label.add(defLabel($PxF21, 10, 74, "F21"))
pnl.label.add(defLabel($PxF22, 10, 78, "F22"))
pnl.label.add(defLabel($PxF23, 10, 82, "F23"))
pnl.label.add(defLabel($PxF24, 10, 86, "F24"))
pnl.label.add(defLabel($PcF1, 12, 2 , "Check Field"))

pnl.field.add(defSwitch($PxF1 , 11, 2  , SWITCH ,false,EMPTY, "Not Obligatoire","F1"))
pnl.field.add(defSwitch($PxF2 , 11, 5  , SWITCH ,false,EMPTY, "Not Obligatoire","F2"))
pnl.field.add(defSwitch($PxF3 , 11, 8  , SWITCH ,false,EMPTY, "Not Obligatoire","F3"))
pnl.field.add(defSwitch($PxF4 , 11, 11 , SWITCH ,false,EMPTY, "Not Obligatoire","F4"))
pnl.field.add(defSwitch($PxF5 , 11, 14 , SWITCH ,false,EMPTY, "Not Obligatoire","F5"))
pnl.field.add(defSwitch($PxF6 , 11, 17 , SWITCH ,false,EMPTY, "Not Obligatoire","F6"))
pnl.field.add(defSwitch($PxF7 , 11, 20 , SWITCH ,false,EMPTY, "Not Obligatoire","F7"))
pnl.field.add(defSwitch($PxF8 , 11, 23 , SWITCH ,false,EMPTY, "Not Obligatoire","F8"))
pnl.field.add(defSwitch($PxF9 , 11, 26 , SWITCH ,false,EMPTY, "Not Obligatoire","F9"))
pnl.field.add(defSwitch($PxF10 , 11, 30 , SWITCH ,false,EMPTY, "Not Obligatoire","F10"))
pnl.field.add(defSwitch($PxF11 , 11, 34 , SWITCH ,false,EMPTY, "Not Obligatoire","F11"))
pnl.field.add(defSwitch($PxF12 , 11, 38 , SWITCH ,false,EMPTY, "Not Obligatoire","F12"))
pnl.field.add(defSwitch($PxF13 , 11, 42 , SWITCH ,false,EMPTY, "Not Obligatoire","F13"))
pnl.field.add(defSwitch($PxF14 , 11, 46 , SWITCH ,false,EMPTY, "Not Obligatoire","F14"))
pnl.field.add(defSwitch($PxF15 , 11, 50 , SWITCH ,false,EMPTY, "Not Obligatoire","F15"))
pnl.field.add(defSwitch($PxF16 , 11, 54 , SWITCH ,false,EMPTY, "Not Obligatoire","F16"))
pnl.field.add(defSwitch($PxF17 , 11, 58 , SWITCH ,false,EMPTY, "Not Obligatoire","F17"))
pnl.field.add(defSwitch($PxF18 , 11, 62 , SWITCH ,false,EMPTY, "Not Obligatoire","F18"))
pnl.field.add(defSwitch($PxF19 , 11, 66 , SWITCH ,false,EMPTY, "Not Obligatoire","F19"))
pnl.field.add(defSwitch($PxF20 , 11, 70 , SWITCH ,false,EMPTY, "Not Obligatoire","F20"))
pnl.field.add(defSwitch($PxF21 , 11, 74 , SWITCH ,false,EMPTY, "Not Obligatoire","F21"))
pnl.field.add(defSwitch($PxF22 , 11, 78 , SWITCH ,false,EMPTY, "Not Obligatoire","F22"))
pnl.field.add(defSwitch($PxF23 , 11, 82 , SWITCH ,false,EMPTY, "Not Obligatoire","F23"))
pnl.field.add(defSwitch($PxF24 , 11, 86 , SWITCH ,false,EMPTY, "Not Obligatoire","F24"))

pnl.field.add(defSwitch($PcF1 , 13, 2  , SWITCH ,false,EMPTY, "Check Field Not Obligatoire","F1"))
pnl.field.add(defSwitch($PcF2 , 13, 5  , SWITCH ,false,EMPTY, "Check Field Not Obligatoire","F2"))
pnl.field.add(defSwitch($PcF3 , 13, 8  , SWITCH ,false,EMPTY, "Check Field Not Obligatoire","F3"))
pnl.field.add(defSwitch($PcF4 , 13, 11 , SWITCH ,false,EMPTY, "Check Field Not Obligatoire","F4"))
pnl.field.add(defSwitch($PcF5 , 13, 14 , SWITCH ,false,EMPTY, "Check Field Not Obligatoire","F5"))
pnl.field.add(defSwitch($PcF6 , 13, 17 , SWITCH ,false,EMPTY, "Check Field Not Obligatoire","F6"))
pnl.field.add(defSwitch($PcF7 , 13, 20 , SWITCH ,false,EMPTY, "Check Field Not Obligatoire","F7"))
pnl.field.add(defSwitch($PcF8 , 13, 23 , SWITCH ,false,EMPTY, "Check Field Not Obligatoire","F8"))
pnl.field.add(defSwitch($PcF9 , 13, 26 , SWITCH ,false,EMPTY, "Check Field Not Obligatoire","F9"))
pnl.field.add(defSwitch($PcF10 , 13, 30 , SWITCH ,false,EMPTY, "Check Field Not Obligatoire","F10"))
pnl.field.add(defSwitch($PcF13 , 13, 34 , SWITCH ,false,EMPTY, "Check Field Not Obligatoire","F13"))
pnl.field.add(defSwitch($PcF13 , 13, 38 , SWITCH ,false,EMPTY, "Check Field Not Obligatoire","F13"))
pnl.field.add(defSwitch($PcF13 , 13, 42 , SWITCH ,false,EMPTY, "Check Field Not Obligatoire","F13"))
pnl.field.add(defSwitch($PcF14 , 13, 46 , SWITCH ,false,EMPTY, "Check Field Not Obligatoire","F14"))
pnl.field.add(defSwitch($PcF15 , 13, 50 , SWITCH ,false,EMPTY, "Check Field Not Obligatoire","F15"))
pnl.field.add(defSwitch($PcF16 , 13, 54 , SWITCH ,false,EMPTY, "Check Field Not Obligatoire","F16"))
pnl.field.add(defSwitch($PcF17 , 13, 58 , SWITCH ,false,EMPTY, "Check Field Not Obligatoire","F17"))
pnl.field.add(defSwitch($PcF18 , 13, 62 , SWITCH ,false,EMPTY, "Check Field Not Obligatoire","F18"))
pnl.field.add(defSwitch($PcF19 , 13, 66 , SWITCH ,false,EMPTY, "Check Field Not Obligatoire","F19"))
pnl.field.add(defSwitch($PcF20 , 13, 70 , SWITCH ,false,EMPTY, "Check Field Not Obligatoire","F20"))
pnl.field.add(defSwitch($PcF21 , 13, 74 , SWITCH ,false,EMPTY, "Check Field Not Obligatoire","F21"))
pnl.field.add(defSwitch($PcF22 , 13, 78 , SWITCH ,false,EMPTY, "Check Field Not Obligatoire","F22"))
pnl.field.add(defSwitch($PcF23 , 13, 82 , SWITCH ,false,EMPTY, "Check Field Not Obligatoire","F23"))
pnl.field.add(defSwitch($PcF24 , 13, 86 , SWITCH ,false,EMPTY, "Check Field Not Obligatoire","F24"))



let fldP = new(Vpanel)

proc clearFldp() =
  fldP.name = ""
  fldP.posx = 1
  fldP.posy = 1
  fldP.height = 0
  fldP.width = 0
  fldP.cadrex = line0
  fldP.title = ""

  fldP.f1  = false
  fldP.f2  = false
  fldP.f3  = false
  fldP.f4  = false
  fldP.f5  = false
  fldP.f6  = false
  fldP.f7  = false
  fldP.f8  = false
  fldP.f9  = false
  fldP.f10  = false
  fldP.f11  = false
  fldP.f12  = false
  fldP.f13  = false
  fldP.f14  = false
  fldP.f15  = false
  fldP.f16  = false
  fldP.f17  = false
  fldP.f18  = false
  fldP.f19  = false
  fldP.f20  = false
  fldP.f21  = false
  fldP.f22  = false
  fldP.f23  = false
  fldP.f24  = false

  fldP.chk1  = false
  fldP.chk2  = false
  fldP.chk3  = false
  fldP.chk4  = false
  fldP.chk5  = false
  fldP.chk6  = false
  fldP.chk7  = false
  fldP.chk8  = false
  fldP.chk9  = false
  fldP.chk10  = false
  fldP.chk11  = false
  fldP.chk12  = false
  fldP.chk13  = false
  fldP.chk14  = false
  fldP.chk15  = false
  fldP.chk16  = false
  fldP.chk17  = false
  fldP.chk18  = false
  fldP.chk19  = false
  fldP.chk20  = false
  fldP.chk21  = false
  fldP.chk22  = false
  fldP.chk23  = false
  fldP.chk24  = false

  fldP.button.add( @[defButton(TKey.None,"")])
  fldP.OK = false

proc chargeFldp(Pnlchx :int) =
  fldP.name   = getPnlName(base[Pnlchx])
  fldP.posx   = base[Pnlchx].posx
  fldP.posy   = base[Pnlchx].posy
  fldP.height = base[Pnlchx].lines
  fldP.width  = base[Pnlchx].cols
  fldP.cadrex = base[Pnlchx].cadre
  fldP.title  = getPnlTitle(base[Pnlchx])

  fldP.f1  = false
  fldP.f2  = false
  fldP.f3  = false
  fldP.f4  = false
  fldP.f5  = false
  fldP.f6  = false
  fldP.f7  = false
  fldP.f8  = false
  fldP.f9  = false
  fldP.f10  = false
  fldP.f11  = false
  fldP.f12  = false
  fldP.f13  = false
  fldP.f14  = false
  fldP.f15  = false
  fldP.f16  = false
  fldP.f17  = false
  fldP.f18  = false
  fldP.f19  = false
  fldP.f20  = false
  fldP.f21  = false
  fldP.f22  = false
  fldP.f23  = false
  fldP.f24  = false

  fldP.chk1  = false
  fldP.chk2  = false
  fldP.chk3  = false
  fldP.chk4  = false
  fldP.chk5  = false
  fldP.chk6  = false
  fldP.chk7  = false
  fldP.chk8  = false
  fldP.chk9  = false
  fldP.chk10  = false
  fldP.chk11  = false
  fldP.chk12  = false
  fldP.chk13  = false
  fldP.chk14  = false
  fldP.chk15  = false
  fldP.chk16  = false
  fldP.chk17  = false
  fldP.chk18  = false
  fldP.chk19  = false
  fldP.chk20  = false
  fldP.chk21  = false
  fldP.chk22  = false
  fldP.chk23  = false
  fldP.chk24  = false

  fldP.button = base[Pnlchx].button
  var nbr = false
  var btn : BUTTON
  for i in 0..len(fldP.button)-1:
        nbr = true
        btn = fldP.button[i]
        case btn.key
          of TKey.F1 : fldP.f1 = true ; fldP.chk1 = getCtrl(btn)
          of TKey.F2 : fldP.f2 = true ; fldP.chk2 = getCtrl(btn)
          of TKey.F3 : fldP.f3 = true ; fldP.chk3 = getCtrl(btn)
          of TKey.F4 : fldP.f4 = true ; fldP.chk4 = getCtrl(btn)
          of TKey.F5 : fldP.f5 = true ; fldP.chk5 = getCtrl(btn)
          of TKey.F6 : fldP.f6 = true ; fldP.chk6 = getCtrl(btn)
          of TKey.F7 : fldP.f7 = true ; fldP.chk7 = getCtrl(btn)
          of TKey.F8 : fldP.f8 = true ; fldP.chk8 = getCtrl(btn)
          of TKey.F9 : fldP.f9 = true ; fldP.chk9 = getCtrl(btn)
          of TKey.F10 : fldP.f10 = true ; fldP.chk10 = getCtrl(btn)
          of TKey.F11 : fldP.f11 = true ; fldP.chk11 = getCtrl(btn)
          of TKey.F12 : fldP.f12 = true ; fldP.chk12 = getCtrl(btn)
          of TKey.F13 : fldP.f13 = true ; fldP.chk13 = getCtrl(btn)
          of TKey.F14 : fldP.f14 = true ; fldP.chk14 = getCtrl(btn)
          of TKey.F15 : fldP.f15 = true ; fldP.chk15 = getCtrl(btn)
          of TKey.F16 : fldP.f16 = true ; fldP.chk16 = getCtrl(btn)
          of TKey.F17 : fldP.f17 = true ; fldP.chk17 = getCtrl(btn)
          of TKey.F18 : fldP.f18 = true ; fldP.chk18 = getCtrl(btn)
          of TKey.F19 : fldP.f19 = true ; fldP.chk19 = getCtrl(btn)
          of TKey.F20 : fldP.f20 = true ; fldP.chk20 = getCtrl(btn)
          of TKey.F21 : fldP.f21 = true ; fldP.chk21 = getCtrl(btn)
          of TKey.F22 : fldP.f22 = true ; fldP.chk22 = getCtrl(btn)
          of TKey.F23 : fldP.f23 = true ; fldP.chk23 = getCtrl(btn)
          of TKey.F24 : fldP.f24 = true ; fldP.chk24 = getCtrl(btn)
          else : discard

  fldP.OK = false

proc PanelDef() =

  if PanelWork == 999 and key != TKey.Proc:
    clearFldp()
    pnl.index = 0
  elif key != TKey.Proc:
    chargeFldp(PanelWork)
    pnl.index = 0

  setTerminal()
  pnl.setText(P_F1[Pname], fldP.name)
  pnl.setText(P_F1[Pposx], $fldp.posx)
  pnl.setText(P_F1[Pposy], $fldp.posy)
  pnl.setText(P_F1[Pheight], $fldp.height)
  pnl.setText(P_F1[Pwidth], $fldp.width)
  pnl.setText(P_F1[Pcadre], $fldp.cadrex)
  pnl.setText(P_F1[Ptitle], $fldP.title)

  pnl.setSwitch(P_F1[PxF1], fldP.f1)
  pnl.setSwitch(P_F1[PxF2], fldP.f2)
  pnl.setSwitch(P_F1[PxF3], fldP.f3)
  pnl.setSwitch(P_F1[PxF4], fldP.f4)
  pnl.setSwitch(P_F1[PxF5], fldP.f5)
  pnl.setSwitch(P_F1[PxF6], fldP.f6)
  pnl.setSwitch(P_F1[PxF7], fldP.f7)
  pnl.setSwitch(P_F1[PxF8], fldP.f8)
  pnl.setSwitch(P_F1[PxF9], fldP.f9)
  pnl.setSwitch(P_F1[PxF10], fldP.f10)
  pnl.setSwitch(P_F1[PxF11], fldP.f11)
  pnl.setSwitch(P_F1[PxF12], fldP.f12)
  pnl.setSwitch(P_F1[PxF13], fldP.f13)
  pnl.setSwitch(P_F1[PxF14], fldP.f14)
  pnl.setSwitch(P_F1[PxF15], fldP.f15)
  pnl.setSwitch(P_F1[PxF16], fldP.f16)
  pnl.setSwitch(P_F1[PxF17], fldP.f17)
  pnl.setSwitch(P_F1[PxF18], fldP.f18)
  pnl.setSwitch(P_F1[PxF19], fldP.f19)
  pnl.setSwitch(P_F1[PxF20], fldP.f20)
  pnl.setSwitch(P_F1[PxF21], fldP.f21)
  pnl.setSwitch(P_F1[PxF22], fldP.f22)
  pnl.setSwitch(P_F1[PxF23], fldP.f23)
  pnl.setSwitch(P_F1[PxF24], fldP.f24)


  pnl.setSwitch(P_F1[PcF1], fldP.chk1)
  pnl.setSwitch(P_F1[PcF2], fldP.chk2)
  pnl.setSwitch(P_F1[PcF3], fldP.chk3)
  pnl.setSwitch(P_F1[PcF4], fldP.chk4)
  pnl.setSwitch(P_F1[PcF5], fldP.chk5)
  pnl.setSwitch(P_F1[PcF6], fldP.chk6)
  pnl.setSwitch(P_F1[PcF7], fldP.chk7)
  pnl.setSwitch(P_F1[PcF8], fldP.chk8)
  pnl.setSwitch(P_F1[PcF9], fldP.chk9)
  pnl.setSwitch(P_F1[PcF10], fldP.chk10)
  pnl.setSwitch(P_F1[PcF11], fldP.chk11)
  pnl.setSwitch(P_F1[PcF12], fldP.chk12)
  pnl.setSwitch(P_F1[PcF13], fldP.chk13)
  pnl.setSwitch(P_F1[PcF14], fldP.chk14)
  pnl.setSwitch(P_F1[PcF15], fldP.chk15)
  pnl.setSwitch(P_F1[PcF16], fldP.chk16)
  pnl.setSwitch(P_F1[PcF17], fldP.chk17)
  pnl.setSwitch(P_F1[PcF18], fldP.chk18)
  pnl.setSwitch(P_F1[PcF19], fldP.chk19)
  pnl.setSwitch(P_F1[PcF20], fldP.chk20)
  pnl.setSwitch(P_F1[PcF21], fldP.chk21)
  pnl.setSwitch(P_F1[PcF22], fldP.chk22)
  pnl.setSwitch(P_F1[PcF23], fldP.chk23)
  pnl.setSwitch(P_F1[PcF24], fldP.chk24)


  #setField(pnl.field[P_F1[PdefButton]] ,  move(fldP.button) )
  printPanel(pnl)
  key = ioPanel(pnl)
  fldP.name = getText(pnl,P_F1[Pname])
  fldp.posx = parseInt(getText(pnl,P_F1[Pposx]))
  fldp.posy = parseInt(getText(pnl,P_F1[Pposy]))
  fldp.height = parseInt(getText(pnl,P_F1[Pheight]))
  fldp.width = parseInt(getText(pnl,P_F1[Pwidth]))
  fldP.cadrex = parseEnum[CADRE](getText(pnl,P_F1[Pcadre]))
  fldP.title = getText(pnl,P_F1[Ptitle])

  fldP.f1  = getSwitch(pnl, P_F1[PxF1])
  fldP.f2  = getSwitch(pnl, P_F1[PxF2])
  fldP.f3  = getSwitch(pnl, P_F1[PxF3])
  fldP.f4  = getSwitch(pnl, P_F1[PxF4])
  fldP.f5  = getSwitch(pnl, P_F1[PxF5])
  fldP.f6  = getSwitch(pnl, P_F1[PxF6])
  fldP.f7  = getSwitch(pnl, P_F1[PxF7])
  fldP.f8  = getSwitch(pnl, P_F1[PxF8])
  fldP.f9  = getSwitch(pnl, P_F1[PxF9])
  fldP.f10  = getSwitch(pnl, P_F1[PxF10])
  fldP.f11  = getSwitch(pnl, P_F1[PxF11])
  fldP.f12  = getSwitch(pnl, P_F1[PxF12])
  fldP.f13  = getSwitch(pnl, P_F1[PxF13])
  fldP.f14  = getSwitch(pnl, P_F1[PxF14])
  fldP.f15  = getSwitch(pnl, P_F1[PxF15])
  fldP.f16  = getSwitch(pnl, P_F1[PxF16])
  fldP.f17  = getSwitch(pnl, P_F1[PxF17])
  fldP.f18  = getSwitch(pnl, P_F1[PxF18])
  fldP.f19  = getSwitch(pnl, P_F1[PxF19])
  fldP.f20  = getSwitch(pnl, P_F1[PxF20])
  fldP.f21  = getSwitch(pnl, P_F1[PxF21])
  fldP.f22  = getSwitch(pnl, P_F1[PxF22])
  fldP.f23  = getSwitch(pnl, P_F1[PxF23])
  fldP.f24  = getSwitch(pnl, P_F1[PxF24])


  fldP.chk1  = getSwitch(pnl, P_F1[PcF1])
  fldP.chk2  = getSwitch(pnl, P_F1[PcF2])
  fldP.chk3  = getSwitch(pnl, P_F1[PcF3])
  fldP.chk4  = getSwitch(pnl, P_F1[PcF4])
  fldP.chk5  = getSwitch(pnl, P_F1[PcF5])
  fldP.chk6  = getSwitch(pnl, P_F1[PcF6])
  fldP.chk7  = getSwitch(pnl, P_F1[PcF7])
  fldP.chk8  = getSwitch(pnl, P_F1[PcF8])
  fldP.chk9  = getSwitch(pnl, P_F1[PcF9])
  fldP.chk10  = getSwitch(pnl, P_F1[PcF10])
  fldP.chk11  = getSwitch(pnl, P_F1[PcF11])
  fldP.chk12  = getSwitch(pnl, P_F1[PcF12])
  fldP.chk13  = getSwitch(pnl, P_F1[PcF13])
  fldP.chk14  = getSwitch(pnl, P_F1[PcF14])
  fldP.chk15  = getSwitch(pnl, P_F1[PcF15])
  fldP.chk16  = getSwitch(pnl, P_F1[PcF16])
  fldP.chk17  = getSwitch(pnl, P_F1[PcF17])
  fldP.chk18  = getSwitch(pnl, P_F1[PcF18])
  fldP.chk19  = getSwitch(pnl, P_F1[PcF19])
  fldP.chk20  = getSwitch(pnl, P_F1[PcF20])
  fldP.chk21  = getSwitch(pnl, P_F1[PcF21])
  fldP.chk22  = getSwitch(pnl, P_F1[PcF22])
  fldP.chk23  = getSwitch(pnl, P_F1[PcF23])
  fldP.chk24  = getSwitch(pnl, P_F1[PcF24])

  case key
    of TKey.PROC:
      if isProcess(pnl,Index(pnl)) :
        callQuery[getProcess(pnl,Index(pnl))] (pnl.field[Index(pnl)])
        fldP.cadrex = parseEnum[CADRE](getText(pnl,P_F1[PCadre]))
        setText(pnl,P_F1[PCadre],$fldP.cadrex)
      setTerminal()
      printPanel(pnl)
      nPnl= 1
    of TKey.F9 , TKey.F10:
      ## Contrôle  Format Panel full Field
      if isValide(pnl) :
        fldP.button  = newseq[BUTTON]()
        var nbrb = -1
        for i in 7..len(P_F1)-1:
          if pnl.field[i].switch :
            inc(nbrb)
            case i
              of 7 :   fldP.button.add(@[defButton(TKey.F1,"F1")]); setCtrl(fldP.button[nbrb],fldP.chk1)
              of 8 :   fldP.button.add(@[defButton(TKey.F2,"F2")]); setCtrl(fldP.button[nbrb],fldP.chk2)
              of 9 :   fldP.button.add(@[defButton(TKey.F3,"F3")]); setCtrl(fldP.button[nbrb],fldP.chk3)
              of 10 :  fldP.button.add(@[defButton(TKey.F4,"F4")]); setCtrl(fldP.button[nbrb],fldP.chk4)
              of 11 :  fldP.button.add(@[defButton(TKey.F5,"F5")]); setCtrl(fldP.button[nbrb],fldP.chk5)
              of 12 :  fldP.button.add(@[defButton(TKey.F6,"F6")]); setCtrl(fldP.button[nbrb],fldP.chk6)
              of 13 :  fldP.button.add(@[defButton(TKey.F7,"F7")]); setCtrl(fldP.button[nbrb],fldP.chk7)
              of 14 :  fldP.button.add(@[defButton(TKey.F8,"F8")]); setCtrl(fldP.button[nbrb],fldP.chk8)
              of 15 :  fldP.button.add(@[defButton(TKey.F9,"F9")]); setCtrl(fldP.button[nbrb],fldP.chk9)
              of 16 :  fldP.button.add(@[defButton(TKey.F10,"F10")]); setCtrl(fldP.button[nbrb],fldP.chk10)
              of 17 :  fldP.button.add(@[defButton(TKey.F11,"F11")]); setCtrl(fldP.button[nbrb],fldP.chk11)
              of 18 :  fldP.button.add(@[defButton(TKey.F12,"F12")]); setCtrl(fldP.button[nbrb],fldP.chk12)
              of 19 :  fldP.button.add(@[defButton(TKey.F13,"F13")]); setCtrl(fldP.button[nbrb],fldP.chk13)
              of 20 :  fldP.button.add(@[defButton(TKey.F14,"F14")]); setCtrl(fldP.button[nbrb],fldP.chk14)
              of 21 :  fldP.button.add(@[defButton(TKey.F15,"F15")]); setCtrl(fldP.button[nbrb],fldP.chk15)
              of 22 :  fldP.button.add(@[defButton(TKey.F16,"F16")]); setCtrl(fldP.button[nbrb],fldP.chk16)
              of 23 :  fldP.button.add(@[defButton(TKey.F17,"F17")]); setCtrl(fldP.button[nbrb],fldP.chk17)
              of 24 :  fldP.button.add(@[defButton(TKey.F18,"F18")]); setCtrl(fldP.button[nbrb],fldP.chk18)
              of 25 :  fldP.button.add(@[defButton(TKey.F19,"F19")]); setCtrl(fldP.button[nbrb],fldP.chk19)
              of 26 :  fldP.button.add(@[defButton(TKey.F20,"F20")]); setCtrl(fldP.button[nbrb],fldP.chk20)
              of 27 :  fldP.button.add(@[defButton(TKey.F21,"F21")]); setCtrl(fldP.button[nbrb],fldP.chk21)
              of 28 :  fldP.button.add(@[defButton(TKey.F22,"F22")]); setCtrl(fldP.button[nbrb],fldP.chk22)
              of 29 :  fldP.button.add(@[defButton(TKey.F23,"F23")]); setCtrl(fldP.button[nbrb],fldP.chk23)
              of 30 :  fldP.button.add(@[defButton(TKey.F24,"F24")]); setCtrl(fldP.button[nbrb],fldP.chk24)
              else: discard
        if len(fldP.button) == 0 : fldP.button.add( @[defButton(TKey.None,"")])

        if key == TKey.F9 and PanelWork == 999:
          base.add(newPanel(fldP.name,fldP.posx,fldP.posy,fldP.height,fldP.width,fldP.button,fldP.cadrex,fldP.title))
          Nbrpanel = len(base) - 1
          fldP.OK = true
          nPnl = 0
          setTerminal()


        elif key == TKey.F10 and PanelWork < 999 :
          updPanel(base[PanelWork],  fldP.name,fldP.posx,fldP.posy,fldP.height,fldP.width,fldP.button,fldP.cadrex,fldP.title)
          fldP.OK = true
          nPnl = 0
          setTerminal()
      else :
        nPnl = 2
        key = TKey.None

    of TKey.F12:
      nPnl = 0
      setTerminal()
    else : discard