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
		private var _imageViewer:AlbumViewer;
		private var _button:Button;
		
		public function ImageSystem()
		{
			super();
		}
		
		override public function Init():void
		{
			_imageViewer = createViewer(new AlbumViewer(), 0, 0, 500, 400) as AlbumViewer;
			_imageViewer.autoTextLayout = false;
			_imageViewer.linkAlbums = true;
			_imageViewer.clusterBubbling = true;
			_imageViewer.mouseChildren = true;
			
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
			_imageViewer.front = front;
			_imageViewer.addChild(front);
			_imageViewer.gestureList = {"2-finger-drag": true, "n-scale": true, "n-rotate": true};
			stage.addChild(_imageViewer);
			hideComponent(_imageViewer);
			
			_button = CMLObjectList.instance.getId("image-button");
			_button.addEventListener(StateEvent.CHANGE, imageButtonHandler);
			stage.addChild(_button);
		}
		
		override public function Update():void
		{
		
		}
		
		private function imageButtonHandler(event:StateEvent):void
		{
			switchButtonState(event.value, _imageViewer);
		}
	}
}