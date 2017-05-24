package Systems
{
	import Components.Audio;
	import Components.TextBox;
	import com.gestureworks.cml.elements.Album;
	import com.gestureworks.cml.elements.Image;
	import flash.display.DisplayObjectContainer;
	import flash.events.TouchEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;
	import flash.display.DisplayObject;
	
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
	import util.LayerHandler;
	
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
		
		static public function set FrameThickness(val:int):void  { _frameThickness = val; }
		static protected var _frameThickness:int = 0;
		
		static public function set FrameColor(val:uint):void  { _frameColor = val; }
		static protected var _frameColor:uint = 0xFF0000;
		
		static public function set ComponentWidth(val:int):void  { _componentWidth = val; }
		static protected var _componentWidth:int = 0;
		
		static public function set ComponentHeight(val:uint):void  { _componentHeight = val; }
		static protected var _componentHeight:int = 0;
		
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
		
		protected function showComponent(x:int, y:int, component:Component):void
		{
			component.visible = true;
			component.touchEnabled = true;
			component.scale = 1.0;
			component.x = x;
			if (component.back)
			{
				component.back.visible = false;
			}
			if (component.parent is Audio)
			{
				Audio(component.parent).Play();
			}
			component.y = y;
			component.rotation = 1;
			LayerHandler.BRING_TO_FRONT(component);
		}
		
		// Loads an image from the disc
		protected function getImage(source:String, width:uint, height:uint):Image
		{
			var img:Image = new Image();
			img.width = width;
			img.height = height;
			img.open(source);
			return img;
		}
		
		protected function hideComponent(component:Component):void
		{
			component.visible = false;
			component.touchEnabled = false;
			// "Hide" the component
			component.x = 13337;
			component.y = 13337;
			if (component.parent is Audio)
			{
				Audio(component.parent).Stop();
			}
			if (component is TextBox)
			{
				TextBox(component).Kill();
			}
		}
		
		protected function switchButtonState(buttonState:String, component:Component, x:int, y:int):void
		{
			// On release
			if (buttonState == "down-state")
			{
				return;
			}
			if (component.visible)
			{
				hideComponent(component);
			}
			else if (!component.visible)
			{
				showComponent(x, y, component);
			}
		}
		
		protected function createViewer(component:Component, width:int, height:int):Component
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
			component.minScale = .5;
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
			frame.frameColor = _frameColor;
			frame.frameAlpha = 0.5;
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
			if (close && !info && !play && !pause)
			{
				menu.y = -30;
				menu.paddingLeft = component.width - 10;
			}
			else
			{
				menu.y = 5;
				menu.paddingLeft = component.width - menu.numChildren * 2 * (20 + 3); // 20 + 3 is radius + linestroke in "menubutton.as"
				menu.paddingRight = 10;
			}
			menu.autohide = false;
			menu.visible = true;
			component.addChild(menu);
			return menu;
		}
		
		protected function addInfoPanel(component:*, title:String, descr:String):InfoPanel
		{
			var infoPanel:InfoPanel = new InfoPanel();
			infoPanel.bkgColor = 0x000000;
			infoPanel.title = title;
			infoPanel.descr = descr;
			component.addChild(infoPanel);
			component.back = infoPanel;
			return infoPanel;
		}
		
		protected function onTouch(event:TouchEvent):void
		{
			LayerHandler.BRING_TO_FRONT(Component(event.currentTarget));
		}
		
		public function Deactivate():void
		{
		}
		
		public function Activate():void
		{
		}
		
		protected function onClose(e:MenuEvent):void
		{
			hideComponent(Component(e.result));
		}
		
		protected function createCustomButton(key:String, bx:int, by:int, bw:int, bh:int):Button
		{
			var button:Button = new Button();
			button.width = bw;
			button.height = bh;
			button.x = bx;
			button.y = by;
			button.dispatch = "initial:initial:down:down:up:up:over:over:out:out:hit:hit";
			var img:Image = getImage(key + "/button/button.png", button.width, button.height);
			var downImg:Image = getImage(key + "/button/button.png", button.width, button.height);
			downImg.alpha = 0.5;
			
			if (key == "custom/1A")
			{
				// Special logic for too big image A
				var hitBox:Graphic = getRectangle(0x000000, button.x, button.y, 51, 47, 0);
				hitBox.x = 1665 - button.x;
				hitBox.y = 372 - button.y;
				button.hit = hitBox;
			}
			else
			{
				button.hit = getRectangle(0x000000, 0, 0, button.width, button.height, 0);
			}
			
			button.initial = img;
			button.down = downImg;
			button.up = img;
			button.over = downImg;
			button.out = img;
			button.init();
			return button;
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
		
		protected function getCircle(color:uint, xPos:int, yPos:int, radius:Number, alpha:Number = 1):Graphic
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
		
		protected function bringToFront(object:*):void
		{
			LayerHandler.BRING_TO_FRONT(object);
		}
		
		protected function recursiveInit(component:*):void
		{
			DisplayUtils.initAll(component);
		}
	}
}
