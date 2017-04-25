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
		private var _videoViewer:VideoViewer;
		
		public function VideoSystem()
		{
			super();
		}
		
		override public function Init():void
		{
			// Create the video Viewer (which actually is an AlbumViewer atm, if amount of videos == 1 -> can change to VideoViewer)
			_videoViewer = createViewer(new VideoViewer(), 0, 0, 720, 576) as VideoViewer;
			_videoViewer.autoTextLayout = false;
			_videoViewer.clusterBubbling = true;
			//_videoViewer.mouseChildren = true;
			_videoViewer.gestureList = {"n-drag": true, "n-scale": true, "n-rotate": true};

			stage.addChild(_videoViewer);

			// For every file in 'videos' folder, load the file
			for each (var videoFile:String in getFilesInDirectoryRelative("videos")) {
				// Dynamically load video from disk
				var video:Video = new Video();
				video.src = videoFile;
				video.width = 720;
				video.height = 576;
				video.autoplay = true;
				video.loop = true;
				video.progressBar = true;
				video.clusterBubbling = true;
				_videoViewer.addChild(video);
			}
			
			// Add InfoPanel, Frame, TouchContainer and ViewerMenu
			addInfoPanel(_videoViewer, "Bärgning", "\nDenna film visar när man bärgar Gribshindens monsterfigur strax utanför Ronneby efter drygt 500 år på botten.");
			addFrame(_videoViewer);
			addTouchContainer(_videoViewer);
			addViewerMenu(_videoViewer, true, true, true);
			
			// Hide it
			hideComponent(_videoViewer);
			
			// Initiate all of its elements
			DisplayUtils.initAll(_videoViewer);
			
			// Load the button from CML
			_button = CMLObjectList.instance.getId("video-button");
			_button.addEventListener(StateEvent.CHANGE, videoButtonHandler);
			stage.addChild(_button);
		}
		
		private function videoButtonHandler(event:StateEvent):void
		{
			// Button state was changed
			switchButtonState(event.value, _videoViewer, 400, 200);
		}
	}
}
