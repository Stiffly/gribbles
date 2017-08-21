package
{
	import Components.TextBox;
	import Events.PDFEvent;
	import Events.ShowFishes;
	import Systems.Fishes;
	import com.gestureworks.cml.elements.Container;
	import com.gestureworks.cml.elements.Text;
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
	import Systems.CustomButtonSystem;
	import Events.MenuEvent;
	import util.LayerHandler;
	
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
		//private var _passedFrames:int = 0;
		private var _startTime:Number = .0;
		//private var _FPSCounter:TextField = new TextField();
		private var _elapsedTime:int = 0;
		private var _elapsedTimeText:TextField = new TextField();
		private var _mainButton:Button;
		private var _backButton:Button;
		private var _idleStart:Number = .0;
		private var _idle:Boolean = true;
		private var _letItRip:Boolean = true;
		private var _flockFishes:Fishes = new Fishes();
		
		private var _currentState:String = State.SCREENSAVER;
		
		private var _systemsAreInitiated:Boolean = false;
		private var _PDFLoaded:Boolean = false;
		
		private var _tutorialBox:Container = null;
		
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
			//createBackButton();
			
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
			
			createTutorialBox();
			
			_flockFishes.Init(stage, 2);
			
			// Hide mouse
			Mouse.hide();
			
			// Show FPS-counter
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(MouseEvent.MOUSE_MOVE, onInteraction);
			stage.addEventListener(ShowFishes.SHOWFISH, showFishes);
			_elapsedTimeText.y = 10;
		}
		
		private function createTutorialBox():void
		{
			_tutorialBox = new Container();
			_tutorialBox.width = 1000;
			_tutorialBox.height = 500;
			
			var g:Graphic = new Graphic();
			g.shape = "rectangle";
			g.width = _tutorialBox.width;
			g.height = _tutorialBox.height;
			g.alpha = 0.7;
			g.color = 0x000000;
			_tutorialBox.addChild(g);
			
			var bigTitle:Text = new Text();
			bigTitle.text = "Gribshunden (1495)";
			bigTitle.fontSize = "72";
			bigTitle.textColor = 0xFFFFFF;
			bigTitle.height = bigTitle.textHeight;
			bigTitle.width = bigTitle.textWidth + 3;
			bigTitle.x = _tutorialBox.width / 2 - bigTitle.width / 2;
			_tutorialBox.addChild(bigTitle);
			
			var textBox:TextBox = new TextBox(new TextContent("", "\nUtforska skeppsvraket på botten.\n\n" + "Håll utkik efter ikonerna nedan som används för att navigera i applikationen.\n\n" + "Rör vart som helst på skärmen för att börja."), 0, .0, 999999, "center", 20, 0);
			textBox.width = _tutorialBox.width;
			textBox.y = bigTitle.height;
			_tutorialBox.addChild(textBox);
			
			var ci:Container = new Container;
			ci.width = 150;
			ci.x = _tutorialBox.width / 2 - ci.width / 2;
			ci.y = textBox.y + 170;
			
			var ii:Image = new Image();
			ii.open("images/buttons/info.png");
			ii.width = 50;
			ii.alpha = 1;
			ci.addChild(ii);
			
			var it:Text = new Text();
			it.fontSize = 20;
			it.x = ii.width + 15;
			it.y = 10;
			it.text = "Info";
			it.textColor = 0xFFFFFF;
			ci.addChild(it);
			
			_tutorialBox.addChild(ci);
			
			var cpl:Container = new Container;
			cpl.width = 150;
			cpl.x = _tutorialBox.width / 2 - cpl.width / 2;
			cpl.y = ci.y + 50;
			
			var pli:Image = new Image();
			pli.open("images/buttons/play.png");
			pli.width = 50;
			pli.alpha = 1;
			cpl.addChild(pli);
			
			var plt:Text = new Text();
			plt.fontSize = 20;
			plt.x = pli.width  + 15;
			plt.y = 10;
			plt.text = "Spela";
			plt.textColor = 0xFFFFFF;
			cpl.addChild(plt);
			
			_tutorialBox.addChild(cpl);
			
			var cpa:Container = new Container;
			cpa.width = 150;
			cpa.x = _tutorialBox.width / 2 - cpa.width / 2;
			cpa.y = cpl.y + 50;
			
			var pai:Image = new Image();
			pai.open("images/buttons/pause.png");
			pai.width = 50;
			pai.alpha = 1;
			cpa.addChild(pai);
			
			var pat:Text = new Text();
			pat.fontSize = 20;
			pat.y = 10;
			pat.x = pai.width + 15;
			pat.text = "Paus";
			pat.textColor = 0xFFFFFF;
			cpa.addChild(pat);
			
			_tutorialBox.addChild(cpa);
			
			var cc:Container = new Container;	
			cc.width = 150;		
			cc.x = _tutorialBox.width / 2 - cc.width / 2;
			cc.y = cpa.y + 50;
			
			var cli:Image = new Image();
			cli.open("images/buttons/close.png");
			cli.width = 50;
			cli.alpha = 1;
			cc.addChild(cli);
			
			var ct:Text = new Text();
			ct.fontSize = 20;
			ct.font = "Arial";
			ct.x = cli.width + 15;
			ct.y = 10;
			ct.text = "Stäng";
			ct.textColor = 0xFFFFFF;
			cc.addChild(ct);
			
			_tutorialBox.addChild(cc);
			
			DisplayUtils.initAll(_tutorialBox);
			addChild(_tutorialBox);
		}
		
		private function onEnterFrame(event:Event):void
		{
			var updateFreq:int = 1; // Times per second
			//_passedFrames++;
			var dt:Number = (getTimer() - _startTime) / 1000;
			if (dt > 1 / updateFreq)
			{
				//_FPSCounter.text = "FPS: " + _passedFrames * updateFreq;
				_startTime = getTimer();
					//_passedFrames = 0;
			}
			if (_systemsAreInitiated)
			{
				switch (_currentState)
				{
				case State.MAINAPP: 
					for each (var child:* in _tutorialBox.childList)
					{
						if (child is TextBox)
						{
							child.Update();
						}
					}
					for each (var s:System in _systems)
						s.Update();
					_flockFishes.Update();
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
					sy.Hide();
					_loaderImage.visible = false;
					_PDFLoaded = true;
					switchToScreenSaver();
					stage.dispatchEvent(new PDFEvent(PDFEvent.PDFLoaded));
					// Do not update systems until they're all initiated
					_systemsAreInitiated = true;
				}
			}
			
			// Idle logic
			if (_idle && _PDFLoaded && _currentState == State.SCREENSAVER)
			{
				if (Math.floor(((getTimer() - _idleStart) / 1000)) > 1)
				{
					_screenSaver.Ripple();
					_idleStart = getTimer();
				}	
			}
			if (_currentState == State.SCREENSAVER)
			{
				if (!_idle && ((getTimer() - _idleStart) / 1000) > 10)
				{
					_idle = true;
					_idleStart = getTimer();
				}
			}
			if (_currentState == State.MAINAPP)
			{
				if (((getTimer() - _idleStart) / 1000) > 120)
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
		
		private function showFishes(event:ShowFishes):void
		{
			//LayerHandler.BRING_TO_FRONT(_flockFishes);
			_flockFishes.Activate();
		}
		
		private function getCircle(color:uint, width:int, height:int, alpha:Number = 1):Graphic
		{
			var circle:Graphic = new Graphic();
			circle.shape = "circle";
			circle.radius = width / 2;
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
			for each (var child:* in _tutorialBox.childList)
			{
				if (child is TextBox)
				{
					child.Rebirth();
				}
			}
			
			_tutorialBox.x = stage.stageWidth / 2 - _tutorialBox.width / 2;
			_tutorialBox.y = stage.stageHeight / 2 - _tutorialBox.height / 2;
			_tutorialBox.visible = true;
			LayerHandler.BRING_TO_FRONT(_tutorialBox);
			
			_backgroundImage.visible = true;
			_currentState = State.MAINAPP;
			_mainButton.visible = false;
			//_backButton.visible = true;
			
			_flockFishes.Activate();
		}
		
		private function switchToScreenSaver():void
		{
			_screenSaver.Activate();
			_flockFishes.Deactivate();
			for each (var s:System in _systems)
			{
				s.Deactivate();
				s.Hide();
			}
			_backgroundImage.visible = false;
			_currentState = State.SCREENSAVER;
			_mainButton.visible = true;
			
			_tutorialBox.visible = false;
			//_backButton.visible = false;
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
			_idle = false;
			if ((getTimer() - _idleStart) / 1000 < 1)
			{
				return;
			}
			if (_currentState == State.MAINAPP)
			{
				_idleStart = getTimer();
				for each (var child:* in _tutorialBox.childList)
				{
					if (child is TextBox)
					{
						child.Kill();
					}
				}
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