package Systems
{
	import Systems.System;
	import com.gestureworks.cml.components.Component;
	import com.gestureworks.cml.components.HTMLViewer;
	import com.gestureworks.cml.elements.Button;
	import com.gestureworks.cml.elements.HTML;
	import com.gestureworks.cml.elements.Image;
	import com.gestureworks.cml.events.StateEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.LocationChangeEvent;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class WebPageSystem extends System
	{
		// The webpage map ...
		private var _webMap:Object = new Object();
		private var _approvedURLs:Array = ["http://www.blekingemuseum.se/pages/275", "http://www.blekingemuseum.se/pages/377", "http://www.blekingemuseum.se/pages/378", "http://www.blekingemuseum.se/pages/379", "http://www.blekingemuseum.se/pages/380", "http://www.blekingemuseum.se/pages/403", "http://www.blekingemuseum.se/pages/423", "http://www.blekingemuseum.se/pages/1223"];
		
		public function WebPageSystem()
		{
			super();
		}
		
		override public function Init():void 
		{
			
		}
		
		public function Load(key:String):void
		{			
			for each (var child:String in getFilesInDirectoryRelative(key))
			{
				if (isDirectory(child))
				{
					continue;
				}
				var extention:String = getExtention(child).toUpperCase();
				if (extention != "TXT")
				{
					continue;
				}
				var loader:URLLoader = new URLLoader(new URLRequest(child));
				loader.addEventListener(Event.COMPLETE, FinalizeWebPage(key));
			}
		}
		
		override public function Activate():void 
		{
		}
		
		override public function Deactivate():void 
		{
			for (var key:String in _webMap)
			{
				hideComponent(_webMap[key]);
			}
		}
		
		override public function Hide():void 
		{
			for each (var hv:HTMLViewer in _webMap)
			{
				hideComponent(hv);
			}
		}
		
		private function FinalizeWebPage(key:String):Function
		{
			return function(event:Event):void
			{
				var webURL:String = URLLoader(event.currentTarget).data;
				var htmlViewer:HTMLViewer = createViewer(new HTMLViewer(), 800, 900) as HTMLViewer;
				
				// Create the HTML Element, the actual html content
				var html:HTML = new HTML();
				html.className = "html_element";
				html.width = 800;
				html.height = 900;
				html.src = webURL;
				html.hideFlash = true;
				html.smooth = true;
				html.hideFlashType = "display:none;";
				html.html.addEventListener(LocationChangeEvent.LOCATION_CHANGE, onNewPage(html));
				htmlViewer.addChild(html);
				
				// Add a frame , menu 
				addFrame(htmlViewer);
				addViewerMenu(htmlViewer, true, false, false, false);
				_webMap[key] = htmlViewer;
				hideComponent(htmlViewer);
				
				addChild(htmlViewer);
				// Initialize all of its elements
				recursiveInit(htmlViewer);
			}
		}
		
		private function onNewPage(h:HTML):Function
		{
			return function (e:LocationChangeEvent):void
			{
				// Iterate through the list of approved URL's and compare with the new location
				var isSafeURL:Boolean = false;
				for each (var safeURL:String in _approvedURLs)
				{
					if (h.html.location == safeURL)
					{
						// The new location was safe, continue as normal
						isSafeURL = true;
						return;
					}
				}
				if (isSafeURL == false)
				{
					// The new URL was not safe, reload the page. This will clear the load request.
					h.html.reload();
				}
			}
		}
		
		public function GetViewer(key:String):Component
		{
			if (_webMap[key] != null)
			{
				return _webMap[key];
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