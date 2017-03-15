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
		private var video : AlbumViewer;
		private var image : AlbumViewer;
		private var button : Button;
		private var imageButton : Button;
		
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
			video = CMLObjectList.instance.getId("av"); // AlbumViewer
			video.alpha = 0.0;
			video.touchEnabled = true;
			
			image = CMLObjectList.instance.getId("image-viewer");
			image.alpha = 0.0;
			image.touchEnabled = true;
			
			button  = CMLObjectList.instance.getId("avbutton"); // AlbumViewer
			button.addEventListener(StateEvent.CHANGE, buttonHandler);
			
			imageButton  = CMLObjectList.instance.getId("image-button"); // AlbumViewer
			imageButton.addEventListener(StateEvent.CHANGE, imageButtonHandler);
		}
		
		private function buttonHandler(event : StateEvent) : void
		{
			// Only on release
			if (event.value == "down-state")
				return;
			if (video.alpha > 0) {
				video.alpha = 0.0;
				video.touchEnabled = false;
			}
			else if (video.alpha == 0) {
				video.alpha = 1.0;
				video.touchEnabled = true;
			}
		}
		
				private function imageButtonHandler(event : StateEvent) : void
		{
			// Only on release
			if (event.value == "down-state")
				return;
			if (image.alpha > 0) {
				image.alpha = 0.0;
				image.touchEnabled = false;
			}
			else if (image.alpha == 0) {
				image.alpha = 1.0;
				image.touchEnabled = true;
			}
		}
		
	}
}
