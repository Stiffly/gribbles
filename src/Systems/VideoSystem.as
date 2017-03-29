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
		private var m_VideoViewer:AlbumViewer;
		private var m_Button:Button;
		
		public function VideoSystem()
		{
			super();
		}
		
		override public function Init():void
		{
			m_VideoViewer = createViewer(new AlbumViewer(), 0, 0, 500, 400) as AlbumViewer;
			m_VideoViewer.autoTextLayout = false;
			m_VideoViewer.linkAlbums = true;
			m_VideoViewer.clusterBubbling = true;
			m_VideoViewer.mouseChildren = true;

			
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
			m_VideoViewer.front = front;
			m_VideoViewer.addChild(front);
			m_VideoViewer.gestureList = {"2-finger-drag": true, "n-scale": true, "n-rotate": true};
			hideComponent(m_VideoViewer);
			stage.addChild(m_VideoViewer);
			
			m_Button = CMLObjectList.instance.getId("video-button");
			m_Button.addEventListener(StateEvent.CHANGE, videoButtonHandler);
			stage.addChild(m_Button);
		}
		
		private function videoButtonHandler(event:StateEvent):void
		{
			switchButtonState(event.value, m_VideoViewer);
		}
	}
}
