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
		private var m_Image : AlbumViewer;
		private var m_ImageObj : Object;
		private var m_Button : Button;
		
		public function ImageSystem():void
		{
			super();
		}

		override public function Init():void
		{
			m_Image = CMLObjectList.instance.getId("image-viewer");
			hideComponent(m_Image);
			stage.addChild(m_Image);
			
			m_Button  = CMLObjectList.instance.getId("image-button");
			m_Button.addEventListener(StateEvent.CHANGE, imageButtonHandler);
			stage.addChild(m_Button);
			
			m_ImageObj = m_Image;
		}
		
		override public function Update() : void
		{
			
		}
		
		private function imageButtonHandler(event : StateEvent) : void
		{
			switchButtonState(event.id, event.value, m_ImageObj);
		}
	}
}