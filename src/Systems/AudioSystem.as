package Systems
{
	
	/**
	 * AudioSystem.as
	 * Keeps track of audiofiles (WAV/MP3)
	 *
	 * @author Adam Byléhn
	 * @contact adambylehn@hotmail.com
	 */
	
	import com.gestureworks.cml.core.CMLObjectList;
	import com.gestureworks.cml.elements.Frame;
	import com.gestureworks.cml.elements.TouchContainer;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.elements.Button;
	import com.gestureworks.cml.components.WAVPlayer;
	import com.gestureworks.cml.elements.WAV;
	import com.gestureworks.cml.components.MP3Player;
	import com.gestureworks.cml.elements.MP3;
	
	public class AudioSystem extends System
	{
		private var m_WavPlayer:WAVPlayer;
		private var m_MP3Player:MP3Player;
		private var m_Button:Button;
		
		public function AudioSystem()
		{
			super();
		}
		
		public override function Init():void
		{
			var x_pos:int = 300;
			var y_pos:int = 300;
			var width:int = 500;
			var height:int = 250;
			
			m_WavPlayer = createViewer(new WAVPlayer(), x_pos, y_pos, width, height) as WAVPlayer;
			
			var wav:WAV = new WAV();
			wav.className = "wav-component";
			wav.src = "audio/water.wav";
			wav.autoplay = true;
			wav.display = "waveform";
			wav.width = width;
			wav.height = height;
			wav.loop = true;
			wav.init();
			m_WavPlayer.addChild(wav);
			stage.addChild(m_WavPlayer);
			hideComponent(m_WavPlayer);
			
			m_MP3Player = createViewer(new MP3Player(), x_pos, y_pos, width, height) as MP3Player;
			
			var mp3:MP3 = new MP3();
			mp3.className = "mp3-component";
			mp3.src = "audio/krabbe.mp3";
			mp3.display = "waveform";
			mp3.width = width;
			mp3.height = height;
			mp3.loop = true;
			mp3.init();
			m_MP3Player.addChild(mp3);
			stage.addChild(m_MP3Player);
			hideComponent(m_MP3Player);
			
			m_Button = CMLObjectList.instance.getId("music-button");
			m_Button.addEventListener(StateEvent.CHANGE, buttonHandler);
			stage.addChild(m_Button);
		}
		
		public function buttonHandler(event:StateEvent):void
		{
			//switchButtonState(event.value, m_WavPlayer);
			switchButtonState(event.value, m_MP3Player);
		}
	}
}