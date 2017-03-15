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
			
			video = CMLObjectList.instance.getId("video-viewer"); // AlbumViewer
			hideAlbum(video);
			
			image = CMLObjectList.instance.getId("image-viewer");
			hideAlbum(image);
			
			button  = CMLObjectList.instance.getId("video-button"); // AlbumViewer
			button.addEventListener(StateEvent.CHANGE, buttonHandler);
			
			imageButton  = CMLObjectList.instance.getId("image-button"); // AlbumViewer
			imageButton.addEventListener(StateEvent.CHANGE, imageButtonHandler);
		}
		
		private function buttonHandler(event : StateEvent) : void
		{
			// Only on release
			if (event.value == "down-state")
				return;
			if (video.alpha > 0)
				hideAlbum(video);
			else if (video.alpha == 0)
				showAlbum(video);
		}
		
		private function imageButtonHandler(event : StateEvent) : void
		{
			// Only on release
			if (event.value == "down-state")
				return;
			if (image.alpha > 0) 
				hideAlbum(image);
			else if (image.alpha == 0) 
				showAlbum(image);
		}
		
		private function showAlbum(album : AlbumViewer) : void 
		{
			album.alpha = 1.0;
			album.touchEnabled = true;
			album.x = 585;
			album.y = 299;
			album.scale = 1.0;
			album.rotation = -10.0;
		}
		
		private function hideAlbum(album : AlbumViewer) : void 
		{
			album.alpha = 0.0;
			album.touchEnabled = false;
			album.x = 13337;
			album.y = 13337;
		}
	}
}
