package Events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class PDFEvent extends Event 
	{
		public static const PDFLoaded:String = "PDF_LOADED";
		
		public function PDFEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new PDFEvent(type, bubbles, cancelable);
		} 
		
	}
	
}