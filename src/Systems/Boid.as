package Systems 
{
	import Systems.Vector2D;
	import flash.display.Sprite;
	import flash.display.Stage;
	import Math;
	/**
	 * ...
	 * @author Sebastian Lundgren and Max Larsson
	 */
	public class Boid
	{
		private var _OFFSET : uint = 20;
		// Embed an image which will be used as a background
		private var _pos:Vector2D;
		
		private var _dir:Vector2D;
		private var _dirVector:Vector<Vector2D>;
		
		private var _distanceVector:Vector<int>;
		
		private var _speed : Number;
		private var _inPanic : Boolean;
		
		private var _fishSprite:BoidBody;
		
		public function Boid()
		{
			_dir = new Vector2D(0, 0);
			_fishSprite = new BoidBody();
			
			_pos = new Vector2D(0, 0);
			
	
		}
		
		
		public function Init(stage:Stage):void
		{
			_speed = 1;
			_inPanic = false;
			_fishSprite.Init(stage);
			
			spawnAtRandomPoint();
			
			_dirVector = new Vector.<Vector2D>(50);
			
			for (var i:int = 0; n < _dirVector.length; n++ )
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
			
			_fishSprite.Update(mousePos, debugger);
			
			
			_dirVector[0] = _dir;
			
			for (var i:int = _dirVector.length-1; n > 0; n-- )
			{
				_dirVector[i] = _dirVector[i-1];
			}
			
			
		}
		
		private function SetBodyPosDir()
		{
			float rotation = (float)(Math.Atan2(dir.Y, dir.X));// / (2 * Math.PI));
            Vector2 rotToFront = new Vector2();
            int countDown = 0;
            Vector2 lastPos = pos;
            float distance = 0;
            for (int n = 0; n < fishTex.Length; n++)
            {
                rotToFront = dirArr[countDown];
                //rotToFront.Normalize();
                
                rotation = (float)(Math.Atan2(rotToFront.Y, rotToFront.X));// / (2 * Math.PI));

                rotation += MathHelper.ToRadians(-90);
                spriteBatch.Draw(fishTex[n], lastPos, new Rectangle(0, 0, fishTex[n].Width, fishTex[n].Height), new Color(color.R + (n * 2), color.G + (n * 2), color.B + (n * 2)),
                    rotation,
                    new Vector2(fishTex[n].Width / 2, (fishTex[n].Height)),
                    size,
                    SpriteEffects.None, 1
                    );



                    lastPos = lastPos - (dirArr[countDown] * distanceArr[n]);
                    countDown += 4;
                    
            }
		}
		
		public function setPos(newPos : Vector2D):void
		{
			_pos = newPos;
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

		public function getPos(): Vector2D
		{
			return _pos;
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
	}

}