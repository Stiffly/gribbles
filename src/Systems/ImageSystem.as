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
		private var _figureFront:Album;
		private var _indexCircles:Array = new Array();
	
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
			
			_drawingInfo.push(new textContent("1", "\nEtt"));
			_drawingInfo.push(new textContent("Ritningar från Saeby kyrka", "\nBilden är från en ristning i kalkputsen i Saeby kyrka, Danmark. Ristningen föreställer ett stort örlogskepp med djurfigur i stäven från cirka 1500."));
			_drawingInfo.push(new textContent("Ritningar från Saeby kyrka", "\nBilden är från en ristning i kalkputsen i Saeby kyrka, Danmark. Ristningen föreställer ett stort örlogskepp med djurfigur i stäven från cirka 1500."));
			_drawingInfo.push(new textContent("Ritningar från Saeby kyrka", "\nBilden är från en ristning i kalkputsen i Saeby kyrka, Danmark. Ristningen föreställer ett stort örlogskepp med djurfigur i stäven från cirka 1500."));
			_drawingInfo.push(new textContent("5", "\nFem"));
			_drawingInfo.push(new textContent("Kraek", "\nDen okända mästaren \"WA\" ritade denna \"Kraek\" - karrack - omkring 1470. Gribhunden har sannolikt haft en akter uppbyggd på liknande sätt."));
			_drawingInfo.push(new textContent("7", "\nSju"));
			
			_albumPositions.push(new Position(400, 0));
			var drawingsViewer:AlbumViewer = createViewer(new AlbumViewer(), _albumPositions[_i].X, _albumPositions[_i].Y, 1000, 700) as AlbumViewer;
			_i++;
			drawingsViewer.autoTextLayout = false;
			drawingsViewer.linkAlbums = true;
			drawingsViewer.clusterBubbling = true;
			drawingsViewer.mouseChildren = true;
			drawingsViewer.gestureList = {"2-finger-drag": true, "n-scale": true, "n-rotate": true};
			//drawingsViewer.nativeTransform = false;
			//drawingsViewer.addEventListener(GWGestureEvent.ROTATE, rotate_handler);
			//drawingsViewer.addEventListener(GWGestureEvent.SCALE, scale_handler);
			//drawingsViewer.addEventListener(GWGestureEvent.DRAG, drag_handler);
			addChild(drawingsViewer);
			
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
			// Add Frame, TouchContainer and ViewerMenu
			addFrame(drawingsViewer);
			//addTouchContainer(_imageViewer);
			addViewerMenu(drawingsViewer, true, false, false);
			// Initiate the album viewer and its children
			DisplayUtils.initAll(drawingsViewer);
			
			_imageViewers.push(drawingsViewer);
			
			_albumPositions.push(new Position(400, 500));
			var figureViewer:AlbumViewer = createViewer(new AlbumViewer(), _albumPositions[_i].X, _albumPositions[_i].Y, 1000, 700) as AlbumViewer;
			figureViewer.autoTextLayout = false;
			figureViewer.linkAlbums = true;
			figureViewer.clusterBubbling = true;
			figureViewer.mouseChildren = true;
			figureViewer.gestureList = {"2-finger-drag": true, "n-scale": true, "n-rotate": true};
			addChild(figureViewer);
			
			// Front
			_figureFront =  new Album();
			_figureFront.id = "front";
			_figureFront.loop = true;
			_figureFront.horizontal = true;
			_figureFront.applyMask = true;
			_figureFront.margin = 8;
			_figureFront.mouseChildren = true;
			_figureFront.clusterBubbling = false;
			_figureFront.dragGesture = "1-finger-drag";
			
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
			var figurePaths:Array = getFilesInDirectoryRelative("images/content/figurehead");
			for (var j:int = 0; j < figurePaths.length; j++)
			{
				_figureFront.addChild(loadImage(figurePaths[j]));
				figureBack.addChild(createDescription(_figureInfo[j]));
				
				var g:Graphic = getCircle(0x000000, j, 0.5);
				_indexCircles.push(g);
			}
			figureViewer.front = _figureFront;
			figureViewer.back = figureBack;
			figureViewer.addChild(_figureFront);
			figureViewer.addChild(figureBack);
			// Back
			//addInfoPanel(figureViewer, "Galjonsfigur", "Detta är ett annat album.");
			// Add Frame, TouchContainer and ViewerMenu
			addFrame(figureViewer);
			//addTouchContainer(_imageViewer);
			addViewerMenu(figureViewer, true, false, false);
			// Initiate the album viewer and its children
			DisplayUtils.initAll(figureViewer);
			
			for each (var g:Graphic in _indexCircles)
				figureViewer.addChild(g);
			
			_imageViewers.push(figureViewer);
			
			// Create the button loaded from CML
			_button = CMLObjectList.instance.getId("image-button");
			_button.addEventListener(StateEvent.CHANGE, imageButtonHandler);
			addChild(_button);
		}
		
		override public function Update():void
		{
			for each (var g:Graphic in _indexCircles)
				g.color = 0x000000;
			_indexCircles[_figureFront.currentIndex].color = 0xFFFFFF;
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
		
		private function getCircle(color:uint, it:Number, alpha:Number = 1):Graphic
		{
			var circle:Graphic = new Graphic();
			var rad:Number = 10;
			circle.x = it * 2 * rad;
			circle.shape = "circle";
			circle.radius = rad;
			circle.color = color;
			circle.alpha = alpha;
			circle.lineStroke = 0;
			return circle;
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
				
		public override function Hide():void
		{
			for each (var iv:AlbumViewer in _imageViewers) {
				hideComponent(iv);
			}
		}
	}
}

class textContent
{
	public function textContent(t:String, d:String) { title = t; description = d; };
	public var title:String;
	public var description:String;
}
	