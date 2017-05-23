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
		private var _enemy : Boid;
		
		public function Fishes() 
		{
		}
		
		public function Init(stage:Stage):void
		{
			_viewDistance = 200;
			_keepdistance = 100;
			_amountOfFish = 6;		
			
			
			_boids = new Vector.<Boid>(_amountOfFish);
			
			_boids[0] = new Boid();
			_boids[0].Init(stage, _viewDistance, true);
			_boids[0].setPos(new Vector2D(850, 400));
			_boids[0].setDir(_boids[0].getPos().findVector(new Vector2D(800, 400)).normalize());
			_boids[0].setSpeed(1.0);
			
			_boids[1] = new Boid();
			_boids[1].Init(stage, _viewDistance, false);
			_boids[1].setPos(new Vector2D(800, 450));
			_boids[1].setSpeed(1.0);
			
			_boids[2] = new Boid();
			_boids[2].Init(stage, _viewDistance, false);
			_boids[2].setPos(new Vector2D(850, 450));
			_boids[2].setSpeed(1.0);
			
			
			_boids[3] = new Boid();
			_boids[3].Init(stage, _viewDistance, false);
			_boids[3].setPos(new Vector2D(845, 450));
			_boids[3].setSpeed(1.0);
			
			_boids[4] = new Boid();
			_boids[4].Init(stage, _viewDistance, false);
			_boids[4].setPos(new Vector2D(846, 450));
			_boids[4].setSpeed(1.0);
			
			_boids[5] = new Boid();
			_boids[5].Init(stage, _viewDistance, false);
			_boids[5].setPos(new Vector2D(847, 450));
			_boids[5].setSpeed(1.0);
			
			/*
			_boids = new Vector.<Boid>(_amountOfFish);
			var i:int;
			for (i = 0; i < _amountOfFish; i++)
			{
				_boids[i] = new Boid();
				_boids[i].Init(stage, _viewDistance, false);
			}
			*/
			_enemy = new Boid();
			_enemy.Init(stage, _viewDistance, false);
			_enemy.setRed();
			_enemy.setSpeed(0);
			
		}
		
		public function Update():void 
		{
			//this.BoidAlgorithm();
			this.boidsFirstRules();
			
			
			
			
			var i : uint;
			for (i = 0; i < _amountOfFish; i++)
			{
				_boids[i].setDir(_boids[i].getDir().normalize());
				_boids[i].Update();
			}
			_enemy.Update();
		}
		
		public function Shutdown():void 
		{
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
				var averageSpeed : Number = 0.0;
				
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
						averageDirection.multiplyNormVec(0.3)
						_boids[i].increaseDir(averageDirection);
					}
					
					newAveragePosition.dividePoint(boidsInVisibalDistance + 1);
					
					var dirToCenter : Vector2D = _boids[i].getPos().findVector(newAveragePosition);
					const MIDDLE_OFFSET : int = 7;
					
				
					_boids[i].increaseDir(dirToCenter);
					
					if (boidsKeepDistance > 0)
					{
						_boids[i].increaseDir(averageSepForce);
					}					
				}
			}
			
			
			
		}
		/*
		private function BoidAlgorithm():void 
		{
			var averageSepForce : Vector2D 		= new Vector2D(0, 0);
			var newAveragePosition : Vector2D 	= new Vector2D(0, 0);
			var averageDirection : Vector2D 	= new Vector2D(0, 0);
			var v1 : Vector2D = new Vector2D(0, 0);
			var v2 : Vector2D = new Vector2D(0, 0);
			var v3 : Vector2D = new Vector2D(0, 0);
			var v4 : Vector2D = new Vector2D(0, 0);
			var v5 : Vector2D = new Vector2D(0, 0);
			
			
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
						
						if (boidLen < _viewDistance)
						{
							//calculate average posision
							newAveragePosition.addition(_boids[i].getPos());
							averageDirection.addition(_boids[i].getDir());	
							
							boidVec = boidVec.normalize();
							v1.addition(boidVec.rescale((boidLen / _keepdistance) - 1));
							
							boidsInVisibalDistance++;
						}
						
						
						//comment out
						if (obsLen < _viewDistance)
						{
							//heavy computation here
							var obsRad : Number = 100;
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
						//comment out end
					}
				}
				//end sep
				//comment out
				if (averageSepForce._x != 0 && averageSepForce._y != 0)
				{
					newAveragePosition.rescale(1 / boidsInVisibalDistance);
					v3.addition(activeBoid.findVector(newAveragePosition));
				}
				//comment out end
				
				if (boidsInVisibalDistance > 0)
				{
					//rescale, avg direction
					averageDirection = averageDirection.rescale(1 / boidsInVisibalDistance);
					v2 = averageDirection;
					
					//rescale, avg position
					newAveragePosition = newAveragePosition.rescale((1 / boidsInVisibalDistance));
					//find the vector form boid to average point, v3
					v3.addition(activeBoid.findVector(newAveragePosition));
				}
				totalNewDir = new Vector2D(0, 0);
				totalNewDir.addition(_boids[n].getDir());
				
				v5 = this.AvoidEnemyBoid(_boids[n]);
				
				//add the vectors to the new direction
				if (_boids[n].isPanic() == false)
				{
					totalNewDir.addition(v1);
					totalNewDir.addition(v2);
					totalNewDir.addition(v3);
					totalNewDir.addition(v4);
				}
				else
				{	
					totalNewDir.addition(v5);
				}
				
				
				
				
				if (totalNewDir._x != 0 && totalNewDir._y != 0)
				{
					_boids[n].setDir(totalNewDir);
				}
			}
			
		}
		*/
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
	}

}