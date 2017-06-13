package Systems 
{
	import Systems.Vector2D;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import Math;
	/**
	 * ...
	 * @author Sebastian Lundgren and Max Larsson
	 */
	public class Boid
	{
		[Embed(source="../../bin/images/Carp/head.png")]
		private var headSpriteBit:Class;

		var headBitmap:Bitmap = new headSpriteBit();

		// Embed an image which will be used as a background
		private var _pos:Vector2D;
		private var _dir:Vector2D;
		private var _dirVector:Vector.<Vector2D>;
		private var _speed : Number;
		private var _inPanic : Boolean;
		
		private var _fishSprite:BoidBody;
		
		var _distanceVector:Vector.<int>;
		
		public function Boid()
		{
			_dir = new Vector2D(0, 0);
			_fishSprite = new BoidBody();
			_pos = new Vector2D(0, 0);
		}
		
		
		public function Init(stage:Stage, viewDist : Number, showVisDist : Boolean):void
		{
			_speed = 3;
			_inPanic = false;
			_fishSprite.Init(stage, headBitmap);
			
			_dirVector = new Vector.<Vector2D>(50);
			
			for (var n:int = 0; n < _dirVector.length; n++ )
			{
				_dirVector[n] = new Vector2D(_dir._x,_dir._y);
			}
			
			_distanceVector = new Vector.<int>(6);
			_distanceVector[0] =  20;
            _distanceVector[1] = 14;
            _distanceVector[2] = 11;
            _distanceVector[3] = 20;
            _distanceVector[4] = 21;
            _distanceVector[5] = 20;
		}
		
		public function Activate()
		{
			
		}
		
		public function Deactivate()
		{
			
		}
		
		public function Update(mousePos : Vector2D, debugger:TextBox ):void
		{	
			var spawnPoint : Vector2D;
			var center : Vector2D;
			var dirToCenter : Vector2D;

			//CalculateDir();
			
			_pos._x += _dir._x * _speed;
			_pos._y += _dir._y * _speed;
			
			_fishSprite.SetPos(_pos);
			_fishSprite.RotateAroundCenter(Math.atan2(_dir._y,_dir._x));
			_fishSprite.Update(mousePos, debugger);
			
		}
		
		public function CalculateDir():void 
		{
 			
			//Set fishBody Positions
			var rotation:Number = Math.atan2(_dir._y, _dir._x);
			var rotToFront:Vector2D = new Vector2D(0,0);
			var countDown:int = 0;
			var lastPos:Vector2D = new Vector2D(0, 0);
			lastPos._x = _pos._x;
			lastPos._y = _pos._y;
			
			for (var n:int = 0; n < 3; n++ )
			{
				
				//translateSprite(new Vector2D(lastPos._x,lastPos._y),n);
				
				lastPos._x = lastPos._x - (_dirVector[countDown]._x * _distanceVector[n]);
				lastPos._y = lastPos._y - (_dirVector[countDown]._y *_distanceVector[n]);
				
				rotToFront = _dirVector[countDown];
				
				rotation = Math.atan2(rotToFront._y, rotToFront._x);
				
				//textureVec[n].rotationY = rotatate += 0.4;
				//textureVec[n].transform.matrix.
				
				//rotateAroundCenter(rotation +(Math.PI / 180 * ( -90)), n);
				//rotateAroundCenter((Math.PI / 180 * ( rotatate)), n);
				//rotateAroundPoint(textureVec[n], 44);
				
				countDown += 4;
			}
			
			//} endregion
		}
		
		public function setPos(newPos : Vector2D):void
		{
			//translate
			//_fishSprite.SetPos(newPos);
		}
		
		public function setDir(newDir : Vector2D):void 
		{
			_dir = newDir;
		}
		
		public function increaseDir(toAdd : Vector2D) : void
		{
			_dir._x += toAdd._x;
			_dir._y += toAdd._y;
		}
		/*
		public function getSprite():Sprite
		{
		}
		*/
		public function getPos(): Vector2D
		{
			//var toReturn : Vector2D = new Vector2D(_sprite.x, _sprite.y);
			return new Vector2D(0,0);
		}
		
		public function getDir():Vector2D 
		{
			return _dir;
		}
		
		public function getSpeed():Number
		{
			return _speed;
		}
		
		public function setSpeed(newSpeed:Number):void 
		{
			_speed = newSpeed;
		}
		
		public function spawnAtRandomPoint():void 
		{
			var spawnPoint : Vector2D;
			var center : Vector2D;
			var dirToCenter : Vector2D;
			
			//find vector to point
			spawnPoint = new Vector2D(1920 -(Math.random() * 1000), 1080 -(Math.random() * 1000));
			center = new Vector2D(1920 / 2, 1080 / 2);
			dirToCenter = spawnPoint.findVector(center);
					
			//respawn boid
			this.setPos(spawnPoint);
			this.setDir(dirToCenter);
		}

		public function panicSwitch() : void
		{
			_inPanic = !_inPanic;
		}
		
		public function isPanic() : Boolean
		{
			return _inPanic;
		}
		
		private function ReinitializeBoidPosition():void
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
	}

}