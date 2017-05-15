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
		
		// The textbox map keeps track of all textboxes, with unique parent folder as key
		//private var _textBoxMap:Object = new Object();
		// A list of approved url's
		
		private var _textBoxSystem:TextBoxSystem = null;
		private var _wepPageSystem:WebPageSystem = null;
		private var _albumSystem:AlbumSystem = null;
		private var _videoSystem:VideoSystem = null;
		private var _audioSystem:AudioSystem = null;
				
		public function CustomButtonSystem()
		{
			_textBoxSystem = TextBoxSystem(addChild(new TextBoxSystem()));
			_wepPageSystem = WebPageSystem(addChild(new WebPageSystem()));
			_albumSystem = AlbumSystem(addChild(new AlbumSystem()));
			_videoSystem = VideoSystem(addChild(new VideoSystem()));
			_audioSystem = AudioSystem(addChild(new AudioSystem()));
			super();
		}
		
		override public function Init():void
		{
			super.Init();
			_textBoxSystem.Init();
			_wepPageSystem.Init();
			_albumSystem.Init();
			_videoSystem.Init();
			_audioSystem.Init();
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
			_audioSystem.Update();
			_textBoxSystem.Update();
			_wepPageSystem.Update();
			_albumSystem.Update();
			_videoSystem.Update();
		}
		
		override public function Activate():void
		{
			/*for each (var b:Button in _buttonMap)
			{
				b.visible = true;
				b.active = true;
			}*/
		}
		
		override public function Deactivate():void
		{
			/*for each (var b:Button in _buttonMap)
			{
				b.visible = false;
				b.active = false;
			}*/

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
					//loadVideo(key);					
					_videoSystem.Load(key, xmlX, xmlY, xmlWidth, xmlHeight);
				}
				else if (xmlType.toUpperCase() == "AUDIO")
				{
					//loadAudio(key);
					_audioSystem.Load(key, xmlX, xmlY, xmlWidth, xmlHeight);
				}
				else if (xmlType.toUpperCase() == "WEB")
				{
					_wepPageSystem.Load(key, xmlX, xmlY, xmlWidth, xmlHeight);
				}
				else
				{
					throw("ERROR: Unhandled type: " + xmlType + " in " + key + "/button/properties.xml. Type should either be \"Text\" or \"Album\".");
				}
			}
		}
		// Hides all the albums
		override public function Hide():void
		{
		}
	}
}