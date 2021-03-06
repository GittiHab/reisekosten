electron = require('electron')
fs = require 'fs'
path = require 'path'
mkdirp = require 'mkdirp'
# Module to control application life.
app = electron.app
# Module to create native browser window.
BrowserWindow = electron.BrowserWindow

# Keep a global reference of the window object, if you don't, the window will
# be closed automatically when the JavaScript object is garbage collected.
mainWindow = null

# Globals
## Data path
global['DataPath'] = path.normalize app.getPath('appData') + '/Pius Ladenburger/Reisekostenabrechnung'
if not fs.existsSync global['DataPath']
  mkdirp global['DataPath']

createWindow = ->
  # Create the browser window.
  mainWindow = new BrowserWindow {width: 1070, height: 600}

  # and load the index.html of the app.
  mainWindow.loadURL 'file://' + __dirname + '/gui/html/index.html'

  # Open the DevTools.
#  mainWindow.webContents.openDevTools()

  # Emitted when the window is closed.
  mainWindow.on 'closed', ->
    # Dereference the window object, usually you would store windows
    # in an array if your app supports multi windows, this is the time
    # when you should delete the corresponding element.
    mainWindow = null

# This method will be called when Electron has finished
# initialization and is ready to create browser windows.
# Some APIs can only be used after this event occurs.
app.on 'ready', createWindow

# Quit when all windows are closed.
app.on 'window-all-closed', ->
  app.quit()


app.on 'activate', ->
  # On OS X it's common to re-create a window in the app when the
  # dock icon is clicked and there are no other windows open.
  if mainWindow is null
    createWindow()

# In this file you can include the rest of your app's specific main process
# code. You can also put them in separate files and require them here.
