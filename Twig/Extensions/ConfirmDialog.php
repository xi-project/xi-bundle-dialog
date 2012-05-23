<?php

namespace Xi\Bundle\DialogBundle\Twig\Extensions;

use \Twig_Environment,
    Symfony\Component\Routing\Router;

/**
 * Author: Henri Vesala <henri.vesala@soprano.fi>
 * 
 */
class ConfirmDialog extends \Twig_Extension
{

    /**
     * @var Twig_Environment
     */
    protected $twig;
    
    /**
     * @var Router
     */
    protected $router;
    
    /**
     * @var string 
     */
    protected $route;
    
    /**
     * @var string 
     */
    protected $template;

    /**
     * @var array 
     */
    protected $defaultArguments;

    /**
     * @var string 
     */
    protected $href;
    
    /**
     * @param Twig_Environment $twig 
     */
    public function __construct(Twig_Environment $twig, Router $router, $route, $template, $defaultArguments = array())
    {
        $this->router  = $router;
        $this->twig    = $twig;
        $this->route = $route;
        $this->template = $template;
        $this->defaultArguments = $defaultArguments;        
    }
    
    public function getFunctions()
    {
        return array('xi_confirmdialog_render' => new \Twig_Function_Method(
            $this, 'confirmDialog', array('is_safe' => array('html'))
        ));
    }

    /**
     * @param array $args
     * @return \Twig_Environment 
     */
    public function confirmDialog($href, array $args = array())
    {

        $this->href = $args['href'] = $href;      
        if(empty($args['title'])&& (!empty($args['header']))){     // automatically sets title if there is header
            $args['title'] = $args['header'];
        }
        
        $this->checkArguments();
        $args['class'] = implode(' ', $this->combineClasses($args));
        $args['data-href'] = $this->getDataHref($args);
        $args['linkText'] = $this->getLinkText($args);
        return $this->twig->render($this->getTemplate($args), array('arguments' => $args));
    }

    /**
     * @param array $args
     * @return string
     */
    protected function getLinkText(array $args)
    {
        return (empty($args['linkText']) ? null : $args['linkText']);
    }

    /**
     *  Gets template file. Default argument template is used if overide is not set.
     *
     * @param array $args
     * @return string 
     */
    protected function getTemplate(array $args) 
    {
        if(isset($args['template'])){
            return $args['template'];
        }
        
        return $this->template;
    }
    
    /**
     * Gets data-href argument. Default argument route "data-route" is used if data-href is not set.
     * 
     * @param array $args
     * @return array 
     */
    protected function getDataHref(array $args)
    {
        if(isset($args['data-href'])){
            return $args['data-href'];
        }
  
        return $this->router->generate($this->route);
    }
 
    /**
     * Combine css classes to single string
     * 
     * @param array $args
     * @return array 
     */
    protected function combineClasses(array $args)
    {
        if(!is_array($this->defaultArguments['class'])){
            if(!empty($this->defaultArguments['class'])){
                $this->defaultArguments['class'] = explode(',', $this->defaultArguments['class']);
            } else {            
                $this->defaultArguments['class'] = array();
            }
        }        
        if(empty($args['class'])){
            $args['class'] = array();
        }        
        return array_merge($args['class'], $this->defaultArguments['class']);
    }
    
    /**
     * Throws an exception if required arguments are not set
     */
    protected function checkArguments()
    {        
        if(empty($this->href)){
            throw new \InvalidArgumentException('argument: href is not set. Confirm dialog does not know what action it confirms!');
        }
    
        if(empty($this->route)) {
            throw new \InvalidArgumentException('argument: data-route is not set. Default data-route value should be placed in your service definition.');
        }
        
        if(empty($this->template)) {
            throw new \InvalidArgumentException('argument: template is not set. Default template shold be placed in your service definition');
        }
        
    }
    
    public function getName()
    {
        return 'confirm_dialog_extension';
    }
}