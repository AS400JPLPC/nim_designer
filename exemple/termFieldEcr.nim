
var pnlF0  = new(PANEL)
var pnlF1  = new(PANEL)
var pnlF2 = new(PANEL)
var mField= new(MENU)


mField = newMenu( "Field" , 3 , 50 ,
MNUVH.vertical ,@[
  "zone0","zone1","zone2","zone3","zone4","zone5",
  "zone6","zone7","zone8","zone9","zone10","zone11",
  "zone12","zone13","zone14","zone15","Zone16"
],line1)  #,mnuatrx

proc ecr00() =
  # use button CtrlQ reserved for return reftyp QUERY 
  pnlF0= new_Panel("Help00",1,1,terminalHeight(),terminalWidth(), @[defButton(TKey.F12,"Next")],CADRE.line0)
  pnlF0.label.add(defLabel("L02005", 2, 5,   "Présentation"))
  pnlF0.label.add(defLabel("L04005", 4, 5,   "manipulation des affichages"))
  pnlF0.label.add(defLabel("L06005", 6, 5,   "manipulation des fenêtres"))
  pnlF0.label.add(defLabel("L08005", 8, 5,   "manipulation des champs"))
  pnlF0.label.add(defLabel("L10005", 10, 5,  "manipulation de  combo"))
  pnlF0.label.add(defLabel("L12005", 12, 5,  "manipulation de  menu"))
  pnlF0.label.add(defLabel("L14005", 14, 5,  "manipulation de  F1.."))


  pnlF0.label.add(defLabel("L22005", 22, 5,   "Présentation"))
  pnlF0.label.add(defLabel("L24005", 24, 5,   "display manipulation"))
  pnlF0.label.add(defLabel("L26005", 26, 5,   "window manipulation"))
  pnlF0.label.add(defLabel("L28005", 28, 5,   "manipulation of fields"))
  pnlF0.label.add(defLabel("L30005", 30, 5,   "combo manipulation"))
  pnlF0.label.add(defLabel("L32005", 32, 5,   "manipulation de  menu"))
  pnlF0.label.add(defLabel("L34005", 34, 5,   "manipulation de  F1.."))


proc ecr01() =
  # use button CtrlQ reserved for return reftyp QUERY 
  pnlF1= new_Panel("nom",1,1,terminalHeight(),terminalWidth(),
  @[defButton(TKey.F3,"Exit"),defButton(TKey.F2,"PANEL F2"),defButton(TKey.F6, "active",false),
  defButton(TKey.F9, "menu")],CADRE.line0)

  pnlF1.label.add(defLabel("zone0", 2, 5,  "ALPHA               zone0  :"))
  pnlF1.field.add(defString("zone0", 2, 5+(len(pnlF1.label[0].text)), ALPHA, 30, "Soleil",FILL, "ALPHA Obligatoire", "Type Alpha a-Z"))

  pnlF1.label.add(defLabel("zone1", 4, 5,  "ALPHA_UPPER         zone1  :"))
  pnlF1.field.add(defString("zone1", 4, 5+(len(pnlF1.label[1].text)), ALPHA_UPPER, 30, "BONJOUR",EMPTY, "ALPHA Obligatoire", "Type Alpha A-Z"))
  setProtect(pnlF1.field[1],true)
  
  pnlF1.label.add(defLabel("zone2", 6, 5,  "PASSWORD            zone2  :"))
  pnlF1.field.add(defString("zone2", 6, 5+(len(pnlF1.label[2].text)), PASSWORD, 10, "flagada",EMPTY, "PASSWORD Obligatoire", "Type Password"))

  pnlF1.label.add(defLabel("zone3", 10, 5, "ALPHA_NUMERIC       zone3  :"))
  pnlF1.field.add(defString("zone3", 10, 5+(len(pnlF1.label[3].text)), ALPHA_NUMERIC, 30, "Soleil 1 étoile",EMPTY, "ALPHA_NUMERIC Obligatoire", "Type 'a-Z 0-9 and Punct'"))

  pnlF1.label.add(defLabel("zone4", 12, 5, "ALPHA_NUMERIC_UPPER zone4  :"))
  pnlF1.field.add(defString("zone4", 12, 5+(len(pnlF1.label[4].text)), ALPHA_NUMERIC_UPPER, 30, "LE SOLEIL EST 1 ÉTOILE",EMPTY, "ALPHA_NUMERIC Obligatoire", "Type  'A-Z 0-9 and Punct'"))

  pnlF1.label.add(defLabel("zone5", 14, 5, "TEXT_NUMERIC        zone5  :"))
  pnlF1.field.add(defString("zone5", 14, 5+(len(pnlF1.label[5].text)), TEXT_FULL, 30, "BONJOUR, (3*7) étoiles",FILL, " TEXT_NUMERIC Obligatoire", "Type  FILL"))

  pnlF1.label.add(defLabel("zone6", 16, 5,"DIGIT               zone6  :"))
  pnlF1.field.add(defNumeric("zone6", 16, 5+(len(pnlF1.label[6].text)), DIGIT, 5, 0, "67",FILL, "DIGIT Obligatoire", "Type Digit 0-9"))

  pnlF1.label.add(defLabel("zone7", 18, 5,"DIGIT_SIGNED        zone7  :"))
  pnlF1.field.add(defNumeric("zone7", 18, 5+(len(pnlF1.label[7].text)), DIGIT_SIGNED, 5,0, "-67",FILL, "DIGIT Obligatoire", "Type Digot '-/+ -9'"))

  pnlF1.label.add(defLabel("zone8", 20, 5,"DECIMAL             zone8  :"))
  pnlF1.field.add(defNumeric("zone8", 20, 5+(len(pnlF1.label[8].text)), DECIMAL, 5,2, "67.58",FILL, "DECIMAL Obligatoire", "Type Digot .0-9"))

  pnlF1.label.add(defLabel("zone9", 22, 5,  "DECIMAL_SIGNED      zone9  :"))
  pnlF1.field.add(defNumeric("zone9", 22, 5+(len(pnlF1.label[9].text)), DECIMAL_SIGNED, 5,2, "-67.58",FILL, "DECIMAL Obligatoire", "Type DECIMAL '-/+.0-9'"))

  pnlF1.label.add(defLabel("zone10", 24, 5,"DATE_ISO            zone10 :"))
  pnlF1.field.add(defDate("zone10", 24, 5+(len(pnlF1.label[10].text)), DATE_ISO, "2020-04-18",FILL, "DATE Obligatoire", "Type Date-ISO YYYY-MM-DD"))
  
  pnlF1.label.add(defLabel("zone11", 26, 5,"DATE_US             zone11  "))
  pnlF1.field.add(defDate("zone11", 26, 5+(len(pnlF1.label[11].text)), DATE_US, "04/18/2020",EMPTY, "DATE Obligatoire", "Type Date-US MM/DD/YYYY"))
  
  pnlF1.label.add(defLabel("zone12", 28, 5,"DATE_FR             zone12 :"))
  pnlF1.field.add(defDate("zone12", 28, 5+(len(pnlF1.label[12].text)), DATE_FR, "18/04/2020",EMPTY, "DATE Obligatoire", "Type Date-FR DD/MM/YYYY"))

  pnlF1.label.add(defLabel("zone13", 30, 5,"MAIL_ISO            zone13 :"))
  pnlF1.field.add(defMail("zone13", 30, 5+(len(pnlF1.label[13].text)), MAIL_ISO, 50, "newmane@orange.fr",EMPTY, "MAIL Obligatoire", "Type Email"))

  pnlF1.label.add(defLabel("zone14", 32, 5,"YES_NO              zone14 :"))
  pnlF1.field.add(defString("zone14", 32, 5+(len(pnlF1.label[14].text)), YES_NO, 1, "N",FILL, "YES_NO Obligatoire", "Type n/y"))

  pnlF1.label.add(defLabel("zone15", 34, 5,"SWITCH              zone15 :"))
  pnlF1.field.add(defSwitch("zone15", 34, 5+(len(pnlF1.label[15].text)), SWITCH,false,EMPTY, "SWITCH Obligatoire", "Type ◉/◎"))

  pnlF1.label.add(defLabel("zone16", 36, 5,"COMBO               zone16 :"))
  pnlF1.field.add(defString("zone16", 36, 5+(len(pnlF1.label[16].text)), FPROC,19,"",FILL, "Value Obligatoire", "Type COMBO"))
  setProcess(pnlF1.field[16],"callRefTyp")

  pnlF1.label.add(defLabel("zone1/", 38, 5,"F1 = Help   Escape= return (error/menu)"))

  pnlF1.hiden.add(defStringH("zone3",TEXT_FULL, "BONJOUR, (36) étoiles"))     # full String
  pnlF1.hiden.add(defStringH("zone10",DATE_ISO, "2020-04-24"))                # full String
  pnlF1.hiden.add(defSwitchH("zone15", SWITCH,true))                          # specifique switch
  pnlF1.hiden.add(defStringH("zone8",DECIMAL, "256.05"))                      # full String


proc ecr02() =
  pnlF2 = new_Panel("nom",10,30,20,70,
    @[defButton(TKey.CtrlV,"get VAL"),defButton(TKey.CtrlH,"get HIDEN"),defButton(TKey.F12,"Abandon"),
    defButton(TKey.F9,"Menu"),defButton(TKey.F15,"Clear")],CADRE.line1,"test Panel")
  pnlF2.label.add(defLabel("nom", 5, 2,"ASTRE :"))
  pnlF2.label.add(defLabel("fruit", 10, 2,"Fruit :"))
  pnlF2.label.add(defLabel("aime", 12, 2,"Aimez-Vous les fruits :"))
  pnlF2.field.add(defString("zone0", 5, 3+(len(pnlF2.label[0].text)), ALPHA, 30, "Lune",EMPTY, "Obligatoire", "Nom de la personne "))
  pnlF2.field.add(defNumeric("zone8", 10, 3+(len(pnlF2.label[1].text)), DECIMAL, 3,2, "345.6",EMPTY, "Obligatoire", "Prix  des carottes"))
  pnlF2.field.add(defSwitch("zone15", 12, 3+(len(pnlF2.label[2].text)), SWITCH,true,EMPTY,"","Appuyer sur la bare espacement"))