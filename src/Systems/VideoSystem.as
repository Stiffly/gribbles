package Systems 
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import com.gestureworks.cml.components.AlbumViewer;
	import com.gestureworks.cml.elements.Button;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.core.CMLObjectList;
	import com.gestureworks.cml.events.StateEvent;
	import flash.events.MouseEvent;
	

	public class VideoSystem extends Systems.System
	{		
		private var album : AlbumViewer;
		private var button : Button;
		
		public function VideoSystem():void 
		{
			super();
		}
		
		override public function Init():void 
		{
			CMLParser.addEventListener(CMLParser.COMPLETE, cmlComplete);
		}		
		
		private function cmlComplete(event:Event):void
		{
			CMLParser.removeEventListener(CMLParser.COMPLETE, cmlComplete);
			album = CMLObjectList.instance.getId("av"); // AlbumViewer
			album.alpha = 0.0;
			album.touchEnabled = true;
			
			CMLParser.removeEventListener(CMLParser.COMPLETE, cmlComplete);
			button  = CMLObjectList.instance.getId("avbutton"); // AlbumViewer
			button.addEventListener(StateEvent.CHANGE, buttonHandler);
		}
		
		private function buttonHandler(event : StateEvent) : void
		{
			// Only on release
			if (event.value == "down-state")
				return;
			if (album.alpha > 0) {
				album.alpha = 0.0;
				album.touchEnabled = false;
			}
			else if (album.alpha == 0) {
				album.alpha = 1.0;
				album.touchEnabled = true;
			}
		}
		
	}
}
