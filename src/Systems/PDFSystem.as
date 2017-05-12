package Systems
{
	import com.gestureworks.cml.components.Component;
	import com.gestureworks.cml.utils.DisplayUtils;
	import com.gestureworks.cml.core.CMLObjectList;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.elements.Button;
	import com.gestureworks.cml.components.HTMLViewer;
	import com.gestureworks.cml.elements.HTML;
	import com.gestureworks.cml.elements.TouchContainer;
	
	/**
	 * Systems.PDFSystem
	 *
	 * The system that handles the PDFViewer
	 *
	 * @author Adam Byléhn
	 * @contact adambylehn@hotmail.com
	 */
	
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
			_PDFViewer.gestureList = {"n-drag": true, "n-rotate": false, "n-scale": false};
			_PDFViewer.affineTransform = true;
			
			addChild(_PDFViewer);
			setChildIndex(_PDFViewer, 0);
			
			// Loading an image through image element
			
			var PDF:HTML = new HTML();
			
			PDF.width = 700;
			PDF.height = 800;
			var pdfWidth:String = PDF.width.toString();
			var pdfHeight:String = PDF.height.toString();
			
			// Load the PDF without toolbar 
			PDF.srcString = "<body" + "<embed src=\"pdf/dykrapport.pdf#toolbar=0&navpanes=0&scrollbar=0\" width=" + pdfWidth + " height=" + pdfHeight + "/>" + "</body>";
			//PDF.src = "pdf/dykrapport.pdf";
			
			// This has to be at 0,0 or the PDF will not be loaded properly (!?)
			PDF.x = 0;
			PDF.y = 0;
			PDF.targetParent = true;
			PDF.mouseChildren = true;
			_PDFViewer.addChild(PDF);
			
			addFrame(_PDFViewer);
			addTouchContainer(_PDFViewer);
			addViewerMenu(_PDFViewer, true, false, false, false);
			
			DisplayUtils.initAll(_PDFViewer);
			
			_button = CMLObjectList.instance.getId("pdf-button");
			_button.alpha = 1.0;
			_button.y = 100;
			_button.x = 800;
			_button.addEventListener(StateEvent.CHANGE, buttonHandler);
			addChild(_button);
		}
		
		override public function Update():void
		{
		}
		
		private function buttonHandler(event:StateEvent):void
		{
			switchButtonState(event.value, _PDFViewer, 400, 400);
		}
		
		protected override function switchButtonState(buttonState:String, component:Component, x:int, y:int):void
		{
			// On release
			if (buttonState == "down-state")
			{
				return;
			}
			if (component.x < 10000)
			{
				hideComponent(component);
			}
			else if (component.x > 10000)
			{
				showComponent(0,0, component);
			}
		}
		
		protected override function hideComponent(component:Component):void
		{
			// "Hide" the component
			component.x = 13337;
			component.y = 13337;
			component.visible = false;
		}
		
		protected override function showComponent(x:int, y:int, component:Component):void
		{
			component.x = ((stage.stageWidth - component.width) >> 1);
			component.y = ((stage.stageHeight - component.height) >> 1);
			component.visible = true;
			setChildIndex(component, numChildren - 1);
		}
		
		public override function Hide():void
		{
			hideComponent(_PDFViewer);
		}
	}
}