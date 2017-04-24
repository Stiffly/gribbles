package Systems
{
	/**
	 * Systems.WaterSystem
	 * Keeps track of the background image and it's corresponding water ripples
	 *
	 * @author Adam Byléhn
	 * @contact adambylehn@hotmail.com
	 */
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.TouchSprite
	import flash.events.TouchEvent;
	
	import be.nascom.flash.graphics.Rippler;
	
	public class WaterSystem extends Sprite
	{
		// Embed an image which will be used as a background
		[Embed(source = "../../bin/images/stones.jpg")]
		private var _sourceImage:Class;
		// The "rippler" that instantiates water ripples at the surface 
		private var _rippler:Rippler;
		// The touch object, in this case the entire screen
		private var _touchSprite:TouchSprite;
		
		// Constructor
		public function WaterSystem()
		{
			super();
		}
		
		public function Init():void
		{
			// Create the touch object wich will be used as the background for the application
			_touchSprite = new TouchSprite();
			// Fill the touch object with the "background image"
			_touchSprite.graphics.beginBitmapFill(new _sourceImage().bitmapData, null, true, true);
			_touchSprite.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			_touchSprite.graphics.endFill();
			
			// Add the touch sprite to the stage
			stage.addChild(_touchSprite);
			stage.setChildIndex(_touchSprite, 1);
			
			// Create the Rippler instance to affect the Bitmap object
			_rippler = new Rippler(_touchSprite, 20, 10);
			
			// Make the TouchSprite listen to the TOUCH_MOVE event
			_touchSprite.addEventListener(TouchEvent.TOUCH_MOVE, handleDrag);
		}
		
		public function Update():void
		{
			_rippler.Update();
		}
		
		private function handleDrag(event:TouchEvent):void
		{
			_rippler.drawRipple(event.stageX, event.stageY, 20, 1);
		}
		
		public function Deactivate():void
		{
			_rippler.destroy();
			_touchSprite.visible = false;
		}
		
		public function Activate():void
		{
			_rippler = new Rippler(_touchSprite, 20, 10);
			_touchSprite.visible = true;
		}
	}
}
import flash.display.Sprite;

class Dust extends Sprite
{
	
}
