package Events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Adam Byléhn
	 */
	public class ShowFishes extends Event 
	{
		public static const SHOWFISH:String = "SHOW_FISH";
		
		public function ShowFishes(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new ShowFishes(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ShowFishes", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}