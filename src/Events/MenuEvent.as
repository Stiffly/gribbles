package Events
{
	import flash.events.Event;
	
	/**
	 * Events.MenuEvent
	 *
	 * An event for recognizing when the close button defined by GestureWorks is pressed
	 *
	 * @author Adam Byléhn
	 * @contact adambylehn@hotmail.com
	 */
	
	public class MenuEvent extends Event
	{
		public static const CLOSE:String = "close";
		public var result:Object;
		
		public function MenuEvent(type:String, result:Object, bubbles:Boolean = false, cancelable:Boolean = false)
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