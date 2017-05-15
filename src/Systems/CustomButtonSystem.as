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
		private var _systemMap:Object = new Object();
				
		public function CustomButtonSystem()
		{
			_systemMap["TEXT"] = TextBoxSystem(addChild(new TextBoxSystem()));
			_systemMap["WEB"] = WebPageSystem(addChild(new WebPageSystem()));
			_systemMap["ALBUM"] = AlbumSystem(addChild(new AlbumSystem()));
			_systemMap["VIDEO"] = VideoSystem(addChild(new VideoSystem()));
			_systemMap["AUDIO"] = AudioSystem(addChild(new AudioSystem()));
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
		}
		
		override public function Deactivate():void
		{
			for each (var value:System in _systemMap)
			{
				value.Deactivate();
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
				var xmlWidth:uint = buttonProperties.child("width");
				var xmlHeight:uint = buttonProperties.child("height");
				var xmlX:uint = buttonProperties.child("x");
				var xmlY:uint = buttonProperties.child("y");
				
				switch (xmlType)
				{
					case "ALBUM":
						var numberOfChildren:int = getAlbumChildren(key);
						
						// An image with associated description file
						if (numberOfChildren == 2)
						{
							_systemMap[xmlType].LoadImage(key, xmlX, xmlY, xmlWidth, xmlHeight);
						}
						else if (numberOfChildren > 2)
						{
							_systemMap[xmlType].LoadAlbum(key, xmlX, xmlY, xmlWidth, xmlHeight);
						}
						else
						{
							throw("Error: No content in album " + key + ". Please double check the type in properties.xml");
						}
						break;
					case "TEXT":
						_systemMap[xmlType].Load(key, xmlX, xmlY, xmlWidth, xmlHeight);
						break;
					case "VIDEO":
						_systemMap[xmlType].Load(key, xmlX, xmlY, xmlWidth, xmlHeight);
						break;
					case "WEB":
						_systemMap[xmlType].Load(key, xmlX, xmlY, xmlWidth, xmlHeight);
						break;
					case "AUDIO":
						_systemMap[xmlType].Load(key, xmlX, xmlY, xmlWidth, xmlHeight);
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