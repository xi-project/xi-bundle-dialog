# Dialog functionality for Symfony2

DialogBundle provides basic jQueryUI dialog with internal ajax functionality. It has dependency on xi-bundle-ajax that
provides ajax interface and error handling. Dialogbundle dialogs can gracefully handle backend errors thanks to xi-bundle-ajax.




## Dependencies

xi-bundle-ajax
* https://github.com/xi-project/xi-bundle-ajax

## Installing

### deps -file
```
[XiAjaxBundle]
    git=http://github.com/xi-project/xi-bundle-ajax.git
    target=/bundles/Xi/Bundle/AjaxBundle

[XiDialogBundle]
    git=http://github.com/xi-project/xi-bundle-dialog.git
    target=/bundles/Xi/Bundle/DialogBundle
```

### autoload.php file
```php
<?php
'Xi\\Bundle'       => __DIR__.'/../vendor/bundles',
?>
```
### appKernel.php -file
```php
<?php
            new Xi\Bundle\AjaxBundle\XiAjaxBundle(),
            new Xi\Bundle\DialogBundle\XiDialogBundle(),
 ?>
```   
### routing.yml -file
```yml
XiDialogBundle:
    resource: "@XiDialogBundle/Resources/config/routing.yml"
    prefix:   /
``` 

## Dialog

Dialog is basic jQueryUI dialog with internal ajax functionality. On opening it displays loading animation, sends ajax request to your backend
and displays content in dialog after receiving response. Script will load its content according to your element href attribute.

All jQueryUI dialog options are available and also there are also following parameters that you can use:

refreshDialogOnOpening:
    Should dialog content be refreshed if you open it again after you have closed it. (boolean) Default: false

headerAttribute:
    what attribute should be used as header for your dialog. (string) Default: 'title'


The following example is written in Coffeescript.

```coffeescript

new App.Dialog('.dialog', {
    width: 600, 
    position: [null, 100]
    headerAttribute: 'header'
    refreshDialogOnOpening: false
}, optionalYourOwnLoaderClass, optionalYourOwnErrorizerClass)

```

## Confirmdialog

Confirmdialog is a simple ajax dialog for accepting changes that user has made.
Confirmdialog is rendered by Twig extension that accept two arguments: url to target and (array) options.
Options are rendered as attributes of element that launches confirmation dialog.
If you want to set header for your dialog in default configuration please set `header` as one of the options.
`header` also sets elements title if `title` option is not set.
`linkText` is optional, the value is shown like this: <a href="#">linkText</a>
Confirm button copies it's href attribure from the element that launches the dialog, and executes the default behaviour when clicked.

```twig

{{ sba_confirmdialog_render('url_to_what_shoud_be_deleted), {'header': 'header_of_yours', 'linkText': 'text_for_link' 'some_attribute': 'some_attribute_of_yours'}}

```

Confirm dialog assumes that you have AjaxBundle:AjaxElement up and running. Basically you just need to put following line
in your coffeescrpit bootstrap: `new App.AjaxElement.Default '.ajax-link'`. 
Check xi-bundle-ajax https://github.com/xi-project/xi-bundle-ajax for more information.
