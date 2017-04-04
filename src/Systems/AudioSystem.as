package Systems
{
	
	/**
	 * Systems.AudioSystem
	 * Keeps track of audiofiles (WAV/MP3)
	 *
	 * @author Adam Byléhn
	 * @contact adambylehn@hotmail.com
	 */
	
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
	import ui.ViewerMenu;
	import ui.InfoPanel;
	
	public class AudioSystem extends System
	{
		private var _WAVPlayer:Array = new Array();
		private var _MP3Player:Array = new Array();
		private var _button:Button;
		
		public function AudioSystem()
		{
			super();
		}
		
		public override function Init():void
		{
			var x_pos:int = 300;
			var y_pos:int = 300;
			var width:int = 600;
			var height:int = 400;
			
			for each (var audioPath:String in getFilesInDirectoryRelative("audio"))
			{
				if (audioPath.toLowerCase().search(".wav") != -1)
				{
					var wavPlayer:WAVPlayer = createViewer(new WAVPlayer(), x_pos, y_pos, width, height) as WAVPlayer;
					setWAVroperties(wavPlayer, audioPath, width, height);
				} else if (audioPath.toLowerCase().search(".mp3") != -1)
				{
					var mp3Player:MP3Player = createViewer(new MP3Player(), x_pos, y_pos, width, height) as MP3Player;
					setMP3Properties(mp3Player, audioPath, width, height);
				}
			}
			_button = CMLObjectList.instance.getId("music-button");
			_button.addEventListener(StateEvent.CHANGE, buttonHandler);
			stage.addChild(_button);
		}
		
		private function buttonHandler(event:StateEvent):void
		{
			for each (var wavPlayer:WAVPlayer in _WAVPlayer) {
				switchButtonState(event.value, wavPlayer);
			}
			for each (var mp3Player:MP3Player in _MP3Player) {
				switchButtonState(event.value, mp3Player);
			}
		}
		
		private function setMP3Properties(component:Component, path:String, width:int, height:int):void
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
			stage.addChild(component);
			
			addInfoPanel(component, "Snack om Gribshunden", "En beskrivning om processen som leder till att Gribshunden sjunker.");
			addFrame(component);
			addTouchContainer(component);
			addViewerMenu(component, false, false, true, true);
			
			DisplayUtils.initAll(component);
			
			_MP3Player.push(component);
			hideComponent(component);
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
			stage.addChild(component);
			
			DisplayUtils.initAll(component);
			
			_WAVPlayer.push(component);
			hideComponent(component);
		}
	}
}