package Systems 
{
	/**
	* System.as
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
	import com.gestureworks.cml.components.Component;
	import com.gestureworks.cml.elements.TouchContainer;
	import com.gestureworks.cml.elements.Button;
	import com.gestureworks.cml.elements.Frame;
	import com.gestureworks.cml.elements.WAV;
	import com.gestureworks.cml.elements.MP3;
	import ui.ViewerMenu;
	import ui.InfoPanel;

	
	public class System extends GestureWorks
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
			component.rotation = int(Math.round(Math.random() * 180)) - 90;
			if (getQualifiedClassName(component.getChildAt(0)).search("WAV") != -1) {
				WAV(component.getChildAt(0)).play();
			}
			if (getQualifiedClassName(component.getChildAt(0)).search("MP3") != -1) {
				MP3(component.getChildAt(0)).play();
			}
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
		
		protected function switchButtonState(buttonState : String, component : Component ) : void
		{
			// On release
			if (buttonState == "down-state")
				return;
			if (component.alpha > 0) {
				hideComponent(component);
			}
			else if (component.alpha == 0) {
				showComponent(component);
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
			component.maxScale = 2;
			component.minScale = 0.2;
			// Enable debugging information
			//component.debugDisplay = true;
			return component;
		}
		
		protected function addTouchContainer(component:Component):void
		{
			var container:TouchContainer = new TouchContainer();
			container.className = "container";
			container.visible = true;
			container.targetParent = true;
			container.mouseChildren = false;
			container.gestureEvents = false;
			component.addChild(container);
		}
		
		protected function addFrame(component:Component):void
		{
			var frame : Frame = new Frame();
			frame.targetParent = true;
			frame.mouseChildren = false;
			frame.className = "frame";
			component.addChild(frame);
		}
		
		protected function addViewerMenu(component:Component, info:Boolean, close:Boolean, play:Boolean, pause:Boolean):void
		{
			var menu:ViewerMenu = new ViewerMenu(info, close, play, pause);
			menu.y = -65;
			menu.paddingLeft = 400;
			menu.autohide = false;
			menu.visible = true;
			component.addChild(menu);
		}
		
		protected function addInfoPanel(component:Component, title:String, descr:String):void
		{
			var infoPanel:InfoPanel = new InfoPanel();
			infoPanel.bkgColor = 0x665533;
			infoPanel.title = title;
			infoPanel.descr = descr;
			component.addChild(infoPanel);
			component.back = infoPanel;
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
	}
}
