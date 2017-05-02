package Systems 
{
	import Systems.System;
	import com.gestureworks.cml.components.Component;
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
	
	import com.gestureworks.cml.utils.DisplayUtils;
	
	import util.TextContent;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class CustomButtonSystem extends System 
	{
		// The button map keeps track of all button, with the unique parent folder as key
		private var _buttonMap:Object = new Object();
		// The album map keeps track of all album viewers, with unique parent folder as key
		private var _albumMap:Object = new Object();
		// The supported file formats that can be loaded
		private var _knownFormats:Array = [".png", ".jpg", ".bmp", ".gif", ".jpeg", ".tiff"];
		// Stores the number of children that each album has, used to init albums only once, when all children are loaded
		private var _numChildren:Object = new Object();
		// Member iterator to keep track of how many children has been loaded
		private var _i:uint = 0;
		
		public function CustomButtonSystem() 
		{
			super();
			
		}
		
		override public function Init():void
		{
			for each (var parentPath:String in getFilesInDirectoryRelative("custom"))
			{
				_numChildren[parentPath] = 0;
				// Button properties loaded from XML
				var urlRequest:URLRequest = new URLRequest(parentPath + "/button/properties.xml");
				var loader:URLLoader = new URLLoader(urlRequest);
				loader.addEventListener(Event.COMPLETE, onXMLLoaded(parentPath));
				
				// Create album viewer
				var av:AlbumViewer = createViewer(new AlbumViewer(), 400, 400, 1000, 700) as AlbumViewer;
				av.autoTextLayout = false;
				av.linkAlbums = true;
				av.clusterBubbling = true;
				av.mouseChildren = true;
				av.gestureList = {"2-finger-drag": true, "n-scale": true, "n-rotate": true};
				addChild(av);
				
				// Front
				var front:Album = new Album();
				front.id = "front";
				front.loop = true;
				front.horizontal = true;
				front.applyMask = true;
				front.margin = 8;
				front.mouseChildren = true;
				front.clusterBubbling = false;
				front.dragGesture = "1-finger-drag";
				
				// Back
				var back:Album = new Album();
				back.id = "back";
				back.loop = true;
				back.alpha = 0.4;
				back.horizontal = true;
				back.margin = 8;
				back.clusterBubbling = false;
				back.visible = false;
				//back.dragGesture = "1-finger-drag";
				back.dragAngle = 0;
				
				// Add all the children, images etc.
				for each (var childPath:String in getFilesInDirectoryRelative(parentPath))
				{
					for each (var extention:String in _knownFormats) 
					{	
						if (childPath.toUpperCase().search(extention.toUpperCase()) != -1)
						{
							// Load image
							front.addChild(getImage(childPath, 1000, 700));
							// Update number of children, this is compared against in onFileLoaded function
							_numChildren[parentPath]++;
							// Load its associated description
							var textFile:String = childPath.replace(extention, ".txt");
							var loader2:URLLoader = new URLLoader(new URLRequest(textFile));
							loader2.addEventListener(Event.COMPLETE, onFileLoaded(av, front, back, parentPath));
						}
					}
				}
			}
		}
		
		override public function Update():void
		{
			
		}
		
		override public function Activate():void 
		{
			for each(var b:Button in _buttonMap) 
			{
				b.visible = true;
				b.active= true;
			}
		}
		
		override public function Deactivate():void
		{
			for each(var b:Button in _buttonMap) 
			{
				b.visible = false;
				b.active= false;
			}
		}
		
		// This is the event handler that triggers when the XML file describing the button is loaded
		private function onXMLLoaded(parentPath:String):Function 
		{
			return function (e:Event):void
			{
				// Create button from the XML data
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
				var img:Image = getImage(parentPath + "/button/button.png", width, height);
				button.hit = getRectangle(x, y, width, height);
				button.initial = img;
				button.down = getRectangle(x, y, width, height);
				button.up = img;
				button.over = getRectangle(x, y, width, height);
				button.out = img;
				button.addEventListener(StateEvent.CHANGE, onClick(parentPath));
				button.init();
				// Add tracking of the button by adding it to the button map
				_buttonMap[parentPath] = button;
				addChild(button);
			}
		}
		
		// This handler triggers when a description file is loaded (.txt)
		private function onFileLoaded(av:AlbumViewer, front:Album, back:Album, parentPath:String):Function 
		{
			return function (event:Event):void
			{
				// increment iterator i
				_i++;
				var content:String = URLLoader(event.currentTarget).data;
				// Finds the first newline and creates a text content that is used for the description
				var index:int = content.search("\n");
				back.addChild(createDescription(new TextContent(content.slice(0, index), content.slice(index +1 , content.length))));
				// This is true when all of the description files are loaded
				if (_numChildren[parentPath] ==  _i)
				{
					// When all the description files are loaded we can initiate the albums
					av.front = front;
					av.back = back;
					av.addChild(front);
					av.addChild(back);
					addFrame(av);
					addViewerMenu(av, true, true, false, false);
					DisplayUtils.initAll(av);
					_albumMap[parentPath] = av;
					hideComponent(av);
					_i = 0;
					return;
				}
			}
		}
		
		// Loads an image form the disc
		private function getImage(source:String, width:uint, height:uint):Image
		{
			var img:Image = new Image();
			img.width = width;
			img.height = height;
			img.open(source);
			return img;
		}
		
		// Creates an invisible rectangle
		private function getRectangle(x:uint, y:uint, width:uint, height:uint):Graphic
		{
			var rect:Graphic = new Graphic;
			rect.shape = "rectangle";
			rect.width = width;
			rect.height = height;
			rect.alpha = 0;
			return rect;
		}
		
		// Button handler
		private function onClick(parentPath:String):Function 
		{
			return function (e:StateEvent):void
			{
				// On release
				if (e.value != "up")
					return;
				
				if (_albumMap[parentPath].alpha > 0) {
					hideComponent(_albumMap[parentPath]);
				}
				else if (_albumMap[parentPath].alpha == 0) {
					showComponent(400, 400, _albumMap[parentPath]);
				}
			}
		}
		
		// This is called when a button is clicked and the component is hidden
		private function showComponent(x:uint, y:uint, component:Component):void
		{
			component.alpha = 1.0;
			component.touchEnabled = true;
			component.scale = 1.0;
			component.x = x;
			component.y = y;
			setChildIndex(component, numChildren - 1);
		}
		
		override public function Hide():void 
		{
			for each (var av:AlbumViewer in _albumMap)
			{
				hideComponent(av);
			}
		}
	}
}