package Systems
{
	import com.gestureworks.cml.components.Component;
	import com.gestureworks.cml.core.CMLObjectList;
	import com.gestureworks.cml.elements.Frame;
	import com.gestureworks.cml.elements.TouchContainer;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.elements.Button;
	import com.gestureworks.cml.components.WAVPlayer;
	import com.gestureworks.cml.elements.WAV;
	import com.gestureworks.cml.components.MP3Player;
	import com.gestureworks.cml.elements.MP3;
	import com.gestureworks.cml.utils.DisplayUtils;
	
	import util.Position;
	import util.TextContent;
	import ui.ViewerMenu;
	import ui.InfoPanel;
	
	/**
	 * Systems.AudioSystem
	 *
	 * A class that contains two strings - title and description - along with a method
	 * for creating a description container.
	 *
	 * @author Adam Byléhn
	 * @contact adambylehn@hotmail.com
	 */
	
	public class AudioSystem extends System
	{
		// Array of wav players
		private var _WAVPlayers:Array = new Array();
		// Array of mp3 players
		private var _MP3Players:Array = new Array();
		// Array of positions for the audio players
		private var _audioPos:Array = new Array();
		private var _audioInfo:Array = new Array();
		// The offset used for placing the audio players
		private var _offset:Position = new Position(400, 200);
		// Member iterator variable
		private var _i:int = 0;
		
		public function AudioSystem()
		{
			super();
		}
		
		public override function Init():void
		{
			
			var width:int = 600;
			var height:int = 400;
			_audioInfo.push(new TextContent("Tyge Krabbe", "\nDen danska adelsmannen Tyge Krabbe fanns ombord på Gribshunden. Så här beskriver han förlisningen i ett brev till herr Hartvig."));
			_audioInfo.push(new TextContent("Kong Hansis Krønicke", "\nUr Kung Hans krönika av Arild Huitfeldt år 1599."));
			
			for each (var audioPath:String in getFilesInDirectoryRelative("audio"))
			{
				if (audioPath.toLowerCase().search(".wav") != -1)
				{
					_audioPos.push(new Position(_offset.X + (_i % 2 * (width + _frameThickness)), _offset.Y + (Math.floor(_i >> 1) * (height + _frameThickness))));
					var wavPlayer:WAVPlayer = createViewer(new WAVPlayer(), _audioPos[_i].X, _audioPos[_i].Y, width, height) as WAVPlayer;
					setWAVroperties(wavPlayer, audioPath, width, height);
					_i++;
					
				}
				else if (audioPath.toLowerCase().search(".mp3") != -1)
				{
					_audioPos.push(new Position(_offset.X + (_i % 2 * (width + (_frameThickness << 2))), _offset.Y + (Math.floor(_i >> 1) * (height + (_frameThickness << 2)))));
					var mp3Player:MP3Player = createViewer(new MP3Player(), _audioPos[_i].X, _audioPos[_i].Y, width, height) as MP3Player;
					
					setMP3Properties(mp3Player, audioPath, width, height, _audioInfo[_i]);
					_i++;
				}
			}
			_button = CMLObjectList.instance.getId("music-button");
			_button.addEventListener(StateEvent.CHANGE, buttonHandler);
			addChild(_button);
		}
		
		private function buttonHandler(event:StateEvent):void
		{
			for each (var wavPlayer:WAVPlayer in _WAVPlayers)
			{
				switchButtonState(event.value, wavPlayer, 400, 400);
			}
			for (var j:int = 0; j < _MP3Players.length; j++)
			{
				switchButtonState(event.value, _MP3Players[j], _audioPos[j].X, _audioPos[j].Y);
			}
		}
		
		private function setMP3Properties(component:Component, path:String, width:int, height:int, description:TextContent):void
		{
			var mp3:MP3 = new MP3();
			mp3.className = "mp3-component";
			mp3.src = path;
			mp3.display = "waveform";
			mp3.width = width;
			mp3.height = height;
			mp3.loop = true;
			mp3.targetParent = true;
			mp3.mouseChildren = false;
			component.front = mp3;
			component.addChild(mp3);
			addChild(component);
			
			addInfoPanel(component, description.title, description.description);
			addFrame(component);
			addTouchContainer(component);
			addViewerMenu(component, true, true, true, true);
			
			DisplayUtils.initAll(component);
			
			_MP3Players.push(component);
		}
		
		private function setWAVroperties(component:Component, path:String, width:int, height:int):void
		{
			var wav:WAV = new WAV();
			wav.className = "wav-component";
			wav.src = path;
			wav.autoplay = false;
			wav.display = "waveform";
			wav.width = width;
			wav.height = height;
			wav.loop = true;
			component.addChild(wav);
			addChild(component);
			
			DisplayUtils.initAll(component);
			
			_WAVPlayers.push(component);
			hideComponent(component);
		}
		
		public override function Hide():void
		{
			for each (var mp3:MP3Player in _MP3Players)
			{
				hideComponent(mp3);
			}
		}
	}
}