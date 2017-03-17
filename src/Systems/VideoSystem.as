package Systems 
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.display.StageDisplayState;
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
		private var videoButton : Button;
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
			
			video = CMLObjectList.instance.getId("video-viewer");
			hideAlbum(video);
			stage.addChild(video);
			
			
			image = CMLObjectList.instance.getId("image-viewer");
			hideAlbum(image);
			stage.addChild(image);
			
			videoButton  = CMLObjectList.instance.getId("video-button");
			videoButton.addEventListener(StateEvent.CHANGE, videoButtonHandler);
			stage.addChild(videoButton);
			
			
			imageButton  = CMLObjectList.instance.getId("image-button");
			imageButton.addEventListener(StateEvent.CHANGE, imageButtonHandler);
			stage.addChild(imageButton);
			
		}
		
		private function videoButtonHandler(event : StateEvent) : void
		{
			var button :Button  = CMLObjectList.instance.getId(event.id);
			// Only on release
			if (event.value == "down-state")
				return;
			if (video.alpha > 0) {
				hideAlbum(video);
				button.dispatch = "down";
			}
			else if (video.alpha == 0) {
				showAlbum(video);
				button.dispatch = "up";
			}
			
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
			album.scale = 1.0;
			album.x = stage.stageWidth / 2 - album.width / 2;
			album.y = stage.stageHeight / 2 - album.height / 2;
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
