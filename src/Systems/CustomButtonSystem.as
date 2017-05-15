package Systems
{
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.events.TouchEvent;
	import flash.events.LocationChangeEvent;
	
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
	import com.gestureworks.cml.components.HTMLViewer;
	import com.gestureworks.cml.components.MP3Player;
	import com.gestureworks.cml.components.VideoViewer;
	import com.gestureworks.cml.components.WAVPlayer;
	import com.gestureworks.cml.elements.HTML;
	import com.gestureworks.cml.elements.Video;
	
	import Components.TextBox;
	import Components.Audio;
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
	 * @contact adambylehn@hotmail.com
	 */
	
	public class CustomButtonSystem extends System
	{
		// The button map keeps track of all button, with the unique parent folder as key
		private var _buttonMap:Object = new Object();
		// The album map keeps track of all album viewers, with unique parent folder as key
		private var _albumMap:Object = new Object();
		// The image map keeps track of all image viewers, with unique parent folder as key
		private var _imageMap:Object = new Object();
		// The video map ...
		private var _videoMap:Object = new Object();
		// The audio map ...
		private var _audioMap:Object = new Object();
		// The textbox map keeps track of all textboxes, with unique parent folder as key
		//private var _textBoxMap:Object = new Object();
		// Stores the number of children that each album has, used to init albums only once, when all children are loaded
		private var _numChildren:Object = new Object();
		// A map containing arrays of the index circles that shows what image in the album that is active
		private var _indexCircles:Object = new Object();
		// Member iterator to keep track of how many children has been loaded
		private var _i:uint = 0;
		// A list of approved url's
		
		private var _textBoxSystem:CustomTextBoxSystem = null;
		private var _wepPageSystem:CustomWebPageSystem = null;
				
		public function CustomButtonSystem()
		{
			_textBoxSystem = new CustomTextBoxSystem();
			_wepPageSystem = new CustomWebPageSystem();
			addChild(_wepPageSystem);
			addChild(_textBoxSystem);
			super();
		}
		
		override public function Init():void
		{
			super.Init();
			_textBoxSystem.Init();
			_wepPageSystem.Init();
			for each (var key:String in getFilesInDirectoryRelative("custom"))
			{
				_numChildren[key] = 0;
				// Button properties loaded from XML
				var urlRequest:URLRequest = new URLRequest(key + "/button/properties.xml");
				var loader:URLLoader = new URLLoader(urlRequest);
				loader.addEventListener(Event.COMPLETE, onXMLLoaded(key));
			}
		}
		
		override public function Update():void
		{
			_textBoxSystem.Update();
			_wepPageSystem.Update();
			
			// For all parent folders...
			for (var key:String in _indexCircles)
			{
				if (_albumMap[key] == null)
					return;
				// For all index circle per album
				for each (var circle:Graphic in _indexCircles[key])
				{
					circle.color = 0x999999;
				}
				// If the back is active, we use this as our index
				if (_albumMap[key].back.visible)
				{
					_indexCircles[key][_albumMap[key].back.currentIndex].color = 0x000000;
				}
				// Else the front is active, use it instead
				else
				{
					_indexCircles[key][_albumMap[key].front.currentIndex].color = 0x000000;
				}
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
		private function onXMLLoaded(key:String):Function
		{
			return function(e:Event):void
			{
				// Create button from the XML data
				var buttonProperties:XML = XML(e.target.data);
				var xmlType:String = buttonProperties.child("type");
				var xmlWidth:uint = buttonProperties.child("width");
				var xmlHeight:uint = buttonProperties.child("height");
				var xmlX:uint = buttonProperties.child("x");
				var xmlY:uint = buttonProperties.child("y");
				
				var button:Button = new Button();
				if (xmlType.toUpperCase() != "TEXT" && xmlType.toUpperCase() != "WEB")
				{
					button.width = xmlWidth;
					button.height = xmlHeight;
					button.x = xmlX;
					button.y = xmlY;
					button.dispatch = "initial:initial:down:down:up:up:over:over:out:out:hit:hit";
					var img:Image = getImage(key + "/button/button.png", xmlWidth, xmlHeight);
					var downImg:Image = getImage(key + "/button/button.png", xmlWidth, xmlHeight);
					downImg.alpha = 0.5;
					if (key == "custom/1A")
					{
						// Special logic for too big image A
						var hitBox:Graphic = getRectangle(0x000000, xmlX, xmlY, 51, 47, 0);
						hitBox.x = 1665 - button.x;
						hitBox.y = 372 - button.y;
						button.hit = hitBox;
					}
					else
					{
						button.hit = getRectangle(0x000000, 0, 0, xmlWidth, xmlHeight, 0);
					}
					button.initial = img;
					button.down = downImg;
					button.up = img;
					button.over = downImg;
					button.out = img;
					button.init();
					// Add tracking of the button by adding it to the button map
					_buttonMap[key] = button;
					addChild(button);
				}
				
				if (xmlType.toUpperCase() == "ALBUM")
				{
					// Get the number of children, exluding directories
					var children:Array = getFilesInDirectoryRelative(key);
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
						loadImage(key);
					}
					else if (numChildren > 2)
					{
						loadAlbum(key);
					}
					else
					{
						throw("Error: No content in album " + key + ". Please double check the type in properties.xml");
					}
				}
				else if (xmlType.toUpperCase() == "TEXT")
				{
					_textBoxSystem.Load(key, xmlX, xmlY, xmlWidth, xmlHeight);
				}
				else if (xmlType.toUpperCase() == "VIDEO")
				{
					loadVideo(key);
				}
				else if (xmlType.toUpperCase() == "AUDIO")
				{
					loadAudio(key);
				}
				else if (xmlType.toUpperCase() == "WEB")
				{
					_wepPageSystem.Load(key, xmlX, xmlY, xmlWidth, xmlHeight);
				}
				else
				{
					throw("ERROR: Unhandled type: " + xmlType + " in " + key + "/button/properties.xml. Type should either be \"Text\" or \"Album\".");
				}
				button.addEventListener(StateEvent.CHANGE, onClick(key));
			}
		}
		
		private function loadAudio(key:String):void 
		{
			for each (var child:String in getFilesInDirectoryRelative(key))
			{
				if (isDirectory(child))
				{
					continue;
				}
				var extention:String = getExtention(child).toUpperCase();
				if (extention == "TXT")
				{
					continue;
				}
				
				var av:Audio = new Audio(extention, 500, 350);
				av.addEventListener(TouchEvent.TOUCH_BEGIN, onTouch);
				av.mouseChildren = true;
				av.clusterBubbling = true;
				av.width = 500;
				av.height = 350;
				av.Open(child);
				addChild(av);
				
				// Load its associated description
				var textFile:String = child.toUpperCase().replace(extention, "TXT");
				var loader:URLLoader = new URLLoader(new URLRequest(textFile));
				loader.addEventListener(Event.COMPLETE, FinalizeAudio(av, key));
			}
		}
		
		private function FinalizeAudio(av:Audio, key:String):Function
		{
			return function(event:Event):void
			{
				var content:String = URLLoader(event.currentTarget).data;
				var index:int = content.search("\n");
				if (av.Type == "MP3")
				{
					var mp3:MP3Player = av.GetAudioViewer();
					addInfoPanel(mp3, content.slice(0, index), content.slice(index + 1, content.length), 12);
					addFrame(mp3);
					addViewerMenu(mp3, true, true, true, true);
					addTouchContainer(mp3);
					_audioMap[key] = av;
					DisplayUtils.initAll(av);
					hideComponent(av);
				}
				else if (av.Type == "WAV")
				{
					var wav:WAVPlayer = av.GetAudioViewer();
					addInfoPanel(wav, content.slice(0, index), content.slice(index + 1, content.length), 12);
					addFrame(wav);
					addViewerMenu(wav, true, true, true, true);
					addTouchContainer(wav);
					_audioMap[key] = av;
					DisplayUtils.initAll(av);
					hideComponent(av);
				}
			}
		}
		
		private function loadVideo(key:String):void 
		{
			var vv:VideoViewer = createViewer(new VideoViewer(), 400, 400, 500, 350) as VideoViewer;
			vv.autoTextLayout = false;
			vv.clusterBubbling = true;
			vv.mouseChildren = true;
			vv.gestureList = {"n-drag": true, "n-scale": true, "n-rotate": true};
			addChild(vv);
			
			for each (var child:String in getFilesInDirectoryRelative(key))
			{
				if (isDirectory(child))
				{
					continue;
				}
				var extention:String = getExtention(child).toUpperCase();
				if (extention == "TXT")
				{
					continue;
				}
				vv.addChild(getVideo(child, vv.width, vv.height));
				// Load its associated description
				var textFile:String = child.toUpperCase().replace(extention, "TXT");
				var loader:URLLoader = new URLLoader(new URLRequest(textFile));
				loader.addEventListener(Event.COMPLETE, FinalizeVideo(vv, key));
			}
		}
		
		private function FinalizeVideo(vv:VideoViewer, key:String):Function
		{
			return function(event:Event):void
			{
				var content:String = URLLoader(event.currentTarget).data;
				var index:int = content.search("\n");
				addInfoPanel(vv, content.slice(0, index), content.slice(index + 1, content.length), 12);
				addFrame(vv);
				addViewerMenu(vv, true, true, true, true);
				_videoMap[key] = vv;
				DisplayUtils.initAll(vv);
				hideComponent(vv);
			}
		}
		
		// This loads an imageviewer with an image from disk
		private function loadImage(key:String):void
		{
			var iv:ImageViewer = createViewer(new ImageViewer(), 400, 400, 500, 350) as ImageViewer;
			iv.autoTextLayout = false;
			iv.clusterBubbling = true;
			iv.mouseChildren = true;
			iv.gestureList = {"n-drag": true, "n-scale": true, "n-rotate": true};
			addChild(iv);
			
			for each (var child:String in getFilesInDirectoryRelative(key))
			{
				if (isDirectory(child))
				{
					continue;
				}
				var extention:String = getExtention(child).toUpperCase();
				if (extention == "TXT")
				{
					continue;
				}
				iv.addChild(getImage(child, iv.width, iv.height));
				// Load its associated description
				var textFile:String = child.toUpperCase().replace(extention, "TXT");
				var loader:URLLoader = new URLLoader(new URLRequest(textFile));
				loader.addEventListener(Event.COMPLETE, FinalizeImage(iv, key));
			}
		}
		
		// This loads an album form disk
		private function loadAlbum(key:String):void
		{
			// Create album viewer
			var av:AlbumViewer = createViewer(new AlbumViewer(), 400, 400, 500, 350) as AlbumViewer;
			av.autoTextLayout = false;
			av.linkAlbums = true;
			av.clusterBubbling = true;
			av.mouseChildren = true;
			av.gestureList = {"n-drag": true, "n-scale": true, "n-rotate": true};
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
			front.dragGesture = "";
			
			// Back
			var back:Album = new Album();
			back.id = "back";
			back.loop = true;
			back.alpha = .4;
			back.horizontal = true;
			back.touchEnabled = false;
			back.margin = 8;
			back.clusterBubbling = false;
			back.visible = false;
			back.dragGesture = "";
			back.dragAngle = 0;
			
			// Add all the children, images etc.
			for each (var child:String in getFilesInDirectoryRelative(key))
			{
				if (isDirectory(child))
				{
					continue;
				}
				var extention:String = getExtention(child).toUpperCase();
				if (extention == "TXT")
				{
					continue;
				}
				// Load image
				front.addChild(getImage(child, av.width, av.height));
				// Update number of children, this is compared against in onFileLoaded function
				_numChildren[key]++;
				// Load its associated description
				var textFile:String = child.toUpperCase().replace(extention, "TXT");
				var loader2:URLLoader = new URLLoader(new URLRequest(textFile));
				loader2.addEventListener(Event.COMPLETE, FinalizeAlbum(av, front, back, key));
			}
		}
		
		private function FinalizeImage(iv:ImageViewer, key:String):Function
		{
			return function(event:Event):void
			{
				var content:String = URLLoader(event.currentTarget).data;
				var index:int = content.search("\n");
				addInfoPanel(iv, content.slice(0, index), content.slice(index + 1, content.length), 12);
				addFrame(iv);
				addViewerMenu(iv, true, true, false, false);
				_imageMap[key] = iv;
				DisplayUtils.initAll(iv);
				hideComponent(iv);
			}
		}
		
		// This handler triggers when a description file for an album is loaded (.txt)
		private function FinalizeAlbum(av:AlbumViewer, front:Album, back:Album, key:String):Function
		{
			return function(event:Event):void
			{
				// increment iterator i
				_i++;
				var content:String = URLLoader(event.currentTarget).data;
				// Finds the first newline and creates a text content that is used for the description
				var index:int = content.search("\n");
				back.addChild(TextContent.CREATE_DESCRIPTION(new TextContent(content.slice(0, index), content.slice(index + 1, content.length)), av.width, av.height, 1, 30, 12));
				// This is true when all of the description files are loaded
				if (_numChildren[key] == _i)
				{
					// When all the description files are loaded we can initiate the albums
					av.front = front;
					av.back = back;
					av.addChild(front);
					av.addChild(back);
					addFrame(av);
					addViewerMenu(av, true, true, false, false);
					addButtons(av);
					
					_indexCircles[key] = new Array();
					for (var i:int = 0; i < _numChildren[key]; i++)
					{
						var radius:Number = 10;
						var g:Graphic = getCircle(0x999999, i * (radius << 1), - radius - _frameThickness, radius, 1);
						_indexCircles[key].push(g);
						av.addChild(g);
					}
					
					DisplayUtils.initAll(av);
					_albumMap[key] = av;
					hideComponent(av);
					_i = 0;
					return;
				}
			}
		}
		
		private function addButtons(av:AlbumViewer):void 
		{
			var buttonSpace:int = 20;
			var right:Button = new Button();
			right.height = 26;
			right.width= 26;
			right.y = av.height + 3;
			right.x = av.width / 2 + buttonSpace;
			right.dispatch = "initial:initial:down:down:up:up:over:over:out:out";
			var hit:Image = getImage("images/buttons/right.png", right.width, right.height);
			hit.alpha = 0;
			right.hit = hit;
			var down:Image = getImage("images/buttons/right.png", right.width, right.height);
			down.alpha = 0.5;
			right.initial = getImage("images/buttons/right.png", right.width, right.height);
			right.down = down;
			var over:Image = down;
			right.up = getImage("images/buttons/right.png", right.width, right.height);
			right.over = over;
			var out:Image = getImage("images/buttons/right.png", right.width, right.height);
			right.out = out;
			right.init();
			right.addEventListener(StateEvent.CHANGE, onNextImage(av));
			av.addChild(right);
			
			var left:Button = new Button();
			left.height = 26;
			left.width= 26;
			left.y = av.height + 3;
			left.x = av.width / 2 - buttonSpace - left.width;
			left.dispatch = "initial:initial:down:down:up:up:over:over:out:out";
			hit = getImage("images/buttons/left.png", left.width, left.height);
			hit.alpha = 0;
			left.hit = hit;
			down = getImage("images/buttons/left.png", left.width, left.height);
			down.alpha = 0.5;
			left.initial = getImage("images/buttons/left.png", left.width, left.height);
			left.down = down;
			over = down;
			left.up = getImage("images/buttons/left.png", left.width, left.height);
			left.over = over;
			out = getImage("images/buttons/left.png", left.width, left.height);
			left.out = out;
			left.init();
			left.addEventListener(StateEvent.CHANGE, onPreviousImage(av));
			av.addChild(left);
			
		}
		
		
		
		private function onPreviousImage(av:AlbumViewer):Function
		{
			return function (e:StateEvent):void
			{
				if (e.value != "up")
				{
					return;
				}
				av.front.previous();
			}
		}
		
		private function onNextImage(av:AlbumViewer):Function 
		{
			return function (e:StateEvent):void
			{
				if (e.value != "up")
				{
					return;
				}
				av.front.next();
			}
		}
		
		private function getVideo(source:String, width:uint, height:uint):Video
		{
			var vid:Video = new Video();
			vid.autoplay = true;
			vid.width = width;
			vid.height = height;
			vid.open(source);
			return vid;
		}
		
		// Button handler
		private function onClick(key:String):Function
		{
			return function(e:StateEvent):void
			{
				// On release
				if (e.value != "up")
					return;
				
				if (_albumMap[key] != null)
				{
					if (_albumMap[key].alpha > 0)
					{
						hideComponent(_albumMap[key]);
					}
					else if (_albumMap[key].alpha == 0)
					{
						showComponent(_buttonMap[key].x + (_buttonMap[key].width >> 1) - (_albumMap[key].width >> 1), _buttonMap[key].y + (_buttonMap[key].height >> 1) - (_albumMap[key].height >> 1), _albumMap[key]);
					}
				}
				if (_imageMap[key] != null)
				{
					if (_imageMap[key].alpha > 0)
					{
						hideComponent(_imageMap[key]);
					}
					else if (_imageMap[key].alpha == 0)
					{
						showComponent(_buttonMap[key].x + (_buttonMap[key].width >> 1) - (_imageMap[key].width >> 1), _buttonMap[key].y + (_buttonMap[key].height >> 1) - (_imageMap[key].height >> 1), _imageMap[key]);
					}
				}
				if (_videoMap[key] != null)
				{
					if (_videoMap[key].alpha > 0)
					{
						hideComponent(_videoMap[key]);
					}
					else if (_videoMap[key].alpha == 0)
					{
						showComponent(_buttonMap[key].x + (_buttonMap[key].width >> 1) - (_videoMap[key].width >> 1), _buttonMap[key].y + (_buttonMap[key].height >> 1) - (_videoMap[key].height >> 1), _videoMap[key]);
					}
				}
				if (_audioMap[key] != null)
				{
					if (_audioMap[key].alpha > 0)
					{
						hideComponent(_audioMap[key]);
					}
					else if (_audioMap[key].alpha == 0)
					{
						showComponent(_buttonMap[key].x + (_buttonMap[key].width >> 1) - (_audioMap[key].width >> 1), _buttonMap[key].y + (_buttonMap[key].height >> 1) - (_audioMap[key].height >> 1), _audioMap[key]);
					}
				}
			}
		}
		
		// Hides all the albums
		override public function Hide():void
		{
			for each (var av:AlbumViewer in _albumMap)
			{
				hideComponent(av);
			}
		}
	}
}