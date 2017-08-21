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
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.TouchSprite
	import flash.events.TouchEvent;
	public class Fishes extends Sprite
	{
		private var _viewDistance : Number;
		private var _keepdistance : Number;
		private var _enemydistance : Number;
		private var _amountOfFish : int;
		private var _boids : Vector.<Boid>;
		private var _touchPos : Array;
		private var scary : Vector.<Vector2D>;
		private var _nrOfTouches : int;
		
		public function Fishes() 
		{
		}
		
		public function Init(stage:Stage, amountOfFish:int=25):void
		{
			_amountOfFish = amountOfFish;
			_touchPos = new Array(new Vector2D(0,0), new Vector2D(0,0), new Vector2D(0,0), new Vector2D(0,0));
			_nrOfTouches = 0;
			
			_boids = new Vector.<Boid>(_amountOfFish);
			for (var i:int = 0; i < _amountOfFish; i++)
			{
				_boids[i] = new Boid();
				_boids[i].Init(stage,_viewDistance,true);

				//_boids[i].setSpeed(1);
				_boids[i].Update();
			}
			scary = new Vector.<Vector2D>(_amountOfFish);
			
			_viewDistance = 50 * _boids[0].worldUnit;
			_keepdistance = 40 * _boids[0].worldUnit;
			_enemydistance = 20 * _boids[0].worldUnit;
		}
		
		public function Activate():void
		{
			for (var i:int = 0; i < _amountOfFish; i++)
			{
					_boids[i].Activate();
			}
		}
		
		public function Deactivate():void
		{
			for (var i:int = 0; i < _amountOfFish; i++)
			{
				_boids[i].Deactivate();
			}
		}
		
		private function moveEnemy(event:MouseEvent):void 
		{
			for (var i : int = 0; i < _amountOfFish; i++)
			{
				_touchPos[i]._x = event.stageX;
				_touchPos[i]._y = event.stageY;
			}

		}
		
		public function Update():void 
		{
			for (var i:int = 0; i < _amountOfFish; i++)
			{
				NewAvoidEnemy(_boids[i])
				boidsFirstRules(i);
				_boids[i].Update();
			}
			_nrOfTouches = 0;

		}
		
		public function Shutdown():void 
		{
			var i : int = 0;
			for (i = 0; i < _amountOfFish; i++)
			{
				delete _boids[i];
			}
		}
		
		private function boidsFirstRules(i:int) : void
		{

				var averageSepForce : Vector2D = new Vector2D(0, 0);
				var newAveragePosition : Vector2D = new Vector2D(0, 0);
				var averageDirection : Vector2D = new Vector2D(0, 0);
				var neighboorPos : Vector2D = new Vector2D(0, 0);
				var boidsInVisibalDistance : int = 0;
				var boidsKeepDistance : int = 0;
				var averageSpeed : Number = 0.0;
				
				//we walk through and process each boid here, different from boidtest
				newAveragePosition.addition(_boids[i].getPos());
				
				var n : int;
				for (n = 0; n < _amountOfFish; n++)
				{
					_boids[i].increaseDir(_boids[i].getDir().normalize());
					if (i != n)
					{
						var boidVec : Vector2D = _boids[i].getPos().findVector(_boids[n].getPos());
						var boidLen : Number = boidVec.length();
						neighboorPos = _boids[i].getPos();
						
						//this check makes sure that the flock does not consider fishes outside the scene
						if (
						boidLen < _viewDistance 
						&& 
						(neighboorPos._x > 0) && (neighboorPos._y > 0)
						&&
						(neighboorPos._x < 1800) && (neighboorPos._y < 1080)
						)
						{
							//calculate the avg data for Alignment and cohesion
							newAveragePosition.addition(_boids[n].getPos());
							
							averageDirection.addition(_boids[n].getDir());
							
							boidsInVisibalDistance++;
							
							averageSpeed += _boids[i].getSpeed();
							
							if (boidLen < _keepdistance)
							{
								//separation, the closer to a flockmate, the more they are repelled
								var normVec : Vector2D = boidVec;
								normVec.multiplyNormVec((boidLen / _keepdistance) - 1);
								
								averageSepForce.addition(normVec);
								boidsKeepDistance++;
							}
						}
					}
				}
				
				if (boidsInVisibalDistance > 0)
				{
					//Adjust boid to follow thw flocks average position, cohation
					if (averageDirection.isEqvivalentTo(_boids[i].getDir()) == false)
					{
						//alignment
						averageDirection.dividePoint(boidsInVisibalDistance + 1);
						//averageDirection.multiplyNormVec(2)
						averageDirection = averageDirection.normalize();
						_boids[i].increaseDir(averageDirection);
					}
					
					//Cohesion, take the average point position and find the vector to that pos from boid
					newAveragePosition.dividePoint(boidsInVisibalDistance + 1);
					
					var dirToCenter : Vector2D = _boids[i].getPos().findVector(newAveragePosition);
					dirToCenter = dirToCenter.normalize();
					dirToCenter.multiplyNormVec(0.5);
					_boids[i].increaseDir(dirToCenter);
					
					if (boidsKeepDistance > 0)
					{
						averageSepForce = averageSepForce.normalize();
						_boids[i].increaseDir(averageSepForce);
					}					
				}
			
		}
		
		private function NewAvoidEnemy(boidToScare:Boid):void
		{
			var speed:Number = Number(boidToScare.getSpeed());
			//not sure if right way
			for (var i : int = 0; i < _nrOfTouches; i++)
			{
				var OtherVec : Vector2D = _touchPos[i].findVector(boidToScare.getPos() );
				var OtherLen : Number = OtherVec.length();
				if (OtherLen < _enemydistance)
				{
					var constant : Number = OtherLen / _enemydistance;
				
					OtherVec = OtherVec.normalize();
					OtherVec.multiplyNormVec((constant));
					boidToScare.increaseDir(OtherVec.normalize());
				
					speed = speed * (9 + constant);
				
					if (10 < speed)
						speed = 10;
				}
				boidToScare.setSpeed(speed);
			}
			
			if (speed <= 10.0 && speed > 4.0)
			{
				speed -= speed * 0.01;
			}
			else if (speed < 4.0 )
			{
				speed = 4.0;
			}
			boidToScare.setSpeed(speed);
		}
		
		public function scareFishPos(pos:Vector2D):void 
		{
			if (_nrOfTouches < 4)
			{
				
				_touchPos[_nrOfTouches]._x = pos._x;
				_touchPos[_nrOfTouches]._y = pos._y;
				
				
				_nrOfTouches++;
			}
		}
	}
}