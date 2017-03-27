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
		private var m_WavPlayer:TouchContainer;
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
			wav.src = "audio/water.wav";
			wav.autoplay = true;
			wav.display = "waveform";
			wav.width = width;
			wav.height = height;
			wav.loop = true;
			wav.init();
			m_WavPlayer.addChild(wav);
			
			stage.addChild(m_WavPlayer);
		}
	}
}