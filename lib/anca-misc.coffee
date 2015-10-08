AncaMiscView = require './anca-misc-view'
{CompositeDisposable} = require 'atom'
path = require('path')


module.exports = AncaMisc =
  ancaMiscView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @ancaMiscView = new AncaMiscView(state.ancaMiscViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @ancaMiscView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace', 'anca-misc:copy-filepath-to-clipboard': => @copy_filepath_cb(true)
    @subscriptions.add atom.commands.add 'atom-workspace', 'anca-misc:copy-filename-to-clipboard': => @copy_filepath_cb(false)

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @ancaMiscView.destroy()

  serialize: ->
    ancaMiscViewState: @ancaMiscView.serialize()

  toggle: ->
    console.log 'AncaMisc was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()

  copy_filepath_cb: (fullpath) ->
    if editor = atom.workspace.getActiveTextEditor()
      filepath = editor.getPath()
      if not fullpath
        filepath = path.basename(filepath)
      editor.insertText(filepath,{select:true})
      editor.cutSelectedText()
