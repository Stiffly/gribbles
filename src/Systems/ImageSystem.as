package Systems
{
	/**
	 * Systems.ImageSystem
	 * Keeps track of the ImageViewer and its associated button
	 *
	 * @author Adam Byléhn
	 * @contact adambylehn@hotmail.com
	 */
	
	import com.gestureworks.cml.utils.DisplayUtils;
	
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
			_imageViewer.gestureList = {"2-finger-drag": true, "n-scale": true, "n-rotate": true};
			_imageViewer.autoTextLayout = false;
			_imageViewer.linkAlbums = true;
			_imageViewer.clusterBubbling = true;
			_imageViewer.mouseChildren = true;
			
			stage.addChild(_imageViewer);
			
			// Front
			var front:Album = new Album();
			front.loop = true;
			front.horizontal = true;
			front.applyMask = true;
			front.margin = 8;
			front.mouseChildren = true;
			front.clusterBubbling = true;
			front.dragGesture = "1-finger-drag";
			
			// Add images to album
			for each (var imageFile:String in getFilesInDirectoryRelative("images/content")) {
				front.addChild(getImage(imageFile));
			}
			
			_imageViewer.front = front;
			_imageViewer.addChild(front);

			// Back
			//_imageViewer.back = addInfoPanel(_imageViewer, "En bild", "Detta är en bild");
			
			// Add Frame, TouchContainer and ViewerMenu
			addFrame(_imageViewer);
			addTouchContainer(_imageViewer);
			addViewerMenu(_imageViewer, true, false, false, false);
			
			// Initiate the album viewer and its children
			DisplayUtils.initAll(_imageViewer);
			
			// Hid the album viewer
			hideComponent(_imageViewer);
			
			// Create the button loaded from CML
			_button = CMLObjectList.instance.getId("image-button");
			_button.addEventListener(StateEvent.CHANGE, imageButtonHandler);
			stage.addChild(_button);
		}
		
		override public function Update():void
		{
		
		}
		
		// On button click
		private function imageButtonHandler(event:StateEvent):void
		{
			switchButtonState(event.value, _imageViewer);
		}
		
		// Load an image from disk
		private function getImage(source:String):Image
		{
			var image:Image = new Image();
			image.open(source);
			image.width = 500;
			image.height = 400;
			return image;
		}
	}
}