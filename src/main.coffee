module.exports = PynsistCore =
  config:
    pathToPynsist:
      title: "Path To Pynsist"
      description: "Specify the full path to `pynsist`"
      type: "string"
      default: "pynsist"
      order: 0
    mutePathWarning:
      title: "Mute Path Warning"
      description: "When enabled, warnings about missing path to `pynsist` will be muted"
      type: "boolean"
      default: false
      order: 1
    showBuildNotifications:
      title: "Show Build Notifications"
      description: "Displays color-coded notifications that close automatically after 5 seconds"
      type: "boolean"
      default: true
      order: 2
    clearConsole:
      title: "Clear Console"
      description: "When `console-panel` isn't available, build logs will be printed using `console.log()`. This setting clears the console prior to building."
      type: "boolean"
      default: true
      order: 3
    useWineToRun:
      title: "Use Wine to run"
      description: "When on a non-Windows platform, you can run compiled installers using [Wine](https://www.winehq.org/)"
      type: "boolean"
      default: false
      order: 4
    manageDependencies:
      title: "Manage Dependencies"
      description: "When enabled, third-party dependencies will be installed automatically"
      type: "boolean"
      default: true
      order: 5
  subscriptions: null

  activate: (state) ->
    { CompositeDisposable } = require "atom"
    { generate } = require "./pynsist"
    { getConfig, isPathSetup } = require "./util"
    { platform } = require "os"
    { satisfyDependencies } = require "atom-satisfy-dependencies"

    # Events subscribed to in atom"s system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register commands
    @subscriptions.add atom.commands.add "atom-workspace", "pynsist:generate-script": => generate(@consolePanel, false)
    @subscriptions.add atom.commands.add "atom-workspace", "pynsist:compile-installer": => generate(@consolePanel, true)

    satisfyDependencies("pynsist") if getConfig("manageDependencies") is true
    isPathSetup() if getConfig("mutePathWarning") is false and platform() is "win32"

  deactivate: ->
    @subscriptions?.dispose()
    @subscriptions = null

  consumeConsolePanel: (@consolePanel) ->
