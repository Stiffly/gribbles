package Systems
{
	/**
	 * Systems.ImageSystem
	 * Keeps track of the ImageViewer and its associated button
	 *
	 * @author Adam Byléhn
	 * @contact adambylehn@hotmail.com
	 */
	
	import com.gestureworks.cml.away3d.lights.DirectionalLight;
	import flash.net.URLLoader; 
	import flash.net.URLRequest;
	import flash.events.Event;
	 
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
		private var _i:uint = 0;
		private var _parentPaths:Array = new Array();
		private var _numChildren:Object = new Object();
		private var _indexCircles:Object = new Object();
		private var _pathToAlbumViewerMap:Object = new Object();
		private var _knownFormats:Array = [".png", ".jpg", ".bmp", ".gif", ".jpeg", ".tiff"];
	
		public function ImageSystem()
		{
			super();
		}
		
		override public function Init():void
		{
			for each (var parentPath:String in getFilesInDirectoryRelative("images/content"))
			{
				_parentPaths.push(parentPath);
				_numChildren[parentPath] = 0;
				var av:AlbumViewer = createViewer(new AlbumViewer(), 400, 400, 1000, 700) as AlbumViewer;
				av.autoTextLayout = false;
				av.linkAlbums = true;
				av.clusterBubbling = true;
				av.mouseChildren = true;
				av.gestureList = {"2-finger-drag": true, "n-scale": true, "n-rotate": true};
				addChild(av);
				
				// Front
				var front:Album = new Album();
				front.id = "front";
				front.loop = true;
				front.horizontal = true;
				front.applyMask = true;
				front.margin = 8;
				front.mouseChildren = true;
				front.clusterBubbling = false;
				front.dragGesture = "1-finger-drag";
				
				// Back
				var back:Album = new Album();
				back.id = "back";
				back.loop = true;
				back.alpha = 0.6;
				back.horizontal = true;
				back.margin = 8;
				back.clusterBubbling = false;
				back.visible = false;
				back.dragGesture = "1-finger-drag";
				back.dragAngle = 0;
				
				for each (var childPaths:String in getFilesInDirectoryRelative(parentPath))
				{
					for each (var extention:String in _knownFormats) {	
						if (childPaths.toUpperCase().search(extention.toUpperCase()) != -1)
						{
							front.addChild(loadImage(childPaths));
							// Load its associated description
							var textFile:String = childPaths.replace(extention, ".txt");
							var loader:URLLoader = new URLLoader(new URLRequest(textFile));
							loader.addEventListener(Event.COMPLETE, onFileLoaded(av, front, back, parentPath));
							_numChildren[parentPath]++;
						}
					}
				}
			}
			
			// Create the button loaded from CML
			_button = CMLObjectList.instance.getId("image-button");
			_button.addEventListener(StateEvent.CHANGE, imageButtonHandler);
			addChild(_button);
		}
		
		override public function Update():void
		{
			for each (var s:String in _parentPaths)
			{
				for each (var g:Graphic in _indexCircles[s])
				{
					g.color = 0x000000;
				}
				_indexCircles[s][_pathToAlbumViewerMap[s].front.currentIndex].color = 0xFFFFFF;
			}
		}
		
		// On button click
		private function imageButtonHandler(event:StateEvent):void
		{
			for each (var s:String in _parentPaths) 
			{
				switchButtonState(event.value, _pathToAlbumViewerMap[s], 400, 400);
			}
		}
		
		private function onFileLoaded(av:AlbumViewer, front:Album, back:Album, s:String):Function {
			return function (event:Event):void
			{
				_i++;
				var content:String = URLLoader(event.currentTarget).data;
				var index:int = content.search("\n");
				back.addChild(createDescription(new textContent(content.slice(0, index), content.slice(index +1 , content.length))));
				if (_numChildren[s] ==  _i)
				{
					av.front = front;
					av.back = back;
					av.addChild(front);
					av.addChild(back);
					addFrame(av);
					addViewerMenu(av, true, false, false);
					_indexCircles[s] = new Array();
					for (var i:int = 0; i < _numChildren[s]; i++)
					{
						var g:Graphic = getCircle(0x000000, i, 0.5);
						_indexCircles[s].push(g);
						av.addChild(g);
					}
					_pathToAlbumViewerMap[s] = av;
					DisplayUtils.initAll(av);
					hideComponent(av);
					_i = 0;
					return;
				}
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
			for each (var s:String in _parentPaths) 
			{
				if (_pathToAlbumViewerMap[s] == null)
					return;
				hideComponent(_pathToAlbumViewerMap[s]);
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
	