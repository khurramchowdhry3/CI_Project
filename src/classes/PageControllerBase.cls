/*
 * Created by: Danail Georgiev - Xoomworks 
 * Created at: 22 March 2016
 * Purpose: A virtual class, which can be inherited by a controller, which needs to communicate with a component controller
 */
public with sharing virtual class PageControllerBase 
{
	private ComponentControllerBase componentController;
    
    public virtual ComponentControllerBase getComponentController()
    {
        return componentController;
    }
    
    public virtual void setComponentController(ComponentControllerBase compController)
    {
        componentController = compController;
    }
    
    public PageControllerBase getThis()
    {
        return this;
    }
}