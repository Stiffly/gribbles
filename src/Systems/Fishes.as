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
	import flash.sampler.NewObjectSample;
	public class Fishes 
	{
		private var _viewDistance : Number;
		private var _keepdistance : Number;
		private var _amountOfFish : int;
		private var _boids:Vector.<Boid>;
		
		
		public function Fishes() 
		{
		}
		
		public function Init(stage:Stage):void
		{
			_viewDistance = 100;
			_keepdistance = 50;
			_amountOfFish = 25;		
			
			
			_boids = new Vector.<Boid>(_amountOfFish);
			var i:int;
			for (i = 0; i < _amountOfFish; i++)
			{
				_boids[i] = new Boid();
				_boids[i].Init(stage);
				
			}
			
			_boids[0].setPos(new Vector2D(200, 200));
			_boids[1].setPos(new Vector2D(240, 250));
			_boids[2].setPos(new Vector2D(220, 235));
			_boids[3].setPos(new Vector2D(300, 300));
			
			_boids[0].setDir(_boids[0].getPos().findVector(_boids[1].getPos()));
			_boids[1].setDir(new Vector2D(0, -1));
			//_boids[1].setDir(_boids[1].getPos().findVector(_boids[0].getPos()));
			//_boids[2].setDir(_boids[2].getPos().findVector(_boids[3].getPos()));
			//_boids[3].setDir(_boids[3].getPos().findVector(_boids[2].getPos()));
		}
		
		public function Update():void 
		{
			this.boidsFirstRules();
			
			var i : uint;
			for (i = 0; i < _amountOfFish; i++)
			{
				_boids[i].Update();
			}
		}
		
		public function Shutdown():void 
		{
			
		}
		
		public function boidsFirstRules():void 
		{
			var averageSepForce : Vector2D 		= new Vector2D(0, 0);
			var newAveragePosition : Vector2D 	= new Vector2D(0, 0);
			var averageDirection : Vector2D 	= new Vector2D(0, 0);
			var v1 : Vector2D = new Vector2D(0, 0);
			var v2 : Vector2D = new Vector2D(0, 0);
			var v3 : Vector2D = new Vector2D(0, 0);
			
			
			var totalNewDir : Vector2D			= new Vector2D(0, 0);
			
			var boidsInVisibalDistance : int;
			boidsInVisibalDistance = 0;
			
			var boidsKeepDistance : int;
			boidsKeepDistance = 0;
			
			var arrSize : uint;
			
			
			var activeBoid : Vector2D;
			var tempBoid : Vector2D;
			
			//hämta pos ifrån processing boid
			activeBoid = this._boids[0].getPos();
				
			
			var n : int;
			for (n = 0; n < _amountOfFish; n++)
			{
				activeBoid = this._boids[n].getPos();
				
				var i : int;
				
				//first rule, separation
				for (i = 0; i < _amountOfFish; i++)
				{
					if (n != i)
					{
						tempBoid = _boids[i].getPos();
						
						var boidVec : Vector2D = activeBoid.findVector(tempBoid);
						var boidLen : Number = boidVec.length();
						
						if (boidLen < _viewDistance)
						{
							//calculate average posision
							newAveragePosition.addition(_boids[i].getPos());
							averageDirection.addition(_boids[i].getDir());	
							
							
							boidVec = boidVec.normalize();
							v1.addition(boidVec.rescale((boidLen / _keepdistance) - 1));
						}
					}
				}
				//end sep
				if (averageSepForce._x != 0 && averageSepForce._y != 0)
				{
					totalNewDir.addition(activeBoid.findVector(newAveragePosition));
				}
				
				if (boidsInVisibalDistance > 0)
				{
					//rescale, avg position
					newAveragePosition.rescale((1 / boidsInVisibalDistance));
					
					//alignment
					averageDirection.rescale(1/boidsInVisibalDistance);
					v2 = averageDirection;
					
					
					v3 = newAveragePosition.normalize();
				}
				
				totalNewDir = new Vector2D(0, 0);
				totalNewDir.addition(_boids[n].getDir());
				
				totalNewDir.addition(v1);
				totalNewDir.addition(v2);
				totalNewDir.addition(v3);
				
				if (totalNewDir._x != 0 && totalNewDir._y != 0)
				{
					_boids[n].setDir(totalNewDir);
				}
			}
			
		}
	}

}