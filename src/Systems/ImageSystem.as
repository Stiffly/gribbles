package Systems
{
	/**
	 * ImageSystem.as
	 * Keeps track of the ImageViewer and its associated button
	 *
	 * @author Adam Byléhn
	 * @contact adambylehn@hotmail.com
	 */
	
	import com.gestureworks.cml.core.CMLObjectList;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.elements.Button;
	import com.gestureworks.cml.components.AlbumViewer;
	
	public class ImageSystem extends System
	{
		private var m_ImageViewer:AlbumViewer;
		private var m_Button:Button;
		
		public function ImageSystem()
		{
			super();
		}
		
		override public function Init():void
		{
			m_ImageViewer = CMLObjectList.instance.getId("image-viewer");
			hideComponent(m_ImageViewer);
			stage.addChild(m_ImageViewer);
			
			m_ImageViewer.maxScale = 2;
			m_ImageViewer.minScale = 0.2;
			m_ImageViewer.debugDisplay = true;
			
			m_Button = CMLObjectList.instance.getId("image-button");
			m_Button.addEventListener(StateEvent.CHANGE, imageButtonHandler);
			stage.addChild(m_Button);
		}
		
		override public function Update():void
		{
		
		}
		
		private function imageButtonHandler(event:StateEvent):void
		{
			switchButtonState(event.value, m_ImageViewer);
		}
	}
}