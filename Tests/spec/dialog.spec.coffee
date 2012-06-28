require "./init.coffee"
# file to test    

ajaxBundleCoffeeDir = "../../vendor/xi/ajax-bundle/Xi/Bundle/AjaxBundle/Resources/coffee/"

require ajaxBundleCoffeeDir + 'ajax-abstract-logic.coffee'
require ajaxBundleCoffeeDir + 'ajax-loader.coffee'
require "../../Resources/coffee/dialog.coffee"

describe "app dialog", ->

    launchElement = null
    dialog = null

    beforeEach ->
        launchElement = $('<a class="confirm-dialog" title="dialog-title" href="/path/to/href" data-href="/path/to/data/href">link</a>')
        dialog = new App.Dialog '.confirm-dialog', { width: 300, modal: true}
        spyOn(dialog, 'displayErrors').andReturn true

    it "creates new dialog", ->
        expect(dialog).toBeDefined()
        expect(dialog.element).toEqual('.confirm-dialog')

    it "checks for errors, valid", ->
        noErrors = dialog.checkForErrors {valid: 'stuff'}, 'success', {}, dialog
        expect(noErrors).toBeFalsy()
        expect(dialog.displayErrors).not.toHaveBeenCalled()

    it "checks for errors, serverside", ->
        serversideError = dialog.checkForErrors {valid: 'stuff'}, 'error', {}, dialog
        expect(serversideError).toBeTruthy()
        expect(dialog.displayErrors).toHaveBeenCalled()

    it "checks for errors, fatal", ->
        fatalError = dialog.checkForErrors "PHP Fatal Error: diibadaada", '', {}, dialog
        expect(fatalError).toBeTruthy()
        expect(dialog.displayErrors).toHaveBeenCalled()

    it "checks for errors, unknown", ->
        msyticError = dialog.checkForErrors '', '', {}, dialog
        expect(msyticError).toBeTruthy()
        expect(dialog.displayErrors).toHaveBeenCalled()

    it "gets data uri", ->
        expect(dialog.getUri(launchElement)).toBe "/path/to/href"

    it "gets header", ->
        header = dialog.getHeader(launchElement, {headerAttribute : 'title'})
        expect(header).toBe "dialog-title"

    it "binds dialog to element", ->
        dialogElem = $('<div></div>')
        dialog.bindDialogToElement dialogElem, launchElement

        expect(dialogElem.attr('id')).toEqual $(launchElement).data('dialog-binded')


describe "confirm dialog", ->

    launchElement = null
    dialog = null

    beforeEach ->
        launchElement = $('<a class="confirm-dialog" href="/path/to/href" data-href="/path/to/data/href">link</a>');
        dialog = new App.ConfirmDialog('.confirm-dialog', { width: 300, modal: true})

    it "gets data uri", ->
        expect(dialog.getUri(launchElement)).toBe "/path/to/data/href"

    # disabled until proper content merged
    xit "loads proper stuff after complete request", ->

