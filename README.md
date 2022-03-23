# Designer

# Testing 2022-03-21   11h55

* change procSDA procJson 2022-03-21 15h40  modification
* change procMenu 2022-03-23 4h09 Ajustement fonction AltP CrtlP (harmonisation cmd)
* je devrais avoir fini les test ...

---

le projet:
soulager l'intendance et la répétion d'écriture de code , d'avoir tout de suite la visualisation des écrans.

cela m'a permis de tester les deux lib. Termkey et Termcurs. Généralement et en particulier la lib Termcurs lui rajouter quelques fonctions.

pourquoi j'ai dupliqué la lib Termcurs en procCurs:

La lib Termcurs est pour des utilisations dans des projets de gestion ou d'outils. je part du principe que l'on utilise une lib mais que l'on ne doit la modifier afin d'avoir une maintenance qui tende vers le point zéro. D'avoir une lib et un code libre qui gère l’interaction écran près à l'emploi permet de s'occuper de la raison pour laquelle on écrit un programme.

la lib procCurs:

je l'ai ouverte car je n'ai pas seulement utilisée,mais j'ai joué avec, car j'avais besoin d'extrapoler et j'avais beaucoup de manipulation anormal ou la donnée et les procédures était intimement lier et les dépendances étaient trop profonde.
dedans il y a beaucoup de subtilités et cela va même jusqu'à générer du code à la volé (cela aurait pu être fait avec Termcurs)
l'ouverture m'a permis de soulager et d'avoir accès directement (le soft est lourd plusieurs millier de lignes)

je souhaite que cela permette pour les débutants et plus d'étudier NIM-LANG un language qui n'a rien à envier des autres.

cela permet d'avoir des programmes  léger en terme d'occupation mémoire simple à la lecture et démontre que l'on peut faire beaucoup de chose avec du pure Nim sans apport de lib externe ecrite dans un autre language . assez de blabla regardont de quoi il s'agit.

il utilise la bibliothèque Termkey Termcurs  utilise la sourie pour naviguer et selectioner...

![](assets/20220315_030352_ecr01.png)

* [ ] New permet de creer un formulaire

![](assets/20220315_030810_ecr01_01.png)

titleTerm.: Nom étendu du fichier comprenant l'ensemble des panels
"FICHE CLIENT"

fileTerm..: Nom du fichier  (exemple.dspf)
"cli001"

> F9  enregistre

> F12 abandon

![](assets/20220315_031539_ecr01_02.png)

---

* [ ] création du panel

![](assets/20220315_032120_ecr01_03.png)

* [ ] choix : creer = 999 add panel sinon cliquer sur une ligne

![](assets/20220315_032658_ecr01_04.png)

* [ ] Saisie de la structure du panel

  saisie clavier
  up / down -- tab / tabs -- enter pour valider la zone de sasie et passer à la zone suivante

![](assets/20220315_033532_ecr02_01.png)

Name......: Obligatoire le référencement et le panel sont lier voir source

Cadre.....: appuyer sur une touche, le choix apparaît ligne1 = 1 ligne

![](assets/20220315_033957_ecr02_02.png)

les touches de fontion F1..F24 appuyer sur la bar d'espacemant pour activé la fonction

puis associer le controle par défault des zones comprise dans le panel

> *F3* n'a pas besoin de crontôle ex: = exit programe
>
> *F9 F11* on besoin de faire le contrôle car les données ont des conséquences
>
> vous pouvez dans le source affecter à la main d'autre valeur  ex CtrlV
> leurs donner un text plus explicite ex F9 = F9 Enrg.
>
> ex:`defButton(TKey.F3,"F3 Exit.",false)` `defButton(TKey.F9,"F9 Enrg.",true)` `defButton(TKey.CtrlV,"",true)`

---

paneaux de definition des labels Fields Menus Combo/Grid

![](assets/20220315_133712_ecr03_01.png)

pointer la sourie pour positioner l'objet que vous voulez décrire.

altL -> Label  CtrlV valide le label

altT -> Titre

altF -> Field

altM -> Menu   altP display de tous les  menus

altG -> Combo/Grid

altD -> affichage des objet Label Field Menu

altO -> réordonner les objet Label Field

altR -> remove les objet Label Field Menu Combo/Grid

altS -> réaffichage du terminal

CtrlQ -> fermeture du panel retour au menu principal

---

titre

![](assets/20220315_135205_ecr03_11.png)

vaidation CtrlV

![](assets/20220315_135328_ecr03_12.png)

label Idem ex nom....:

![](assets/20220315_143234_ecr03_13.png)

---

Field altF
choix ajouter ou modifier

![](assets/20220315_143608_ecr03_21png)

definition de zone Nom

![](assets/20220315_144050_ecr03_22png)

defintion attribut

![](assets/20220315_144139_ecr03_23png)

veuillez faire enter ou tab sur chaque zone

With -> nombre d'caractère

Scal -> Nombre de décimal après la virgule

Empty-> Vide = on sinon la zone est obligatoire

Error -> message ce rapportant à la zone pour l'utilisateur

Help -> aide avec la touche Ctrl H

Protect -> falg interdisant la sasie ou modification est utile lors de saisie de clef de table et modification des zones si rapportant

exemple : Decimal

![](assets/20220320_214852_ecr03_25.png)

exemple : appel process

![](assets/20220320_215300_ecr03_26.png)

exemple: combo

Alt G

pensez association de la zone process et name.combo

Définition du Combo/Grid

![](assets/20220320_232730_ecr03_31.png)

definiton des titre des  colonnes

Alt C

![](assets/20220320_221032_ecr03_32.png)

enregistrement data pour les colonnes

Alt I   Item

![](assets/20220320_221222_ecr03_33.png)

Alt C entete

Alt I Item uniquement combo

Alt P liste colonne

Alt R remove colonne

Alt D display combo/grid

Alt S retour à la Définition du Combo/Grid

Résultat :

![](assets/20220320_221446_ecr03_40.png)

Idem pour le Grid sans les items

pour sauvegarder le combo/grid  Ctrl V

pour quitter l'envirronement de définition combo/grid Alt Q

---

sauvegarde:

![](assets/20220320_233406_ecr03_50png)

dans la sous directorie ./dspf

name.dspf fichier json

dans la directorie du programme TermSDA

source.nim

que vous pouvez compiler

envirronement de travail

TermSDA et Tsource son des executables des terminaux fait avec C++ GTK
ex: Tsource vous permez d'excuter Source dans une fenetre terminal

![](assets/20220323_190448_ecr10_01.png)


ps:

1. le proc du FCALL n'est pas defini
2. la gestion du grid vous est laissé à faire à la main un exemple complet dans exemple
3. nim c -f --gc:orc -d:useMalloc --passc:-flto --passC:-fno-builtin-memcpy --verbosity:0 --hints:off --threads:on -d:release -o:procSDA procSDA.nim
4. creer un dossier placer le programme TermSDA et le programme procSDA dans ce dossier Idem pour TSource
5. creer un sous dossier dspf et obj
6. .vscode -les procedures et envirronement VSCODE
7. exemple -programme nim
8. src     -programme terminal ccp
9. proc...


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

   Task Manager extension

   exemple de code

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

Menu:

Ctrl V  validation

Ctrl P  display menu

Alt P   display full menu

Alt S   refresh saisie menu

F9 enregistrement

F12  return

Name : nom du menu

cadre : line1  | line2 ||

Vertical ou Horizontal

![](assets/20220323_035654_ecr04_01.png)

exemple:

![](assets/20220323_040650_ecr04_02.png)
