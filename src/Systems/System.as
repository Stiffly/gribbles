package Systems 
{
	/**
	* System.as
	* Super class that all the other system inherits from
	* 
	* @author Adam Byléhn
	* @contact adambylehn@hotmail.com
	*/
	
	import flash.display.Sprite;
	import com.gestureworks.cml.core.CMLObjectList;	
	import com.gestureworks.cml.components.Component;
	import com.gestureworks.cml.elements.Button;

	
	public class System extends Sprite
	{
		public function System():void 
		{
			super();
		}
		// A function to be overidden by child classes
		public function Init():void { }
		// A function to be overidden by child classes
		public function Update():void { }
		
		protected function showComponent(component : Component) : void
		{
			component.alpha = 1.0;
			component.touchEnabled = true;
			component.scale = 1.0;
			component.x = stage.stageWidth / 2 - component.width / 2;
			component.y = stage.stageHeight / 2 - component.height / 2;
			component.rotation = -10.0;
		}
		
		protected function hideComponent(component : Component) : void
		{
			component.alpha = 0.0;
			component.touchEnabled = false;
			component.x = 13337; // "Hide" the component
			component.y = 13337;
		}
		
		protected function switchButtonState( buttonID : String, buttonState : String, component : Object ) : void
		{
			var button : Button  = CMLObjectList.instance.getId(buttonID);
			if (buttonState == "down-state")
				return;
			if (component.alpha > 0) {
				hideComponent(component as Component);
			}
			else if (component.alpha == 0) {
				showComponent(component as Component);
			}
		}
	}
}
