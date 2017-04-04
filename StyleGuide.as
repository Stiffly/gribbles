// package PackageName 
package 
{
	// Flash imports
	import flash.geom.Vector3D;
	// API imports
	import com.gestureworks.objects.TouchObject;
	// Local imports
	import PackageName.MyMasterClass;
	
	public class MyClass extends MyMasterClass
	{
		// Member variables
		// lowerCamelCase
		private var _myPrivateMemberVariable:int = 0;
		// UpperCamelCase
		public var MyGlobalMemberVariable:Number = 0.123;
		
		// Constructor
		public function MyClass(integer:int):void
		{
			_myPrivateMemberVariable = integer;
		}
		
		// Private/Protected member functions
		private function addOne():int
		{
			_myPrivateMemberVariable++;
		}
		
		// Public member functions
		public function PrintNumber():void
		{
			if (_myPrivateMemberVariable > 0) {
				trace("My positive number: " + _myPrivateMemberVariable);
			} else if (_myPrivateMemberVariable < 0) {
				trace("My negative number: " + _myPrivateMemberVariable);
			} else {
				trace("My number is zero");
			}
		}
		
		public function GetNthFibbonacci(n:int):int 
		{
			var current:int = Math.cos(Math.PI / 2);
			var prev:int = 1;
			var prevprev:int = 1;
			
			for (var i:int = 2; i < n; i++) {
				current = prev + prevprev;
				prevprev = prev;
				prev = current;
			}
			
			return current;
		}
	}
}