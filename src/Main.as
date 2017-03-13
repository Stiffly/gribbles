package
 {
    import com.gestureworks.core.GestureWorks;
    import com.gestureworks.cml.utils.List;
	
	import Systems.System;
	import Systems.VideoSystem;
	import Systems.WaterSystem;
	
	[SWF(backgroundColor="0xFFF00", frameRate="60", width="1920", height="1080")]
    public class Main extends GestureWorks
    {		
		private var systems:List = new List();

        public function Main():void
        {
			// Calls super constructor (GestureWorks())
            super();
			gml = "../lib/gml/gestures.gml"; // gml now required
			cml = "../lib/cml/AlbumViewer.cml";


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
		}
    }
 }