#
# Usage example: new App.Dialog('.dialog', {width: 500})
# Now every element that has class "dialog" will launch a new dialog.
# You must also set href and title to elements to get dialog work properly
#
# dialog
class App.Dialog
    # element to be bound with, jquery ui dialog options, loader class
    constructor: (@element, options, @loader, @errorizers) ->

        settings = {
            headerAttribute: 'title'
            refreshDialogOnOpening: false
        }
        $.extend(settings, options);

        basedialog = $('<div></div>')
        if !loader
            loader = new App.AjaxLoader.Default()

        if !errorizers  or !errorizers.length
            @errorizers = [new App.FatalErrorizer.Default]
        else
            @errorizers.push(new App.FatalErrorizer.Default)

        self = @
        $(@element).live('click', (event) ->
            dialog = basedialog.clone()
            loader.start()

            settings.title = self.getHeader($(this), settings)
            settings.close = () =>
                self.onClose(dialog, settings, this)

            if $(this).data('dialog-binded')
                self.reopenDialog($('#'+$(this).data('dialog-binded')))
                loader.stop()
            else
                $(dialog).load(self.getUri($(this)), (response, status, xhr) =>
                    loader.stop()
                    if !self.checkForErrors(response, status, xhr, dialog)
                        self.loadComplete(dialog, this)
                        self.bindDialogToElement(dialog, this)

                ).dialog(settings)
            return false
        )

    checkForErrors: (response, status, xhr, dialog) =>
        if status == "error"
            this.displayErrors($(dialog),  {'error':{'xhr': xhr}})
        else if response == '' or (typeof(response) == 'string' and response.search(/Fatal error:/i) != -1) # you really don't want to get empty string as response
            this.displayErrors($(dialog), response) #errorizer should know what empty or fatal error response means
        else
            return false

        return true

    # Calls errorizers to show errors
    displayErrors: ($element, response) =>
        for errorizer in @errorizers
            if errorizer.errorize $element, response
                return true

    loadComplete: (dialog, element) ->

    onClose: (dialog, settings, element) ->
        if(settings.refreshDialogOnOpening) #remove old dialogs if we want to load new content
            $(dialog).remove()
            if $(element).data('dialog-binded')
                $(element).removeData('dialog-binded')

    getUri: (element) ->
        $(element).attr('href')

    getHeader: (element, settings) ->
        $(element).attr(settings.headerAttribute)

    bindDialogToElement: (dialog, element) ->
        uniqId = 'dialog-'+ new Date().getTime()
        $(element).data('dialog-binded', uniqId)
        $(dialog).attr('id', uniqId)

    reopenDialog: (dialogContent) ->
        dialogContent.closest('.ui-dialog').show()


#
# Usage example: new App.ConfirmDialog('.confirm-dialog', { width: 300, modal: true})
# You must also set href, data-href and title to elements to get dialog work properly
#
# - data-href should point to your service that provides confirmation message
# - href should point to place where data is really being deleted
# - title is used as dialog header
#
# dialog
class App.ConfirmDialog extends App.Dialog

    # uses data-href so user can remove objects if if javascript is not being used
    getUri: (element) ->
        $(element).data('href')

    loadComplete: (dialog, element) -> 
        $confirmBtn = $('[data-id|="confirm-delete"] > [data-id|="confirm"]')
        $confirmBtn.attr('href', $(element).attr('href'))

        $('[data-id|="confirm-delete"] > [data-id|="cancel"]').live('click', =>
            $(dialog).dialog('close')
            return false
        )


