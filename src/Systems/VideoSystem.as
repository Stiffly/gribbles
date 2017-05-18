package Systems
{

	import com.gestureworks.cml.components.Component;
	import com.gestureworks.cml.components.VideoViewer;
	import com.gestureworks.cml.elements.Image;
	import com.gestureworks.cml.elements.Video;
	import com.greensock.plugins.ColorMatrixFilterPlugin;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.elements.Button;
	import com.gestureworks.cml.utils.DisplayUtils;
	import util.TextContent;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class VideoSystem extends System
	{
		
		// The video map ...
		private var _videoMap:Object = new Object();
		
		public function VideoSystem()
		{
			super();
		}
		
		public function Load(key:String):void
		{
			var vv:VideoViewer = createViewer(new VideoViewer(), 400, 400, 500, 350) as VideoViewer;
			vv.autoTextLayout = false;
			vv.clusterBubbling = true;
			vv.mouseChildren = true;
			vv.gestureList = {"n-drag": true, "n-scale": true, "n-rotate": true};
			addChild(vv);
			
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
				vv.addChild(getVideo(child, vv.width, vv.height));
				// Load its associated description
				var textFile:String = child.toUpperCase().replace(extention, "TXT");
				var loader:URLLoader = new URLLoader(new URLRequest(textFile));
				loader.addEventListener(Event.COMPLETE, FinalizeVideo(vv, key));
			}
		}
		
		private function FinalizeVideo(vv:VideoViewer, key:String):Function
		{
			return function(event:Event):void
			{
				var content:String = URLLoader(event.currentTarget).data;
				var index:int = content.search("\n");
				addInfoPanel(vv, content.slice(0, index), content.slice(index + 1, content.length), 16);
				addFrame(vv);
				addViewerMenu(vv, true, true, true, true);
				_videoMap[key] = vv;
				DisplayUtils.initAll(vv);
				hideComponent(vv);
			}
		}
		
		private function getVideo(source:String, width:uint, height:uint):Video
		{
			var vid:Video = new Video();
			vid.autoplay = true;
			vid.loop = true;
			vid.width = width;
			vid.height = height;
			vid.open(source);
			return vid;
		}
		
		override public function Activate():void 
		{
		}
		
		override public function Deactivate():void 
		{
			for (var key:String in _videoMap)
			{
				hideComponent(_videoMap[key]);
			}
		}
		
		public function GetViewer(key:String):Component
		{
			if (_videoMap[key] != null)
			{
				return _videoMap[key];
			}
			return null;
		}
		
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