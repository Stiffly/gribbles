package
{
	/**
	 * Main
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
	import flash.events.KeyboardEvent;
	
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
		private var _systems:List = new List();
		private var _passedFrames:int = 0;
		private var _startTime:Number = 0;
		private var _FPSCounter:TextField = new TextField();
		private var _elapsedTime:int = 0;
		private var _elapsedTimeText:TextField = new TextField();
		
		private var _systemsAreInitiated:Boolean = false;
		
		public function Main()
		{
			trace("gribbles starting");
			// Calls super constructor GestureWorks()
			super();
			cml = "main.cml";
			gml = "gml/gestures.gml"; // gml now required
			tuio = true;
			
			// Add systems here			
			_systems.append(new HTMLSystem());
			_systems.append(new PDFSystem());
			_systems.append(new WaterSystem());
			_systems.append(new VideoSystem());
			_systems.append(new ImageSystem());
			_systems.append(new AudioSystem());
			
			CMLParser.addEventListener(CMLParser.COMPLETE, cmlComplete);
		}
		
		// Is called when the parsing of the CML file is complete
		private function cmlComplete(event:Event):void
		{
			trace("CML parsing complete");
			CMLParser.removeEventListener(CMLParser.COMPLETE, cmlComplete);

			// This makes the image fit to the screen
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			// Enter fullscreen mode
			stage.fullScreenSourceRect = new Rectangle(0, 0, 1920, 1080);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.displayState = StageDisplayState.FULL_SCREEN;
			
			// Loops over each system and intializes it
			for each (var s:System in _systems)
			{
				addChild(s);
				s.Init();
			}
			// Do not update systems until they're all initiated
			_systemsAreInitiated = true;
		}
		
		override protected function gestureworksInit():void
		{
			trace("Gestureworks initiated");
			
			// Hide mouse
			Mouse.hide();
			
			// Show FPS-counter
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addChild(_FPSCounter);
			_elapsedTimeText.y = 10;
			stage.addChild(_elapsedTimeText);
		}
		
		private function onEnterFrame(event:Event):void
		{
			var updateFreq:int = 1; // Times per second
			_passedFrames++;
			var dt:Number = (getTimer() - _startTime) / 1000;
			if (dt > 1 / updateFreq)
			{
				_FPSCounter.text = "FPS: " + _passedFrames * updateFreq;
				_startTime = getTimer();
				_passedFrames = 0;
			}
			if (_systemsAreInitiated)
			{
				for each (var s:System in _systems)
				{
					s.Update();
				}
			}
			// Elapsed time counter
			_elapsedTime += dt;
			_elapsedTimeText.text = "Elapsed time: " + Math.floor(_elapsedTime / 60) + ":" + _elapsedTime % 60;
		}
		
		private function onKeyDown(event:KeyboardEvent) : void
		{
			if (event.keyCode == 117) { // F6
				stage.displayState = StageDisplayState.FULL_SCREEN;
			}
		}
	}
}