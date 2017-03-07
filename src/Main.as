package
 {
	import Systems.VideoSystem;
	import Systems.WaterSystem;
    import com.gestureworks.core.GestureWorks;
    import flash.text.TextField;
	
	[SWF(backgroundColor="0x000000", frameRate="60", width="1920", height="1080")]
    public class Main extends GestureWorks
    {
		private var myWater:WaterSystem;
		private var myVideo:VideoSystem;
		
		
        public function Main():void
        {
            super();
			gml = "gestures.gml"; // gml now required
			
			myWater = new WaterSystem();
			myVideo = new VideoSystem();
			addChild(myWater);
			addChild(myVideo);
			myWater.Init();
			myVideo.Init();
        }
 
        override protected function gestureworksInit():void
        {
            var txt:TextField = new TextField;
            txt.text = "Gesture work initialized";
            addChild(txt);
		}
    }
 }