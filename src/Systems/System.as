package Systems 
{
	//import com.gestureworks.core.GestureWorks;
	import flash.display.Sprite;
	
	public class System extends Sprite
	{
		public function System():void 
		{
			super();
		}
		// A function to be overidden by child classes
		public function Init():void { }
		// A function to be overidden by child classes
		public function Update():void { }
	}
}
