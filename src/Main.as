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
	import flash.utils.getTimer;
	import flash.ui.Mouse;
	import flash.text.TextField;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import com.gestureworks.cml.elements.Graphic;
	import com.gestureworks.cml.core.CMLAir; CMLAir;
	import com.gestureworks.core.GestureWorksAIR; GestureWorksAIR;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.events.StateEvent;
	
	import Systems.System;
	import Systems.VideoSystem;
	import Systems.WaterSystem;
	import Systems.ImageSystem;
	import Systems.HTMLSystem;
	import Systems.PDFSystem;
	import Systems.AudioSystem;
		
	[SWF(backgroundColor="0x313131", width="1920", height="1080", frameRate="30")]
	public class Main extends GestureWorksAIR
	{
		// Loader image
		[Embed(source = "../bin/images/loader.png")]
		private var _loaderSource:Class;
		private var _loaderImage:Sprite;
		
		// Background image
		[Embed(source = "../bin/images/content/bottenbild2.jpg")]
		private var _backgroundSource:Class;
		private var _backgroundImage:Sprite;
		
		private var _systems:Array = new Array();
		private var _screenSaver:WaterSystem;
		private var _passedFrames:int = 0;
		private var _startTime:Number = 0;
		private var _FPSCounter:TextField = new TextField();
		private var _elapsedTime:int = 0;
		private var _elapsedTimeText:TextField = new TextField();
		private var _mainButton:Button;
		private var _idleStart:Number;
		
		private var _currentState:String = State.SCREENSAVER;
		
		private var _systemsAreInitiated:Boolean = false;
		
		public function Main()
		{
			trace("gribbles starting");
			
			fullscreen = true;
			
			// Calls super constructor GestureWorks()
			super();
			cml = "main.cml";
			gml = "gml/gestures.gml"; // gml now required
			
			// Add systems here
			_systems.push(new HTMLSystem());
			_systems.push(new PDFSystem());
			_systems.push(new VideoSystem());
			_systems.push(new ImageSystem());
			_systems.push(new AudioSystem());
			_screenSaver = new WaterSystem();
			
			CMLParser.addEventListener(CMLParser.COMPLETE, cmlComplete);
		}
		
		// Is called when the parsing of the CML file is complete
		private function cmlComplete(event:Event):void
		{
			trace("CML parsing complete");
			CMLParser.removeEventListener(CMLParser.COMPLETE, cmlComplete);			
			trace("gribbles starting");

			// Create a button for switching to mainapp
			_mainButton = new Button();
			var radius:Number = 50;
			_mainButton.width = radius * 2;
			_mainButton.height = radius * 2;
			_mainButton.x =  stage.stageWidth / 2 - radius * 2;
			_mainButton.y = stage.stageHeight / 2 - radius * 2;
			_mainButton.dispatch = "initial:initial:down:down:up:up:over:over:out:out";
			_mainButton.hit = getCircle(0x000000, 0);
			_mainButton.initial = getCircle(0xFFFFFF); //white
			_mainButton.down = getCircle(0x0000FF); //blue
			_mainButton.up = getCircle(0xFFFFFF); //blue
			_mainButton.over = getCircle(0xFFFFFF); //blue
			_mainButton.out = getCircle(0xFFFFFF); //blue
			_mainButton.init();
			_mainButton.addEventListener(StateEvent.CHANGE, onButtonPress);
			addChild(_mainButton);
			addChildAt(_loaderImage, numChildren -1);
			
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
			_loaderImage.visible = false;
		}
		
		override protected function gestureworksInit():void
		{
			trace("Gestureworks initiated");
			_loaderImage = new Sprite();
			_loaderImage.graphics.beginBitmapFill(new _loaderSource().bitmapData, null, true, true);
			_loaderImage.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			_loaderImage.graphics.endFill();
			addChild(_loaderImage);
			addChildAt(_loaderImage, numChildren -1);
			
			_backgroundImage = new Sprite();
			_backgroundImage.graphics.beginBitmapFill(new _backgroundSource().bitmapData, null, true, true);
			_backgroundImage.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			_backgroundImage.graphics.endFill();
			_backgroundImage.visible = false;
			addChild(_backgroundImage);
			addChildAt(_backgroundImage, 0);
			
			// Hide mouse
			Mouse.hide();
			
			// Show FPS-counter
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(MouseEvent.MOUSE_MOVE, onInteraction);
			addChild(_FPSCounter);
			_elapsedTimeText.y = 10;
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
			// Idle logic
			if (_currentState == State.MAINAPP) {
				if (((getTimer() - _idleStart) / 1000) > 10)
				{
					switchToScreenSaver();
				}
			}
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
			_idleStart = getTimer();
		}
		
		private function switchToMainApp():void
		{
			_screenSaver.Deactivate();
			for each (var s:System in _systems)
			{
				s.Activate();
			}
			_backgroundImage.visible = true;
			_currentState = State.MAINAPP;
			_mainButton.visible = false;
		}
		
		private function switchToScreenSaver():void
		{
			_screenSaver.Activate();
			for each (var s:System in _systems)
			{
				s.Deactivate();
				//if (s is PDFSystem)
				//	continue;
				s.Hide();
			}
			_backgroundImage.visible = false;
			_currentState = State.SCREENSAVER;
			_mainButton.visible = true;
			setChildIndex(_mainButton, numChildren - 1);
		}
		
		private function onInteraction(event:MouseEvent):void
		{
			if (_currentState == State.MAINAPP) {
				_idleStart = getTimer();
			}
		}
	}
}

final class State 
{
    public static const SCREENSAVER:String = "SCREENSAVER";
    public static const MAINAPP:String = "MAINAPP";
}