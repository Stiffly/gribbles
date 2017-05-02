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
		// Member iterator to keep track of how many children has been loaded
		private var _i:uint = 0;
		// We store all parent folder paths in an array
		private var _parentPaths:Array = new Array();
		// Stores the number of children that each album has, used to init albums only once, when all children are loaded
		private var _numChildren:Object = new Object();
		// A map containing arrays of the index circles that shows what image in the album that is active
		private var _indexCircles:Object = new Object();
		// The album map keeps track of all album viewers, with unique parent folder as key
		private var _pathToAlbumViewerMap:Object = new Object();
		// The supported file formats that can be loaded
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
				
				// Create album viewer
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
				
				// Add all the children, images 
				for each (var childPaths:String in getFilesInDirectoryRelative(parentPath))
				{
					for each (var extention:String in _knownFormats) {	
						if (childPaths.toUpperCase().search(extention.toUpperCase()) != -1)
						{
							// Load image
							front.addChild(loadImage(childPaths));
							// Update number of children, this is compared against in onFileLoaded function
							_numChildren[parentPath]++;
							// Load its associated description
							var textFile:String = childPaths.replace(extention, ".txt");
							var loader:URLLoader = new URLLoader(new URLRequest(textFile));
							loader.addEventListener(Event.COMPLETE, onFileLoaded(av, front, back, parentPath));
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
			// For all parent folders...
			for each (var s:String in _parentPaths)
			{
				// For all index circle per album
				for each (var g:Graphic in _indexCircles[s])
				{
					g.color = 0x999999;
				}
				// If the back is active, we use this as our index
				if (_pathToAlbumViewerMap[s].back.active) 
				{
					_indexCircles[s][_pathToAlbumViewerMap[s].back.currentIndex].color = 0x000000;
				}
				// Else the front is active, use it instead
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
		
		// This handler triggers when a description file is loaded (.txt)
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
					addViewerMenu(av, false, true, false, false);
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
		
		// Create a circle
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
		
		// Hides everything
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
	