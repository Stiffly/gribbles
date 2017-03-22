package Systems 
{
	/**
	 * VideoSystem.as
	 * Keeps track of the VideoViewer and its associated button
	 * 
	 * @author Adam Byléhn
	 * @contact adambylehn@hotmail.com
	 */
	
	import flash.events.Event;	
	import flash.events.MouseEvent;

	import com.gestureworks.cml.elements.Button;	
	import com.gestureworks.cml.components.AlbumViewer;
	import com.gestureworks.cml.core.CMLObjectList;
	import com.gestureworks.cml.events.StateEvent;

	public class VideoSystem extends Systems.System
	{
		private var m_Video : AlbumViewer;
		private var m_VideoObj : Object;
		private var m_Button : Button;
		
		public function VideoSystem():void
		{
			super();
		}
		
		override public function Init():void
		{
			m_Video = CMLObjectList.instance.getId("video-viewer");
			hideComponent(m_Video);
			stage.addChild(m_Video);
			
			m_Button  = CMLObjectList.instance.getId("video-button");
			m_Button.addEventListener(StateEvent.CHANGE, videoButtonHandler);
			stage.addChild(m_Button);
			m_VideoObj = m_Video;
		}
		
		private function videoButtonHandler(event : StateEvent) : void
		{
			switchButtonState(event.id, event.value, m_VideoObj);	
		}
	}
}
