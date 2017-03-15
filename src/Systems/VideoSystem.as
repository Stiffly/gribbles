package Systems 
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import com.gestureworks.cml.components.AlbumViewer;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.core.CMLObjectList;
	

	public class VideoSystem extends Systems.System
	{		
		private var album : AlbumViewer;
		
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
			var album : AlbumViewer = CMLObjectList.instance.getId("av"); // AlbumViewer
			album.alpha = 1.0;
			album.touchEnabled = false;
		}
		
	}
}
