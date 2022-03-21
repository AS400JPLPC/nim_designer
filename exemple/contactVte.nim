import gintro/gdk except Window
import gintro/pango
import gintro/[gtk, glib, gobject, vte]
import strformat

{.warning[CStringConv]: off.}

#var cmd: array[2, cstring] = ["/bin/bash".cstring, cast[cstring](0)]
var pid = 0
var terminal* : Terminal
var window* : Window


let ALTF4 : bool  = true # ALT_F4 ATVIVE

var ROW : Natural  # the desired number of columns
var NROW : Natural # the desired number of rows

let VTENAME : string = "VTE-TERM3270"

let VTEFONT : string = "DejaVu Sans Mono"

proc app_exit(win: Window) = mainQuit()

proc exit_terminal(widget: Terminal, status: int) = quit(0)

proc on_title_changed*(widget: vte.Terminal) =
  window.setTitle(widget.getWindowTitle())
  showAll(window)

proc on_resize_window*(widget: vte.Terminal, row : int ; nrow :int) =
  widget.setSize(row,nrow)
  showAll(window)

#-------------------------------------
# traitement ALT+F4
#-------------------------------------
proc key_press_ALTF4(win: Window;event :Event ): bool =

  if (ALTF4 == true) :
    var dialog : Dialog = newDialog()
    dialog.setTitle("MESSAGE-ALT-F4")
    dialog.setResizable(false)
    dialog.setDeletable(false)
    dialog.defaultSize = (250, 50)
    dialog.position = WindowPosition.center
    dialog.borderWidth = 20
    discard dialog.addButton("Cancel", 1)
    discard dialog.addButton("Continue", 2)

    var reponse :int  = dialog.run();

    destroy(dialog)

    case reponse
      of  1:
          app_exit(win)
          return false
      else :discard

  return true

# parametrage pour simuler XTERM

proc  init_Terminal() =
  var font_terminal : string                            #  resize  title  font

  # size default
  var scrn = getDefaultScreen()
  ROW  = 132
  NROW = 32

  # seach max size
  if getWidth(scrn) <= int32(1600) and getHeight(scrn)  >= int32(1024) :
    font_terminal = fmt"{VTEFONT} 13" #  généralement 13"... 15"
    ROW  = 132
    NROW = 32
  if getWidth(scrn) <= int32(1920) and getHeight(scrn)  >= int32(1080) :
    font_terminal = fmt"{VTEFONT} 15" #  généralement 17"... 22"
    ROW  = 152
    NROW = 42
  if getWidth(scrn) > int32(1920)  :
    font_terminal = fmt"{VTEFONT} 15" #  ex: 2560 x1600 => 27"
    ROW  = 172
    NROW = 52

  terminal.setSize( ROW, NROW)                          #  size du terminal

  window.setTitle( VTENAME)                             #  titre du terminal de base

  terminal.setFont(newFontDescription(font_terminal))   #  font utilisé

  #recommendation scroll/pagination programmation manuel pour apllication spécifique  scroll=0/false

  terminal.setScrollbackLines(0)                        #  désactiver historique = 0.

  terminal.setScrollOnOutput(false)                     #  défilement

  terminal.setRewrapOnResize(false)                     #  Contrôle si le terminal remballera ou non son contenu,
                                                        #  y compris l'historique de défilement si resize
                                                        # attention résultat imprévu > true test oblogatoire

  discard terminal.setEncoding("UTF-8")                 #  UTF8

  terminal.setMouseAutohide(true)                       # cacher le curseur de la souris quand le clavier est utilisé.

  terminal.setCursorBlinkMode(CursorBlinkMode.on)       # on/off

  terminal.setCursorShape(CursorShape.`block`)          # `block` = 0 ibeam =1  underline= 2


proc newApp() =


  window = newWindow()
  window.setPosition(WindowPosition.centerAlways)
  window.setResizable(false)
  window.setDeletable(false)



  let envPath= "/home/soleil/NimScreen/"

  let vPROG = "/home/soleil/NimScreen/Contact"
  var argv: seq[string]
  argv.add(vPROG)

# pensez à la possibilité de mettre le nom programme + autre argument   dans vPROG
# import os
# let programName = getAppFilename() #your programme
# let arguments = commandLineParams() # programme call ...ect
# var cmd: array[2, cstring] = [argument[1].cstring, cast[cstring](0)]

  terminal = newTerminal()
  init_Terminal()


  # recuperation du PID ex si altf4 kill du programme child
  #[ if not terminal.spawnSync(
      cast[PtyFlags](0),
      "",
      argv,
      envPath,
      {SpawnFlag.leaveDescriptorsOpen},
      nil,
      nil,
      pid,
      nil
  ):
  ]#



  # recuperation du PID ex si altf4 kill du programme child
  if not terminal.spawnSync(
      {},
      envPath,
      argv,
      [],
      {},
      nil,
      nil,
      pid,
      nil
  ):
      echo "Terminal Error!"
      quit(QuitFailure)


  window.connect("delete-event", key_press_ALTF4)

  window.connect("destroy", app_exit)
  terminal.connect("child-exited", exit_terminal)
  terminal.connect("window-title-changed", on_title_changed)
  terminal.connect("resize-window", on_resize_window)


  window.add(terminal)
  showAll(window)

proc main =
    gtk.init()
    newApp()
    gtk.main()

main()
