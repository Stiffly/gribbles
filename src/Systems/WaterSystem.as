package Systems 
{
    import flash.display.Bitmap;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
	
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.core.TouchSprite
	
	import be.nascom.flash.graphics.Rippler;	
	import Systems.System;

	public class WaterSystem extends Systems.System
	{
		// Embed an image which will be used as a background
		[Embed(source="../../assets/images/DSC_7142.jpg")]
		private var m_SourceImage : Class;
		// The "rippler" that instantiates water ripples at the surface 
		private var m_Rippler : Rippler;
		// The touch object, in this case the entire screen
		private var m_TouchSprite : TouchSprite;

		public function WaterSystem():void 
		{
			super();
		}
		
		override public function Init():void 
		{
			// This makes the image fit-ish to the screen
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			// Create the touch object wich will be used as the background for the application
			m_TouchSprite = new TouchSprite();
			// Fill the touch object with the "background image"
			m_TouchSprite.graphics.beginBitmapFill(new m_SourceImage().bitmapData, null, true, true);
			m_TouchSprite.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			m_TouchSprite.graphics.endFill();
			
			// Add the touch sprite to the stage
			addChild(m_TouchSprite);
			
			// Create the Rippler instance to affect the Bitmap object
			m_Rippler = new Rippler(m_TouchSprite, 20, 6);
			
			// Register the TAP event to the touchsprite
			m_TouchSprite.gestureList = {"tap": true};
			m_TouchSprite.addEventListener(GWGestureEvent.TAP, handleTap);
		}
		
		private function handleTap(event : GWGestureEvent) : void
		{			
			// Cast event values to integers (required by ripple function)
			var x : int = event.value.tap_x;
			var y : int = event.value.tap_y;
			// Creates the water effect at the position of the Tap
			m_Rippler.drawRipple(x, y, 20, 1);
		}
	}
}
