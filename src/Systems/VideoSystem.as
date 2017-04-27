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
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.errors.IOError;
	 
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
		private var _videoViewer:Array = new Array();
		private var _knownFormats:Array = [".mov", ".avi", ".dvi", ".mpg", ".mpeg", ".flv", ".3GP" ];
		private var _i:uint = 0;
		
		public function VideoSystem()
		{
			super();
		}
		
		override public function Init():void
		{
			// For every file in 'videos' folder, load the file
			for each (var videoFile:String in getFilesInDirectoryRelative("videos")) {
				for each (var extention:String in _knownFormats) {
					if (videoFile.toUpperCase().search(extention.toUpperCase()) != -1) {
						var videoViewer:VideoViewer = createViewer(new VideoViewer(), 0, 0, 720, 576) as VideoViewer;
						// Create the video Viewer (which actually is an AlbumViewer atm, if amount of videos == 1 -> can change to VideoViewer)
						_videoViewer.push(videoViewer);
						videoViewer.autoTextLayout = false;
						videoViewer.clusterBubbling = true;
						//_videoViewer.mouseChildren = true;
						videoViewer.gestureList = {"n-drag": true, "n-scale": true, "n-rotate": true};
						addChild(videoViewer);
					
						// Dynamically load video from disk
						var video:Video = new Video();
						video.src = videoFile;
						video.width = 720;
						video.height = 576;
						video.autoplay = true;
						video.loop = true;
						video.progressBar = true;
						videoViewer.addChild(video);
						
						// Load its associated description
						var textFile:String = videoFile.replace(extention, ".txt");
						var loader:URLLoader = new URLLoader(new URLRequest(textFile));
						loader.addEventListener(Event.COMPLETE, onFileLoaded(videoViewer));
					}
				}
			}
			// Initiate all of its elements
			DisplayUtils.initAll(_videoViewer);
			
			// Load the button from CML
			_button = CMLObjectList.instance.getId("video-button");
			_button.addEventListener(StateEvent.CHANGE, videoButtonHandler);
			addChild(_button);
		}
		
		private function videoButtonHandler(event:StateEvent):void
		{
			// Button state was changed
			for each (var vv:VideoViewer in _videoViewer)
				switchButtonState(event.value, vv, 400, 200);
		}
		
		public override function Hide():void
		{
			for each (var vv:VideoViewer in _videoViewer)
				hideComponent(vv);
		}
		
		private function onFileLoaded(videoViewer:VideoViewer):Function {
			return function (event:Event):void
			{
				var content:String = URLLoader(event.currentTarget).data;
				var index:int = content.search("\n");
				addInfoPanel(videoViewer, content.slice(0, index), content.slice(index +1 , content.length));
				// Add InfoPanel, Frame, TouchContainer and ViewerMenu
				addFrame(videoViewer);
				addViewerMenu(videoViewer, true, true, true);
				DisplayUtils.initAll(videoViewer);
			};
		}
	}
}
