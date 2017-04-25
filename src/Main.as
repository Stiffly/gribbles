package
{
	/**
	 * Main
	 * This is the entry point of the application gribbles
	 *
	 * @author Adam Byléhn
	 * @contact adambylehn@hotmail.com
	 */
	
	import com.gestureworks.cml.elements.Button;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.StageDisplayState;
	import flash.utils.getTimer;
	import flash.ui.Mouse;
	import flash.text.TextField;
	import flash.events.KeyboardEvent;
	
	import com.gestureworks.cml.elements.Graphic;
	import com.gestureworks.cml.core.CMLAir; CMLAir;
	import com.gestureworks.core.GestureWorksAIR; GestureWorksAIR;
	import com.gestureworks.cml.utils.List;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.events.StateEvent;
	
	import Systems.System;
	import Systems.VideoSystem;
	import Systems.WaterSystem;
	import Systems.ImageSystem;
	import Systems.HTMLSystem;
	import Systems.PDFSystem;
	import Systems.AudioSystem;
		
	[SWF(frameRate = "30", backgroundColor="0x313131", width = "1920", height = "1080")]
	public class Main extends GestureWorksAIR
	{
		[Embed(source = "../bin/images/loader.png")]
		private var _sourceImage:Class;
		private var _loaderImage:Sprite;
		
		private var _systems:List = new List();
		private var _screenSaver:WaterSystem;
		private var _passedFrames:int = 0;
		private var _startTime:Number = 0;
		private var _FPSCounter:TextField = new TextField();
		private var _elapsedTime:int = 0;
		private var _elapsedTimeText:TextField = new TextField();
		private var _mainButton:Button;
		
		private var _currentState:String = State.SCREENSAVER;
		
		private var _systemsAreInitiated:Boolean = false;
		
		public function Main()
		{
			trace("gribbles starting");
			_loaderImage = new Sprite();
			_loaderImage.graphics.beginBitmapFill(new _sourceImage().bitmapData, null, true, true);
			_loaderImage.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			_loaderImage.graphics.endFill();
			stage.addChild(_loaderImage);
			//stage.addChildAt(_loaderImage, stage.numChildren -1);
			
			fullscreen = true;
			
			// Calls super constructor GestureWorks()
			super();
			cml = "main.cml";
			gml = "gml/gestures.gml"; // gml now required
			
			
			// Add systems here			
			_systems.append(new HTMLSystem());
			_systems.append(new PDFSystem());
			_systems.append(new VideoSystem());
			_systems.append(new ImageSystem());
			_systems.append(new AudioSystem());
			_screenSaver = new WaterSystem();
			
			CMLParser.addEventListener(CMLParser.COMPLETE, cmlComplete);
		}
		
		// Is called when the parsing of the CML file is complete
		private function cmlComplete(event:Event):void
		{
			trace("CML parsing complete");
			CMLParser.removeEventListener(CMLParser.COMPLETE, cmlComplete);			
			
			// Create a button for switching to mainapp
			_mainButton = new Button();
			var radius:Number = 50;
			_mainButton.width = radius * 2;
			_mainButton.height = radius * 2;
			_mainButton.x = stage.stageWidth / 2 - _mainButton.width / 2;
			_mainButton.y = stage.stageHeight / 2 -  _mainButton.height / 2;
			_mainButton.dispatch = "initial:initial:down:down:up:up:over:over:out:out";
			_mainButton.hit = getCircle(0x000000, 0);
			_mainButton.initial = getCircle(0xFFFFFF); //white
			_mainButton.down = getCircle(0x0000FF); //blue
			_mainButton.up = getCircle(0xFF0000); //red
			_mainButton.over = getCircle(0x00FF00); //green
			_mainButton.out = getCircle(0xFF00FF); //purple
			_mainButton.init();
			_mainButton.addEventListener(StateEvent.CHANGE, onButtonPress);
			stage.addChild(_mainButton);
			stage.addChildAt(_loaderImage, stage.numChildren -1);
			
			// Loops over each system and intializes it
			for each (var s:System in _systems)
			{
				addChild(s);
				s.Init();
			}
			addChild(_screenSaver);
			_screenSaver.Init();
			switchToScreenSaver();
			// Do not update systems until they're all initiated
			_systemsAreInitiated = true;
		}
		
		override protected function gestureworksInit():void
		{
			trace("Gestureworks initiated");
			
			// Hide mouse
			//Mouse.hide();
			
			// Show FPS-counter
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addChild(_FPSCounter);
			_elapsedTimeText.y = 10;
			_loaderImage.visible = false;
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
				switch (_currentState) {
					case State.MAINAPP:
						for each (var s:System in _systems)
							s.Update();
						break;
					case State.SCREENSAVER:
						_screenSaver.Update();
						break;
				}
			}
			// Elapsed time counter
			_elapsedTime += dt;
			_elapsedTimeText.text = "Elapsed time: " + Math.floor(_elapsedTime / 60) + ":" + _elapsedTime % 60;
		}
		
		private function onKeyDown(event:KeyboardEvent) : void
		{
			if (event.keyCode == 117) { // F6
				fullscreen = true;
			}
		}
		
		private function getCircle(color:uint, alpha:Number = 1):Graphic
		{
			var circle:Graphic = new Graphic();
			circle.shape = "circle";
			circle.radius = 100;
			circle.color = color;
			circle.alpha = alpha;
			circle.lineStroke = 0;
			return circle;
		}
		
		private function onButtonPress(event:StateEvent) :void
		{
			switchToMainApp();
		}
		
		private function switchToMainApp():void
		{
			_screenSaver.Deactivate();
			for each (var s:System in _systems)
			{
				s.Activate();
			}
			_currentState = State.MAINAPP;
			_mainButton.visible = false;
		}
		
		private function switchToScreenSaver():void
		{
			_screenSaver.Activate();
			for each (var s:System in _systems)
			{
				s.Deactivate();
			}
			_currentState = State.SCREENSAVER;
			_mainButton.visible = true;
		}
	}
}

final class State 
{
    public static const SCREENSAVER:String = "SCREENSAVER";
    public static const MAINAPP:String = "MAINAPP";
}