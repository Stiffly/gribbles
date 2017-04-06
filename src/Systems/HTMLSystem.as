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
		private var _button:Button;
		private var _approvedURLs:Array;
		
		public function HTMLSystem()
		{
			super();
		}
		
		override public function Init():void
		{
			_approvedURLs = new Array (
			"http://www.blekingemuseum.se/pages/275",
			"http://www.blekingemuseum.se/pages/377",
			"http://www.blekingemuseum.se/pages/378",
			"http://www.blekingemuseum.se/pages/379",
			"http://www.blekingemuseum.se/pages/380",
			"http://www.blekingemuseum.se/pages/403",
			"http://www.blekingemuseum.se/pages/423",
			"http://www.blekingemuseum.se/pages/1223" );
			
			_HTMLViewer = createViewer(new HTMLViewer(), 0, 0, 1280, 720) as HTMLViewer;
			
			_HTMLElement = new HTML();
			_HTMLElement.className = "html_element";
			_HTMLElement.width = 1280;
			_HTMLElement.height = 720;
			_HTMLElement.src = "http://www.blekingemuseum.se/pages/275";
			_HTMLElement.hideFlash = true;
			_HTMLElement.smooth = true;
			_HTMLElement.hideFlashType = "display:none;";
			_HTMLElement.html.addEventListener(LocationChangeEvent.LOCATION_CHANGE, onNewPage);
			
			addFrame(_HTMLViewer);
			//addTouchContainer(_HTMLViewer);
			
			_HTMLViewer.addChild(_HTMLElement);
			
			stage.addChild(_HTMLViewer);
			hideComponent(_HTMLViewer);
			
			DisplayUtils.initAll(_HTMLViewer);
			
			_button = CMLObjectList.instance.getId("web-button");
			_button.addEventListener(StateEvent.CHANGE, buttonHandler);
			stage.addChild(_button);
		}
		
		override public function Update():void
		{

		}
		
		private function buttonHandler(event:StateEvent):void
		{
			switchButtonState(event.value, _HTMLViewer);
		}
		
		private function onNewPage(e:LocationChangeEvent):void
		{
			var isSafeURL:Boolean = false;
			for each (var safeURL:String in _approvedURLs) {
				if (_HTMLElement.html.location == safeURL) {
					isSafeURL = true;
					break;
				}
			}
			if (isSafeURL == false) {
				_HTMLElement.html.reload();
			}
		}
	}
}