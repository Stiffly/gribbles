package Systems
{
	/**
	 * ImageSystem.as
	 * Keeps track of the ImageViewer and its associated button
	 *
	 * @author Adam Byléhn
	 * @contact adambylehn@hotmail.com
	 */
	
	import com.gestureworks.cml.core.CMLObjectList;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.elements.Button;
	import com.gestureworks.cml.components.AlbumViewer;
	import com.gestureworks.cml.elements.Image;
	import com.gestureworks.cml.elements.Album;
	
	public class ImageSystem extends System
	{
		private var m_ImageViewer:AlbumViewer;
		private var m_Button:Button;
		
		public function ImageSystem()
		{
			super();
		}
		
		override public function Init():void
		{
			m_ImageViewer = createViewer(new AlbumViewer(), 0, 0, 500, 400) as AlbumViewer;
			m_ImageViewer.autoTextLayout = false;
			m_ImageViewer.linkAlbums = true;
			m_ImageViewer.clusterBubbling = true;
			m_ImageViewer.mouseChildren = true;
			
			// Front
			var front:Album = new Album();
			front.loop = true;
			front.horizontal = true;
			front.applyMask = true;
			front.margin = 8;
			front.mouseChildren = true;
			front.clusterBubbling = true;
			front.dragGesture = "1-finger-drag";
						
			for each (var imageFile:String in getFilesInDirectoryRelative("images/content"))
			{
				trace(imageFile);
				var image:Image = new Image();
				image.open(imageFile);
				image.width = 500;
				image.height = 400;
				image.init();
				front.addChild(image);
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
			m_ImageViewer.front = front;
			m_ImageViewer.addChild(front);
			m_ImageViewer.gestureList = {"2-finger-drag": true, "n-scale": true, "n-rotate": true};
			stage.addChild(m_ImageViewer);
			hideComponent(m_ImageViewer);
			
			m_Button = CMLObjectList.instance.getId("image-button");
			m_Button.addEventListener(StateEvent.CHANGE, imageButtonHandler);
			stage.addChild(m_Button);
		}
		
		override public function Update():void
		{
		
		}
		
		private function imageButtonHandler(event:StateEvent):void
		{
			switchButtonState(event.value, m_ImageViewer);
		}
	}
}