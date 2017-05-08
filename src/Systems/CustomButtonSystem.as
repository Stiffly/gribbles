package Systems
{
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.net.URLLoader;
	
	import com.gestureworks.cml.components.AlbumViewer;
	import com.gestureworks.cml.components.ImageViewer;
	import com.gestureworks.cml.elements.Album;
	import com.gestureworks.cml.elements.Button;
	import com.gestureworks.cml.elements.Image;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.components.Component;
	import com.gestureworks.cml.elements.Graphic;
	import com.gestureworks.cml.elements.TouchContainer;
	import com.gestureworks.cml.utils.DisplayUtils;
	
	import Components.TextBox;
	import Systems.System;
	import util.TextContent;
	
	/**
	 * Systems.CustomButtonSystem
	 *
	 * A custom button system that dynamically loads buttons and contents from
	 * folders located in bin/custom. It loads a required properties.xml file
	 * for each folder which determines the behavior of the buttons/content.
	 * Each folder represents a new button in the scene.
	 *
	 * @author Adam Byléhn
	 */
	
	public class CustomButtonSystem extends System
	{
		// The button map keeps track of all button, with the unique parent folder as key
		private var _buttonMap:Object = new Object();
		// The album map keeps track of all album viewers, with unique parent folder as key
		private var _albumMap:Object = new Object();
		private var _imageMap:Object = new Object();
		// The textbox map keeps track of all textboxes, with unique parent folder as key
		private var _textBoxMap:Object = new Object();
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
			super.Init();
			for each (var parentPath:String in getFilesInDirectoryRelative("custom"))
			{
				_numChildren[parentPath] = 0;
				// Button properties loaded from XML
				var urlRequest:URLRequest = new URLRequest(parentPath + "/button/properties.xml");
				var loader:URLLoader = new URLLoader(urlRequest);
				loader.addEventListener(Event.COMPLETE, onXMLLoaded(parentPath));
			}
		}
		
		override public function Update():void
		{
			for each (var tb:TextBox in _textBoxMap)
			{
				tb.Update();
			}
		}
		
		override public function Activate():void
		{
			for each (var b:Button in _buttonMap)
			{
				b.visible = true;
				b.active = true;
			}
		}
		
		override public function Deactivate():void
		{
			for each (var b:Button in _buttonMap)
			{
				b.visible = false;
				b.active = false;
			}
		}
		
		// This is the event handler that triggers when the XML file describing the button is loaded
		private function onXMLLoaded(parentPath:String):Function
		{
			return function(e:Event):void
			{
				// Create button from the XML data
				var buttonProperties:XML = new XML();
				buttonProperties = XML(e.target.data);
				var type:String = buttonProperties.child("type");
				var width:uint = buttonProperties.child("width");
				var height:uint = buttonProperties.child("height");
				var x:uint = buttonProperties.child("x");
				var y:uint = buttonProperties.child("y");
				var button:Button = new Button();
				button.width = width;
				button.height = height;
				button.x = x;
				button.y = y;
				button.dispatch = "initial:initial:down:down:up:up:over:over:out:out:hit:hit";
				var img:Image = getImage(parentPath + "/button/button.png", width, height);
				if (parentPath == "custom/1A")
				{
					// Special logic for too big image A
					var hitBox:Graphic = getRectangle(x, y, 51, 47);
					hitBox.x = 1665 - button.x;
					hitBox.y = 372 - button.y;
					button.hit = hitBox;
				}
				else
				{
					button.hit = getRectangle(x, y, width, height);
				}
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
				
				if (type.toUpperCase() == "ALBUM")
				{
					// Get the number of children, exluding directories
					var children:Array = getFilesInDirectoryRelative(parentPath);
					var numChildren:int = children.length;
					for each (var child:String in children)
					{
						if (isDirectory(child))
						{
							numChildren--;
						}
					}
					// An image with associated description file
					if (numChildren == 2)
					{
						loadImage(parentPath);
					}
					else if (numChildren > 2)
					{
						loadAlbum(parentPath);
					}
					else
					{
						throw("Error: No content in album " + parentPath + ". Please double check the type in properties.xml");
					}
				}
				else if (type.toUpperCase() == "TEXT")
				{
					loadTextBox(parentPath);
				}
				else
				{
					throw("ERROR: Unhandled type: " + type + " in " + parentPath + "/button/properties.xml. Type should either be \"Text\" or \"Album\".");
				}
			}
		}
		
		// This loads an imageviewer with an image from disk
		private function loadImage(parentPath:String):void
		{
			var iv:ImageViewer = createViewer(new ImageViewer(), 400, 400, 1000, 700) as ImageViewer;
			iv.autoTextLayout = false;
			iv.clusterBubbling = true;
			iv.mouseChildren = true;
			iv.gestureList = {"n-drag": true, "n-scale": true, "n-rotate": true};
			addChild(iv);
			
			for each (var child:String in getFilesInDirectoryRelative(parentPath))
			{
				for each (var extention:String in _knownFormats)
				{
					if (child.toUpperCase().search(extention.toUpperCase()) != -1)
					{
						iv.addChild(getImage(child, 1000, 700));
						// Load its associated description
						var textFile:String = child.replace(extention, ".txt");
						var loader:URLLoader = new URLLoader(new URLRequest(textFile));
						loader.addEventListener(Event.COMPLETE, FinalizeImage(iv, parentPath));
					}
				}
			}
		
		}
		
		// This loads an album form disk
		private function loadAlbum(parentPath:String):void
		{
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
			back.touchEnabled = false;
			back.margin = 8;
			back.clusterBubbling = false;
			back.visible = false;
			back.dragGesture = "1-finger-drag";
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
						loader2.addEventListener(Event.COMPLETE, FinalizeAlbum(av, front, back, parentPath));
					}
				}
			}
		}
		
		// This loads a specified from a .txt file on disk
		private function loadTextBox(parentPath:String):void
		{
			for each (var childPath:String in getFilesInDirectoryRelative(parentPath))
			{
				if (isDirectory(childPath))
				{
					continue;
				}
				// Assures that it is a .txt file
				if (childPath.toUpperCase().search(".txt".toUpperCase()) != -1)
				{
					var loader:URLLoader = new URLLoader(new URLRequest(childPath));
					loader.addEventListener(Event.COMPLETE, FinalizeTextBox(parentPath));
				}
				else
				{
					throw("ERROR: Found file " + childPath + "which does not end with .txt extention. Please make sure that you have specified the correct type in button/properties.xml");
				}
			}
		}
		
		private function FinalizeImage(iv:ImageViewer, parentPath:String):Function
		{
			return function(event:Event):void
			{
				var content:String = URLLoader(event.currentTarget).data;
				var index:int = content.search("\n");
				addInfoPanel(iv, content.slice(0, index), content.slice(index + 1, content.length));
				addFrame(iv);
				addViewerMenu(iv, true, true, false, false);
				_imageMap[parentPath] = iv;
				DisplayUtils.initAll(iv);
				hideComponent(iv);
			}
		}
		
		// This handler triggers when a description file for an album is loaded (.txt)
		private function FinalizeAlbum(av:AlbumViewer, front:Album, back:Album, parentPath:String):Function
		{
			return function(event:Event):void
			{
				// increment iterator i
				_i++;
				var content:String = URLLoader(event.currentTarget).data;
				// Finds the first newline and creates a text content that is used for the description
				var index:int = content.search("\n");
				back.addChild(createDescription(new TextContent(content.slice(0, index), content.slice(index + 1, content.length)), 1000, 700, 0.1));
				// This is true when all of the description files are loaded
				if (_numChildren[parentPath] == _i)
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
		
		// This handler is triggered when the content for a textbox is loaded
		private function FinalizeTextBox(parentPath:String):Function
		{
			return function(e:Event):void
			{
				var content:String = URLLoader(e.currentTarget).data;
				var index:int = content.search("\n");
				var textContent:TextContent = new TextContent(content.slice(0, index), content.slice(index + 1, content.length));
				
				var textBox:TextBox = new TextBox(textContent, _frameThickness);
				textBox.x = _buttonMap[parentPath].x;
				textBox.y = _buttonMap[parentPath].y;
				textBox.width = 400;
				textBox.height = 400;
				textBox.nativeTransform = true;
				textBox.clusterBubbling = true;
				textBox.mouseChildren = true;
				//var tcr:TouchContainer = createDescription(textContent, textBox.width, textBox.height, 1, 5);
				//textBox.addChild(tcr);
				addFrame(textBox);
				addTouchContainer(textBox);
				addChild(textBox);
				_textBoxMap[parentPath] = textBox;
				hideComponent(textBox);
				DisplayUtils.initAll(textBox);
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
			return function(e:StateEvent):void
			{
				// On release
				if (e.value != "up")
					return;
				
				if (_albumMap[parentPath] != null)
				{
					if (_albumMap[parentPath].alpha > 0)
					{
						hideComponent(_albumMap[parentPath]);
					}
					else if (_albumMap[parentPath].alpha == 0)
					{
						showComponent(400, 400, _albumMap[parentPath]);
					}
				}
				if (_imageMap[parentPath] != null)
				{
					if (_imageMap[parentPath].alpha > 0)
					{
						hideComponent(_imageMap[parentPath]);
					}
					else if (_imageMap[parentPath].alpha == 0)
					{
						showComponent(400, 400, _imageMap[parentPath]);
					}
				}
				if (_textBoxMap[parentPath] != null)
				{
					if (_textBoxMap[parentPath].alpha > 0)
					{
						hideComponent(_textBoxMap[parentPath]);
					}
					else if (_textBoxMap[parentPath].alpha == 0)
					{
						showComponent(_buttonMap[parentPath].x + _buttonMap[parentPath].width / 2 - _textBoxMap[parentPath].width / 2, _buttonMap[parentPath].y + _buttonMap[parentPath].height / 2 - _textBoxMap[parentPath].height / 2, _textBoxMap[parentPath]);
						_textBoxMap[parentPath].Rebirth();
					}
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
		
		// Hides all the albums
		override public function Hide():void
		{
			for each (var av:AlbumViewer in _albumMap)
			{
				hideComponent(av);
			}
			for each (var tb:TextBox in _textBoxMap)
			{
				hideComponent(tb);
			}
		}
	}
}