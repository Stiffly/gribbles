package Systems
{
	/**
	 * Systems.PDFSystem
	 * The system that handles the PDFViewer
	 *
	 * @author Adam Byléhn
	 * @contact adambylehn@hotmail.com
	 */
	 
	
	import com.gestureworks.cml.components.Component;
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
			_PDFViewer.clusterBubbling = true;
			_PDFViewer.gestureList = { "n-drag":true, "n-rotate":false, "n-scale":false};
			_PDFViewer.affineTransform = true;

			addChild(_PDFViewer);
			setChildIndex(_PDFViewer, 0);

			//loading an image through image element
			var PDF:HTML = new HTML();
			//PDF.src = "pdf/dykrapport.pdf";
			PDF.srcString = "<body>" +
								"<iframe src=\"pdf/dykrapport.pdf\" style=\"width: 100%;height: 100%;border: none;\"></iframe>" +
							"</body>";
			
			// This has to be at 0,0 or the PDF will not be loaded properly (?)
			PDF.x = 0;
			PDF.y = 0;
			PDF.width = 600;
			PDF.height = 800;
			PDF.targetParent = true;
			PDF.mouseChildren = true;
			_PDFViewer.addChild(PDF);
			
			addFrame(_PDFViewer);
			addTouchContainer(_PDFViewer);
			
			DisplayUtils.initAll(_PDFViewer);
			
			_button = CMLObjectList.instance.getId("pdf-button");
			_button.addEventListener(StateEvent.CHANGE, buttonHandler);
			addChild(_button);
		}
		
		override public function Update():void { }
		
		private function buttonHandler(event:StateEvent):void
		{
			switchButtonState(event.value, _PDFViewer, 400, 400);
		}
		
		protected override function switchButtonState(buttonState:String, component:Component, x:int, y:int):void
		{
			// On release
			if (buttonState == "down-state")
				return;
			if (component.x < 10000) {
				hideComponent(component);
			}
			else if (component.x > 10000) {
				showComponent(component);
			}
		}
		
		protected override function hideComponent(component:Component):void
		{
			component.x = 13337; // "Hide" the component
			component.y = 13337;
		}
		
		private function showComponent(component:Component):void
		{
			component.x = stage.stageWidth / 2 - component.width / 2;
			component.y = stage.stageHeight  / 2 - component.height / 2;
			setChildIndex(component, numChildren -  1);
		}
		
		public override function Hide():void
		{
			hideComponent(_PDFViewer);
		}
	}
}