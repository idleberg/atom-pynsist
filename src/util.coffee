module.exports = Util =

  getConfig: (key = "") ->
    meta = require "../package.json"

    if key?
      return atom.config.get("#{meta.name}.#{key}")

    return atom.config.get("#{meta.name}")

  clearConsole: (consolePanel) ->
    try
      consolePanel.clear()
    catch
      console.clear() if @getConfig("clearConsole")

  detectOutput: (relativePath, line, needle) ->
    { existsSync } = require "fs"
    { join } = require "path"

    if line.indexOf(needle.string) isnt -1
      regex = needle.regex
      result = regex.exec(line.toString())
      absolutePath = join(relativePath, result[1])
      doesExist = existsSync absolutePath
      if doesExist is true
        return absolutePath

    return ""

  getPath: (callback) ->
    { spawn } = require "child_process"

    # If stored, return pathToPynsist
    pathToPynsist = @getConfig("pathToPynsist")
    if pathToPynsist.length > 0 and pathToPynsist isnt "pynsist"
      return callback(pathToPynsist)

    # Find makensis
    which = spawn Util.which(), ["pynsist"]

    which.stdout.on "data", ( data ) ->
      path = data.toString().trim()
      atom.config.set("pynsist.pathToPynsist", path)
      return callback(path)

    which.on "close", ( errorCode ) ->
      if errorCode > 0
        Util.isPathSetup()

  isPathSetup: () ->
    { access, constants} = require "fs"

    pathToPynsist = @getConfig("pathToPynsist")

    access pathToPynsist, constants.R_OK | constants.W_OK, (error) ->
      if error
        notification = atom.notifications.addWarning(
          "**pynsist**: No valid \`pynsist\` was specified in your settings or your is not in your `PATH` [environmental variable](http://superuser.com/a/284351/195953)",
          dismissable: true,
          buttons: [
            {
              text: "Open Settings"
              className: "icon icon-gear"
              onDidClick: ->
                atom.workspace.open("atom://config/packages/pynsist", {pending: true, searchAllPanes: true})
                notification.dismiss()
            }
            {
              text: "Ignore",
              onDidClick: ->
                atom.config.set("pynsist.mutePathWarning", true)
                notification.dismiss()
            }
          ]
        )

  notifyOnSucess: (outScript, outFile) ->
    { platform } = require "os"

    buttons = []

    if outFile isnt ""
      message =  "Successfully compiled installer"
      if platform() is "win32" or @getConfig("useWineToRun") is true
        buttons.push({
          text: "Run Installer"
          className: "icon icon-playback-play"
          onDidClick: ->
            Util.runInstaller(outFile)
            notification.dismiss()
        })
    else
      message = "Successfully generated script"

    buttons.push(
      {
        text: "Open Script"
        className: "icon icon-pencil"
        onDidClick: ->
          atom.workspace.open(outScript)
          notification.dismiss()
      }
      {
        text: "Cancel"
        onDidClick: ->
          notification.dismiss()
      }
    )

    notification = atom.notifications.addSuccess(
      message,
      dismissable: true,
      buttons: buttons
    ) if @getConfig("showBuildNotifications")

  runInstaller: (outFile) ->
    { spawn } = require "child_process"
    { platform } = require "os"


    if platform() is "win32"
      try
        # Setting shell to true seems to prevent spawn UNKNOWN errors
        spawn outFile, shell: true
      catch error
        atom.notifications.addWarning("**pynsist**", detail: error, dismissable: true)

    else if @getConfig("useWineToRun") is true
      try
        spawn "wine", [ outFile ]
      catch error
        atom.notifications.addWarning("**pynsist**", detail: error, dismissable: true)

  which: ->
    { platform } = require "os"

    if platform() is "win32"
      return "where"

    return "which"
