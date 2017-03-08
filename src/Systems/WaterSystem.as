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
		private var m_SourceImage : Class;
		private var m_Target : Bitmap;
		private var m_Rippler : Rippler;
		
		public function WaterSystem():void 
		{
			super();
		}
		
		override public function Init():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			// Create a Bitmap displayobject and add it to the stage 
			m_Target = new Bitmap(new m_SourceImage().bitmapData);
			addChild(m_Target);

			// Create the Rippler instance to affect the Bitmap object
			m_Rippler = new Rippler(m_Target, 20, 6);
			
			// Create the event listener for mouse movements
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
		}
		
		// Creates a ripple at mouse coordinates on mouse movement
		private function handleMouseMove(event : MouseEvent) : void
		{
			m_Rippler.drawRipple(m_Target.mouseX, m_Target.mouseY, 10, 1);
		}
	}
}
