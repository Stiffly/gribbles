package Systems
{
	/**
	 * Systems.HTMLSystem
	 * Handles the HTMLViewer and its associated button
	 *
	 * @author Adam
	 * @contact adambylehn@hotmail.com
	 */
	
	import com.gestureworks.cml.utils.DisplayUtils;
	
	import com.gestureworks.cml.core.CMLObjectList;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.elements.Button;
	import com.gestureworks.cml.components.HTMLViewer;
	import com.gestureworks.cml.elements.HTML;
	import com.gestureworks.cml.elements.Frame;
	import com.gestureworks.cml.elements.TouchContainer;
	import flash.events.LocationChangeEvent;
	
	
	public class HTMLSystem extends System
	{
		private var _HTMLViewer:HTMLViewer;
		private var _HTMLElement:HTML;
		private var _approvedURLs:Array;
		
		public function HTMLSystem()
		{
			super();
		}
		
		override public function Init():void
		{
			// A list of URL's that will be checked upon when the HTML's location state changes
			_approvedURLs = new Array (
			"http://www.blekingemuseum.se/pages/275",
			"http://www.blekingemuseum.se/pages/377",
			"http://www.blekingemuseum.se/pages/378",
			"http://www.blekingemuseum.se/pages/379",
			"http://www.blekingemuseum.se/pages/380",
			"http://www.blekingemuseum.se/pages/403",
			"http://www.blekingemuseum.se/pages/423",
			"http://www.blekingemuseum.se/pages/1223" );
			
			// Create the HTML Viewer
			_HTMLViewer = createViewer(new HTMLViewer(), 0, 0, 800, 900) as HTMLViewer;
			
			// Create the HTML Element, the actual html content
			_HTMLElement = new HTML();
			_HTMLElement.className = "html_element";
			_HTMLElement.width = 800;
			_HTMLElement.height = 900;
			_HTMLElement.src = "http://www.blekingemuseum.se/pages/275";
			_HTMLElement.hideFlash = true;
			_HTMLElement.smooth = true;
			_HTMLElement.hideFlashType = "display:none;";
			_HTMLElement.html.addEventListener(LocationChangeEvent.LOCATION_CHANGE, onNewPage);
			_HTMLViewer.addChild(_HTMLElement);

			// Add a frame around the viewer
			addFrame(_HTMLViewer);
			
			// Add the viewer to stage and hide it
			addChild(_HTMLViewer);
			
			// Initialize all of its elements
			DisplayUtils.initAll(_HTMLViewer);
			
			// The button loaded from CML
			_button = CMLObjectList.instance.getId("web-button");
			_button.addEventListener(StateEvent.CHANGE, buttonHandler);
			addChild(_button);
		}
		
		override public function Update():void
		{

		}
		
		private function buttonHandler(event:StateEvent):void
		{
			// Button state was changed, clicked or released
			switchButtonState(event.value, _HTMLViewer,
			stage.stageWidth / 2 - _HTMLViewer.width / 2,
			stage.stageHeight / 2 - _HTMLViewer.height / 2);
		}
		
		private function onNewPage(e:LocationChangeEvent):void
		{
			// Iterate through the list of approved URL's and compare with the new location
			var isSafeURL:Boolean = false;
			for each (var safeURL:String in _approvedURLs) {
				if (_HTMLElement.html.location == safeURL) {
					// The new location was safe, continue as normal
					isSafeURL = true;
					return;
				}
			}
			if (isSafeURL == false) {
				// The new URL was not safe, reload the page. This will clear the load request.
				_HTMLElement.html.reload();
			}
		}
				
		public override function Hide():void
		{
			hideComponent(_HTMLViewer);
		}
	}
}