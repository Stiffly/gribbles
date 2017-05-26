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
		
		private var _OFFSET : uint = 20;
		// Embed an image which will be used as a background
		private var _pos:Vector2D;
		private var _dir:Vector2D;
		private var _dirVector:Vector.<Vector2D>;
		private var _distanceVector:Vector.<int>;
		private var _speed : Number;
		
		private var _spriteVec : Vector.<Sprite>;
		
		private var rotatate:Number = 0;
		
		private var _oldRotate:Vector.<Number>;
		
		private var referenceMatrix:flash.geom.Matrix;
		
	
		public function Boid()
		{
			_pos = new Vector2D(0, 0);
			_dir = new Vector2D(0, 0);
			_dirVector = new Vector.<Vector2D>(24);
			for (var n:int; n < _dirVector.length; n++ )
			{
				_dirVector[n] = new Vector2D(0, 0);
			}
			
			_distanceVector = new Vector.<int>(6);
			_distanceVector[0] = 20;
			_distanceVector[1] = 14;
			_distanceVector[2] = 11;
			_distanceVector[3] = 20;
			_distanceVector[4] = 21;
			_distanceVector[5] = 20;
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
			
			_speed = 2;
			
			
			_spriteVec = new Vector.<Sprite>(6);
			
			var i : int;
			for (i = 0; i < _spriteVec.length; i++ )
			{
				_spriteVec[i] = new Sprite();
				_spriteVec[i].graphics.beginBitmapFill(textureVec[i].bitmapData, null, true, true);
				_spriteVec[i].graphics.drawRect(0, 0, textureVec[i].width, textureVec[i].height);
				_spriteVec[i].graphics.endFill();
				
				stage.addChild(_spriteVec[i]);
				
				//_spriteVecRotationOrg[i] = new flash.geom.Matrix;
				//_spriteVecRotationOrg[i] = new flash.geom.Matrix(_spriteVec[i].transform.matrix);
			}
			
		
			
			//spawnAtRandomPoint();
			_pos._x = 400;
		    _pos._y = 400;
			
			_dir._x = (Math.random());
			_dir._y = (Math.random());
			_dir = _dir.normalize();
			


			
			referenceMatrix = headBM.transform.matrix.clone();
			for (i = 0; i < _spriteVec.length; i++ )
			{
			
				_spriteVec[i].scaleX = 0.2;
				_spriteVec[i].scaleY = 0.2;
				//translateSprite(new Vector2D( - textureVec[i].width / 2, textureVec[i].height/2), i);
			}
			
			_oldRotate = new Vector.<Number>(6);
			for (i = 0; i < _oldRotate.length; i++ )
			{
				_oldRotate[i] = 0;
			}
			
			
		}
		
		public function Update():void
		{	
			
			//var pos : Vector2D = this.getPos();
			
			//temp update head and body
			_dir = _dir.normalize();
			this._pos._x += (_dir._x * _speed);
			this._pos._y += (_dir._y * _speed);
			
			_dirVector[0] = _dir;
			var n:int  = 0;
            for (n = _dirVector.length - 1; n > 0; n--)
            {
                _dirVector[n] = _dirVector[n - 1];
            }
			
			reinitializeBoidPosition();
			
			//Set fishBody Positions
			var rotation:Number = Math.atan2(_dir._y, _dir._x);
			var rotToFront:Vector2D = new Vector2D(0,0);
			var countDown:int = 0;
			var lastPos:Vector2D = new Vector2D(0, 0);
			lastPos._x = _pos._x;
			lastPos._y = _pos._y;
			
			for (n = 0; n < _spriteVec.length; n++ )
			{
				//translateSprite(new Vector2D(1.0, 0.0), n);
				//textureVec[n].x = lastPos._x;// - textureVec[n].width / 2;
				//textureVec[n].y = lastPos._y;// + textureVec[n].height;
				
				translateSprite(new Vector2D(lastPos._x,lastPos._y),n);
				//translateSprite(new Vector2D(lastPos._x - _spriteVec[n].x,lastPos._y - _spriteVec[n].y),n);
				
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
		
		private function rotateAroundPoint(image:Bitmap,angleDegree:Number):void
		{
			//var point:Point = new Point( 100, 100 ); // pivot point local to the object's coordinates

			var matrix:flash.geom.Matrix = referenceMatrix.clone();
			
			matrix.translate(-image.width / 2,image.height / 2);
			matrix.rotate(angleDegree * (Math.PI / 180));
			matrix.translate(image.width / 2,-image.height / 2);
			image.transform.matrix = matrix;
			//image.x += (image.x + image.width / 2);
			//image.y += (image.y + image.height);
			//image.transform.matrix = m;
		}
		
		public function setPos(newPos : Vector2D):void
		{
			//_pos._x = _pos._x + (_dir._x * _OFFSET);
			//_pos._y = _pos._y + (_dir._y * _OFFSET);
		}
		
		public function setDir(newDir : Vector2D):void 
		{
			_dir = newDir.normalize();
			
			//_pos._x = _pos._x + (_dir._x * _OFFSET);
			//_pos._y = _pos._y + (_dir._y * _OFFSET);
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
                }
                if (_pos._y > 1080)
                {
                    _dir._x = -_dir._x;
					_dir._y = -_dir._y;
                }
                if (_pos._x < -100)
                {
                    _dir._x = -_dir._x;
					_dir._y = -_dir._y;
                }
                if (_pos._y < -100)
                {
                    _dir._x = -_dir._x;
					_dir._y = -_dir._y;
                }
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
		
		private function rotateAroundCenter(degree:Number, spriteIndex : int):void 
		{
			var toRotate : Number = 0;
			toRotate =  -_oldRotate[spriteIndex] + degree;
			
			
				var orgMatrix : flash.geom.Matrix = _spriteVec[spriteIndex].transform.matrix;
				
				//get the rect of the obj
				var rect : Rectangle = _spriteVec[spriteIndex].getBounds(_spriteVec[spriteIndex].parent);
				
				var transX : Number = - (rect.left + (rect.width / 2));
				var transY : Number = - (rect.top + (rect.height / 2));
				
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