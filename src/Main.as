/*
 * Main.as
 * This is the entry point of the application.
 * 
 * author: Adam Byléhn
 * contact: adambylehn@hotmail.com
 * 
 */

package
 {
	import flash.events.Event;
	import flash.geom.Rectangle;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;	
	import flash.display.StageDisplayState;
	import flash.utils.getTimer;
	import flash.ui.Mouse;
	import flash.text.TextField;
	
	import com.gestureworks.cml.core.CMLAir;	
    import com.gestureworks.core.GestureWorks;
    import com.gestureworks.cml.utils.List;
	
	import Systems.System;
	import Systems.VideoSystem;
	import Systems.WaterSystem;
	
	// Load CML Air classes
	CMLAir;
	
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
			cml = "main.cml";
			gml = "gml/gestures.gml"; // gml now required

			// Add systems here
			systems.append(new WaterSystem());
			//systems.append(new VideoSystem());

        }

        override protected function gestureworksInit():void
        {
			// Loops over each system and intializes it
			for each(var s:System in systems)
			{
				addChild(s);
				s.Init();
			}
			
			// The following should be toggelable from a configuration file
			
			// This makes the image fit-ish to the screen
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			// Enter fullscreen mode
			stage.fullScreenSourceRect = new Rectangle(0, 0, 1920, 1080);
			stage.displayState = StageDisplayState.FULL_SCREEN;
			// Hide mouse 
			Mouse.hide();
			
			// Show FPS-counter
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addChild(FPScounter);
		}
		
		private function onEnterFrame( event : Event) : void 
		{
			var updateFreq : int = 4; // Times per second
			passedFrames++;
			if ((getTimer() - startTime) / 1000 > 1 / updateFreq) {
				FPScounter.text = "FPS: " + passedFrames * updateFreq;
				startTime = getTimer();
				passedFrames = 0;
			}
		}
    }
 }