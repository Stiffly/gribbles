package Systems
{
	/**
	 * WaterSystem.as
	 * Keeps track of the background image and it's corresponding water ripples
	 *
	 * @author Adam Byléhn
	 * @contact adambylehn@hotmail.com
	 */
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.TouchSprite
	import flash.events.TouchEvent;
	
	import be.nascom.flash.graphics.Rippler;
	
	public class WaterSystem extends Systems.System
	{
		// Embed an image which will be used as a background
		[Embed(source = "../../bin/images/content/bottenbild2.jpg")]
		private var m_SourceImage:Class;
		// The "rippler" that instantiates water ripples at the surface 
		private var m_Rippler:Rippler;
		// The touch object, in this case the entire screen
		private var m_TouchSprite:TouchSprite;
		
		// Constructor
		public function WaterSystem()
		{
			super();
		}
		
		override public function Init():void
		{
			// Create the touch object wich will be used as the background for the application
			m_TouchSprite = new TouchSprite();
			// Fill the touch object with the "background image"
			m_TouchSprite.graphics.beginBitmapFill(new m_SourceImage().bitmapData, null, true, true);
			m_TouchSprite.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			m_TouchSprite.graphics.endFill();
			
			// Add the touch sprite to the stage
			stage.addChild(m_TouchSprite);
			stage.setChildIndex(m_TouchSprite, 1);
			
			// Create the Rippler instance to affect the Bitmap object
			m_Rippler = new Rippler(m_TouchSprite, 20, 10);
			
			// Make the TouchSprite listen to the TOUCH_MOVE event
			m_TouchSprite.addEventListener(TouchEvent.TOUCH_MOVE, handleDrag);
		}
		
		private function handleDrag(event:TouchEvent):void
		{
			m_Rippler.drawRipple(event.stageX, event.stageY, 20, 1);
		}
	}
}
