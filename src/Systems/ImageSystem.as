package Systems
{
	/**
	 * Systems.ImageSystem
	 * Keeps track of the ImageViewer and its associated button
	 *
	 * @author Adam Byléhn
	 * @contact adambylehn@hotmail.com
	 */
	
	import com.gestureworks.cml.components.Component;
	import com.gestureworks.cml.elements.Container;
	import com.gestureworks.cml.elements.Text;
	import com.gestureworks.cml.elements.TouchContainer;
	import com.gestureworks.cml.utils.DisplayUtils;
	import com.gestureworks.cml.elements.Graphic;
	
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
		private var _imageViewers:Array = new Array();
		private var temp:Array = new Array();
		private var temp2:int = 0;
		private var _button:Button;
		
	
		
		public function ImageSystem()
		{
			super();
		}
		
		
		
		override public function Init():void
		{
			temp.push(new textContent("Galjonsfiguren", "Träskulpturen under lyft på sin trävagga. Öron och den tandförsedda käften med människoansiktet stickande ut är tydliga. Ögonen verkar sitta nedaför \"pannan\" riktade frammåt och de två \"knopparna\" ovanpå skulle då eventuellt kunna vara fästen för horn."));
			temp.push(new textContent("Number dos", "This is numbero two"));
			temp.push(new textContent("Number tres", "This is numbero tre"));
			temp.push(new textContent("Number quattro staggioni", "This is numbero vier"));
			
			var drawingsViewer:AlbumViewer = createViewer(new AlbumViewer(), 0, 0, 500, 500) as AlbumViewer;
			drawingsViewer.autoTextLayout = false;
			drawingsViewer.linkAlbums = false;
			drawingsViewer.clusterBubbling = true;
			drawingsViewer.mouseChildren = true;
			drawingsViewer.nativeTransform = false;
			drawingsViewer.gestureList = {"2-finger-drag": true, "n-scale": true, "n-rotate": true};
			drawingsViewer.addEventListener(GWGestureEvent.ROTATE, rotate_handler);
			drawingsViewer.addEventListener(GWGestureEvent.SCALE, scale_handler);
			drawingsViewer.addEventListener(GWGestureEvent.DRAG, drag_handler);
			stage.addChild(drawingsViewer);
			
			// Front
			var drawingsFront:Album = new Album();
			drawingsFront.loop = true;
			drawingsFront.horizontal = true;
			drawingsFront.applyMask = true;
			drawingsFront.margin = 8;
			drawingsFront.mouseChildren = true;
			drawingsFront.clusterBubbling = true;
			drawingsFront.dragGesture = "1-finger-drag";
			// Add images to album
			for each (var drawingsPath:String in getFilesInDirectoryRelative("images/content/drawings"))
			{
				drawingsFront.addChild(loadImage(drawingsPath));
			}
			drawingsViewer.front = drawingsFront;
			drawingsViewer.addChild(drawingsFront);
			// Back
			addInfoPanel(drawingsViewer, "Ritningar", "Du kan bläddra genom att swipa ett finger i sidled på albumet.\n\nAlbumet visar bilder på Gribshunden.");
			// Add Frame, TouchContainer and ViewerMenu
			addFrame(drawingsViewer);
			//addTouchContainer(_imageViewer);
			addViewerMenu(drawingsViewer, true, false, false);
			// Initiate the album viewer and its children
			DisplayUtils.initAll(drawingsViewer);
			// Hide the album viewer
			hideComponent(drawingsViewer);
			_imageViewers.push(drawingsViewer);
			
			var figureViewer:AlbumViewer = createViewer(new AlbumViewer(), 0, 0, 500, 500) as AlbumViewer;
			figureViewer.autoTextLayout = false;
			figureViewer.linkAlbums = false;
			figureViewer.clusterBubbling = true;
			figureViewer.mouseChildren = true;
			figureViewer.nativeTransform = true;
			figureViewer.gestureList = {"2-finger-drag": true, "n-scale": true, "n-rotate": true};
			stage.addChild(figureViewer);
			
			// Front
			var figureFront:Album = new Album();
			figureFront.loop = true;
			figureFront.horizontal = true;
			figureFront.applyMask = true;
			figureFront.margin = 8;
			figureFront.mouseChildren = true;
			figureFront.clusterBubbling = true;
			figureFront.dragGesture = "1-finger-drag";
			
			// Back
			var figureBack:Album = new Album();
			figureBack.id = "back";
			figureBack.alpha = 0.5;
			figureBack.applyMask = true;
			figureBack.horizontal = true;
			figureBack.visible = false;
			figureBack.margin = 8;
			figureBack.loop = true;
			figureBack.horizontal = true;
			figureBack.applyMask = true;
			figureBack.margin = 8;
			figureBack.mouseChildren = true;
			figureBack.clusterBubbling = true;
			figureBack.touchEnabled = false;
			// Add images to album
			for each (var figurePath:String in getFilesInDirectoryRelative("images/content/figurehead"))
			{
				figureFront.addChild(loadImage(figurePath));
				figureBack.addChild(createDescription(temp[temp2].title, temp[temp2].description));
				temp2++;
			}
			figureViewer.front = figureFront;
			figureViewer.back = figureBack;
			figureViewer.addChild(figureFront);
			figureViewer.addChild(figureBack);
			// Back
			//addInfoPanel(figureViewer, "Galjonsfigur", "Detta är ett annat album.");
			// Add Frame, TouchContainer and ViewerMenu
			addFrame(figureViewer);
			//addTouchContainer(_imageViewer);
			addViewerMenu(figureViewer, true, false, false);
			// Initiate the album viewer and its children
			DisplayUtils.initAll(figureViewer);
			// Hide the album viewer
			hideComponent(figureViewer);
			_imageViewers.push(figureViewer);
			
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
			for each (var imageViewer:AlbumViewer in _imageViewers)
			{
				switchButtonState(event.value, imageViewer, 400, 400);
			}
		}
		
		// Dynamically load an image from disk
		private function loadImage(source:String):Image
		{
			var image:Image = new Image();
			image.open(source);
			image.width = 500;
			image.height = 500;
			return image;
		}
		
		private function createDescription(title:String, description:String) :TouchContainer
		{
			var tc:TouchContainer = new TouchContainer();
			tc.width = 500;
			tc.height = 500;
			
			var g:Graphic = new Graphic();
			g.shape = "rectangle";
			g.color = 0x15B011;
			g.width = tc.width;
			g.height = tc.height;
			tc.addChild(g);
			
			var c:Container = new Container();
			c.paddingTop = 30;
			c.paddingLeft = 30;
			c.paddingRight = 30;
			c.width = 500;
			c.height = 500;
			c.relativeY = true;
			tc.addChild(c);
			
			var t:Text = new Text();
			t.str = title;
			t.fontSize = 30;
			t.color = 0xFFFFFF;
			t.font = "OpenSansBold";
			t.autosize = true;
			t.width = 500;
			c.addChild(t);
			
			var d:Text = new Text();
			d.str = description;
			d.fontSize = 20;
			d.color = 0xFFFFFF;
			d.font = "OpenSansBold";
			d.wordWrap = true;
			d.autosize = true;
			d.multiline = true;
			d.width = 500;
			c.addChild(d);
			
			DisplayUtils.initAll(tc);
			
			return tc;
		}
	}

}

class textContent
{
	public function textContent(t:String, d:String) { title = t; description = d; };
	public var title:String;
	public var description:String;
}
	