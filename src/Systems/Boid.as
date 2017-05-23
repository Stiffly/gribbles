package Systems 
{
	import Systems.Vector2D;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import Math;
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
		
		private var _OFFSET : uint = 20;
		// Embed an image which will be used as a background
		private var _pos:Vector2D;
		private var _dir:Vector2D;
		private var _dirVector:Vector.<Vector2D>;
		private var _speed : Number;
		
		
	
		public function Boid()
		{
			_pos = new Vector2D(0, 0);
			_dir = new Vector2D(0, 0);
			_dirVector = new Vector.<Vector2D>(24);
			for (var n:int; n < _dirVector.length; n++ )
			{
				_dirVector[n] = new Vector2D(0, 0);
			}
		}
		
		
		public function Init(stage:Stage):void
		{
			
			textureVec = new Vector.<Bitmap>(6);
			
			textureVec[0] = headBM;
			textureVec[1] = b1BM;
			textureVec[2] = b2BM;
			textureVec[3] = b3BM;
			textureVec[4] = b4BM;
			textureVec[5] = tailBM;
			
			_speed = 1;
			
			spawnAtRandomPoint();
			
			_dir._x = (Math.random());
			_dir._y = (Math.random());
			_dir = _dir.normalize();
			

			for (var n:int; n < textureVec.length; n++ )
			{
				textureVec[n].scaleX = 0.2;
				textureVec[n].scaleY = 0.2;
				stage.addChild(textureVec[n]);
			}
		}
		
		public function Update():void
		{	
			var pos : Vector2D = this.getPos();
			
			//if the fish escapes the sceen it will reset to a random position from above
			if (_pos._x > 1920 || pos._y > 1080)
			{
				//find vector to point
				var spawnPoint : Vector2D = new Vector2D(1920 -(Math.random() * 1000), 0);
				var center : Vector2D = new Vector2D(1920 / 2, 1080 / 2);
				var dirToCenter : Vector2D = spawnPoint.findVector(center);
				
				//respawn boid
				this.setPos(spawnPoint);
				this.setDir(dirToCenter);
			}
			
			//temp update head and body
			//_dir.normalize();
			this._pos._x += (_dir._x * _speed);
			this._pos._y += (_dir._y * _speed);
			
			_dirVector[0] = _dir;
			var n:int  = 0;
            for (n = _dirVector.length - 1; n > 0; n--)
            {
                _dirVector[n] = _dirVector[n - 1];
            }
			
			//Set fishBody Positions
			var rotation:Number = Math.atan2(_dir._y, _dir._x);
			var rotToFront:Vector2D = new Vector2D(0,0);
			var countDown:int = 0;
			var lastPos:Vector2D = _pos;
			for (n = 0; n < textureVec.length; n++ )
			{
				rotToFront = _dirVector[countDown];
				
				rotation = Math.atan2(rotToFront._y, rotToFront._x);
				rotation += 1.57079633;
				
				textureVec[n].rotation = radianToDegree(rotation);
				textureVec[n].x = lastPos._x;
				textureVec[n].y = lastPos._y;
				
				lastPos._x = lastPos._x - (_dirVector[countDown]._x * 3);
				lastPos._y = lastPos._y - (_dirVector[countDown]._y * 3);
				
				countDown += 4;
			}
		}
		
		public function Render():void 
		{
		}
		
		public function setPos(newPos : Vector2D):void
		{
			_pos._x = _pos._x + (_dir._x * _OFFSET);
			_pos._y = _pos._y + (_dir._y * _OFFSET);
		}
		
		public function setDir(newDir : Vector2D):void 
		{
			_dir = newDir.normalize();
			
			_pos._x = _pos._x + (_dir._x * _OFFSET);
			_pos._y = _pos._y + (_dir._y * _OFFSET);
		}
		
		public function getPos(): Vector2D
		{
			var toReturn : Vector2D = new Vector2D(_pos._x, _pos._y);
			return toReturn;
		}
		
		public function getDir():Vector2D 
		{
			return _dir;
		}
		
		public function spawnAtRandomPoint():void 
		{
			_pos._x = (Math.random() * 1920);
		    _pos._y = (Math.random() * 1080);
		}
		
		private function radianToDegree(radians:Number):Number
		{
			return radians * 180 / Math.PI;
		}
	}
	

}