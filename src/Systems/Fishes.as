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
			_viewDistance = 120;
			_keepdistance = 50;
			_amountOfFish = 1;		
			
			
			_boids = new Vector.<Boid>(_amountOfFish);
			var i:int;
			for (i = 0; i < _amountOfFish; i++)
			{
				_boids[i] = new Boid();
				_boids[i].Init(stage);
			}
		}
		
		public function Update():void 
		{
			//this.BoidAlgorithm();
			
			var i : uint;
			for (i = 0; i < _amountOfFish; i++)
			{
				_boids[i].Update();
			}
		}
		
		public function Shutdown():void 
		{
		}
		
		private function BoidAlgorithm():void 
		{
			var averageSepForce : Vector2D 		= new Vector2D(0, 0);
			var newAveragePosition : Vector2D 	= new Vector2D(0, 0);
			var averageDirection : Vector2D 	= new Vector2D(0, 0);
			var v1 : Vector2D = new Vector2D(0, 0);
			var v2 : Vector2D = new Vector2D(0, 0);
			var v3 : Vector2D = new Vector2D(0, 0);
			var v4 : Vector2D = new Vector2D(0, 0);
			
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
						
						newAveragePosition = _boids[i].getPos();
						var boidVec : Vector2D = activeBoid.findVector(tempBoid);
						var boidLen : Number = boidVec.length();
						var obsPos : Vector2D = new Vector2D(1920 / 2, 1080 / 2);
						var obsVec : Vector2D = activeBoid.findVector(obsPos);
						var obsLen : Number = obsVec.length();
						var inHood : Number = 0;
						
						if (boidLen < _viewDistance)
						{
							//calculate average posision
							newAveragePosition.addition(_boids[i].getPos());
							averageDirection.addition(_boids[i].getDir());	
							
							boidVec = boidVec.normalize();
							v1.addition(boidVec.rescale((boidLen / _keepdistance) - 1));
							
							inHood++;
						}
						
						
						/*
						if (obsLen < _viewDistance)
						{
							//heavy computation here
							var obsRad : Number = 1000;
							var avoidDegree : Number = Math.sqrt(Math.pow(obsLen, 2) - Math.pow(obsRad / 2, 2));
							avoidDegree /= obsLen;
							
							var DirObsAngle : Number = _boids[n].getDir().dot(obsVec);
							if (DirObsAngle >= avoidDegree)
							{
								v4 = obsVec.normalize();
								var magnifier : Number = ( -1 * avoidDegree * (1 - (obsLen / _viewDistance)));
								v4 = obsVec.rescale(magnifier);   
							}
						}
						*/
					}
				}
				//end sep
				if (averageSepForce._x != 0 && averageSepForce._y != 0)
				{
					newAveragePosition.rescale(1 / inHood);
					totalNewDir.addition(activeBoid.findVector(newAveragePosition));
				}
				
				if (boidsInVisibalDistance > 0)
				{
					//rescale, avg position
					newAveragePosition.rescale((1 / boidsInVisibalDistance));
					
					//alignment
					averageDirection.rescale(1/boidsInVisibalDistance);
					v2 = averageDirection;
					v3 = newAveragePosition;
				}
				totalNewDir = new Vector2D(0, 0);
				totalNewDir.addition(_boids[n].getDir());
				
				//add the vectors to the new direction
				
				totalNewDir.addition(v1);
				totalNewDir.addition(v2);
				totalNewDir.addition(v3);
				totalNewDir.addition(v4);
				
				if (totalNewDir._x != 0 && totalNewDir._y != 0)
				{
					_boids[n].setDir(totalNewDir);
				}
			}
			
		}
	}

}