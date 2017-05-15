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
		// The video map ...
		private var _videoMap:Object = new Object();
		// The audio map ...
		private var _audioMap:Object = new Object();
		// The textbox map keeps track of all textboxes, with unique parent folder as key
		//private var _textBoxMap:Object = new Object();
		// A list of approved url's
		
		private var _textBoxSystem:CustomTextBoxSystem = null;
		private var _wepPageSystem:CustomWebPageSystem = null;
		private var _albumSystem:CustomAlbumSystem = null;
				
		public function CustomButtonSystem()
		{
			_textBoxSystem = new CustomTextBoxSystem();
			_wepPageSystem = new CustomWebPageSystem();
			_albumSystem = new CustomAlbumSystem();
			addChild(_albumSystem);
			addChild(_wepPageSystem);
			addChild(_textBoxSystem);
			super();
		}
		
		override public function Init():void
		{
			super.Init();
			_textBoxSystem.Init();
			_wepPageSystem.Init();
			_albumSystem.Init();
			for each (var key:String in getFilesInDirectoryRelative("custom"))
			{
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
			_albumSystem.Update();
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
				if (xmlType.toUpperCase() != "TEXT" &&
					xmlType.toUpperCase() != "WEB" &&
					xmlType.toUpperCase() != "ALBUM")
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
					var numberOfChildren:int = children.length;
					for each (var child:String in children)
					{
						if (isDirectory(child))
						{
							numberOfChildren--;
						}
					}
					// An image with associated description file
					if (numberOfChildren == 2)
					{
						_albumSystem.LoadImage(key, xmlX, xmlY, xmlWidth, xmlHeight);
					}
					else if (numberOfChildren > 2)
					{
						_albumSystem.LoadAlbum(key, xmlX, xmlY, xmlWidth, xmlHeight);
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
		}
	}
}