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
	import com.gestureworks.events.GWGestureEvent;
	import flash.events.TouchEvent;
	
	
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
			_imageViewer.linkAlbums = false;
			_imageViewer.clusterBubbling = true;
			_imageViewer.mouseChildren = true;
			_imageViewer.nativeTransform = false;
			_imageViewer.affineTransform = false;
			_imageViewer.gestureList = {"2-finger-drag": true, "n-scale": true, "n-rotate": true};
			_imageViewer.addEventListener(GWGestureEvent.ROTATE, rotate_handler);
			_imageViewer.addEventListener(GWGestureEvent.SCALE, scale_handler);
			_imageViewer.addEventListener(GWGestureEvent.DRAG, drag_handler);
			
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
			addInfoPanel(_imageViewer, "Bildalbum", "Du kan bläddra genom att swipa ett finger i sidled på albumet.");
			
			// Add Frame, TouchContainer and ViewerMenu
			addFrame(_imageViewer);
			//addTouchContainer(_imageViewer);
			addViewerMenu(_imageViewer, true, false, false);
			
			// Initiate the album viewer and its children
			DisplayUtils.initAll(_imageViewer);
			
			// Hid the album viewer
			hideComponent(_imageViewer);
			
			// Create the button loaded from CML
			_button = CMLObjectList.instance.getId("image-button");
			_button.addEventListener(StateEvent.CHANGE, imageButtonHandler);
			_button.x = 900;
			_button.y = 500;
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
		
		// Dynamically load an image from disk
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