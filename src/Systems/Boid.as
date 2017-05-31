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
			
			
			_speed = 1;
			
			
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
			
		
			
			spawnAtRandomPoint();
			
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
		
		public function Update():void
		{	
			reinitializeBoidPosition();
			
			_dir = _dir.normalize();
			
			this._pos._x += (_dir._x * _speed);
			this._pos._y += (_dir._y * _speed);
			
			_dirVector[0] = _dir;
			var n:int  = 0;
            for (n = _dirVector.length - 1; n > 0; n--)
            {
                _dirVector[n] = _dirVector[n - 1];
            }
			
			_spriteVec[0].x = this._pos._x;
			_spriteVec[0].y = this._pos._y;
			
			
			//{ Translate and rotate
			
			
			
			
			/*
			//Set fishBody Positions
			var rotation:Number = Math.atan2(_dir._y, _dir._x);
			var rotToFront:Vector2D = new Vector2D(0,0);
			var countDown:int = 0;
			var lastPos:Vector2D = new Vector2D(0, 0);
			lastPos._x = _pos._x;
			lastPos._y = _pos._y;
			
			for (n = 0; n < _spriteVec.length; n++ )
			{
				
				translateSprite(new Vector2D(lastPos._x,lastPos._y),n);
				
				lastPos._x = lastPos._x - (_dirVector[countDown]._x * _distanceVector[n]);
				lastPos._y = lastPos._y - (_dirVector[countDown]._y *_distanceVector[n]);
				
				rotToFront = _dirVector[countDown];
				
				rotation = Math.atan2(rotToFront._y, rotToFront._x);
				
				//textureVec[n].rotationY = rotatate += 0.4;
				//textureVec[n].transform.matrix.
				
				rotateAroundCenter(rotation +(Math.PI / 180 * ( -90)), n);
				//rotateAroundCenter((Math.PI / 180 * ( rotatate)), n);
				//rotateAroundPoint(textureVec[n], 44);
				
				countDown += 4;
			}
			*/
			//} endregion
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
		public function Render():void 
		{
		}
		
		public function setPos(newPos : Vector2D):void
		{
			_pos._x = newPos._x;
			_pos._y = newPos._y;
		}
		
		public function setDir(newDir : Vector2D):void 
		{
			_dir = newDir;
			_dir = _dir.normalize();
		}
		
		public function increaseDir(toAdd : Vector2D) : void
		{
			toAdd = toAdd.normalize()
			
			_dir._x += toAdd._x;
			_dir._y += toAdd._y;
			
			_dir = _dir.normalize();
		}
		
		public function getPos(): Vector2D
		{
			var toReturn : Vector2D = new Vector2D(_pos._x, _pos._y);
			return toReturn;
		}
		
		public function reinitializeBoidPosition():void
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
			spawnPoint = new Vector2D(300 + (Math.random() * 300), 300 + (Math.random() * 300));
			center = new Vector2D(1920 / 2, 1080 / 2);
			dirToCenter = spawnPoint.findVector(center);
			
					
			//respawn boid
			this.setPos(spawnPoint);
			this.setDir(dirToCenter);
		}
			
		private function rotateAroundCenter(degree:Number, spriteIndex : int):void 
		{
			var toRotate : Number = 0;
			toRotate =  -_oldRotate[spriteIndex] + degree;
			
			
				var orgMatrix : flash.geom.Matrix = _spriteVec[spriteIndex].transform.matrix;
				
				//get the rect of the obj
				var rect : Rectangle = _spriteVec[spriteIndex].getBounds(_spriteVec[spriteIndex].parent);
				
				var transX : Number = - (rect.left + (rect.width / 2));
				var transY : Number = - (rect.top + (rect.height)/2);
				
				//translate
				orgMatrix.translate(transX, transY);
				
				// Rotation (note: the parameter is in radian) 
				orgMatrix.rotate(toRotate); 
				
				// Translating the object back to the original position.
				orgMatrix.translate(-transX, -transY); 
				
				_spriteVec[spriteIndex].transform.matrix = orgMatrix;
				
				_oldRotate[spriteIndex] = degree;
		}
		
		private function translateSprite(newPos : Vector2D, spriteIndex : int):void 
		{
				var orgMatrix : flash.geom.Matrix = _spriteVec[spriteIndex].transform.matrix;
				
				//get the rect of the obj
				var rect : Rectangle = _spriteVec[spriteIndex].getBounds(_spriteVec[spriteIndex].parent);
				
				var transX : Number = - (rect.left + (rect.width / 2))+ newPos._x;
				var transY : Number = - (rect.top + (rect.height / 2))+ newPos._y;
				
				//translate
				orgMatrix.translate(transX, transY); 
				
				orgMatrix.rotate(0);
				
				_spriteVec[spriteIndex].transform.matrix = orgMatrix;
		}
	}
}