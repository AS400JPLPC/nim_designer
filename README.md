# Designer

dépendance : **Termkey Termcurs**

# Testing 2022-03-21   11h55

* change procSDA procJson 2022-03-21 15h40  modification
* change procMenu 2022-03-23 4h09 fonction AltP CrtlP (harmonisation cmd)
* update procInit 2022-03-26 change libellé date
* update reademe 2022-03-27

---

le but:
Soulager la compréhention par la visualisation des Formulaires puis de générer le code.

Créer des programmes en pure NIM,sans lib externe et occupant peu de place mémoire.

l'utilisation de **Termvte** , crée une fenêtre terminale, beaucoup plus souple à gérer que xterm etc...

elle peut fonctionner dans un terminal que vous paramétrez.

# utilisation du logiciel:

Utiliser la souris pour naviguer, sélectionner, positionner...

![](assets/20220315_030352_ecr01.png)

* [ ] New permet de créer un formulaire et de le sauvegarder au format JSON et génère un source.nim

![](assets/20220315_031539_ecr01_02.png)

titleTerm.: Nom étendu du fichier comprenant l'ensemble des panels

fileTerm..: Nom du fichier  (exemple.dspf)

> F9  enregistre

> F12 abandon

Recovery: Recharge le display file en mémoire. Apporter toutes les modifications jugées nécéssaires.

![](assets/20220315_031510_ecr01_01.png)

---

* [ ] création du panel

![](assets/20220315_032120_ecr01_03.png)

* [ ] choix : créer = "999 add panel" sinon cliquer sur une ligne

![](assets/20220315_032658_ecr01_04.png)

* [ ] Saisie de la structure du panel

  fonction saisie clavier:
  up / down -- tab / tabs -- enter, pour valider la zone de saisie et passer à la zone suivante.

  si il y a une erreur de saisie appuyez sur la touche "Escape" pour corriger

![](assets/20220315_033532_ecr02_01.png)


| field       | fonction                                                                          |
| ------------- | ----------------------------------------------------------------------------------- |
| Name        | Obligatoire, le référencement et le panel sont lier voir exemple dans le source |
| PosX,Y      | récupération du positionement de la souris                                      |
| Heights     | nombre de lignes verticales                                                       |
| Width       | nombre de caractères horizontals                                                 |
| Cadre       | appuyer sur une touche, le choix apparaît ---- combo: ligne = 1 ligne =2         |
| Title       | Titre du panel                                                                    |
| F1..F24     | appuyer sur la bar d'espacemant pour activé la fonction                          |
| Check Field | associer le controle par défault des zones comprise dans le panel                |

![](assets/20220315_033957_ecr02_02.png)

> *F3* n'a pas besoin de crontôle ex: = exit programe
>
> *F9 F11* on besoin de faire le contrôle car les données ont des conséquences
>
> vous pouvez dans le source affecter à la main d'autre valeur  ex CtrlV
>
> leurs donner un text plus explicite ex F9 = F9 Enrg.
>
> si vous ne mettez pas de text la fonction n'est pas visible à l'écran mais active
>
> ne pas ce servir CrtlH qui est réserver à la saisie.
>
> ex:`defButton(TKey.F3,"F3 Exit.",false)` `defButton(TKey.F9,"F9 Enrg.",true)` `defButton(TKey.CtrlV,"",true)`

---

paneaux de définition des labels Fields Menus Combo/Grid

![](assets/20220315_133712_ecr03_01.png)

pointer la souris pour positioner l'objet que vous voulez décrire.


| key   | Fonction                                            |
| ------- | ----------------------------------------------------- |
| AltL  | Label  puis tapez votre label CtrlV valide le label |
| AltT  | Titre  idem label                                   |
| AltF  | Field                                               |
| AltM  | Menu                                                |
| AltP  | display de tous les  menus                          |
| AltG  | Combo/Grid                                          |
| AltD  | affichage des objet Label Field Menu                |
| AltO  | réordonner les objet Label Field                   |
| AltR  | remove les objet Label Field Menu Combo/Grid        |
| AltS  | réaffichage du terminal                            |
| CtrlQ | fermeture du panel retour au menu principal         |
|       |                                                     |
| CtrlH | réserver à la saisie pour Help field              |

---

* [ ] AltT -> Titre

![](assets/20220315_135205_ecr03_11.png)

* [ ] CtrlV -> vaidation

![](assets/20220315_135328_ecr03_12.png)

* [ ] AltL -> Label Idem Titre ex nom....:

![](assets/20220315_143234_ecr03_13.png)

---

* [ ] AltF -> définition FIELD

choix ajouter ou modifier

![](assets/20220315_143608_ecr03_21png)

*veuillez valider chaque zone*


| field    | fonction                                    |
| ---------- | --------------------------------------------- |
| Name     | nom du buffer                               |
| PosX,Y   | défini au moment du clique de la souris    |
| Ref.Type | combo: détermine le mode de sasie          |
| With     | nombre d'entier                             |
| Scal     | Nombre de décimal après la virgule        |
| Empty    | on -> Vide   off -> la zone est obligatoire |
| Error    | message ce rapportant à la zone de saisie  |
| Help     | aide avec la touche CtrlH                   |
| Edt.Char | code par exemple : € $ ¥ ₪ £ %          |
| Protect  | falg interdisant la saisie ou modification  |

![](assets/20220315_144050_ecr03_22png)

![](assets/20220315_144139_ecr03_23png)

* [ ] les zones Hiden

```pnlF1.hiden.add(defStringH("zone3",TEXT_FULL, "12101951"))                  # full String n° client
pnlF1.hiden.add(defStringH("zone10",DATE_ISO, "2020-04-24"))                # full String
pnlF1.hiden.add(defSwitchH("zone15", SWITCH,true))                          # specifique switch
pnlF1.hiden.add(defStringH("zone8",DECIMAL, "256.05"))                      # full String
```

exemple : Decimal

![](assets/20220320_214852_ecr03_25.png)

exemple : appel process
appel automatiquement la procédure ex: un combo ou calcul avec retour de donnés...

![](assets/20220320_215300_ecr03_26.png)

* [ ] AltG - > Définition du Combo/Grid


| field      | fonction                                 |
| ------------ | ------------------------------------------ |
| Form       | Combo / Grid                             |
| Name       | nom du process                           |
| PosX,Y     | défini au moment du clique de la souris |
| Rows       | Nombre de ligne horizontale              |
| Separateur | combo: sepStyle noStyle                  |

pensez à l'association de la zone process et name.combo

![](assets/20220320_232730_ecr03_31.png)

* [ ] AltC -> Définiton des titres des  colonnes


| field  | fonction                                 |
| -------- | ------------------------------------------ |
| text   | titre de la colonne                      |
| long   | nombre de caractères                    |
| PosX,Y | défini au moment du clique de la souris |
| Type   | combo TEXT_FREE DIGIT ....               |
| Color  | combo color                              |
| Car    | code par exemple : € $ ¥ ₪ £ %       |

![](assets/20220320_221032_ecr03_32.png)

* [ ] AltI-> Item

enregistrement data des colonnes

![](assets/20220320_221222_ecr03_33.png)


| key   | Fonction                                          |
| ------- | --------------------------------------------------- |
| AltC  | Header Colonne                                    |
| AltI  | Item uniquement combo                             |
| AltP  | liste colonne                                     |
| AltR  | remove colonne                                    |
| AltD  | display combo/grid                                |
| AltS  | recharge à la Définition du Combo/Grid          |
| CtrlV | sauvegarde le combo/grid                          |
| AltQ  | quitter l'envirronement de définition combo/grid |

Résultat :

![](assets/20220320_221446_ecr03_40.png)

---

* [ ] AltM -> Menu:


| key   | Fonction            |
| ------- | --------------------- |
| CtrlV | validation          |
| CtrlP | display menu        |
| AltP  | display full menu   |
| AltS  | refresh saisie menu |

> F9 enregistrement

> F12 return


| field  | fonction                                 |
| -------- | ------------------------------------------ |
| Name   | nom du menu                              |
| PosX,Y | défini au moment du clique de la souris |
| ....   | Item                                     |
| cadre  | combo: 1 ligne  2 lignes                 |
| ....   | combo: Vertical ou Horizontal            |

![](assets/20220323_035654_ecr04_01.png)

exemple:

![](assets/20220323_040650_ecr04_02.png)

---

* [ ] sauvegarde:

![](assets/20220320_233406_ecr03_50png)

dans la sous directorie ./dspf

"name.dspf" fichier json

dans la directorie du programme TermSDA  "Source.nim" que vous pouvez compiler

---

envirronement de travail

TermSDA et Tsource son des executables des terminaux fait avec C++ GTK libvte
ex: Tsource vous permez d'excuter Source dans une fenêtre terminal

![](assets/20220323_190448_ecr10_01.png)

ps:

1. le proc faisant appel à la fonction  FCALL  n'est pas defini
2. la gestion du grid vous est laissé à faire à la main un exemple complet dans exemple
3. nim c -f --gc:orc -d:useMalloc --passc:-flto --passC:-fno-builtin-memcpy --verbosity:0 --hints:off --threads:on -d:release -o:procSDA procSDA.nim
4. creer un dossier placer le programme TermSDA et le programme procSDA dans ce dossier Idem pour TSource
5. creer un sous dossier dspf et obj->(pour compiler TermSDA.ccp fenêtre window)
6. les dossiers:
   .vscode -les procedures et envirronement VSCODE
   exemple -programme nim
   src     -programme terminal ccp
   proc...


| programme | Text                     |
| ----------- | -------------------------- |
| procCurs  | interne(termcurs)        |
| procField | definition Field         |
| procLabel | definition Label         |
| procGrid  | definition Grid/Combo    |
| procMenu  | definition Menu          |
| procPanel | definition Panel         |
| procInit  | ouveture programme SDA   |
| callqry   | combo commun             |
| procJson  | lecture / écriture JSON |
| procSDA   | programme Principal      |
| makefile  | outil pour compiler ccp  |

VSCODE :

**Task Manager** extension
--------------------------

exemple source généré:

```
import termkey
import termcurs
import tables


var callQuery: Table[string, proc(fld : var FIELD)]


type
  FIELD_Fcli00a {.pure.}= enum
    cliNom,
    decimal,
    tproc
const P1: array[FIELD_Fcli00a, int] = [0,1,2]


# MENU -> TEST
var Table = new(MENU)
Table = newMenu("Table", 10, 44, vertical, @["Définition", "Visualisation", "Liste"], line1)


# Panel Fcli00a

var Fcli00a= new(PANEL)

# description
proc dscFcli00a() =
  Fcli00a = newPanel("Fcli00a",1,1,32,132,@[defButton(TKey.F3,"F3",false,true), defButton(TKey.F9,"F9",true,true), defButton(TKey.F10,"F10",true,true)],line1,"Fiche Client")

  # LABEL  -> Fcli00a

  Fcli00a.label.add(defTitle("L02002", 2, 2, "Fiche Client"))
  Fcli00a.label.add(deflabel("L04002", 4, 2, "Nom.......:"))
  Fcli00a.label.add(deflabel("L06002", 6, 2, "Décimal...:"))
  Fcli00a.label.add(deflabel("L09002", 9, 2, "Proc......:"))

  # FIELD -> Fcli00a

  Fcli00a.field.add(defString("cliNom", 4, 14, ALPHA_UPPER,30,"", FILL, "Obligatoire","Nom du client"))
  Fcli00a.field.add(defNumeric("decimal", 6, 14, DECIMAL,9,2,"", EMPTY,"", ""))
  setEdtCar(Fcli00a.field[P1[decimal]], "€")
  Fcli00a.field.add(defString("tproc", 9, 14, FPROC,10,"", EMPTY, "","appel procedure"))
  setProcess(Fcli00a.field[P1[tproc]],"myproc")


#===================================================
proc myproc(fld : var FIELD) =
  var Cell_pos : int = -1
  var Xcombo  = newGRID("myproc",9,14,14,sepStyle)
  var Cell_Pays = defCell("Pays",10,TEXT_FREE,"Cyan")
  setHeaders(Xcombo, @[Cell_Pays])
  addRows(Xcombo, @[ "France" ])
  addRows(Xcombo, @[ "Espagne" ])
  addRows(Xcombo, @[ "Italie" ])

  printGridHeader(Xcombo)
  case fld.text
    of "France"   : Cell_pos = 0
    of "Espagne"   : Cell_pos = 1
    of "Italie"   : Cell_pos = 2
    else : discard

  while true :
    let (keys, val) = ioGrid(Xcombo,Cell_pos)
    case keys
      of TKey.Enter :
        restorePanel(Fcli00a,Xcombo)
        fld.text  = $val[0]
        break
      else: discard

callQuery["myproc"] = myproc
#===================================================




proc main() =
  initTerm(32,132)

  dscFcli00a()
  printPanel(Fcli00a)
  displayPanel(Fcli00a)

  # ONLY -> FOR TEST
  dspMenuItem(Fcli00a,Table,0)
  let nTest = ioMenu(Fcli00a,Table,0)


  #Exemple ------

  while true:
    let  key = ioPanel(Fcli00a)
    case key
      of TKey.PROC :  # for field Process
        if isProcess(Fcli00a,Index(Fcli00a)):
          callQuery[getProcess(Fcli00a,Index(Fcli00a))](Fcli00a.field[Index(Fcli00a)])
      of TKey.F3:
        break
      of TKey.F9:
        break
      of TKey.F10:
        break
      else : discard

  closeTerm()



main()

```
