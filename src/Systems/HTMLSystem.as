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
		
		public function HTMLSystem()
		{
			super();
		}
		
		override public function Init():void
		{
			var htmlContainer:TouchContainer = new TouchContainer();
			htmlContainer.className = "html_container";
			htmlContainer.visible = true;
			htmlContainer.targetParent = true;
			htmlContainer.mouseChildren = false;
			htmlContainer.gestureEvents = false;
			htmlContainer.init();
			
			var htmlframe:Frame = new Frame();
			htmlframe.className = "frame_element";
			htmlframe.init();
			
			m_HTMLViewer = new HTMLViewer();
			m_HTMLViewer.x = 0;
			m_HTMLViewer.y = 0;
			m_HTMLViewer.width = 1280;
			m_HTMLViewer.height = 720;
			m_HTMLViewer.gestureEvents = true;
			m_HTMLViewer.gestureList = {"n-drag": true, "n-scale": true, "n-rotate": true};
			m_HTMLViewer.html = m_HTMLElement;
			
			m_HTMLElement = new HTML();
			m_HTMLElement.className = "html_element";
			m_HTMLElement.width = 1280;
			m_HTMLElement.height = 720;
			//htmlElement.baseURL = "http://www.blekingemuseum.se/pages/255";
			m_HTMLElement.src = "http://www.blekingemuseum.se/pages/255";
			m_HTMLElement.hideFlash = true;
			m_HTMLElement.smooth = true;
			m_HTMLElement.hideFlashType = "display:none;";
			m_HTMLElement.init();
			
			m_HTMLViewer.addChild(m_HTMLElement);
			m_HTMLViewer.addChild(htmlframe);
			m_HTMLViewer.addChild(htmlContainer);
			m_HTMLViewer.init();
			
			stage.addChild(m_HTMLViewer);
			hideComponent(m_HTMLViewer);
			
			m_Button = CMLObjectList.instance.getId("web-button");
			m_Button.addEventListener(StateEvent.CHANGE, buttonHandler);
			stage.addChild(m_Button);
		}
		
		override public function Update():void
		{
			// TEMP: This should be listening to a "URL change"-event
			m_HTMLElement.goBack();
		}
		
		private function buttonHandler(event:StateEvent):void
		{
			switchButtonState(event.id, event.value, m_HTMLViewer);
		}
	}
}