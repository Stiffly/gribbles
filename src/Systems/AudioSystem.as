package Systems
{
	
	import com.gestureworks.cml.components.Component;
	import com.gestureworks.cml.elements.Image;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.elements.Button;
	import Components.Audio;
	import com.gestureworks.cml.components.MP3Player;
	import com.gestureworks.cml.components.WAVPlayer;
	import util.TextContent;
	import flash.events.TouchEvent;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class AudioSystem extends System
	{
		// The audio map ...
		private var _audioMap:Object = new Object();
		
		public function AudioSystem()
		{
			super();
		
		}
		
		public function Load(key:String):void
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
		
		override public function Update():void 
		{
			for each (var value:Audio in _audioMap)
			{
				value.Update();
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
					mp3.maxScale = 2;
					mp3.minScale = 0.5;
				
					addInfoPanel(mp3, content.slice(0, index), content.slice(index + 1, content.length), 16);
					addFrame(mp3);
					addViewerMenu(mp3, true, true, true, true);
					//addTouchContainer(mp3);
					_audioMap[key] = av;
					recursiveInit(av);
					hideComponent(av._mp3Viewer);
				}
				else if (av.Type == "WAV")
				{
					var wav:WAVPlayer = av.GetAudioViewer();
					wav.maxScale = 2;
					wav.minScale = 0.5;
					addInfoPanel(wav, content.slice(0, index), content.slice(index + 1, content.length), 16);
					addFrame(wav);
					addViewerMenu(wav, true, true, true, true);
					//addTouchContainer(wav);
					_audioMap[key] = av;
					recursiveInit(av);
					hideComponent(av._wavViewer);
				}
			}
		}
		
		override public function Activate():void 
		{
		}
		
		override public function Deactivate():void 
		{
			for (var key:String in _audioMap)
			{
				if (_audioMap[key].Type == "MP3")
					hideComponent(_audioMap[key]._mp3Viewer);
				if (_audioMap[key].Type == "WAV")
					hideComponent(_audioMap[key]._wavViewer);
			}
		}
		
		public function GetViewer(key:String):Component
		{
			if (_audioMap[key] != null)
			{
				return _audioMap[key];
			}
			return null;
		}
	}
}