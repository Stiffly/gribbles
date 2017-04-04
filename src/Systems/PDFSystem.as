package Systems
{
	/**
	 * Systems.PDFSystem
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
		private var _PDFViewer:HTMLViewer;
		private var _touchContainer:TouchContainer;
		private var _PDF:HTML;
		
		public function PDFSystem()
		{
			super();
		}
		
		override public function Init():void
		{
			_touchContainer = new TouchContainer();
			
			_touchContainer.x = 700;
			_touchContainer.y = 300;
			_touchContainer.alpha = 1;
			_touchContainer.scale = 1;
			
			//touch interactions
			_touchContainer.gestureList = {"n-drag": true, "n-scale": true, "n-rotate": true};
			
			//loading an image through image element
			_PDF = new HTML();
			_PDF.src = "dykrapport.pdf";
			_PDF.x = 0;
			_PDF.y = 0;
			_PDF.width = 600;
			_PDF.height = 500;
			_PDF.id = "img1";
			_PDF.scale = 1;
			_PDF.init();
			_touchContainer.addChild(_PDF);
			//initialise touch container
			stage.addChild(_touchContainer);
		
			//stage.addChild(m_PDFViewer);
		
			//m_PDFViewer = CMLObjectList.instance.getId("PDF-viewer");
			//hideComponent(m_PDFViewer);
		
			//stage.addChild(m_PDFViewer);
		
		/*m_Button  = CMLObjectList.instance.getId("pdf-button");
		   m_Button.addEventListener(StateEvent.CHANGE, buttonHandler);
		   stage.addChild(m_Button);
		   m_PDFObj = m_PDFViewer;*/
		}
		
		override public function Update():void
		{
			//m_PDF.x = m_PDFViewer.x;
			//trace(m_PDF.scale += 0.1);
		}
		
		private function buttonHandler(event:StateEvent):void
		{
			switchButtonState(event.id, event.value, _PDFViewer);
		}
	}

}