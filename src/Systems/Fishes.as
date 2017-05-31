package Systems 
{
	/**
	 * ...
	 * @author Sebastian Lundgren och Max Larsson
	 * 
	 */
	
	import Systems.Boid;
	import air.update.descriptors.StateDescriptor;
	import flash.display.Stage;
	import flash.geom.Vector3D;
	import flash.sampler.NewObjectSample;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.TouchSprite
	import flash.events.TouchEvent;
	public class Fishes 
	{
		private var _viewDistance : Number;
		private var _keepdistance : Number;
		private var _amountOfFish : int;
		private var _boids:Vector.<Boid>;
		private var _enemy : Vector2D;
		
		public function Fishes() 
		{
		}
		
		public function Init(stage:Stage):void
		{
			_viewDistance = 200;
			_keepdistance = 150;
			_amountOfFish = 6;		
			
			
			_boids = new Vector.<Boid>(_amountOfFish);
			var i:int;
			for (i = 0; i < _amountOfFish; i++)
			{

				_boids[i] = new Boid();
				_boids[i].Init(stage, _viewDistance, false);
				
			}

			_enemy = new Vector2D(0,0);
			
		}
		
		public function Update():void 
		{	
			for (var i : int = 0; i < _boids.length; i++)
			{
				_boids[i].Update(i,_boids,_enemy,_viewDistance,_keepdistance);
			}
		}
		
		public function Activate():void 
		{
			var i : uint;
			for (i = 0; i < _amountOfFish; i++)
			{
				_boids[i].Activate();
			}
		}
		
		public function Deactivate():void 
		{
			var i : uint;
			for (i = 0; i < _amountOfFish; i++)
			{
				_boids[i].Deactivate();
			}
		}
		
		public function scareFishPos(pos:Vector2D):void 
		{
			_enemy = pos;
		}
	}

}