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
	public class Fishes 
	{
		private var _viewDistance : Number;
		private var _keepdistance : Number;
		private var _amountOfFish : int;
		private var _boids:Vector.<Boid>;
		private var _enemy : Boid;
		
		public function Fishes() 
		{
		}
		
		public function Init(stage:Stage):void
		{
			_viewDistance = 70;
			_keepdistance = 50;
			_amountOfFish = 40;		
			
			_boids = new Vector.<Boid>(_amountOfFish);
			var i:int;
			for (i = 0; i < _amountOfFish; i++)
			{

				_boids[i] = new Boid();
				_boids[i].Init(stage, _viewDistance, false);
				_boids[i].setSpeed(1);
				
			}
			

			_enemy = new Boid();
			_enemy.Init(stage, _viewDistance, false);
			
			_enemy.setSpeed(0);
			_enemy.Deactivate();
			
			var centerPos : Vector2D = new Vector2D(1920 / 2, -1080 / 2);
			var pos : Vector2D = _enemy.getPos();
			
			_enemy.setDir(pos.findVector(centerPos).normalize());
		}
		
		private function moveEnemy(event:MouseEvent):void 
		{
			_enemy.setPos(new Vector2D(event.stageX, event.stageY));
		}
		
		public function Update():void 
		{
			//this.BoidAlgorithm();
			this.boidsFirstRules();
			
			for (var i : int = 0; i < _boids.length; i++)
			{
				_boids[i].Update();
			}
			
			_enemy.Update();
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
		
		private function boidsFirstRules() : void
		{
			var i : int;
			for (i = 0; i < _amountOfFish; i++)
			{
				var averageSepForce : Vector2D = new Vector2D(0, 0);
				var newAveragePosition : Vector2D = new Vector2D(0, 0);
				var averageDirection : Vector2D = new Vector2D(0, 0);
				var boidsInVisibalDistance : int = 0;
				var boidsKeepDistance : int = 0;
				
				//we walk through and process each boid here, different from boidtest
				newAveragePosition.addition(_boids[i].getPos());
				
				var n : int;
				for (n = 0; n < _amountOfFish; n++)
				{
					if (i != n)
					{
						var boidVec : Vector2D = _boids[i].getPos().findVector(_boids[n].getPos());
						var boidLen : Number = boidVec.length();
						
						if (boidLen < _viewDistance)
						{
							//calculate the avg data for Alignment and cohesion
							newAveragePosition.addition(_boids[n].getPos());
							
							averageDirection.addition(_boids[n].getDir());
							
							boidsInVisibalDistance++;
							
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
						averageDirection = averageDirection.normalize();
						
						_boids[i].increaseDir(averageDirection);
					}
					
					//Cohesion, take the average point position and find the vector to that pos from boid
					newAveragePosition.dividePoint(boidsInVisibalDistance + 1);
					
					var dirToCenter : Vector2D = _boids[i].getPos().findVector(newAveragePosition);
					dirToCenter = dirToCenter.normalize();
					_boids[i].increaseDir(dirToCenter);
					
					if (boidsKeepDistance > 0)
					{
						averageSepForce = averageSepForce.normalize();
						_boids[i].increaseDir(averageSepForce);
					}					
				}
			}
		}
		
		private function AvoidEnemyBoid(boidToScare:Boid):Vector2D
		{
			var avoidVec : Vector2D = new Vector2D(0, 0);
			var fallOffSpeed : Number = boidToScare.getSpeed();
			var speed : Number = boidToScare.getSpeed();
			
			//not sure if right way
			var OtherVec : Vector2D = _enemy.getPos().findVector(boidToScare.getPos());
			var OtherLen : Number = OtherVec.length();
			if (OtherLen < _viewDistance)
			{
				var constant : Number = OtherLen / _viewDistance;
				avoidVec = OtherVec.rescale(OtherLen);
				avoidVec = avoidVec.rescale(constant);
				
				var w : Number = 2.0;
				var speedMod : Number = OtherLen / _viewDistance; 
				
				speed += speedMod;
				
				if (3.0 < speed)
				{
					speed = 3;
				}
				
				
				avoidVec.rescale(w);
				//switch to panic
				if (boidToScare.isPanic() == false)
				{
					boidToScare.panicSwitch();
				}
			}
			else
			{
				if (speed <= 3.0 && speed > 1.0)
				{
					speed -= speed * 0.01;
				}
				else if (speed < 1.0 )
				{
					speed = 1.0;
				}
				
				//no panic
				if (boidToScare.isPanic() == true)
				{
					//if not panic
					
					
					boidToScare.panicSwitch();
				}
			}
			
			boidToScare.setSpeed(speed);
			return avoidVec;
		}
		
		public function scareFishPos(pos:Vector2D):void 
		{
			_enemy.setPos(pos);
		}
	}

}