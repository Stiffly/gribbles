package
{
	import Components.TextBox;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.ui.Mouse;
	import flash.text.TextField;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import util.TextContent;
	
	import com.gestureworks.cml.elements.Graphic;
	import com.gestureworks.cml.core.CMLAir;
	CMLAir;
	import com.gestureworks.core.GestureWorksAIR;
	GestureWorksAIR;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.elements.Button;
	import com.gestureworks.cml.elements.Image;
	import com.gestureworks.cml.elements.Menu;
	import com.gestureworks.cml.utils.DisplayUtils;
	import Systems.System;
	import Systems.WaterSystem;
	import Systems.PDFSystem;
	import Systems.CustomButtonSystem;
	import Events.MenuEvent;
	
	/**
	 * Main
	 *
	 * This is the entry point of the application gribbles
	 *
	 * @author Adam Byléhn
	 * @contact adambylehn@hotmail.com
	 */
	
	[SWF(backgroundColor = "0x313131", width = "1920", height = "1080", frameRate = "30")]
	public class Main extends GestureWorksAIR
	{
		// Loader image
		[Embed(source = "../bin/images/loader.png")]
		private var _loaderSource:Class;
		private var _loaderImage:Sprite;
		
		// Background image
		[Embed(source = "../bin/images/bottenbild2.png")]
		private var _backgroundSource:Class;
		private var _backgroundImage:Sprite;
		
		private var _systems:Array = new Array();
		private var _screenSaver:WaterSystem;
		private var _passedFrames:int = 0;
		private var _startTime:Number = .0;
		private var _FPSCounter:TextField = new TextField();
		private var _elapsedTime:int = 0;
		private var _elapsedTimeText:TextField = new TextField();
		private var _mainButton:Button;
		private var _backButton:Button;
		private var _idleStart:Number = .0;
		
		private var _currentState:String = State.SCREENSAVER;
		
		private var _systemsAreInitiated:Boolean = false;
		private var _PDFLoaded:Boolean = false;
		
		private var _tutorialBox:TextBox = null;
		
		public function Main()
		{
			trace("gribbles starting");
			
			fullscreen = true;
			
			// Calls super constructor GestureWorks()
			super();
			cml = "main.cml";
			gml = "gml/gestures.gml"; // gml now required
			
			// Add systems here
			//_systems.push(new HTMLSystem());
			_systems.push(new PDFSystem());
			//_systems.push(new VideoSystem());
			//_systems.push(new ImageSystem());
			//_systems.push(new AudioSystem());
			_systems.push(new CustomButtonSystem());
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
			createMiddleButton();
			// Create a button for switching to screensaver
			createBackButton();
			
			addChildAt(_loaderImage, numChildren - 1);
			
			// Loops over each system and intializes it
			for each (var s:System in _systems)
			{
				addChild(s);
				s.Init();
			}
			addChild(_screenSaver);
			_screenSaver.Init();
			_screenSaver.Deactivate();
		}
		
		
		override protected function gestureworksInit():void
		{
			trace("Gestureworks initiated");
			_loaderImage = new Sprite();
			_loaderImage.graphics.beginBitmapFill(new _loaderSource().bitmapData, null, true, true);
			_loaderImage.graphics.drawRect(.0, .0, stage.stageWidth, stage.stageHeight);
			_loaderImage.graphics.endFill();
			addChildAt(_loaderImage, numChildren - 1);
			
			_backgroundImage = new Sprite();
			_backgroundImage.graphics.beginBitmapFill(new _backgroundSource().bitmapData, null, true, true);
			_backgroundImage.graphics.drawRect(.0, .0, stage.stageWidth, stage.stageHeight);
			_backgroundImage.graphics.endFill();
			_backgroundImage.visible = false;
			addChildAt(_backgroundImage, 0);
			
			_tutorialBox = new TextBox(new TextContent("Välkommen", "Utforska skeppsvraket på botten genom att klicka på vrakdelarna"), 15);
			
			_tutorialBox.width = 1000;
			_tutorialBox.x = stage.stageWidth / 2 - _tutorialBox.width / 2;
			_tutorialBox.y = stage.stageHeight / 2 - _tutorialBox.height / 2;
			_tutorialBox.nativeTransform = true;
			_tutorialBox.clusterBubbling = true;
			_tutorialBox.mouseChildren = true;
			DisplayUtils.initAll(_tutorialBox);
			addChildAt(_tutorialBox, numChildren - 1);
			
			// Hide mouse
			//Mouse.hide();
			
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
				switch (_currentState)
				{
				case State.MAINAPP: 
					_tutorialBox.Update();
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
			
			if (!_PDFLoaded && _elapsedTime > 5)
			{
				// 10 seconds have passed, should be safe to hide PDF
				for each (var sy:System in _systems)
				{
					if (sy is PDFSystem) 
					{
						sy.Hide();
						_loaderImage.visible = false;
						_PDFLoaded = true;
						switchToScreenSaver();
						// Do not update systems until they're all initiated
						_systemsAreInitiated = true;
					}
				}
			}
			// Idle logic
			if (_currentState == State.MAINAPP)
			{
				if (((getTimer() - _idleStart) / 1000) > 60)
				{
					switchToScreenSaver();
				}
			}
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			if (event.keyCode == 117)
			{ // F6
				fullscreen = true;
			}
		}
		
		private function getCircle(color:uint, width:int, height:int, alpha:Number = 1):Graphic
		{
			var circle:Graphic = new Graphic();
			circle.shape = "circle";
			circle.width = width;
			circle.height = height;
			circle.radius = 100;
			circle.color = color;
			circle.alpha = alpha;
			circle.lineStroke = 0;
			return circle;
		}
		
		private function getImage(path:String):Image
		{
			var image:Image = new Image();
			image.open(path);
			return image;
		}
		
		private function onButtonPress(event:StateEvent):void
		{
			if (event.value != "up")
			{
				return;
			}
			
			if (_currentState == State.MAINAPP)
			{
				switchToScreenSaver();
			}
			else if (_currentState == State.SCREENSAVER)
			{
				switchToMainApp();
				_idleStart = getTimer();
			}
		}
		
		private function switchToMainApp():void
		{
			_screenSaver.Deactivate();
			for each (var s:System in _systems)
			{
				s.Activate();
			}
			
			_tutorialBox.Rebirth();
			_tutorialBox.x = stage.stageWidth / 2 - _tutorialBox.width / 2;
			_tutorialBox.y = stage.stageHeight / 2 - _tutorialBox.height / 2;
			_tutorialBox.visible = true;
			setChildIndex(_tutorialBox, numChildren - 1);
			_backgroundImage.visible = true;
			_currentState = State.MAINAPP;
			_mainButton.visible = false;
			_backButton.visible = true;
		}
		
		private function switchToScreenSaver():void
		{
			_screenSaver.Activate();
			for each (var s:System in _systems)
			{
				s.Deactivate();
				if (s is PDFSystem && !_PDFLoaded)
					continue;
				s.Hide();
			}
			_backgroundImage.visible = false;
			_currentState = State.SCREENSAVER;
			_mainButton.visible = true;
			_backButton.visible = false;
			setChildIndex(_mainButton, numChildren - 1);
		}
		
		private function createMiddleButton():void
		{
			_mainButton = new Button();
			_mainButton.width = 159;
			_mainButton.height = 159;
			_mainButton.x = (stage.stageWidth >> 1) - (_mainButton.width / 2);
			_mainButton.y = (stage.stageHeight >> 1) - (_mainButton.height / 2);
			_mainButton.dispatch = "initial:initial:down:down:up:up:over:over:out:out";
			_mainButton.hit = getCircle(0x000000, 159, 159, 0);
			
			var initial:Image = getImage("images/buttons/button-middle-up.png");
			initial.alpha = 0.5;
			_mainButton.initial = initial;
			_mainButton.down = getImage("images/buttons/button-middle-up.png");
			var up:Image = initial;
			_mainButton.up = up;
			_mainButton.over = getImage("images/buttons/button-middle-up.png");
			var out:Image = up;
			_mainButton.out = out;
			_mainButton.init();
			_mainButton.addEventListener(StateEvent.CHANGE, onButtonPress);
			addChild(_mainButton);
		}
		
		private function createBackButton():void 
		{
			_backButton = new Button();
			_backButton.width = 100;
			_backButton.height = 100;
			_backButton.x = 0 + 5;
			_backButton.y = (stage.stageHeight) - (_backButton.height) - 5;
			_backButton.dispatch = "initial:initial:down:down:up:up:over:over:out:out";
			var hit:Image = getImage("images/buttons/button-back-up.png");
			hit.alpha = 0;
			_backButton.hit = hit;
			var down:Image = getImage("images/buttons/button-back-up.png");
			down.alpha = 0.5;
			_backButton.initial = getImage("images/buttons/button-back-up.png");
			_backButton.down = down;
			var over:Image = down;
			_backButton.up = getImage("images/buttons/button-back-up.png");
			_backButton.over = over;
			var out:Image = getImage("images/buttons/button-back-up.png");
			_backButton.out = out;
			_backButton.init();
			_backButton.addEventListener(StateEvent.CHANGE, onButtonPress);
			addChild(_backButton);
		}
		
		private function onInteraction(event:MouseEvent):void
		{
			if (_currentState == State.MAINAPP)
			{
				_idleStart = getTimer();
				_tutorialBox.Kill();
				_tutorialBox.visible = false;
			}
		}
	}
}

final class State
{
	public static const SCREENSAVER:String = "SCREENSAVER";
	public static const MAINAPP:String = "MAINAPP";
}