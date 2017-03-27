package Systems
{
	/**
	 * VideoSystem.as
	 * Keeps track of the VideoViewer and its associated button
	 *
	 * @author Adam Byléhn
	 * @contact adambylehn@hotmail.com
	 */
	
	import com.gestureworks.cml.core.CMLObjectList;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.elements.Button;
	import com.gestureworks.cml.components.AlbumViewer;
	
	public class VideoSystem extends Systems.System
	{
		private var m_Video:AlbumViewer;
		private var m_Button:Button;
		
		public function VideoSystem()
		{
			super();
		}
		
		override public function Init():void
		{
			m_Video = CMLObjectList.instance.getId("video-viewer");
			m_Video.maxScale = 3;
			m_Video.minScale = 0.2;
			m_Video.debugDisplay = true;
			hideComponent(m_Video);
			stage.addChild(m_Video);
			
			m_Button = CMLObjectList.instance.getId("video-button");
			m_Button.addEventListener(StateEvent.CHANGE, videoButtonHandler);
			stage.addChild(m_Button);
		}
		
		private function videoButtonHandler(event:StateEvent):void
		{
			switchButtonState(event.id, event.value, m_Video);
		}
	}
}
