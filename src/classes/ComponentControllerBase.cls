/*
 * Created by: Danail Georgiev - Xoomworks 
 * Created at: 22 March 2016
 * Purpose: An abstract class, which can be inherited by a component controller to provide communication with parent page controller
 */
public with sharing abstract class ComponentControllerBase 
{
    public transient PageControllerBase pageController;
    
    public PageControllerBase getPageController()
    {
        return this.pageController;
    }
    
    public void setPageController(PageControllerBase pgController)
    {
        if (pgController != null)
        {
            pageController = pgController;
            pageController.setComponentController(this);
            extendedSetterActions();  		
        }
    }
    
	/*public transient PageControllerBase pageController
    {
        get;
        set
        {
            if (value != null)
            {
                pageController = value;
                pageController.setComponentController(this);
        		extendedSetterActions();  		
            }
        }
    }
    */
    public abstract void extendedSetterActions();
    

}