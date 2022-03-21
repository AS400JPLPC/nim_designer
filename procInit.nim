#===================================================
# Init base
#===================================================
proc ViewDspf() : string =
  var Xcombo  = newGRID("CELLINIT",1,1,25,sepStyle)
  var g_id    = defCell("ID",3,DIGIT)
  var g_text  = defCell("File",80,TEXT_FREE)
  var g_last  = defCell("Création",20,TEXT_FREE)
  var g_upd   = defCell("Update",20,TEXT_FREE)
  setTerminal()


  setHeaders(Xcombo, @[g_id, g_text, g_last, g_upd])
  printGridHeader(Xcombo)
  var g_numID = 0
  for kind, path in walkDir("dspf"):
    addRows(Xcombo, @[setID(g_numID), $path ,
            getLastAccessTime(fmt"./{$path.strip()}").format("yyyy-MM-dd  hh:mm") ,
            getLastModificationTime(fmt"./{$path.strip()}").format("yyyy-MM-dd  hh:mm") ]
          )


  while true :
    let (keys, val) = ioGrid(Xcombo)

    case keys
      of TKey.Enter :
        result  = $val[1]
        break
      of TKey.Escape :
        result  = "None"
        break
      of TKey.PageUp :
        keyG = pageUpGrid(Xcombo)
        if keyG == TKey_Grid.PGup:
          gotoXY(terminalHeight(),terminalWidth()-20); stdout.write "Prior"
        else:
          gotoXY(terminalHeight(),terminalWidth()-20);  stdout.write "Home "
      of TKey.PageDown :
        keyG = pageDownGrid(Xcombo)
        if keyG == TKey_Grid.PGdown:
          gotoXY(terminalHeight(),terminalWidth()-20); stdout.write "Next "
        else:
          gotoXY(terminalHeight(),terminalWidth()-20); stdout.write "End  "
      else : continue



proc LoadInit(): bool =

  type
    FIELD_FormInit {.pure.}= enum
      vTitleTerm,
      vFileTerm
  const F_init: array[FIELD_FormInit, int] = [0,1]

  var FormInit= new(PANEL)
  FormInit = newPanel("FormInit",1,1,10,80,@[defButton(TKey.F9,"Enrg.",true), defButton(TKey.F12,"Return")],line1,"Définition JSON")

  # LABEL  -> FormInit
  FormInit.label.add(deflabel("L03002", 3, 2, "titleTerm.:"))
  FormInit.label.add(deflabel("L05002", 5, 2, "fileTerm..:"))

  # FIELD -> FormInit
  FormInit.field.add(defString("vTitleTerm", 3, 13, ALPHA_NUMERIC_UPPER,30,"", FILL, "Obligatoire",
          "Title windows Terminal"))
  FormInit.field.add(defString("vFileTerm", 5, 13, ALPHA_NUMERIC,15,"", FILL, "Obligatoire or Exist file",
          "File name for .dspf"))




  var fDspf : string
  var g_pos : int = -1
  var comboM  = newGRID("INIT",1,1,3,sepStyle)
  var g_line  = defCell("Menu",10,TEXT_FREE)





  if not dirExists("dspf") : createDir("dspf")

  setTerminal()

  setHeaders(comboM, @[g_line])
  addRows(comboM, @["New"])
  addRows(comboM, @["Recovery"])
  addRows(comboM, @["Exit"])
  printGridHeader(comboM)

  while true :
    setTerminal()
    let (keys, val) = ioGrid(comboM,g_pos)

    case keys
      of TKey.Enter :
        fDspf  = $val[0]
        case fDspf
          of "New"  :
            printPanel(FormInit)
            displayPanel(FormInit)

            while true:
              let  key = ioPanel(FormInit)
              case key
                of TKey.F9:
                  titleTerm =FormInit.getText(F_Init[vTitleTerm])
                  fileTerm  =fmt"{FormInit.getText(F_Init[vFileTerm]).strip()}.dspf"
                  if fileExists(fmt"./dspf/{$fileTerm}") :
                    setError(FormInit.field[F_Init[vFileTerm]],true)
                  else : return true
                of TKey.F12: break
                else : discard

          of "Recovery" :
            fDspf = ViewDspf()
            if fDspf != "None" :
              jsonPanel = parseFile (fmt"./{$fDspf.strip()}")
              titleTerm = jsonPanel["titleTerm"].getStr()
              fileTerm  = jsonPanel["fileTerm"].getStr()
              loadBASE()
              return true
            else : discard

          of "Exit" : return false

          else : discard

      else: discard

  setTerminal()