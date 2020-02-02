module.exports = Pynsist =

  generate: (consolePanel, runMakensis) ->
    { clearConsole, detectOutput, getConfig, getPath, notifyOnSucess } = require "./util"
    { spawn, exec } = require "child_process"
    { dirname } = require "path"

    editor = atom.workspace.getActiveTextEditor()

    unless editor?
      atom.notifications.addWarning("**pynsist**: No active editor", dismissable: false)
      return

    script = editor.getPath()
    scriptPath = dirname script
    args = [script]
    scope  = editor.getGrammar().scopeName

    args.push "--no-makensis" if runMakensis is false

    if script? and scope is "source.cfg.pynsist"
      editor.save() if editor.isModified()

      getPath (pathToPynsist) ->
        clearConsole(consolePanel)

        # Let's go
        pynsist = spawn pathToPynsist, args
        outFile = ""
        outScript = ""

        pynsist.stdout.on "data", (line) ->
          try
            consolePanel.log(line.toString())
          catch
            console.log(line.toString())

        # pynsist currently outputs to stderr only (v1.12)
        pynsist.stderr.on "data", (line) ->
          try
            consolePanel.log(line.toString())
          catch
            console.log(line.toString())

          outScript = detectOutput(scriptPath, line, { string: "Writing NSI file to ", regex: /Writing NSI file to (.*)\r?\n/g }) if outScript is ""
          outFile = detectOutput(scriptPath, line, { string: "Installer written to ", regex: /Installer written to (.*)\r?\n/g }) if outFile is "" and runMakensis is true

        pynsist.on "close", ( errorCode ) ->
          if errorCode is 0 and outScript isnt ""
            return notifyOnSucess(outScript, outFile) if getConfig("showBuildNotifications")
          else
            notification = atom.notifications.addError(
              "**pynsist**",
              detail: "Something went wrong. See the console for details.",
              dismissable: true,
              buttons: [
                {
                  text: "Open Console"
                  className: "icon icon-code"
                  onDidClick: ->
                    atom.openDevTools()
                    notification.dismiss()
                }
                {
                  text: "Cancel",
                  onDidClick: ->
                    notification.dismiss()
                }
              ]

            ) if getConfig("showBuildNotifications")
    else
      # Something went wrong
      atom.beep()
