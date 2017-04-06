package Systems
{
	/**
	 * Systems.VideoSystem
	 * Keeps track of the VideoViewer and its associated button
	 *
	 * @author Adam Byléhn
	 * @contact adambylehn@hotmail.com
	 */
	
	import com.gestureworks.cml.utils.DisplayUtils;
	 
	import com.gestureworks.cml.components.VideoViewer;
	import com.gestureworks.cml.core.CMLObjectList;
	import com.gestureworks.cml.elements.Graphic;
	import com.gestureworks.cml.elements.Video;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.elements.Button;
	import com.gestureworks.cml.components.AlbumViewer;
	import com.gestureworks.cml.elements.Album;
	import com.gestureworks.cml.elements.Menu;
	
	public class VideoSystem extends Systems.System
	{
		private var _videoViewer:AlbumViewer;
		private var _button:Button;
		
		public function VideoSystem()
		{
			super();
		}
		
		override public function Init():void
		{
			_videoViewer = createViewer(new AlbumViewer(), 0, 0, 500, 400) as AlbumViewer;
			_videoViewer.autoTextLayout = false;
			_videoViewer.linkAlbums = false;
			_videoViewer.clusterBubbling = true;
			_videoViewer.mouseChildren = true;
			_videoViewer.gestureList = {"2-finger-drag": true, "n-scale": true, "n-rotate": true};

			stage.addChild(_videoViewer);

			// Front
			var front:Album = new Album();
			front.loop = true;
			front.horizontal = true;
			front.applyMask = true;
			front.margin = 8;
			front.mouseChildren = true;
			front.clusterBubbling = true;
			front.dragGesture = "1-finger-drag";
			
			for each (var videoFile:String in getFilesInDirectoryRelative("videos"))
			{
				var video:Video = new Video();
				video.src = videoFile;
				video.width = 500;
				video.height = 400;
				video.centerPlayButton = true;
				video.autoplay = true;
				video.loop = true;
				video.progressBar = true;
				video.volume = 20;
				front.addChild(video);
			}
			_videoViewer.front = front;
			_videoViewer.addChild(front);
			
			addInfoPanel(_videoViewer, "Videofilm", "Denna film visar när man fiskar upp Gribshindens galjonsfigur.");
			addFrame(_videoViewer);
			addTouchContainer(_videoViewer);
			addViewerMenu(_videoViewer, true, true, true);
			
			hideComponent(_videoViewer);
			
			DisplayUtils.initAll(_videoViewer);
			
			_button = CMLObjectList.instance.getId("video-button");
			_button.addEventListener(StateEvent.CHANGE, videoButtonHandler);
			stage.addChild(_button);
		}
		
		private function videoButtonHandler(event:StateEvent):void
		{
			switchButtonState(event.value, _videoViewer);
		}
	}
}
