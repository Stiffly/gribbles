package Systems 
{
	import Systems.Vector2D;
	import adobe.utils.CustomActions;
	import com.adobe.utils.IntUtil;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import Math;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author Sebastian Lundgren and Max Larsson
	 */
	public class Boid
	{
		[Embed(source="../../bin/images/Carp/head.png")]
		private var headSpriteBit:Class;
		private var headBitmap:Bitmap = new headSpriteBit();
		
		[Embed(source="../../bin/images/Carp/b1.png")]
		private var b1SpriteBit:Class;
		private var b1Bitmap:Bitmap = new b1SpriteBit();
		
		[Embed(source="../../bin/images/Carp/b2.png")]
		private var b2SpriteBit:Class;
		private var b2Bitmap:Bitmap = new b2SpriteBit();
		
		[Embed(source="../../bin/images/Carp/b3.png")]
		private var b3SpriteBit:Class;
		private var b3Bitmap:Bitmap = new b3SpriteBit();
		
		[Embed(source="../../bin/images/Carp/b4.png")]
		private var b4SpriteBit:Class;
		private var b4Bitmap:Bitmap = new b4SpriteBit();
		
		[Embed(source="../../bin/images/Carp/tail.png")]
		private var tailSpriteBit:Class;
		private var tailBitmap:Bitmap = new tailSpriteBit();

		// Embed an image which will be used as a background
		private var _pos:Vector2D;
		private var _dir:Vector2D;
		private var _dirVector:Vector.<Vector2D>;
		private var _speed : Number;
		private var _inPanic : Boolean;
		
		private var _fishSprites:Vector.<BoidBody>;
		
		private var _distanceVector:Vector.<int>;
		
		public var worldUnit:Number;
		
		public function Boid()
		{
			_dir = new Vector2D(0, 1);
			_fishSprites = new Vector.<BoidBody>(6);
			for (var i:int = 0; i < _fishSprites.length; i++ )
			{	
				_fishSprites[i] = new BoidBody();
			}
			_pos = new Vector2D(0, 0);
		}
		
		
		public function Init(stage:Stage, viewDist : Number, showVisDist : Boolean):void
		{
			worldUnit = headBitmap.width / 16;
			
			_speed = 5;
			_inPanic = false;

			var colorTransform:ColorTransform = new ColorTransform(Math.random(), Math.random(), Math.random());
			_fishSprites[0].Init(stage, headBitmap, colorTransform);
			_fishSprites[1].Init(stage, b1Bitmap, colorTransform);
			_fishSprites[2].Init(stage, b2Bitmap, colorTransform);
			_fishSprites[3].Init(stage, b3Bitmap, colorTransform);
			_fishSprites[4].Init(stage, b4Bitmap, colorTransform);
			_fishSprites[5].Init(stage, tailBitmap, colorTransform);
			
			spawnAtRandomPoint();
			
			_dirVector = new Vector.<Vector2D>(50);
			
			for (var n:int = 0; n < _dirVector.length; n++ )
			{
				_dirVector[n] = new Vector2D(_dir._x,_dir._y);
			}
			
			_distanceVector = new Vector.<int>(6);
			_distanceVector[0] = 10 * worldUnit;
            _distanceVector[1] = 7 * worldUnit;
            _distanceVector[2] = 5 * worldUnit;
            _distanceVector[3] = 7 * worldUnit;
            _distanceVector[4] = 10 * worldUnit; 
            _distanceVector[5] = 10 * worldUnit;
		}
		
		public function Activate():void
		{
			for (var i:int = 0; i < _fishSprites.length; i++ )
				_fishSprites[i].Activate();
		}
		
		public function Deactivate():void
		{
			for (var i:int = 0; i < _fishSprites.length; i++ )
				_fishSprites[i].Deactivate();
		}
		
		public function Update():void
		{	
			ReinitializeBoidPosition()
			//CalculateDir();
			_dir = _dir.normalize();
			
			_pos._x += _dir._x * _speed;
			_pos._y += _dir._y * _speed;
			
			_dirVector[0] = _dir.normalize();
			var i:int;
			for (i = _dirVector.length-1; i > 0; i-- )
			{
				_dirVector[i] = _dirVector[i-1];
			}
			
			CalculateDir();
			
			for (i = 0; i < _fishSprites.length; i++ )
			{
				_fishSprites[i].SuperUpdateMatrix();
			}
			
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
			
			for (var n:int = 0; n < _fishSprites.length; n++ )
			{	
				rotToFront = _dirVector[countDown];
				
				rotation = Math.atan2(rotToFront._y, rotToFront._x)+ (-90 * Math.PI/180);
				
				_fishSprites[n].SetPos(lastPos);
				_fishSprites[n].SetRoation(rotation);
				
				lastPos._x = lastPos._x - (_dirVector[countDown]._x ) * (_distanceVector[n]);
				lastPos._y = lastPos._y - (_dirVector[countDown]._y) * (_distanceVector[n]);
				
				countDown += 3;
			}
		}
		
		public function setPos(newPos : Vector2D):void
		{
			_pos._x =  newPos._x;
			_pos._y = newPos._y;
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
			var dice : int = -1;
			
			//vänster eller höger sida
			dice = int(Math.random() * 1000);
			dice %= 2;
			
			//spawn random point utanför skärm
			if (dice == 0)
			{
				spawnPoint = new Vector2D(-100, 900 - Math.random() * 1000);
			}
			else
			{
				spawnPoint = new Vector2D(2000, 900 - Math.random() * 1000);
			}
			
			
			//find vector to point
			//spawnPoint = new Vector2D(1600 -(Math.random() * 1000), 900 -(Math.random() * 1000));
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
		
		public function ReinitializeBoidPosition():void
		{
			 if (_pos._x > 3000)
                {
					//_dir._x = -_dir._x;
					//_dir._y = -_dir._y;
					spawnAtRandomPoint();
					
					//_dir = _dir.normalize();
                }
                if (_pos._y > 1500)
                {
					spawnAtRandomPoint();
                    //_dir._x = -_dir._x;
					//_dir._y = -_dir._y;
					//_dir = _dir.normalize();
					
                }
                if (_pos._x < -800)
                {
					spawnAtRandomPoint();
                    //ir._x = -_dir._x;
					//_dir._y = -_dir._y;
					//_dir = _dir.normalize();
					
                }
                if (_pos._y < -800)
                {
					spawnAtRandomPoint();
                    //_dir._x = -_dir._x;
					_dir._y = -_dir._y;
					//_dir = _dir.normalize();
                }
		}
	
		public function GetWorldUnit():Number
		{
			return worldUnit;
		}
	}

}