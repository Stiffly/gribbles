package Systems 
{
	import Systems.System;
	import com.gestureworks.cml.elements.Graphic;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import com.gestureworks.cml.components.AlbumViewer;
	import com.gestureworks.cml.elements.Album;
	import com.gestureworks.cml.elements.Button;
	import com.gestureworks.cml.elements.Image;
	import com.gestureworks.cml.events.StateEvent;
	import flash.events.Event;
	import flash.net.URLLoader;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class CustomButtonSystem extends System 
	{
	
		private var _buttonMap:Object = new Object();
		private var _albumMap:Object = new Object();
		
		public function CustomButtonSystem() 
		{
			super();
			
		}
		
		override public function Init():void
		{
			for each (var parentPath:String in getFilesInDirectoryRelative("custom"))
			{
				var urlRequest:URLRequest = new URLRequest(parentPath + "/properties.xml");
				var loader:URLLoader = new URLLoader(urlRequest);
				loader.addEventListener(Event.COMPLETE, onXMLLoaded(parentPath));
				
				for each (var file:String in getFilesInDirectoryRelative(parentPath))
				{
					
				}
			}
		}
		
		override public function Update():void
		{
			
		}
		
		override public function Activate():void 
		{
		}
		
		override public function Deactivate():void
		{
		}
		
		private function onXMLLoaded(parentPath:String):Function 
		{
			return function (e:Event):void
			{
				var buttonProperties:XML = new XML();
				buttonProperties = XML(e.target.data);
				var width:uint = buttonProperties.child("width");
				var height:uint = buttonProperties.child("height");
				var x:uint =  buttonProperties.child("x");
				var y:uint =  buttonProperties.child("y");
				var button:Button = new Button();
				button.width = width;
				button.height = height;
				button.x = x;
				button.y = y;
				button.dispatch = "initial:initial:down:down:up:up:over:over:out:out";	
				var img:Image = getImage(parentPath + "/button.png");
				button.hit = getRectangle(x, y, width, height);
				button.initial = img;
				button.down = getRectangle(x, y, width, height);
				button.up = img;
				button.over = getRectangle(x, y, width, height);
				button.out = img;
				button.addEventListener(StateEvent.CHANGE, onClick(parentPath));
				button.init();
				_buttonMap[parentPath] = button;
				addChild(button);
			}
		}
		
		private function getImage(source:String):Image
		{
			var img:Image = new Image();
			img.open(source);
			return img;
		}
		
		private function getRectangle(x:uint, y:uint, width:uint, height:uint):Graphic
		{
			var rect:Graphic = new Graphic;
			rect.shape = "rectangle";
			rect.width = width;
			rect.height = height;
			rect.alpha = 0;
			return rect;
		}
		
		private function onClick(parentPath:String):Function 
		{
			return function (e:Event):void
			{
				trace(parentPath);
			}
		}
	}
}