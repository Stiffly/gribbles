package util 
{
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Adam
	 */
	final public class LayerHandler 
	{
		
		public function LayerHandler() 
		{
			
		}
		
		static public function BRING_TO_FRONT(object:DisplayObjectContainer):void
		{
			while (object.parent != null)
			{
				object.parent.setChildIndex(object, object.parent.numChildren - 1)
				object = object.parent;
			}
		}
		
	}

}