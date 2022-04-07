# Panel fecr01

var fecr01= new(PANEL)

# description
proc dscfecr01() =
  fecr01 = newPanel("fecr01",1,1,32,132,@[defButton(TKey.F2,"Select",false,true),defButton(TKey.F3,"Exit",false,true), defButton(TKey.F9,"Add",true,true), defButton(TKey.F10,"Update",true,true), defButton(TKey.F23,"Delete",false,true)],line1,"CONTACT")

    # LABEL  -> fecr01

  fecr01.label.add(deflabel("L02002", 2, 2, "......"))
  fecr01.label.add(deflabel("L02070", 2, 85, "Nom.:"))

  # FIELD -> fecr01
  fecr01.field.add(defString("SNAME", 2, 91, TEXT_FREE,30,"", EMPTY, "","Select Nom"))
  fecr01.field.add(defNumeric("SINDEX", 3, 4, DIGIT,4,0,"", EMPTY,"", "INDEX sfl01"))
  setProtect(fecr01.field[P1[SINDEX]],true)
  fecr01.field.add(defString("SNOM", 3, 9, TEXT_FREE,30,"", EMPTY, "","SNOM sfl01"))
  setProtect(fecr01.field[P1[SNOM]],true)
  fecr01.field.add(defString("SPRENOM", 3, 40, TEXT_FREE,30,"", EMPTY, "","PRENOM sfl01"))
  setProtect(fecr01.field[P1[SPRENOM]],true)
  fecr01.field.add(defTelephone("STEL", 3, 71, TELEPHONE,15,"", EMPTY, "format (033)1234567890", "STEL sfl01"))
  setProtect(fecr01.field[P1[STEL]],true)





var GSFL01: GRIDSFL
#===================================================
proc defSFL01() =
  GSFL01  = newGRID("SFL01",5,2,22,sepStyle)
  var Cell_INDEX = defCell("INDEX",4,DIGIT,"Yellow")
  var Cell_NAME = defCell("NOM",30,TEXT_FREE,"White")
  var Cell_PRENOM = defCell("PRENOM",30,TEXT_FREE,"Green")
  var Cell_TEL = defCell("TEL",15,TEXT_FREE,"White")
  var Cell_RELATION = defCell("RELATION",15,TEXT_FREE,"Yellow")
  setHeaders(GSFL01, @[Cell_INDEX ,Cell_NAME ,Cell_PRENOM ,Cell_TEL ,Cell_RELATION])
#===================================================






# Panel fecr02

var fecr02= new(PANEL)

# description
proc dscfecr02() =
  fecr02 = newPanel("fecr02",1,1,32,132,@[defButton(TKey.F3,"EXIT",false,true), defButton(TKey.F4,"F4",false,true), defButton(TKey.F9,"Add",true,true), defButton(TKey.F10,"Update",true,true), defButton(TKey.F12,"Return",false,true), defButton(TKey.F23,"Delete",false,true)],line1,"Saisie CONTACT")

  # LABEL  -> fecr02

  fecr02.label.add(defTitle("L02002", 2, 2, "INDEX.:"))
  fecr02.label.add(deflabel("L05002", 4, 2, "Nom.:"))
  fecr02.label.add(deflabel("L05039", 4, 39, "Prénom.:"))
  fecr02.label.add(deflabel("L05079", 4, 79, "Civilité.:"))
  fecr02.label.add(deflabel("L05095", 4, 95, "Type.:"))
  fecr02.label.add(deflabel("L07002", 6, 2, "Tel..:"))
  fecr02.label.add(deflabel("L06027", 6, 27, "Tel-bis.:"))
  fecr02.label.add(deflabel("L07026", 8, 2, "Mail.:"))
  fecr02.label.add(deflabel("L09002", 10, 2, "Date de naissance.:"))
  fecr02.label.add(deflabel("L11002", 13, 2, "Adresse.:"))
  fecr02.label.add(deflabel("L15002", 17, 2, "Pays....:"))
  fecr02.label.add(deflabel("L17002", 19, 2, "C.Postal:"))
  fecr02.label.add(deflabel("L19002", 21, 2, "Note....:"))
  fecr02.label.add(deflabel("L24002", 26, 2, "Profession.:"))
  fecr02.label.add(deflabel("L26002", 28, 2, "Société....:"))
  fecr02.label.add(deflabel("L26046", 28, 46, "Tel.société.:"))


  # FIELD -> fecr02

  fecr02.field.add(defNumeric("CID", 2, 9, DIGIT,4,0,"", EMPTY,"", ""))
  setProtect(fecr02.field[P2[CID]],true)
  fecr02.field.add(defString("NOM", 4, 7, ALPHA_UPPER,30,"", FILL, "Obligatoire","Nom du Contact"))
  fecr02.field.add(defString("PRENOM", 4, 47, TEXT_FREE,30,"", FILL, "OBLIGATOIRE","Prénom du contact"))
  fecr02.field.add(defString("CIVILITE", 4, 89, FPROC,4,"", FILL, "Obligatoire","Civilité M. Mme."))
  setProcess(fecr02.field[P2[CIVILITE]],"tcivilite")
  fecr02.field.add(defString("RELATION", 4, 101, FPROC,15,"", FILL, "Obligatoire","Relation"))
  setProcess(fecr02.field[P2[RELATION]],"trelation")
  fecr02.field.add(defTelephone("TEL", 6, 8, TELEPHONE,15,"", FILL, "Obligatoire", "N° de téléphone"))
  fecr02.field.add(defTelephone("TELBIS", 6, 36, TELEPHONE,15,"", EMPTY, "format (033)1234567890", "Téléphone Bis"))
  fecr02.field.add(defMail("MAIL", 8, 8, MAIL_ISO,100,"", EMPTY, "", "Adresse Mail"))
  fecr02.field.add(defDate("DJN", 10, 21, DATE_ISO,"", EMPTY, "", "Date de naissance AAAA-MM-JJ"))
  fecr02.field.add(defString("ADR1", 13, 11, TEXT_FREE,30,"", FILL, "Obligatoire","Adresse du contact N°rue...."))
  fecr02.field.add(defString("ADR2", 14, 11, TEXT_FREE,30,"", EMPTY, "","Suite adresse"))
  fecr02.field.add(defString("ADR3", 15, 11, TEXT_FREE,30,"", EMPTY, "","Suite adresse"))
  fecr02.field.add(defString("CPAYS", 17, 11, FPROC,3,"", FILL, "Obligatoire","Pays (Habitation)"))
  setProcess(fecr02.field[P2[CPAYS]],"tcpays")
  fecr02.field.add(defString("LPAYS", 17, 15, TEXT_FREE,20,"", EMPTY, "","Nom du Pays"))
  setProtect(fecr02.field[P2[LPAYS]],true)
  fecr02.field.add(defString("CPTT", 19, 11, FPROC,10,"", FILL, "Obligatoire","Code Postal"))
  setProcess(fecr02.field[P2[CPTT]],"tcptt")
  fecr02.field.add(defString("VILLE", 19, 23, TEXT_FREE,20,"", EMPTY, "","Ville"))
  setProtect(fecr02.field[P2[VILLE]],true)
  fecr02.field.add(defString("NOTE1", 22, 2, TEXT_FULL,120,"", EMPTY, "","Note ou rappel"))
  fecr02.field.add(defString("NOTE2", 23, 2, TEXT_FULL,120,"", EMPTY, "","Note ou rappel"))
  fecr02.field.add(defString("NOTE3", 24, 2, TEXT_FULL,120,"", EMPTY, "","Note ou rappel"))
  fecr02.field.add(defString("CPROF", 26, 14, FPROC,20,"", EMPTY, "","Profession"))
  setProcess(fecr02.field[P2[CPROF]],"tcprof")
  fecr02.field.add(defString("SOCIETE", 28, 14, TEXT_FREE,30,"", EMPTY, "","Nom de la société"))
  fecr02.field.add(defTelephone("TELCIE", 28, 59, TELEPHONE,15,"", EMPTY, "format (033)1234567890", "Téléphone de la société"))


# Panel fecr03

var fecr03= new(PANEL)

# description
proc dscfecr03() =
  fecr03 = newPanel("fecr03",1,1,4,80,@[defButton(TKey.F2,"Ville",true,true), defButton(TKey.F12,"F12",false,true)],line1,"Commune")

  # LABEL  -> fecr03

  fecr03.label.add(deflabel("L02002", 2, 2, "Pays.:"))
  fecr03.label.add(deflabel("L02034", 2, 34, "Ville/Commune.:"))

  # FIELD -> fecr03

  fecr03.field.add(defString("CPAYS", 2, 8, TEXT_FREE,3,"", EMPTY, "","Code pays"))
  setProtect(fecr03.field[P3[CPAYS2]],true)
  fecr03.field.add(defString("LPAYS", 2, 12, TEXT_FREE,20,"", EMPTY, "","Libellé Pays"))
  setProtect(fecr03.field[P3[LPAYS2]],true)
  fecr03.field.add(defString("VILLE", 2, 49, TEXT_FREE,20,"", FILL, "Obligatoire","Nom de la ville ou Commune"))