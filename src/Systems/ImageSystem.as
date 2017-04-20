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
	
	import util.Position;
	
	public class ImageSystem extends System
	{
		private var _imageViewers:Array = new Array();
		private var _figureInfo:Array = new Array();
		private var _drawingInfo:Array = new Array();
		private var _albumPositions:Array = new Array();
		private var _i:int = 0;
		private var _button:Button;
	
		public function ImageSystem()
		{
			super();
		}
		
		override public function Init():void
		{
			_figureInfo.push(new textContent("Monsterfigur", 	"\nTräskulpturen under lyft på sin trävagga. Öron och den tandförsedda käften med människoansiktet stickande ut är tydliga. Ögonen verkar sitta nedaför \"pannan\" riktade frammåt och de två \"knopparna\" ovanpå skulle då eventuellt kunna vara fästen för horn."));
			_figureInfo.push(new textContent("Bärgning", 		"\nGribshundens \"monsterfigur\" bärgades sommaren 2015 och ligger nu i konservering i Köpenhamn. Bilden visar hur \"monsterfiguren\" bärgas efter drygt 500 år på botten. Vraket ligger kvar vid Ekön utanför Ronneby i Blekinge, knappt 10 meter under vattenytan."));
			_figureInfo.push(new textContent("Monsterfigur", 	"\nBalken med träfiguren som skulle bärgas var 0,353 meter lång, 0,35 x 0,35 meter i huvudändan och 0,20 x 0,20 meter i kortändan. Vikten beräknades till 340 kg. För att stabilisera balken under lyftet specialtillverkades en vadderad vagga vilken fördelade vikten samt skyddade skulpturen från stötar."));
			_figureInfo.push(new textContent("Gribshunden", 	"\nGribshunden är det bäst bevarade exemplet i världen på den teknik och den nya typ av fartyg som senare skulle utvecklas till stora välkända nordeuropeiska örlogsskepp som Mary Rose (1545), Mars (1564), Vasa (1628), och Kronan (1676). Det är ett fartyg som är samtida med Christoffer Columbus så omtalade skepp Sankta Maria från 1492 (fast större)."));
			
			_drawingInfo.push(new textContent("1", "uno"));
			_drawingInfo.push(new textContent("2", "uno"));
			_drawingInfo.push(new textContent("3", "uno"));
			_drawingInfo.push(new textContent("4", "uno"));
			_drawingInfo.push(new textContent("5", "uno"));
			_drawingInfo.push(new textContent("6", "uno"));
			_drawingInfo.push(new textContent("7", "uno"));
			
			_albumPositions.push(new Position(400, 0));
			var drawingsViewer:AlbumViewer = createViewer(new AlbumViewer(), _albumPositions[_i].X, _albumPositions[_i].Y, 1000, 700) as AlbumViewer;
			_i++;
			drawingsViewer.autoTextLayout = false;
			drawingsViewer.linkAlbums = true;
			drawingsViewer.clusterBubbling = true;
			drawingsViewer.mouseChildren = true;
			drawingsViewer.gestureList = {"2-finger-drag": true, "n-scale": true, "n-rotate": true};
			drawingsViewer.addEventListener(TouchEvent.TOUCH_BEGIN, onTouch);
			stage.addChild(drawingsViewer);
			
			// Front
			var drawingsFront:Album = new Album();
			drawingsFront.id = "front";
			drawingsFront.loop = true;
			drawingsFront.horizontal = true;
			drawingsFront.applyMask = true;
			drawingsFront.margin = 8;
			drawingsFront.mouseChildren = true;
			drawingsFront.clusterBubbling = false;
			drawingsFront.dragGesture = "1-finger-drag";
			
			// Back
			var drawingsBack:Album = new Album();
			drawingsBack.id = "back";
			drawingsBack.loop = true;
			drawingsBack.alpha = 0.6;
			drawingsBack.horizontal = true;
			drawingsBack.margin = 8;
			drawingsBack.clusterBubbling = false;
			drawingsBack.visible = false;
			drawingsBack.dragGesture = "1-finger-drag";
			drawingsBack.dragAngle = 0;
			
			// Add images to album
			var drawingPath:Array = getFilesInDirectoryRelative("images/content/drawings");
			for (var i:int = 0; i < drawingPath.length; i++) {
				drawingsFront.addChild(loadImage(drawingPath[i]));
				drawingsBack.addChild(createDescription(_drawingInfo[i]));
			}
			drawingsViewer.front = drawingsFront;
			drawingsViewer.back = drawingsBack;
			drawingsViewer.addChild(drawingsFront);
			drawingsViewer.addChild(drawingsBack);
			
			// Back
			//addInfoPanel(drawingsViewer, "Ritningar", "Du kan bläddra genom att swipa ett finger i sidled på albumet.\n\nAlbumet visar bilder på Gribshunden.");
			// Add Frame, TouchContainer and ViewerMenu
			addFrame(drawingsViewer);
			//addTouchContainer(_imageViewer);
			addViewerMenu(drawingsViewer, true, false, false);
			// Initiate the album viewer and its children
			DisplayUtils.initAll(drawingsViewer);
			// Hide the album viewer
			hideComponent(drawingsViewer);
			_imageViewers.push(drawingsViewer);
			
			_albumPositions.push(new Position(400, 500));
			var figureViewer:AlbumViewer = createViewer(new AlbumViewer(), _albumPositions[_i].X, _albumPositions[_i].Y, 1000, 700) as AlbumViewer;
			figureViewer.autoTextLayout = false;
			figureViewer.linkAlbums = true;
			figureViewer.clusterBubbling = true;
			figureViewer.mouseChildren = true;
			figureViewer.gestureList = {"2-finger-drag": true, "n-scale": true, "n-rotate": true};
			figureViewer.addEventListener(TouchEvent.TOUCH_BEGIN, onTouch);
			stage.addChild(figureViewer);
			
			// Front
			var figureFront:Album = new Album();
			figureFront.id = "front";
			figureFront.loop = true;
			figureFront.horizontal = true;
			figureFront.applyMask = true;
			figureFront.margin = 8;
			figureFront.mouseChildren = true;
			figureFront.clusterBubbling = false;
			figureFront.dragGesture = "1-finger-drag";
			
			// Back
			var figureBack:Album = new Album();
			figureBack.id = "back";
			figureBack.loop = true;
			figureBack.alpha = 0.6;
			figureBack.horizontal = true;
			figureBack.margin = 8;
			figureBack.clusterBubbling = false;
			figureBack.visible = false;
			figureBack.dragGesture = "1-finger-drag";
			figureBack.dragAngle = 0;
			
			// Add images to album
			var figurePath:Array = getFilesInDirectoryRelative("images/content/figurehead");
			for (var j:int = 0; j < figurePath.length; j++)
			{
				figureFront.addChild(loadImage(figurePath[j]));
				figureBack.addChild(createDescription(_figureInfo[j]));
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
			for (var i:int = 0; i < _imageViewers.length; i++ )
			{
				switchButtonState(event.value, _imageViewers[i], _albumPositions[i].X, _albumPositions[i].Y);
			}
		}
		
		// Dynamically load an image from disk
		private function loadImage(source:String):Image
		{
			var image:Image = new Image();
			image.open(source);
			image.width = 1000;
			image.height = 700;
			return image;
		}
		
		private function createDescription(content : textContent) :TouchContainer
		{
			var tc:TouchContainer = new TouchContainer();
			tc.width = 1000;
			tc.height = 400;
			
			var g:Graphic = new Graphic();
			g.shape = "rectangle";
			//g.color = 0x15B011;
			g.color = 0x555555;
			g.width = tc.width;
			g.height = tc.height;
			g.alpha = 0.1;
			tc.addChild(g);
			
			var c:Container = new Container();
			c.paddingTop = 30;
			c.paddingLeft = 30;
			c.paddingRight = 30;
			c.width = 1000;
			c.height = 400;
			c.relativeY = true;
			tc.addChild(c);
			
			var t:Text = new Text();
			t.str = content.title;
			t.fontSize = 30;
			t.color = 0xFFFFFF;
			t.font = "MyFont";
			t.autosize = true;
			t.width = 500;
			c.addChild(t);
			
			var d:Text = new Text();
			d.str = content.description;
			d.fontSize = 20;
			d.color = 0xFFFFFF;
			d.font = "MyFont";
			d.wordWrap = true;
			d.autosize = true;
			d.multiline = true;
			d.width = 500;
			c.addChild(d);
			
			DisplayUtils.initAll(tc);
			
			return tc;
		}
		
		private function onTouch(event:TouchEvent) : void
		{
			stage.setChildIndex(AlbumViewer(event.currentTarget), stage.numChildren - 1);
		}
	}
	
	

}

class textContent
{
	public function textContent(t:String, d:String) { title = t; description = d; };
	public var title:String;
	public var description:String;
}
	