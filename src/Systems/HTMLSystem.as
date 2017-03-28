package Systems
{
	/**
	 * HTMLSystem.as
	 * Handles the HTMLViewer and its associated button
	 *
	 * @author Adam
	 * @contact adambylehn@hotmail.com
	 */
	
	import com.gestureworks.cml.core.CMLObjectList;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.elements.Button;
	import com.gestureworks.cml.components.HTMLViewer;
	import com.gestureworks.cml.elements.HTML;
	import com.gestureworks.cml.elements.Frame;
	import com.gestureworks.cml.elements.TouchContainer;
	
	public class HTMLSystem extends System
	{
		private var m_HTMLViewer:HTMLViewer;
		private var m_HTMLElement:HTML;
		private var m_Button:Button;
		private var m_ApprovedURLs:Array;
		
		public function HTMLSystem()
		{
			super();
		}
		
		override public function Init():void
		{
			m_ApprovedURLs = new Array (
			"http://www.blekingemuseum.se/pages/275",
			"http://www.blekingemuseum.se/pages/377",
			"http://www.blekingemuseum.se/pages/378",
			"http://www.blekingemuseum.se/pages/377",
			"http://www.blekingemuseum.se/pages/380",
			"http://www.blekingemuseum.se/pages/403",
			"http://www.blekingemuseum.se/pages/423",
			"http://www.blekingemuseum.se/pages/1223" );
			
			m_HTMLViewer = createViewer(new HTMLViewer(), 0, 0, 1280, 720) as HTMLViewer;
			
			m_HTMLElement = new HTML();
			m_HTMLElement.className = "html_element";
			m_HTMLElement.width = 1280;
			m_HTMLElement.height = 720;
			m_HTMLElement.src = "http://www.blekingemuseum.se/pages/275";
			m_HTMLElement.hideFlash = true;
			m_HTMLElement.smooth = true;
			m_HTMLElement.hideFlashType = "display:none;";
			m_HTMLElement.init();
			
			m_HTMLViewer.addChild(m_HTMLElement);
			
			stage.addChild(m_HTMLViewer);
			hideComponent(m_HTMLViewer);
			
			m_Button = CMLObjectList.instance.getId("web-button");
			m_Button.addEventListener(StateEvent.CHANGE, buttonHandler);
			stage.addChild(m_Button);
		}
		
		override public function Update():void
		{
			// TEMP: This should be listening to a "URL change"-event
			var isSafeURL:Boolean = false;
			for each (var safeURL:String in m_ApprovedURLs) {				
				if (m_HTMLElement.src == safeURL) {
					isSafeURL = true;
				}
			}
			if (isSafeURL == false) {
				m_HTMLElement.goBack();
			}
		}
		
		private function buttonHandler(event:StateEvent):void
		{
			switchButtonState(event.value, m_HTMLViewer);
		}
	}
}