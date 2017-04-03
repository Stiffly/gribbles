package Systems
{
	/**
	 * VideoSystem.as
	 * Keeps track of the VideoViewer and its associated button
	 *
	 * @author Adam Byléhn
	 * @contact adambylehn@hotmail.com
	 */
	
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
			_videoViewer.linkAlbums = true;
			_videoViewer.clusterBubbling = true;
			_videoViewer.mouseChildren = true;

			
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
				video.init();
				front.addChild(video);
				/*
				var playButton:Button = new Button();
				playButton.initial = "play";
				playButton.hit = "play";
				playButton.down = "play";
				playButton.up = "play";
				playButton.dispatch = "down:down";
				playButton.active = true;
				playButton.init();
				playButton.hideOnToggle;
				video.addChild(playButton);
				
				var buttonGraphic:Graphic = new Graphic();
				buttonGraphic.id = "play";
				buttonGraphic.shape = "triangle";
				buttonGraphic.height = 100;
				buttonGraphic.rotation = 90;
				buttonGraphic.x = 300;
				buttonGraphic.y = 150;
				buttonGraphic.alpha = 0.5;
				buttonGraphic.init();
				playButton.addChild(buttonGraphic);*/
			}
			
			front.init();
			_videoViewer.front = front;
			_videoViewer.addChild(front);
			_videoViewer.gestureList = {"2-finger-drag": true, "n-scale": true, "n-rotate": true};
			hideComponent(_videoViewer);
			stage.addChild(_videoViewer);
			
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
