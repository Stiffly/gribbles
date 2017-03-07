package
 {
    import com.gestureworks.core.GestureWorks;
    import flash.text.TextField;
	
	import be.nascom.flash.graphics.Rippler;
    
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.MouseEvent;
	
	[SWF(backgroundColor="0x000000", frameRate="60", width="1920", height="1080")]
    public class Main extends GestureWorks
    {
		// Embed an image
        [Embed(source="../assets/images/DSC_7142.jpg")]
        private var _sourceImage : Class;
        
        private var _target : Bitmap;
        private var _rippler : Rippler;
		
        public function Main():void
        {
            super();
			gml = "gestures.gml"; // gml now required
			Ripple();
        }
 
        override protected function gestureworksInit():void
        {
            var txt:TextField = new TextField;
            txt.text ="Gesture work initialized";
            addChild(txt);
        }
		
        public function Ripple()
        {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            
            // create a Bitmap displayobject and add it to the stage 
            _target = new Bitmap(new _sourceImage().bitmapData);
            addChild(_target);
            
            // create the Rippler instance to affect the Bitmap object
            _rippler = new Rippler(_target, 20, 6);
            
            // create the event listener for mouse movements
            stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
        }
        
        // creates a ripple at mouse coordinates on mouse movement
        private function handleMouseMove(event : MouseEvent) : void
        {
        	// the ripple point of impact is size 20 and has alpha 1
            _rippler.drawRipple(_target.mouseX, _target.mouseY, 10, 1);
        }
    }
 }