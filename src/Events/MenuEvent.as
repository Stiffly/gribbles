package Events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class MenuEvent extends Event 
	{
		public static const CLOSE:String = "close";
		public var result:Object;
		
		public function MenuEvent(type:String, result:Object, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.result = result;
		} 
		
		public override function clone():Event 
		{ 
			return new MenuEvent(type, result, bubbles, cancelable);
		} 		
	}
	
}