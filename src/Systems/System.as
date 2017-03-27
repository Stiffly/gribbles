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
	import com.gestureworks.cml.elements.TouchContainer;
	import com.gestureworks.cml.elements.Button;
	import com.gestureworks.cml.elements.Frame;

	
	public class System extends Sprite
	{
		public function System()
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
		
		protected function switchButtonState( buttonID : String, buttonState : String, component : Component ) : void
		{
			if (buttonState == "down-state")
				return;
			if (component.alpha > 0) {
				hideComponent(component as Component);
			}
			else if (component.alpha == 0) {
				showComponent(component as Component);
			}
		}
		
		protected function createViewer(component : Component, x : int, y : int, width : int, height : int) : Component
		{
			component.className = "component";
			component.x = x;
			component.y = y;
			component.width = width;
			component.height = height;			
			component.gestureEvents = true;
			component.gestureList = {"n-drag": true, "n-scale": true, "n-rotate": true};
			
			var container:TouchContainer = new TouchContainer();
			container.className = "container";
			container.visible = true;
			container.targetParent = true;
			container.mouseChildren = false;
			container.gestureEvents = false;
			container.init();
			component.addChild(container);

			var frame : Frame = new Frame();
			frame.className = "frame";
			frame.init();
			component.addChild(frame);
			
			component.init();
			return component;
		}
	}
}
