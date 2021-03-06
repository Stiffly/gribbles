package Systems
{
	import com.gestureworks.cml.elements.Text;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.events.TouchEvent;
	import flash.events.LocationChangeEvent;
	import flash.text.TextField;
	
	import com.gestureworks.cml.components.AlbumViewer;
	import com.gestureworks.cml.components.ImageViewer;
	import com.gestureworks.cml.elements.Album;
	import com.gestureworks.cml.elements.Button;
	import com.gestureworks.cml.elements.Image;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.components.Component;
	import com.gestureworks.cml.elements.Graphic;
	import com.gestureworks.cml.elements.TouchContainer;
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
		private var _systemMap:Object = new Object();
		// The button map keeps track of all button, with the unique parent folder as key
		private var _buttonMap:Object = new Object();
		
		public function CustomButtonSystem()
		{
			_systemMap["TEXT"] = TextBoxSystem(addChild(new TextBoxSystem()));
			_systemMap["WEB"] = WebPageSystem(addChild(new WebPageSystem()));
			_systemMap["ALBUM"] = AlbumSystem(addChild(new AlbumSystem()));
			_systemMap["VIDEO"] = VideoSystem(addChild(new VideoSystem()));
			_systemMap["AUDIO"] = AudioSystem(addChild(new AudioSystem()));
			_systemMap["PDF"] = PDFSystem(addChild(new PDFSystem()));
			super();
		}
		
		override public function Init():void
		{
			super.Init();
			for each (var value:System in _systemMap)
			{
				value.Init();
			}
			
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
			for each (var value:System in _systemMap)
			{
				value.Update();
			}
		}
		
		override public function Activate():void
		{
			for each (var value:System in _systemMap)
			{
				value.Activate();
			}
			for each (var button:Button in _buttonMap)
			{
				button.visible = true;
				button.touchEnabled = true;
			}
		}
		
		override public function Deactivate():void
		{
			for each (var value:System in _systemMap)
			{
				value.Deactivate();
			}
			for each (var button:Button in _buttonMap)
			{
				button.visible = false;
				button.touchEnabled = false;
			}
		}
		
		// This is the event handler that triggers when the XML file describing the button is loaded
		private function onXMLLoaded(key:String):Function
		{
			return function(e:Event):void
			{
				// Create button from the XML data
				var buttonProperties:XML = XML(e.target.data);
				var xmlType:String = String(buttonProperties.child("type")).toUpperCase();
				var xmlDescription:String = buttonProperties.child("description");
				var xmlWidth:uint = buttonProperties.child("width");
				var xmlHeight:uint = buttonProperties.child("height");
				var xmlX:uint = buttonProperties.child("x");
				var xmlY:uint = buttonProperties.child("y");
				
				var button:Button = createCustomButton(key, xmlX, xmlY, xmlWidth, xmlHeight);
				button.addEventListener(StateEvent.CHANGE, onClick(key));
				// Add tracking of the button by adding it to the button map
				_buttonMap[key] = button;
				addChild(button);
				
				var description:Text = new Text();
				description.font = "arial";
				description.fontSize = 14;
				description.text = xmlDescription;
				description.init();
				description.y = button.height;
				description.height = description.fontSize;
				description.width = description.textWidth + 10;
				description.x = button.width / 2 - description.textWidth / 2;
				button.addChild(description);
				
				switch (xmlType)
				{
				case "ALBUM":
					var numberOfChildren:int = getAlbumChildren(key);
					// An image with associated description file
					if (numberOfChildren == 2)
					{
						_systemMap[xmlType].LoadImage(key);
					}
					else if (numberOfChildren > 2)
					{
						_systemMap[xmlType].LoadAlbum(key);
					}
					else
					{
						throw("Error: No content in album " + key + ". Please double check the type in properties.xml");
					}
					break;
				case "TEXT": 
					_systemMap[xmlType].Load(key);
					break;
				case "VIDEO": 
				case "WEB":
				case "PDF":
				case "AUDIO": 
					_systemMap[xmlType].Load(key);
					break;
				default: 
					throw("ERROR: Unhandled type: " + xmlType + " in " + key + "/button/properties.xml. Type should either be \"Text\" or \"Album\".");
					break;
				}
			}
		}
		
		private function getAlbumChildren(key:String):int
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
			return numberOfChildren;
		}
		
		// Button handler
		private function onClick(key:String):Function
		{
			return function(e:StateEvent):void
			{
				// On release
				if (e.value != "up")
				{
					return;
				}
				
				if (_systemMap["ALBUM"].GetViewer(key) != null)
				{
					if (_systemMap["ALBUM"].GetViewer(key).visible)
					{
						hideComponent(_systemMap["ALBUM"].GetViewer(key));
					}
					else if (!_systemMap["ALBUM"].GetViewer(key).visible)
					{
						showComponent(_buttonMap[key].x + (_buttonMap[key].width >> 1) - (_systemMap["ALBUM"].GetViewer(key).width >> 1), _buttonMap[key].y + (_buttonMap[key].height >> 1) - (_systemMap["ALBUM"].GetViewer(key).height >> 1), _systemMap["ALBUM"].GetViewer(key));
					}
				}
				
				else if (_systemMap["AUDIO"].GetViewer(key) != null)
				{
					
					if (_systemMap["AUDIO"].GetViewer(key).Type == "MP3")
					{
						if (_systemMap["AUDIO"].GetViewer(key)._mp3Viewer.visible)
						{
							hideComponent(_systemMap["AUDIO"].GetViewer(key)._mp3Viewer);
						}
						else if (!_systemMap["AUDIO"].GetViewer(key)._mp3Viewer.visible)
						{
							showComponent(_buttonMap[key].x + (_buttonMap[key].width >> 1) - (_systemMap["AUDIO"].GetViewer(key).width >> 1), _buttonMap[key].y + (_buttonMap[key].height >> 1) - (_systemMap["AUDIO"].GetViewer(key).height >> 1), _systemMap["AUDIO"].GetViewer(key)._mp3Viewer);
						}
					}
					else if (_systemMap["AUDIO"].GetViewer(key).Type == "WAV")
					{
						if (_systemMap["AUDIO"].GetViewer(key)._wavViewer.visible)
						{
							hideComponent(_systemMap["AUDIO"].GetViewer(key)._wavViewer);
						}
						else if (!_systemMap["AUDIO"].GetViewer(key).visible)
						{
							showComponent(_buttonMap[key].x + (_buttonMap[key].width >> 1) - (_systemMap["AUDIO"].GetViewer(key).width >> 1), _buttonMap[key].y + (_buttonMap[key].height >> 1) - (_systemMap["AUDIO"].GetViewer(key).height >> 1), _systemMap["AUDIO"].GetViewer(key)._wavViewer);
						}
					}
				}
				
				else if (_systemMap["TEXT"].GetViewer(key) != null)
				{
					if (_systemMap["TEXT"].GetViewer(key).visible)
					{
						_systemMap["TEXT"].GetViewer(key).Kill();
						hideComponent(_systemMap["TEXT"].GetViewer(key));
					}
					else if (!_systemMap["TEXT"].GetViewer(key).visible)
					{
						addChild(_systemMap["TEXT"].GetViewer(key)._Line);
						
						for each (var value:Object in _systemMap["TEXT"].GetMap())
						{
							value.Kill();
							hideComponent(value);
						}
								
						var bOriginX:Number = _buttonMap[key].x + _buttonMap[key].width / 2;
						var bOriginY:Number = _buttonMap[key].y + _buttonMap[key].height / 2;
						var tbWidth:Number = _systemMap["TEXT"].GetViewer(key).width;
						var tby:Number = _systemMap["TEXT"].GetViewer(key).y;
						var halfBoxHeight:Number = (_systemMap["TEXT"].GetViewer(key).height >> 1);
						var verticalOffset:Number = 300;
						
						// Right side of the screen
						if (bOriginX > stage.stageWidth * .5)
						{
							var rx:Number = bOriginX - verticalOffset - tbWidth;
							var ry:Number = bOriginY - halfBoxHeight;
							showComponent(rx, ry, _systemMap["TEXT"].GetViewer(key));
							removeChild(_systemMap["TEXT"].GetViewer(key)._Line);
							var rline:Graphic = getLine(0x000000, bOriginX, bOriginY, rx + tbWidth + (_frameThickness << 1), ry + halfBoxHeight, 3, .5);
							_systemMap["TEXT"].GetViewer(key)._Line = rline;
							addChild(_systemMap["TEXT"].GetViewer(key)._Line);
							_systemMap["TEXT"].GetViewer(key).Rebirth();
						}
						// Left side of the screen
						else
						{
							var lx:Number = bOriginX + verticalOffset;
							var ly:Number = bOriginY - halfBoxHeight;
							showComponent(lx, ly, _systemMap["TEXT"].GetViewer(key));
							removeChild(_systemMap["TEXT"].GetViewer(key)._Line);
							var lline:Graphic = getLine(0x000000, bOriginX, bOriginY, lx - (_frameThickness << 1), ly + halfBoxHeight, 3, .5);
							_systemMap["TEXT"].GetViewer(key)._Line = lline;
							addChild(_systemMap["TEXT"].GetViewer(key)._Line);
							_systemMap["TEXT"].GetViewer(key).Rebirth();
						}
					}
				}
				
				else if (_systemMap["VIDEO"].GetViewer(key) != null)
				{
					if (_systemMap["VIDEO"].GetViewer(key).visible)
					{
						hideComponent(_systemMap["VIDEO"].GetViewer(key));
					}
					else if (!_systemMap["VIDEO"].GetViewer(key).visible)
					{
						showComponent(_buttonMap[key].x + (_buttonMap[key].width >> 1) - (_systemMap["VIDEO"].GetViewer(key).width >> 1), _buttonMap[key].y + (_buttonMap[key].height >> 1) - (_systemMap["VIDEO"].GetViewer(key).height >> 1), _systemMap["VIDEO"].GetViewer(key));
					}
				}
				
				else if (_systemMap["WEB"].GetViewer(key) != null)
				{
					if (_systemMap["WEB"].GetViewer(key).visible)
					{
						hideComponent(_systemMap["WEB"].GetViewer(key));
					}
					else if (!_systemMap["WEB"].GetViewer(key).visible)
					{
						showComponent((stage.stageWidth >> 1) - (_systemMap["WEB"].GetViewer(key).width >> 1), (stage.stageHeight >> 1) - (_systemMap["WEB"].GetViewer(key).height >> 1), _systemMap["WEB"].GetViewer(key));
					}
				}
				
				else if (_systemMap["PDF"].GetViewer(key) != null)
				{
					if (_systemMap["PDF"].GetViewer(key).visible)
					{
						hideComponent(_systemMap["PDF"].GetViewer(key));
					}
					else if (!_systemMap["PDF"].GetViewer(key).visible)
					{
						_systemMap["PDF"].ShowComponent((stage.stageWidth >> 1) - (_systemMap["PDF"].GetViewer(key).width >> 1), (stage.stageHeight >> 1) - (_systemMap["PDF"].GetViewer(key).height >> 1), _systemMap["PDF"].GetViewer(key));
					}
				}
			}
		}
		
		// Hides all the albums
		override public function Hide():void
		{
			for each (var value:System in _systemMap)
			{
				value.Hide();
			}
		}
	}
}