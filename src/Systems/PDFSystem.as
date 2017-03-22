package Systems 
{
	/**
	* PDFSystem.as
	* The system that handles the PDFViewer
	* 
	* @author Adam Byléhn
	* @contact adambylehn@hotmail.com
	*/
	
	import com.gestureworks.cml.core.CMLObjectList;	
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.elements.Button;
	import com.gestureworks.cml.components.HTMLViewer;
	 
	public class PDFSystem extends System
	{
		private var m_PDFViewer : HTMLViewer;
		private var m_PDFObj : Object;
		private var m_Button : Button;
		
		public function PDFSystem() 
		{
			
		}
		
		override public function Init():void
		{
			m_PDFViewer = CMLObjectList.instance.getId("PDF-viewer");
			hideComponent(m_PDFViewer);
			stage.addChild(m_PDFViewer);
			
			m_Button  = CMLObjectList.instance.getId("pdf-button");
			m_Button.addEventListener(StateEvent.CHANGE, buttonHandler);
			stage.addChild(m_Button);
			m_PDFObj = m_PDFViewer;
		}
		
		override public function Update() : void
		{
			
		}
		
		private function buttonHandler(event : StateEvent) : void
		{
			switchButtonState(event.id, event.value, m_PDFObj);
		}
	}

}