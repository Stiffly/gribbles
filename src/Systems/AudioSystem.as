package Systems
{
	
	import com.gestureworks.cml.elements.Image;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.elements.Button;
	import com.gestureworks.cml.utils.DisplayUtils;
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
		
		// The button map keeps track of all button, with the unique parent folder as key
		private var _buttonMap:Object = new Object();
		// The audio map ...
		private var _audioMap:Object = new Object();
		
		public function AudioSystem()
		{
			super();
		
		}
		
		public function Load(key:String, bx:int, by:int, bw:int, bh:int):void
		{
			var button:Button = createCustomButton(key, bx, by, bw, bh);
			button.addEventListener(StateEvent.CHANGE, onClick(key));
			// Add tracking of the button by adding it to the button map
			_buttonMap[key] = button;
			addChild(button);
			
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
		
		// Button handler
		private function onClick(key:String):Function
		{
			return function(e:StateEvent):void
			{
				// On release
				if (e.value != "up")
					return;
				
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
	}
}