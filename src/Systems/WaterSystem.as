package Systems 
{

	import be.nascom.flash.graphics.Rippler;
    
    import flash.display.Bitmap;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.MouseEvent;
	import Systems.System;
	
	public class WaterSystem extends Systems.System
	{
		// Embed an image
		[Embed(source="../../assets/images/DSC_7142.jpg")]
		private var _sourceImage : Class;
		
		private var _target : Bitmap;
		private var _rippler : Rippler;
		
		public function WaterSystem():void 
		{
			super();
		}
		
		override public function Init():void 
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