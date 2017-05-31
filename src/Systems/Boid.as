package Systems 
{
	import Systems.Vector2D;
	import com.leapmotion.leap.Matrix;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import Math;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flashx.textLayout.formats.Float;
	/**
	 * ...
	 * @author Sebastian Lundgren and Max Larsson
	 */
	
	public class Boid
	{
		[Embed(source = "../../bin/images/Carp/b1.png")]
		private var b1Class:Class;
		private var b1BM:Bitmap = new b1Class();
		
		[Embed(source = "../../bin/images/Carp/b2.png")]
		private var b2Class:Class;
		private var b2BM:Bitmap = new b2Class();
		
		[Embed(source = "../../bin/images/Carp/b3.png")]
		private var b3Class:Class;
		private var b3BM:Bitmap = new b3Class();
		
		[Embed(source = "../../bin/images/Carp/b4.png")]
		private var b4Class:Class;
		private var b4BM:Bitmap = new b4Class();
		
		[Embed(source = "../../bin/images/Carp/head.png")]
		private var headClass:Class;
		private var headBM:Bitmap = new headClass();
		
		[Embed(source = "../../bin/images/Carp/tail.png")]
		private var tailClass:Class;
		private var tailBM:Bitmap = new tailClass();
		
		private var textureVec:Vector.<Bitmap>;
		
		
		private var _pos:Vector2D;
		private var _dir:Vector2D;
		private var _dirVector:Vector.<Vector2D>;
		private var _distanceVector:Vector.<int>;
		private var _speed : Number;
		private var _inPanic : Boolean;
		private var _spriteVec : Vector.<Sprite>;
		
		private var rotatate:Number = 0;
		private var _oldRotate:Vector.<Number>;
		
	
		public function Boid()
		{
			_pos = new Vector2D(0, 0);
			_dir = new Vector2D(0, 0);
			_dirVector = new Vector.<Vector2D>(50);
			for (var n:int; n < _dirVector.length; n++ )
			{
				_dirVector[n] = new Vector2D(0, 0);
			}
			
			textureVec = new Vector.<Bitmap>(1);
			
			textureVec[0] = headBM;
			//textureVec[1] = b1BM;
			//textureVec[2] = b2BM;
			//textureVec[3] = b3BM;
			//textureVec[4] = b4BM;
			//textureVec[5] = tailBM;
		}
		
		
		public function Init(stage:Stage, viewDist : Number, showVisDist : Boolean):void
		{	
			_speed = 2;
			
			
			_spriteVec = new Vector.<Sprite>(1);
			
			var i : int;
			for (i = 0; i < _spriteVec.length; i++ )
			{
				_spriteVec[i] = new Sprite();
				_spriteVec[i].graphics.beginBitmapFill(textureVec[i].bitmapData, null, true, true);
				_spriteVec[i].graphics.drawRect(0, 0, textureVec[i].width, textureVec[i].height);
				_spriteVec[i].graphics.endFill();
				
				stage.addChild(_spriteVec[i]);
			}
			
		
			
			SpawnAtRandomPoint();
			
			_dir._x = (Math.random());
			_dir._y = (Math.random());
			_dir = _dir.normalize();
			
			for (i = 0; i < _spriteVec.length; i++ )
			{
			
				_spriteVec[i].scaleX = 1;
				_spriteVec[i].scaleY = 1;
				//translateSprite(new Vector2D( - textureVec[i].width / 2, textureVec[i].height/2), i);
			}
			
			_oldRotate = new Vector.<Number>(6);
			for (i = 0; i < _oldRotate.length; i++ )
			{
				_oldRotate[i] = 0;
			}
			
			_distanceVector = new Vector.<int>(6);
			_distanceVector[0] = 20 * (_spriteVec[0].scaleX/0.2);
			_distanceVector[1] = 14* (_spriteVec[0].scaleX/0.2);
			_distanceVector[2] = 11* ( _spriteVec[0].scaleX/0.2);
			_distanceVector[3] = 20* (_spriteVec[0].scaleX/0.2);
			_distanceVector[4] = 21* (_spriteVec[0].scaleX/0.2);
			_distanceVector[5] = 20* (_spriteVec[0].scaleX/0.2);
		}
		
		public function Update(currentBoid:int,boids:Vector.<Boid>,enemy:Vector2D,viewDistance:Number,keepDistance:Number):void
		{	
			BoidsFirstRules(currentBoid,boids, viewDistance,keepDistance);
			
            //this.NewAvoidEnemy(obst);
            //
            ////simple function that moves the boids back to the screen
            //this.ReinitializeBoidPosition(loopAround);
            //
            ////the direction should be normailized to maintain speed reliability
            //dir.Normalize();
            //pos += (dir * speed) * (float)gameTime.ElapsedGameTime.TotalSeconds;
            //dirArr[0] = dir;
            //for (int n = dirArr.Length - 1; n > 0; n--)
            //{
            //    dirArr[n] = dirArr[n - 1];
            //}
			
			_dir = _dir.normalize();
			
			this._pos._x += (_dir._x * _speed);
			this._pos._y += (_dir._y * _speed);
			
			_spriteVec[0].x = _pos._x;
			_spriteVec[0].y = _pos._y;
			
			Draw();
		}
		
		private function Draw():void
		{
			
		}
		public function Activate():void
		{
			for (var i:int = 0; i < _spriteVec.length; i++ )
			{
				_spriteVec[i].visible = true;
			}
			
		}
		
		public function Deactivate():void
		{
			
			for (var i:int = 0; i < _spriteVec.length; i++ )
			{
				_spriteVec[i].visible = false;
			}
			
		}
		
		public function ReinitializeBoidPosition():void
		{
			
			 if (_pos._x > 1920)
                {
					_dir._x = -_dir._x;
					_dir._y = -_dir._y;
					_dir = _dir.normalize();
                }
                if (_pos._y > 1080)
                {
                    _dir._x = -_dir._x;
					_dir._y = -_dir._y;
					_dir = _dir.normalize();
                }
                if (_pos._x < -100)
                {
                    _dir._x = -_dir._x;
					_dir._y = -_dir._y;
					_dir = _dir.normalize();
                }
                if (_pos._y < -100)
                {
                    _dir._x = -_dir._x;
					_dir._y = -_dir._y;
					_dir = _dir.normalize();
                }
		}
		
		public function SpawnAtRandomPoint():void 
		{
			var spawnPoint : Vector2D;
			var center : Vector2D;
			var dirToCenter : Vector2D;
			
			//find vector to point
			spawnPoint = new Vector2D(300 + (Math.random() * 300), 300 + (Math.random() * 300));
			center = new Vector2D(1920 / 2, 1080 / 2);
			dirToCenter = spawnPoint.findVector(center);
			
					
			//respawn boid
			_pos._x = spawnPoint._x;
			_pos._y = spawnPoint._y;
			
			
			
			//this.setPos(spawnPoint);
			//this.setDir(dirToCenter);
			
		}
			
		public function BoidsFirstRules(currentBoid:int,_boids:Vector.<Boid>,_viewDistance:Number,_keepDistance:Number):void
		{
			var averageSepForce : Vector2D = new Vector2D(0, 0);
			var newAveragePosition : Vector2D = new Vector2D(0, 0);
			var averageDirection : Vector2D = new Vector2D(0, 0);
			var boidsInVisibalDistance : int = 0;
			var boidsKeepDistance : int = 0;
			
			newAveragePosition.addition(_pos);
			
			for (var n:int = 0; n < _boids.length; n++ )
			{
				if (currentBoid != n)
				{
					var boidVec : Vector2D = _boids[n]._pos.findVector(_boids[n]._pos);
					var boidVecLength : Number = boidVec.length();
					
					if (boidVecLength < _viewDistance)
					{
						newAveragePosition.addition(_boids[n]._pos);
						
						averageDirection.addition(_boids[n]._dir);
						
						boidsInVisibalDistance++;
						
						if (boidVecLength  < _keepDistance)
						{
							//separation, the closer to a flockmate, the more they are repelled
							//var dumbNumb:Number = (boidVecLength / _keepDistance)-1;
							var normVec : Vector2D = boidVec;
							normVec.multiplyNormVec((boidVecLength / _keepDistance) - 1);// =  normVec.normalize();
							//normVec.rescale(dumbNumb);
							
							averageSepForce.addition(normVec);
							boidsKeepDistance++;
						}
					}
					
				}
			}
			
			if (boidsInVisibalDistance > 0)
			{
				//Adjust boid to follow thw flocks average position, cohation
				if (averageDirection.isEqvivalentTo(_dir) == false)
				{
					//alignment OLD
					averageDirection = averageDirection.normalize();

					//_boids[i].increaseDir(averageDirection);
					_dir.addition(averageDirection);
				}
				
				//Cohesion, take the average point position and find the vector to that pos from boid
				newAveragePosition.dividePoint(boidsInVisibalDistance+1);
				

				var dirToCenter : Vector2D = _pos.findVector(newAveragePosition);
				dirToCenter = dirToCenter.normalize();
				//_boids[i].increaseDir(dirToCenter);
				_dir.addition(dirToCenter);
				
				if (boidsKeepDistance > 0)
				{
					averageSepForce = averageSepForce.normalize();
					//_boids[i].increaseDir(averageSepForce);
					_dir.addition(averageSepForce);
				}	
			}
		}
	}
}