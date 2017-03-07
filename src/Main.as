package
 {
	import Systems.WaterSystem;
    import com.gestureworks.core.GestureWorks;
    import flash.text.TextField;
	
	[SWF(backgroundColor="0x000000", frameRate="60", width="1920", height="1080")]
    public class Main extends GestureWorks
    {
		private var myWater:WaterSystem;
		
        public function Main():void
        {
            super();
			gml = "gestures.gml"; // gml now required
			trace(myWater);
			myWater = new WaterSystem();
			addChild(myWater);
			myWater.Ripple();
        }
 
        override protected function gestureworksInit():void
        {
            var txt:TextField = new TextField;
            txt.text = "Gesture work initialized";
            addChild(txt);
		}
    }
 }