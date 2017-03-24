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
	import com.gestureworks.cml.elements.HTML;
	import com.gestureworks.cml.elements.TouchContainer;
	 
	public class PDFSystem extends System
	{
		private var m_PDFViewer : HTMLViewer;
		private var m_PDFObj : Object;
		private var m_Button : Button;
		private var tc : TouchContainer;
		private var m_PDF : HTML;
		public function PDFSystem() 
		{
			super();
		}
		
		override public function Init():void
		{
			tc = new TouchContainer();
			
			tc.x = 700;
			tc.y = 300;
			tc.alpha = 1;
			tc.scale = 1;
			
			//touch interactions
			tc.gestureList = { "n-drag":true, "n-scale":true, "n-rotate":true };
			
			//loading an image through image element
			m_PDF = new HTML();
			m_PDF.src = "dykrapport.pdf";
			m_PDF.x = 0;
			m_PDF.y = 0;
			m_PDF.width = 600;
			m_PDF.height = 500;
			m_PDF.id = "img1";
			m_PDF.scale = 1;
			m_PDF.init();
			tc.addChild(m_PDF);
			//initialise touch container
			stage.addChild(tc);
			

			//stage.addChild(m_PDFViewer);
			
			//m_PDFViewer = CMLObjectList.instance.getId("PDF-viewer");
			//hideComponent(m_PDFViewer);

			//stage.addChild(m_PDFViewer);
			
			/*m_Button  = CMLObjectList.instance.getId("pdf-button");
			m_Button.addEventListener(StateEvent.CHANGE, buttonHandler);
			stage.addChild(m_Button);
			m_PDFObj = m_PDFViewer;*/
		}
		
		override public function Update() : void
		{
			//m_PDF.x = m_PDFViewer.x;
			//trace(m_PDF.scale += 0.1);
		}
		
		private function buttonHandler(event : StateEvent) : void
		{
			switchButtonState(event.id, event.value, m_PDFObj);
		}
	}

}