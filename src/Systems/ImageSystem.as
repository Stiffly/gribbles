package Systems
{
	/**
	 * Systems.ImageSystem
	 * Keeps track of the ImageViewer and its associated button
	 *
	 * @author Adam Byléhn
	 * @contact adambylehn@hotmail.com
	 */
	
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
	import util.TextContent;
	
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
				back.alpha = 0.4;
				back.horizontal = true;
				back.margin = 8;
				back.clusterBubbling = false;
				back.visible = false;
				//back.dragGesture = "1-finger-drag";
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
					g.color = 0x999999;
				}
				if (_pathToAlbumViewerMap[s].back.active) 
				{
					_indexCircles[s][_pathToAlbumViewerMap[s].back.currentIndex].color = 0x000000;
				}
				else
				{
					_indexCircles[s][_pathToAlbumViewerMap[s].front.currentIndex].color = 0x000000;
				}
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
				back.addChild(createDescription(new TextContent(content.slice(0, index), content.slice(index +1 , content.length))));
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
						var g:Graphic = getCircle(0x999999, i, 0.5);
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
	