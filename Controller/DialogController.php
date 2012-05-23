<?php

namespace Xi\Bundle\DialogBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;

/**
 * Dialog contains common dialog functionality
 * 
 */
class DialogController extends Controller
{
    
    public function deleteAction()
    {
        return $this->render('XiDialogBundle:Dialog:delete.html.twig');
    }
   
}
