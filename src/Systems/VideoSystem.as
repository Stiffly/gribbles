package Systems 
{

	import com.gestureworks.cml.elements.Video;
	
	public class VideoSystem extends Systems.System
	{
		public function VideoSystem():void 
		{
			super();
		}
		
		override public function Init():void 
		{
			var video:Video = new Video();
			video.src = "../assets/videos/undervatten.mov";
			video.autoplay = true;
			video.loop = true;
			video.volume = 1;
			video.init();
			addChild(video);        
			video.play();
		}
		
		
	}
}