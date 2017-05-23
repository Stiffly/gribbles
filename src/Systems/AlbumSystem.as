package Systems
{
	import com.gestureworks.cml.components.AlbumViewer;
	import com.gestureworks.cml.components.Component;
	import com.gestureworks.cml.components.ImageViewer;
	import com.gestureworks.cml.elements.Album;
	import com.gestureworks.cml.elements.Graphic;
	import com.gestureworks.cml.elements.Image;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.elements.Button;
	import util.TextContent;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class AlbumSystem extends System
	{
		// The album map keeps track of all album viewers, with unique parent folder as key
		private var _albumMap:Object = new Object();
		// The image map keeps track of all image viewers, with unique parent folder as key
		private var _imageMap:Object = new Object();
		// Stores the number of children that each album has, used to init albums only once, when all children are loaded
		private var _numChildren:Object = new Object();
		// A map containing arrays of the index circles that shows what image in the album that is active
		private var _indexCircles:Object = new Object();
		// Member iterator to keep track of how many children has been loaded
		private var _i:uint = 0;
		
		public function AlbumSystem()
		{
			super();
		
		}
		
		override public function Init():void 
		{
		}
		
		override public function Update():void 
		{
			
		}
		
		// This loads an album form disk
		public function LoadAlbum(key:String):void
		{
			_numChildren[key] = 0;

			// Create album viewer
			var av:AlbumViewer = createViewer(new AlbumViewer(), 400, 400, 500, 350) as AlbumViewer;
			av.autoTextLayout = false;
			av.linkAlbums = true;
			av.clusterBubbling = true;
			av.mouseChildren = true;
			av.gestureList = {"n-drag": true, "n-scale": true, "n-rotate": true};
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
			front.dragGesture = "";
			
			// Back
			var back:Album = new Album();
			back.id = "back";
			back.loop = true;
			back.horizontal = true;
			back.touchEnabled = false;
			back.margin = 8;
			back.clusterBubbling = false;
			back.visible = false;
			back.dragGesture = "";
			back.backgroundAlpha = 0;
			back.dragAngle = 0;
			
			// Add all the children, images etc.
			for each (var child:String in getFilesInDirectoryRelative(key))
			{
				if (isDirectory(child))
				{
					continue;
				}
				var extention:String = getExtention(child).toUpperCase();
				if (extention == "TXT")
				{
					continue;
				}
				// Load image
				front.addChild(getImage(child, av.width, av.height));
				// Update number of children, this is compared against in onFileLoaded function
				_numChildren[key]++;
				// Load its associated description
				var textFile:String = child.toUpperCase().replace(extention, "TXT");
				var loader2:URLLoader = new URLLoader(new URLRequest(textFile));
				loader2.addEventListener(Event.COMPLETE, FinalizeAlbum(av, front, back, key));
			}
		}
		
		// This loads an imageviewer with an image from disk
		public function LoadImage(key:String):void
		{			
			var iv:ImageViewer = createViewer(new ImageViewer(), 400, 400, 500, 350) as ImageViewer;
			iv.autoTextLayout = false;
			iv.clusterBubbling = true;
			iv.mouseChildren = true;
			iv.gestureList = {"n-drag": true, "n-scale": true, "n-rotate": true};
			addChild(iv);
			
			for each (var child:String in getFilesInDirectoryRelative(key))
			{
				if (isDirectory(child))
				{
					continue;
				}
				var extention:String = getExtention(child).toUpperCase();
				if (extention == "TXT")
				{
					continue;
				}
				iv.addChild(getImage(child, iv.width, iv.height));
				// Load its associated description
				var textFile:String = child.toUpperCase().replace(extention, "TXT");
				var loader:URLLoader = new URLLoader(new URLRequest(textFile));
				loader.addEventListener(Event.COMPLETE, FinalizeImage(iv, key));
			}
		}
		
		private function FinalizeImage(iv:ImageViewer, key:String):Function
		{
			return function(event:Event):void
			{
				var content:String = URLLoader(event.currentTarget).data;
				var index:int = content.search("\n");
				addInfoPanel(iv, content.slice(0, index), content.slice(index + 1, content.length), 16);
				addFrame(iv);
				addViewerMenu(iv, true, true, false, false);
				_imageMap[key] = iv;
				recursiveInit(iv);
				hideComponent(iv);
			}
		}
		
		// This handler triggers when a description file for an album is loaded (.txt)
		private function FinalizeAlbum(av:AlbumViewer, front:Album, back:Album, key:String):Function
		{
			return function(event:Event):void
			{
				// increment iterator i
				_i++;
				var content:String = URLLoader(event.currentTarget).data;
				// Finds the first newline and creates a text content that is used for the description
				var index:int = content.search("\n");
				back.addChild(TextContent.CREATE_DESCRIPTION(new TextContent(content.slice(0, index), content.slice(index + 1, content.length)), av.width, av.height, 0.8, 15));
				// This is true when all of the description files are loaded
				if (_numChildren[key] == _i)
				{
					// When all the description files are loaded we can initiate the albums
					av.front = front;
					av.back = back;
					av.addChild(front);
					av.addChild(back);
					addFrame(av);
					addViewerMenu(av, true, true, false, false);
					addButtons(av);
					
					_indexCircles[key] = new Array();
					for (var i:int = 0; i < _numChildren[key]; i++)
					{
						var radius:Number = 10;
						var g:Graphic = getCircle(0x999999, i * (radius << 1), -radius - _frameThickness, radius, 1);
						_indexCircles[key].push(g);
						av.addChild(g);
					}
					recursiveInit(av);
					_albumMap[key] = av;
					UpdateIndexCircles();
					hideComponent(av);
					_i = 0;
					return;
				}
			}
		}
		
		private function addButtons(av:AlbumViewer):void
		{
			var buttonSpace:int = 20;
			var right:Button = new Button();
			right.height = 26;
			right.width = 26;
			right.y = av.height + 3;
			right.x = av.width / 2 + buttonSpace;
			right.dispatch = "initial:initial:down:down:up:up:over:over:out:out";
			var hit:Image = getImage("images/buttons/right.png", right.width, right.height);
			hit.alpha = 0;
			right.hit = hit;
			var down:Image = getImage("images/buttons/right.png", right.width, right.height);
			down.alpha = 0.5;
			right.initial = getImage("images/buttons/right.png", right.width, right.height);
			right.down = down;
			var over:Image = down;
			right.up = getImage("images/buttons/right.png", right.width, right.height);
			right.over = over;
			var out:Image = getImage("images/buttons/right.png", right.width, right.height);
			right.out = out;
			right.init();
			right.addEventListener(StateEvent.CHANGE, onNextImage(av));
			av.addChild(right);
			
			var left:Button = new Button();
			left.height = 26;
			left.width = 26;
			left.y = av.height + 3;
			left.x = av.width / 2 - buttonSpace - left.width;
			left.dispatch = "initial:initial:down:down:up:up:over:over:out:out";
			hit = getImage("images/buttons/left.png", left.width, left.height);
			hit.alpha = 0;
			left.hit = hit;
			down = getImage("images/buttons/left.png", left.width, left.height);
			down.alpha = 0.5;
			left.initial = getImage("images/buttons/left.png", left.width, left.height);
			left.down = down;
			over = down;
			left.up = getImage("images/buttons/left.png", left.width, left.height);
			left.over = over;
			out = getImage("images/buttons/left.png", left.width, left.height);
			left.out = out;
			left.init();
			left.addEventListener(StateEvent.CHANGE, onPreviousImage(av));
			av.addChild(left);
		}
		
		private function onPreviousImage(av:AlbumViewer):Function
		{
			return function(e:StateEvent):void
			{
				if (e.value != "up")
				{
					return;
				}
				av.front.previous();
				UpdateIndexCircles();
			}
		}
		
		private function onNextImage(av:AlbumViewer):Function
		{
			return function(e:StateEvent):void
			{
				if (e.value != "up")
				{
					return;
				}
				av.front.next();
				UpdateIndexCircles();
			}
		}
		
		private function UpdateIndexCircles():void
		{
			// For all parent folders...
			for (var key:String in _indexCircles)
			{
				if (_albumMap[key] == null)
					return;
				// For all index circle per album
				for each (var circle:Graphic in _indexCircles[key])
				{
					circle.color = 0x999999;
				}
				_indexCircles[key][_albumMap[key].front.currentIndex].color = 0x000000;
			}
		}
		
		override public function Activate():void
		{
			
		}
		
		override public function Deactivate():void 
		{
			for (var a:String in _albumMap)
			{
				hideComponent(_albumMap[a]);
			}
			for (var i:String in _imageMap)
			{
				hideComponent(_imageMap[i]);
			}
		}
		
		public function GetViewer(key:String):Component
		{
			if (_albumMap[key] != null)
			{
				return _albumMap[key];
			}
			else if (_imageMap[key] != null)
			{
				return _imageMap[key];
			}
			return null;
		}
		
		// Button handler
		private function onClick(key:String):Function
		{
			return function(e:StateEvent):void
			{
				// On release
				if (e.value != "up")
				{
					return;
				}
				
			}
		}
	}
}