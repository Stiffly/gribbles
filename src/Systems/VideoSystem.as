package Systems 
{
	import flash.events.Event;
	import com.gestureworks.cml.core.CMLParser;

	public class VideoSystem extends Systems.System
	{
		public function VideoSystem():void 
		{
			super();
		}
		
		override public function Init():void 
		{
			CMLParser.addEventListener(CMLParser.COMPLETE, cmlComplete); 
		}		
		
		private function cmlComplete(event:Event):void
		{
			CMLParser.removeEventListener(CMLParser.COMPLETE, cmlComplete);
		}
		
	}
}
