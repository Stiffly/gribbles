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
	 
	public class HTMLSystem extends System
	{
		public function HTMLSystem():void
		{
			super();
		}
		
		private var m_HTMLViewer : HTMLViewer;
		private var m_HTMLObj : Object;
		private var m_Button : Button;
		
		override public function Init():void
		{
			m_HTMLViewer = CMLObjectList.instance.getId("HTML-viewer");
			hideComponent(m_HTMLViewer);
			stage.addChild(m_HTMLViewer);
			
			m_Button  = CMLObjectList.instance.getId("web-button");
			m_Button.addEventListener(StateEvent.CHANGE, buttonHandler);
			stage.addChild(m_Button);
			m_HTMLObj = m_HTMLViewer;
		}
		
		override public function Update() : void
		{
			
		}
		
		private function buttonHandler(event : StateEvent) : void
		{
			switchButtonState(event.id, event.value, m_HTMLObj);
		}
	}
}