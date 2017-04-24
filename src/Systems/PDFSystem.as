package Systems
{
	/**
	 * Systems.PDFSystem
	 * The system that handles the PDFViewer
	 *
	 * @author Adam Byléhn
	 * @contact adambylehn@hotmail.com
	 */
	 
	
	import com.gestureworks.cml.utils.DisplayUtils;
	
	import com.gestureworks.cml.core.CMLObjectList;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.elements.Button;
	import com.gestureworks.cml.components.HTMLViewer;
	import com.gestureworks.cml.elements.HTML;
	import com.gestureworks.cml.elements.TouchContainer;
	
	public class PDFSystem extends System
	{
		private var _PDFViewer:HTMLViewer;
		
		public function PDFSystem()
		{
			super();
		}
		
		override public function Init():void
		{
			_PDFViewer = createViewer(new HTMLViewer(), 0, 0, 600, 500) as HTMLViewer;
			_PDFViewer.targetParent = true;
			_PDFViewer.mouseChildren = true;
			_PDFViewer.gestureList = { "1-finger-drag":true, "n-rotate":false, "n-scale":false};
			_PDFViewer.affineTransform = true;

			stage.addChild(_PDFViewer);

			//loading an image through image element
			var PDF:HTML = new HTML();
			PDF.src = "pdf/dykrapport.pdf";
			
			PDF.x = 0;
			PDF.y = 0;
			PDF.width = 600;
			PDF.height = 500;
			PDF.targetParent = true;
			PDF.mouseChildren = true;
			PDF.scale = 1;
			_PDFViewer.addChild(PDF);
			
			addFrame(_PDFViewer);
			addTouchContainer(_PDFViewer);
			
			hideComponent(_PDFViewer);
			
			DisplayUtils.initAll(_PDFViewer);
			
			_button = CMLObjectList.instance.getId("pdf-button");
			_button.addEventListener(StateEvent.CHANGE, buttonHandler);
			stage.addChild(_button);
		}
		
		override public function Update():void
		{
		}
		
		private function buttonHandler(event:StateEvent):void
		{
			switchButtonState(event.value, _PDFViewer, 400, 400);
		}
	}
}