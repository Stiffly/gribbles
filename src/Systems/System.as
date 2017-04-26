package Systems 
{
	/**
	* Systems.System
	* Super class that all the other system inherits from
	* 
	* @author Adam Byléhn
	* @contact adambylehn@hotmail.com
	*/
	
	import com.gestureworks.core.GestureWorks;
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.utils.getQualifiedClassName
	import com.gestureworks.cml.core.CMLObjectList;	
	import flash.events.TouchEvent;
	import com.gestureworks.cml.components.Component;
	import com.gestureworks.cml.elements.TouchContainer;
	import com.gestureworks.cml.elements.Button;
	import com.gestureworks.cml.elements.Frame;
	import com.gestureworks.cml.elements.WAV;
	import com.gestureworks.cml.elements.MP3;
	import com.gestureworks.events.GWGestureEvent;
	import ui.ViewerMenu;
	import ui.InfoPanel;
	

	
	public class System extends GestureWorks
	{
		protected var _frameThickness:uint = 15;
		protected var _button:Button;
		
		public function System()
		{
			super();
		}
		
		public function Hide():void {}
		
		// A function to be overidden by child classes
		public function Init():void { }
		// A function to be overidden by child classes
		public function Update():void { }
		
		private function showComponent(x:int, y:int, component : Component) : void
		{
			component.alpha = 1.0;
			component.touchEnabled = true;
			component.scale = 1.0;
			component.x = x;
			component.y = y;
			stage.setChildIndex(component, stage.numChildren - 1);
		}
		
		protected function hideComponent(component : Component) : void
		{
			component.alpha = 0.0;
			component.touchEnabled = false;
			component.x = 13337; // "Hide" the component
			component.y = 13337;
			if (getQualifiedClassName(component.getChildAt(0)).search("WAV") != -1) {
				WAV(component.getChildAt(0)).stop();
			}
			if (getQualifiedClassName(component.getChildAt(0)).search("MP3") != -1) {
				MP3(component.getChildAt(0)).stop();
			}
		}
		
		protected function switchButtonState(buttonState : String, component : Component, x:int, y:int) : void
		{
			// On release
			if (buttonState == "down-state")
				return;
			if (component.alpha > 0) {
				hideComponent(component);
			}
			else if (component.alpha == 0) {
				showComponent(x, y, component);
			}
		}
		
		protected function createViewer(component : Component, x : int, y : int, width : int, height : int) : Component
		{
			component.addEventListener(TouchEvent.TOUCH_BEGIN, onTouch);
			component.className = "component";
			component.x = x;
			component.y = y;
			component.width = width;
			component.height = height;			
			component.gestureEvents = true;
			component.gestureList = {"n-drag": true, "n-scale": true, "n-rotate": true};
			component.maxScale = 2;
			component.minScale = 0.2;
			// Enable debugging information
			//component.debugDisplay = true;
			return component;
		}
		
		protected function addTouchContainer(component:Component):TouchContainer
		{
			var container:TouchContainer = new TouchContainer();
			container.className = "container";
			container.visible = true;
			container.targetParent = true;
			container.mouseChildren = false;
			container.gestureEvents = false;
			component.addChild(container);
			return container;
		}
		
		protected function addFrame(component:Component):Frame
		{
			var frame : Frame = new Frame();
			frame.targetParent = true;
			frame.mouseChildren = false;   
			frame.className = "frame";
			frame.frameThickness = _frameThickness;
			component.addChild(frame);
			return frame;
		}
		
		protected function addViewerMenu(component:Component, info:Boolean, play:Boolean, pause:Boolean):ViewerMenu
		{
			var menu:ViewerMenu = new ViewerMenu(info, false, play, pause);
			menu.y = -65;
			menu.paddingLeft = 15;
			menu.autohide = false;
			menu.visible = true;
			component.addChild(menu);
			return menu;
		}
		
		protected function addInfoPanel(component:Component, title:String, descr:String):InfoPanel
		{
			var infoPanel:InfoPanel = new InfoPanel();
			infoPanel.bkgColor = 0x665533;
			infoPanel.title = title;
			infoPanel.descr = descr;
			component.addChild(infoPanel);
			component.back = infoPanel;
			return infoPanel;
		}
		
		protected function getFilesInDirectoryRelative(directory:String) : Array
		{
			var root:File = File.applicationDirectory;
			var subDirectory:File = root.resolvePath(directory);
			var relativePaths:Array = new Array();
			for each (var file : File in subDirectory.getDirectoryListing()) {
				relativePaths.push(root.getRelativePath(file, true));
			}
			return relativePaths;
		}

		protected function drag_handler(event:GWGestureEvent):void
		{
			trace("drag");
			event.target.x += event.value.drag_dx * 0.5;
			event.target.y += event.value.drag_dy * 0.5;
		}
		
		protected function scale_handler(event:GWGestureEvent):void
		{
			trace("scale");
			event.target.scaleX += Math.min(event.value.scale_dsx, 1);
			event.target.scaleY += Math.min(event.value.scale_dsy, 1);
		}
		
		protected function rotate_handler(event:GWGestureEvent):void
		{
			trace("rotate");
			var projectedRot:Number = event.target.rotation + Math.min(event.value.rotate_dtheta, 1);
			projectedRot = projectedRot % 90 == 0 ? projectedRot + .1 : projectedRot; 
			event.target.rotation = projectedRot; 
		}
		
		private function onTouch(event:TouchEvent) : void
		{
			stage.setChildIndex(Component(event.currentTarget), stage.numChildren - 1);
		}
		
		public function Deactivate():void
		{
			_button.active = false;
			_button.visible = false;
		}
		
		public function Activate():void
		{
			_button.active = true;
			_button.visible = true;
		}
	}
}
