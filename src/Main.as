package
 {
	import com.adobe.tvsdk.mediacore.ABRControlParameters;
	import flash.events.Event;
	import flash.geom.Rectangle;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;	
	import flash.display.StageDisplayState;
	import flash.utils.getTimer;
	import flash.ui.Mouse;
	import flash.text.TextField;
	
    import com.gestureworks.core.GestureWorks;
    import com.gestureworks.cml.utils.List;
	
	import Systems.System;
	import Systems.VideoSystem;
	import Systems.WaterSystem;
	
	[SWF(frameRate="60", width="1920", height="1080")]
    public class Main extends GestureWorks
    {		
		private var systems:List = new List();
		
		private var passedFrames:int = 0;
		private var startTime:Number = 0;
		private var FPScounter : TextField = new TextField(); 

        public function Main():void
        {
			// Calls super constructor (GestureWorks())
            super();
			gml = "../assets/gml/gestures.gml"; // gml now required
			cml = "../assets/cml/main.cml";
			
			// Add systems here
			systems.append(new WaterSystem());
			systems.append(new VideoSystem());
        }

        override protected function gestureworksInit():void
        {
			// Loops over each system and intializes it
			for each(var s:System in systems)
			{
				addChild(s);
				s.Init();
			}

			// This makes the image fit-ish to the screen
			stage.fullScreenSourceRect = new Rectangle(0, 0, 1920, 1080);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.displayState = StageDisplayState.FULL_SCREEN;
			
			Mouse.hide();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			FPScounter.text = "FPS: ";
			addChild(FPScounter);
		}
		
		private function onEnterFrame( event : Event) : void 
		{
			passedFrames++;
			if ((getTimer() - startTime) / 1000 > 1) {
				FPScounter.text = "FPS: " + passedFrames;
				startTime = getTimer();
				passedFrames = 0;
			}
		}
    }
 }