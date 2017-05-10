package Systems
{
	import flash.events.TouchEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import com.gestureworks.cml.elements.Container;
	import com.gestureworks.cml.elements.Graphic;
	import com.gestureworks.cml.elements.Text;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.cml.components.Component;
	import com.gestureworks.cml.elements.TouchContainer;
	import com.gestureworks.cml.elements.Button;
	import com.gestureworks.cml.elements.Frame;
	import com.gestureworks.cml.elements.WAV;
	import com.gestureworks.cml.elements.MP3;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.cml.utils.DisplayUtils;
	
	import Events.MenuEvent;
	import ui.ViewerMenu;
	import ui.InfoPanel;
	import util.TextContent;
	import util.FileSystem;
	import util.Geometry;
	
	/**
	 * Systems.System
	 *
	 * Super class that all the other system inherits from
	 *
	 * @author Adam Byléhn
	 * @contact adambylehn@hotmail.com
	 */
	
	public class System extends GestureWorks
	{
		protected var _frameThickness:uint = 15;
		protected var _button:Button;
		
		public function System()
		{
			super();
		}
		
		public function Hide():void
		{
		}
		
		// A function to be overidden by child classes
		public function Init():void
		{
			stage.addEventListener(MenuEvent.CLOSE, onClose);
		}
		
		// A function to be overidden by child classes
		public function Update():void
		{
		
		}
		
		private function showComponent(x:int, y:int, component:Component):void
		{
			component.alpha = 1.0;
			component.touchEnabled = true;
			component.scale = 1.0;
			component.x = x;
			component.y = y;
			setChildIndex(component, numChildren - 1);
		}
		
		protected function hideComponent(component:Component):void
		{
			component.alpha = .0;
			component.touchEnabled = false;
			// "Hide" the component
			component.x = 13337; 
			component.y = 13337;
			if (getQualifiedClassName(component.getChildAt(0)).search("WAV") != -1)
			{
				WAV(component.getChildAt(0)).stop();
			}
			if (getQualifiedClassName(component.getChildAt(0)).search("MP3") != -1)
			{
				MP3(component.getChildAt(0)).stop();
			}
		}
		
		protected function switchButtonState(buttonState:String, component:Component, x:int, y:int):void
		{
			// On release
			if (buttonState == "down-state")
			{
				return;
			}
			if (component.alpha > 0)
			{
				hideComponent(component);
			}
			else if (component.alpha == 0)
			{
				showComponent(x, y, component);
			}
		}
		
		protected function createViewer(component:Component, x:int, y:int, width:int, height:int):Component
		{
			component.addEventListener(TouchEvent.TOUCH_BEGIN, onTouch);
			component.className = "component";
			component.x = x;
			component.y = y;
			component.width = width;
			component.height = height;
			component.gestureEvents = true;
			component.gestureList = {"n-drag": true, "n-scale": true, "n-rotate": true};
			component.maxScale = 2.0;
			component.minScale = .2;
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
			var frame:Frame = new Frame();
			frame.targetParent = true;
			frame.mouseChildren = false;
			frame.className = "frame";
			frame.frameThickness = _frameThickness;
			component.addChild(frame);
			return frame;
		}
		
		protected function addViewerMenu(component:Component, close:Boolean, info:Boolean, play:Boolean, pause:Boolean):ViewerMenu
		{
			var menu:ViewerMenu = new ViewerMenu(info, close, play, pause);
			menu.y = 5;
			menu.paddingLeft = component.width - menu.numChildren * 2 * (20 + 3); // 20 + 3 i radius + linestroke in "menubutton.as"
			menu.paddingRight = 10;
			menu.autohide = false;
			menu.visible = true;
			component.addChild(menu);
			return menu;
		}
		
		protected function addInfoPanel(component:Component, title:String, descr:String, descriptionfontSize:Number = 20):InfoPanel
		{
			var infoPanel:InfoPanel = new InfoPanel(descriptionfontSize);
			infoPanel.bkgColor = 0x665533;
			infoPanel.title = title;
			infoPanel.descr = descr;
			component.addChild(infoPanel);
			component.back = infoPanel;
			return infoPanel;
		}
		
		private function onTouch(event:TouchEvent):void
		{
			setChildIndex(Component(event.currentTarget), numChildren - 1);
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
		
		protected function onClose(e:MenuEvent):void
		{
			hideComponent(Component(e.result));
		}
		
		protected function getFilesInDirectoryRelative(directory:String):Array
		{
			return FileSystem.GET_FILES_IN_DIRECTORY_RELATIVE(directory);
		}
		
		protected function isDirectory(path:String):Boolean
		{
			return FileSystem.IS_DIRECTORY(path);
		}
		
		protected function getExtention(path:String):String
		{
			return FileSystem.GET_EXTENTION(path);
		}
		
		protected function getCircle(color:uint, xPos:uint, yPos:uint, radius:Number, alpha:Number = 1):Graphic
		{
			return Geometry.GET_CIRCLE(color, xPos, yPos, radius, alpha);
		}
		
		protected function getRectangle(color:uint, x:uint, y:uint, width:uint, height:uint, alpha:Number = 1):Graphic
		{
			return Geometry.GET_RECTANGLE(color, x, y, width, height, alpha);
		}
		
		protected function getLine(color:uint, startX:int, startY:int, goalX:int, goalY:int, lineWidth:Number, alpha:Number = 1):Graphic
		{
			return Geometry.GET_LINE(color, startX, startY, goalX, goalY, lineWidth, alpha);
		}
	}
}
