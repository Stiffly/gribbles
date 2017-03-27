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
			wav.tuio = true;
			m_WavPlayer.addChild(wav);
			stage.addChild(m_WavPlayer);
			hideComponent(m_WavPlayer);
			
			m_Button = CMLObjectList.instance.getId("music-button");
			m_Button.addEventListener(StateEvent.CHANGE, buttonHandler);
			stage.addChild(m_Button);		
		}
		
		public function buttonHandler(event:StateEvent):void
		{
			switchButtonState(event.id, event.value, m_WavPlayer);
		}
	}
}