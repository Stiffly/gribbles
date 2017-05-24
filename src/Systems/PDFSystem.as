package Systems 
{
	import com.gestureworks.cml.components.Component;
	import com.gestureworks.cml.components.HTMLViewer;
	import com.gestureworks.cml.elements.HTML;
	import flash.net.URLLoader;
	import Events.PDFEvent;
	/**
	 * ...
	 * @author Adam
	 */
	public class PDFSystem extends System 
	{
		private var _pdfMap:Object = new Object();
		public function PDFSystem() 
		{
			super();
			
		}
		
		public function Load(key:String):void
		{
			for each (var child:String in getFilesInDirectoryRelative(key))
			{
				if (isDirectory(child))
				{
					continue;
				}
				var extention:String = getExtention(child).toUpperCase();
				if (extention != "PDF")
				{
					continue;
				}
				var pdfViewer:HTMLViewer = createViewer(new HTMLViewer(), 700, 800) as HTMLViewer;
				pdfViewer.targetParent = true;
				pdfViewer.mouseChildren = true;
				pdfViewer.clusterBubbling = true;
				pdfViewer.gestureList = {"n-drag": true, "n-rotate": false, "n-scale": false};
				pdfViewer.affineTransform = true;
				
				addChild(pdfViewer);
				setChildIndex(pdfViewer, 0);
				stage.addEventListener(PDFEvent.PDFLoaded, OnPDFLoaded);
				// Loading an image through image element
				
				var PDF:HTML = new HTML();
				
				PDF.width = pdfViewer.width;
				PDF.height = pdfViewer.height;
				var pdfWidth:String = PDF.width.toString();
				var pdfHeight:String = PDF.height.toString();
				
				// Load the PDF without toolbar 
				PDF.srcString = "<body" + "<embed src=\"" + child + "#toolbar=0&navpanes=0&scrollbar=0\" width=" + pdfWidth + " height=" + pdfHeight + "/>" + "</body>";
				//PDF.src = "pdf/dykrapport.pdf";
				
				// This has to be at 0,0 or the PDF will not be loaded properly (!?)
				PDF.x = 0;
				PDF.y = 0;
				PDF.targetParent = true;
				PDF.mouseChildren = true;
				pdfViewer.addChild(PDF);
				
				addFrame(pdfViewer);
				addTouchContainer(pdfViewer);
				addViewerMenu(pdfViewer, true, false, false, false);
				
				_pdfMap[key] = pdfViewer;
				recursiveInit(pdfViewer);
			}
		}
		
		private function OnPDFLoaded(e:PDFEvent):void 
		{
			for each (var value:HTMLViewer in _pdfMap)
			{
				hideComponent(value);
			}
		}
		
		public function GetViewer(key:String):Component
		{
			if (_pdfMap[key] != null)
			{
				return _pdfMap[key];
			}
			return null;
		}
		
		protected override function hideComponent(component:Component):void
		{
			// "Hide" the component
			component.x = 13337;
			component.y = 13337;
			component.visible = false;
		}
		
		public function ShowComponent(x:int, y:int, component:Component):void
		{
			component.x = ((stage.stageWidth - component.width) >> 1);
			component.y = ((stage.stageHeight - component.height) >> 1);
			component.visible = true;
			setChildIndex(component, numChildren - 1);
			bringToFront(component);
		}
	}
}