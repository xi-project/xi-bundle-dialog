# DialogBundle

Simple dialog inteface.

Requires: XiAjaxBundle and Jquery to work.
 

To use the dialog functionality you must setup your dialog and bind it to certain Jquery selector.

examples:
    new App.Dialog('.dialog', {width: 500})
    new App.Dialog('.modal', {width: 500, modal: true})

 


## Delete confirmation dialog twig extesion

Creates delete button with confirmation functionality

Setup:
git
To use the confirmation dialog functionality you must setup your dialog and bind it to certain Jquery selector ('.confirm-dialog' is a default value).

For default behaviour add this to your JS:   new App.ConfirmDialog('.confirm-dialog', { width: 300, modal: true})

To use delete confirmation dialog you just have to call following in your twig tempalte

{{ xi_confirmdialog_render('TITLE', 'URL', OPTIONS}}

TITLE can be any string. This string is your buttons tooltip and shows up as header in dialog box. 
URL is an url string. This should point to action that handles the deletion. Ie:  url('xxx_youritemtobedeleted_delete', { 'id': tobedeleted.id }))
OPTIONS are an array that contains key value pairs. There are injected to element to be created as attributes.