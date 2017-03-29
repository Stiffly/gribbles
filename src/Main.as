package
{
	/**
	 * Main.as
	 * This is the entry point of the application gribbles
	 *
	 * @author Adam Byléhn
	 * @contact adambylehn@hotmail.com
	 */
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.StageDisplayState;
	import flash.utils.getTimer;
	import flash.ui.Mouse;
	import flash.text.TextField;
	
	import com.gestureworks.cml.core.CMLAir; CMLAir;
	import com.gestureworks.core.GestureWorksAIR; GestureWorksAIR;
	import com.gestureworks.cml.utils.List;
	import com.gestureworks.cml.core.CMLParser;
	
	import Systems.System;
	import Systems.VideoSystem;
	import Systems.WaterSystem;
	import Systems.ImageSystem;
	import Systems.HTMLSystem;
	import Systems.PDFSystem;
	import Systems.AudioSystem;
		
	[SWF(frameRate = "0", width = "1920", height = "1080")]
	public class Main extends GestureWorksAIR
	{
		private var m_Systems:List = new List();
		private var m_PassedFrames:int = 0;
		private var m_StartTime:Number = 0;
		private var m_FPScounter:TextField = new TextField();
		private var m_ElapsedTime:int = 0;
		private var m_ElapsedTimeText:TextField = new TextField();
		
		private var m_SystemsInitiated:Boolean = false;
		
		public function Main()
		{
			trace("gribbles starting");
			// Calls super constructor GestureWorks()
			super();
			cml = "main.cml";
			gml = "gml/gestures.gml"; // gml now required
			tuio = true;
			
			
			// Add systems here			
			m_Systems.append(new HTMLSystem());
			//m_Systems.append(new PDFSystem());
			m_Systems.append(new WaterSystem());
			m_Systems.append(new VideoSystem());
			m_Systems.append(new ImageSystem());
			m_Systems.append(new AudioSystem());
			
			CMLParser.addEventListener(CMLParser.COMPLETE, cmlComplete);
		}
		
		// Is called when the parsing of the CML file is complete
		private function cmlComplete(event:Event):void
		{
			trace("CML parsing complete");
			CMLParser.removeEventListener(CMLParser.COMPLETE, cmlComplete);
			// Loops over each system and intializes it
			for each (var s:System in m_Systems)
			{
				addChild(s);
				s.Init();
			}
			// Do not update systems until they're all initiated
			m_SystemsInitiated = true;
			// This makes the image fit to the screen
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			// Enter fullscreen mode
			stage.fullScreenSourceRect = new Rectangle(0, 0, 1920, 1080);
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}
		
		override protected function gestureworksInit():void
		{
			trace("Gestureworks initiated");
			
			// Hide mouse
			Mouse.hide();
			
			// Show FPS-counter
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addChild(m_FPScounter);
			m_ElapsedTimeText.y = 10;
			stage.addChild(m_ElapsedTimeText);
		}
		
		private function onEnterFrame(event:Event):void
		{
			var updateFreq:int = 1; // Times per second
			m_PassedFrames++;
			var dt:Number = (getTimer() - m_StartTime) / 1000;
			if (dt > 1 / updateFreq)
			{
				m_FPScounter.text = "FPS: " + m_PassedFrames * updateFreq;
				m_StartTime = getTimer();
				m_PassedFrames = 0;
			}
			if (m_SystemsInitiated)
			{
				for each (var s:System in m_Systems)
				{
					s.Update();
				}
			}
			// Elapsed time counter
			m_ElapsedTime += dt;
			m_ElapsedTimeText.text = "Elapsed time: " + Math.floor(m_ElapsedTime / 60) + ":" + m_ElapsedTime % 60;
		}
	}
}