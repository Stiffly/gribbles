package
 {
	import flash.geom.Rectangle;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;	
	import flash.display.StageDisplayState;
	 
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
			var text : TextField = new TextField();
			text.text = "Hällo world!";
			addChild(text);
			// This makes the image fit-ish to the screen
			stage.fullScreenSourceRect = new Rectangle(0, 0, 1920, 1080);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.displayState = StageDisplayState.FULL_SCREEN;
			
			Mouse.hide();
		}
    }
 }