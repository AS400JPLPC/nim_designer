import termkey
import termcurs
import tables


var callQuery: Table[string, proc(fld : var FIELD)]


type
  FIELD_fecr01 {.pure.}= enum
    SELECTION
const P1: array[FIELD_fecr01, int] = [0]

type
  FIELD_fecr02 {.pure.}= enum
    INDEX,
    NOM,
    PRENOM,
    CIVILITE,
    RELATION,
    TEL,
    MAIL,
    DJN,
    ADR1,
    ADR2,
    ADR3,
    CPTT,
    VILLE,
    CPAYS,
    LPAYS,
    NOTE1,
    NOTE2,
    NOTE3,
    CPROF,
    SOCIETE,
    TELCIE
const P2: array[FIELD_fecr02, int] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]


# MENU -> TEST
var filtre = new(MENU)
filtre = newMenu("filtre", 2, 2, horizontal, @["* ", "A ", "B ", "C ", "D ", "E ", "F ", "G ", "H ", "I ", "J ", "K ", "L ", "M ", "N "], line1)


# Panel fecr01

var fecr01= new(PANEL)

# description
proc dscfecr01() = 
  fecr01 = newPanel("fecr01",1,1,32,132,@[defButton(TKey.F3,"F3",false,true), defButton(TKey.F4,"F4",false,true), defButton(TKey.F9,"F9",true,true), defButton(TKey.F10,"F10",true,true)],line1,"CONTACT")

  # LABEL  -> fecr01

  fecr01.label.add(deflabel("L02108", 2, 108, "Trie.:"))

  # FIELD -> fecr01

  fecr01.field.add(defString("SELECTION", 2, 114, FPROC,15,"", EMPTY, "Obligatoire","Trier Par Nom/Famille/Amis/Profession"))
  setProcess(fecr01.field[P1[SELECTION]],"tselection")


#===================================================
proc tselection(fld : var FIELD) =
  var Cell_pos : int = -1
  var Xcombo  = newGRID("tselection",2,114,4,sepStyle) 
  var Cell_Select-Trie = defCell("Select-Trie",15,TEXT_FREE,"Cyan") 
  setHeaders(Xcombo, @[Cell_Select-Trie])
  addRows(Xcombo, @[ "Nom" ])
  addRows(Xcombo, @[ "Famille" ])
  addRows(Xcombo, @[ "Amis" ])
  addRows(Xcombo, @[ "Profession" ])

  case fld.text
    of "Nom"   : Cell_pos = 0 
    of "Famille"   : Cell_pos = 1 
    of "Amis"   : Cell_pos = 2 
    of "Profession"   : Cell_pos = 3 
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


var GSFL01: GRIDSFL
#===================================================
proc SFL01() =
  GSFL01  = newGRID("SFL01",5,2,22,sepStyle) 
  var Cell_INDEX = defCell("INDEX",4,DIGIT,"Yellow") 
  var Cell_NAME = defCell("NAME",30,TEXT_FREE,"White") 
  var Cell_PRENOM = defCell("PRENOM",30,TEXT_FREE,"Green") 
  var Cell_TEL = defCell("TEL",15,TEXT_FREE,"White") 
  var Cell_RELATION = defCell("RELATION",15,TEXT_FREE,"Yellow") 
  setHeaders(GSFL01, @[Cell_INDEX ,Cell_NAME ,Cell_PRENOM ,Cell_TEL ,Cell_RELATION])
#===================================================

# Panel fecr02

var fecr02= new(PANEL)

# description
proc dscfecr02() = 
  fecr02 = newPanel("fecr02",1,1,32,132,@[defButton(TKey.F3,"F3",false,true), defButton(TKey.F4,"F4",false,true), defButton(TKey.F9,"F9",true,true), defButton(TKey.F10,"F10",true,true), defButton(TKey.F12,"F12",false,true)],line1,"Saisie CONTACT")

  # LABEL  -> fecr02

  fecr02.label.add(defTitle("L02002", 2, 2, "INDEX.:"))
  fecr02.label.add(deflabel("L05002", 5, 2, "Nom.:"))
  fecr02.label.add(deflabel("L05039", 5, 39, "Prénom.:"))
  fecr02.label.add(deflabel("L05079", 5, 79, "Civilité.:"))
  fecr02.label.add(deflabel("L05095", 5, 95, "Type.:"))
  fecr02.label.add(deflabel("L07002", 7, 2, "Tel.:"))
  fecr02.label.add(deflabel("L07026", 7, 26, "Mail.:"))
  fecr02.label.add(deflabel("L09002", 9, 2, "Date de naissance.:"))
  fecr02.label.add(deflabel("L11002", 11, 2, "Adresse.:"))
  fecr02.label.add(deflabel("L15002", 15, 2, "C.Postal:"))
  fecr02.label.add(deflabel("L17002", 17, 2, "Pays....:"))
  fecr02.label.add(deflabel("L19002", 19, 2, "Note....:"))
  fecr02.label.add(deflabel("L24002", 24, 2, "Profession.:"))
  fecr02.label.add(deflabel("L26002", 26, 2, "Société....:"))
  fecr02.label.add(deflabel("L26046", 26, 46, "Tel.société.:"))

  # FIELD -> fecr02

  fecr02.field.add(defNumeric("INDEX", 2, 9, DIGIT,4,0,"", EMPTY,"", ""))
  fecr02.field.add(defString("NOM", 5, 7, ALPHA_UPPER,30,"", FILL, "Obligatoire","Nom du Contact"))
  fecr02.field.add(defString("PRENOM", 5, 47, TEXT_FREE,30,"", FILL, "OBLIGATOIRE","Prénom du contact"))
  fecr02.field.add(defString("CIVILITE", 5, 89, FPROC,4,"", FILL, "Obligatoire","Civilité M. Mme."))
  setProcess(fecr02.field[P2[CIVILITE]],"tcivilite")
  fecr02.field.add(defString("RELATION", 5, 101, FPROC,15,"", FILL, "Obligatoire","Relation"))
  setProcess(fecr02.field[P2[RELATION]],"trelation")
  fecr02.field.add(defTelephone("TEL", 7, 7, TELEPHONE,15,"", FILL, "Obligatoire", "N° de téléphone"))
  fecr02.field.add(defMail("MAIL", 7, 32, MAIL_ISO,100,"", EMPTY, "", "Adresse Mail"))
  fecr02.field.add(defDate("DJN", 9, 21, DATE_ISO,"", EMPTY, "", "Date de naissance AAAA-MM-JJ"))
  fecr02.field.add(defString("ADR1", 11, 11, TEXT_FREE,30,"", EMPTY, "","Adresse du contact N°rue...."))
  fecr02.field.add(defString("ADR2", 12, 11, TEXT_FREE,30,"", EMPTY, "","Suite adresse"))
  fecr02.field.add(defString("ADR3", 13, 11, TEXT_FREE,30,"", EMPTY, "","Suite adresse"))
  fecr02.field.add(defString("CPTT", 15, 11, FPROC,10,"", FILL, "Obligatoire","Code Postal"))
  setProcess(fecr02.field[P2[CPTT]],"tcptt")
  fecr02.field.add(defString("VILLE", 15, 23, TEXT_FREE,20,"", EMPTY, "","Ville"))
  setProtect(fecr02.field[P2[VILLE]],true)
  fecr02.field.add(defString("CPAYS", 17, 11, FPROC,3,"", FILL, "Obligatoire","Pays (Habitation)"))
  setProcess(fecr02.field[P2[CPAYS]],"tpays")
  fecr02.field.add(defString("LPAYS", 17, 15, TEXT_FREE,20,"", EMPTY, "","Nom du Pays"))
  setProtect(fecr02.field[P2[LPAYS]],true)
  fecr02.field.add(defString("NOTE1", 20, 2, TEXT_FULL,120,"", EMPTY, "","Note ou rappel"))
  fecr02.field.add(defString("NOTE2", 21, 2, TEXT_FULL,120,"", EMPTY, "","Note ou rappel"))
  fecr02.field.add(defString("NOTE3", 22, 2, TEXT_FULL,120,"", EMPTY, "","Note ou rappel"))
  fecr02.field.add(defString("CPROF", 24, 14, FPROC,20,"", EMPTY, "","Profession"))
  setProcess(fecr02.field[P2[CPROF]],"tprofession")
  fecr02.field.add(defString("SOCIETE", 26, 14, TEXT_FREE,30,"", EMPTY, "","Nom de la société"))
  fecr02.field.add(defTelephone("TELCIE", 26, 59, TELEPHONE,15,"", EMPTY, "format (033)1234567890", "Téléphone de la société"))


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
proc tcptt(fld : var FIELD) =
  var Cell_pos : int = -1
  var Xcombo  = newGRID("tcptt",17,11,14,sepStyle) 
  var Cell_Code = defCell("Code",10,TEXT_FREE,"Cyan") 
  var Cell_Lcptt = defCell("Lcptt",20,TEXT_FREE,"Cyan") 
  setHeaders(Xcombo, @[Cell_Code ,Cell_Lcptt])
  addRows(Xcombo, @[  "11110" ,"Coursan" ])
  addRows(Xcombo, @[  "11100" ,"Narbonne" ])
  addRows(Xcombo, @[  "11100" ,"narbonne" ])

  case fld.text
    of "11110"   : Cell_pos = 0 
    of "11100"   : Cell_pos = 1 
    of "11100"   : Cell_pos = 2 
    else : discard

  while true :
    let (keys, val) = ioGrid(Xcombo,Cell_pos)
    case keys
      of TKey.Enter :
        restorePanel(fecr02,Xcombo)
        fld.text  = $val[0]
        break
      else: discard

callQuery["tcptt"] = tcptt 
#===================================================
#===================================================
proc tpays(fld : var FIELD) =
  var Cell_pos : int = -1
  var Xcombo  = newGRID("tpays",17,11,12,sepStyle) 
  var Cell_Code = defCell("Code",3,TEXT_FREE,"Cyan") 
  var Cell_lcpays = defCell("lcpays",20,TEXT_FREE,"Cyan") 
  setHeaders(Xcombo, @[Cell_Code ,Cell_lcpays])
  addRows(Xcombo, @[  "FRA" ,"France" ])
  addRows(Xcombo, @[  "DEU" ,"Allemagne" ])

  case fld.text
    of "FRA"   : Cell_pos = 0 
    of "DEU"   : Cell_pos = 1 
    else : discard

  while true :
    let (keys, val) = ioGrid(Xcombo,Cell_pos)
    case keys
      of TKey.Enter :
        restorePanel(fecr02,Xcombo)
        fld.text  = $val[0]
        break
      else: discard

callQuery["tpays"] = tpays 
#===================================================
#===================================================
proc trelation(fld : var FIELD) =
  var Cell_pos : int = -1
  var Xcombo  = newGRID("trelation",5,101,3,sepStyle) 
  var Cell_Relation = defCell("Relation",15,TEXT_FREE,"Cyan") 
  setHeaders(Xcombo, @[Cell_Relation])
  addRows(Xcombo, @[ "Famille" ])
  addRows(Xcombo, @[ "Amis" ])
  addRows(Xcombo, @[ "Professionnel" ])

  case fld.text
    of "Famille"   : Cell_pos = 0 
    of "Amis"   : Cell_pos = 1 
    of "Professionnel"   : Cell_pos = 2 
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




proc main() =
  initTerm(32,132)

  dscfecr01()
  printPanel(fecr01)
  displayPanel(fecr01)

  # ONLY -> FOR TEST
  dspMenuItem(fecr01,filtre,0)
  let nTest = ioMenu(fecr01,filtre,0)


  #Exemple ------

  while true:
    let  key = ioPanel(fecr01)
    case key
      of TKey.PROC :  # for field Process
        if isProcess(fecr01,Index(fecr01)):
          callQuery[getProcess(fecr01,Index(fecr01))](fecr01.field[Index(fecr01)])
      of TKey.F3:
        break
      of TKey.F4:
        break
      of TKey.F9:
        break
      of TKey.F10:
        break
      else : discard
  dscfecr02()
  printPanel(fecr02)
  displayPanel(fecr02)

  # ONLY -> FOR TEST
  dspMenuItem(fecr02,filtre,0)
  let nTest = ioMenu(fecr02,filtre,0)


  #Exemple ------

  while true:
    let  key = ioPanel(fecr02)
    case key
      of TKey.PROC :  # for field Process
        if isProcess(fecr02,Index(fecr02)):
          callQuery[getProcess(fecr02,Index(fecr02))](fecr02.field[Index(fecr02)])
      of TKey.F3:
        break
      of TKey.F4:
        break
      of TKey.F9:
        break
      of TKey.F10:
        break
      of TKey.F12:
        break
      else : discard

  closeTerm()



main()
