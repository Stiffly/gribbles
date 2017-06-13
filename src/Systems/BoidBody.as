package Systems 
{
	/**
	 * ...
	 * @author sebMax
	 */
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class BoidBody 
	{
		private var _spriteArr : Vector.<Sprite>;
		private var _spritePos : Vector.<Vector2D>;
		private var _spriteBounds : Vector.<Vector2D>;
		private var _spriteAnchor : Vector.<Vector2D>;
		private var _oldRotation : Vector.<Number>;
		
		private const NR_OF_SPRITES : Number = 1;
		
		
		[Embed(source = "../../bin/images/Carp/b1.png")]
		private var b1Class:Class;
		private var _b1BM:Bitmap = new b1Class();
		//private var _spriteHead : Sprite;
		private var _spriteWidth : Number;
		private var _spriteHeight :Number;
		
		private var _forward : Vector2D;

		private var _pos : Vector2D;
		//private var _dPos : Sprite;
		//private var _dAnchor : Sprite;
		
		private var _dPos : Vector.<Sprite>;
		private var _dAnchor : Vector.<Sprite>;
		
		
		[Embed(source = "../../bin/images/Carp/b2.png")]
		private var b2Class:Class;
		private var _b2BM:Bitmap = new b2Class();
		//private var _spriteB2BM : Sprite;
		private var _spriteB2BMWidth : Number;
		private var _spriteB2BMHeight :Number;
		
		[Embed(source = "../../bin/images/Carp/b3.png")]
		private var b3Class:Class;
		private var _b3BM:Bitmap = new b3Class();
		
		[Embed(source = "../../bin/images/Carp/b4.png")]
		private var b4Class:Class;
		private var _b4BM:Bitmap = new b4Class();
		
		[Embed(source = "../../bin/images/Carp/head.png")]
		private var headClass:Class;
		private var _headBM:Bitmap = new headClass();
		
		[Embed(source = "../../bin/images/Carp/tail.png")]
		private var tailClass:Class;
		private var _tailBM:Bitmap = new tailClass();
		
		public function BoidBody() 
		{
			
		}
		
		public function Init(stage:Stage) : void
		{
			_spriteArr = new Vector.<Sprite>(NR_OF_SPRITES);
			_dPos = new Vector.<Sprite>(NR_OF_SPRITES);
			_dAnchor = new Vector.<Sprite>(NR_OF_SPRITES);
			
			
			_spriteArr[0] = new Sprite();
			_spriteArr[0].graphics.beginBitmapFill(_b1BM.bitmapData, null, true, true);
			_spriteArr[0].graphics.drawRect(0, 0, _b1BM.bitmapData.width, _b1BM.bitmapData.height);
			_spriteArr[0].graphics.endFill();
			
			stage.addChild(_spriteArr[0]);
			
			_spriteArr[1] = new Sprite();
			_spriteArr[1].graphics.beginBitmapFill(_b2BM.bitmapData, null, true, true);
			_spriteArr[1].graphics.drawRect(0, 0, _b2BM.bitmapData.width, _b2BM.bitmapData.height);
			_spriteArr[1].graphics.endFill();
			
			//stage.addChild(_spriteArr[1]);
			
			
			_spriteArr[2] = new Sprite();
			_spriteArr[2].graphics.beginBitmapFill(_b3BM.bitmapData, null, true, true);
			_spriteArr[2].graphics.drawRect(0, 0, _b3BM.bitmapData.width, _b3BM.bitmapData.height);
			_spriteArr[2].graphics.endFill();
			
			//stage.addChild(_spriteArr[2]);
			
			_spriteArr[3] = new Sprite();
			_spriteArr[3].graphics.beginBitmapFill(_b4BM.bitmapData, null, true, true);
			_spriteArr[3].graphics.drawRect(0, 0, _b4BM.bitmapData.width, _b4BM.bitmapData.height);
			_spriteArr[3].graphics.endFill();
			
			//stage.addChild(_spriteArr[3]);
			
			_spriteArr[4] = new Sprite();
			_spriteArr[4].graphics.beginBitmapFill(_tailBM.bitmapData, null, true, true);
			_spriteArr[4].graphics.drawRect(0, 0, _tailBM.bitmapData.width, _tailBM.bitmapData.height);
			_spriteArr[4].graphics.endFill();
			
			//stage.addChild(_spriteArr[4]);
			
			
			var i : Number;
			for (i = 0; i < NR_OF_SPRITES; i++ )
			{
				_dPos[i] = new Sprite();
				_dPos[i].graphics.beginFill(0x0000FF);
				_dPos[i].graphics.drawRect(0, 0, 5, 5);
				_dPos[i].graphics.endFill();
				
				stage.addChild(_dPos[i]);
				
				_dAnchor[i] = new Sprite();
				_dAnchor[i].graphics.beginFill(0x00FF00);
				_dAnchor[i].graphics.drawRect(0, 0, 5, 5);
				_dAnchor[i].graphics.endFill();
				
				stage.addChild(_dAnchor[i]);
			}
			//ugly hack to make rotation less of a pain

			_spritePos = new Vector.<Vector2D>(NR_OF_SPRITES);
			_oldRotation = new Vector.<Number>(NR_OF_SPRITES);
			_spriteBounds = new Vector.<Vector2D>(NR_OF_SPRITES);
			_spriteAnchor = new Vector.<Vector2D>(NR_OF_SPRITES);
			
			for (i = 0; i < NR_OF_SPRITES; i++ )
			{
				_oldRotation[i] = 0;
				_spritePos[i] = new Vector2D(0, 0);
				_spriteBounds[i] = new Vector2D(_spriteArr[i].width, _spriteArr[i].height);
				_spriteAnchor[i] = new Vector2D(0, 0);
			}
			_pos = new Vector2D(0, 0);
			
			_forward = new Vector2D(0, 1);
			_forward = _forward.normalize();
			
			//Move(new Vector2D(0, 700));
			SetPos(new Vector2D(0,700));
		}
		
		public function Shutdown():void 
		{
			
		}
		
		public function Update(dir:Vector2D, debugger:TextBox): void
		{	
			var newDir : Vector2D = new Vector2D(0, 0);
			var centerIsh : Vector2D = new Vector2D(0, 0);
			
			//SetPos(new Vector2D(0, 200));
			
			
			//draw vector between anchor and mousePos
			newDir = _spriteAnchor[0].findVector(dir);
			newDir = newDir.normalize();
			
			//find out angle between the vectors
			var angle : Number = 0;
			var cosAngle : Number = 0;
			cosAngle = _forward.dot(newDir);
			
			//cos(angle)
			angle = Math.acos(cosAngle);
			
			if (dir._x > _spriteAnchor[0]._x)
			{
				angle *= -1;
			}
	
			debugger.DebugBoid(this, dir, newDir, angle, cosAngle);
			
			var i : Number;
			for (i = 0; i < NR_OF_SPRITES; i++ )
			{
				//Translate(i, new Vector2D(1.5, 0));
				SetPos(new Vector2D(0,1));
				RotateAroundCenter(i, angle);
			}
			
			updateDebugPoints();
			//Move(new Vector2D(0, 1));
			
			
			//linear interpolation to this point
			
		}
		
		public function RotateAroundCenter(index : Number ,radian : Number):void 
		{
			var orgMatrix : flash.geom.Matrix = _spriteArr[index].transform.matrix;
 				
 			//get the rect of the obj
			var rect : Rectangle = _spriteArr[index].getBounds(_spriteArr[index].parent);
			
			//translate the anchor point to the middle of the image
			orgMatrix.translate(-1*_spriteAnchor[index]._x,-1*_spriteAnchor[index]._y);
			
			//rotate back to org pos
			orgMatrix.rotate( -1 * _oldRotation[index]);
			
			// Rotation (note: the parameter is in radian) 
			orgMatrix.rotate(radian); 
			_oldRotation[index] = radian;
			
			// Translating the object back to the original position.
			orgMatrix.translate(_spriteAnchor[index]._x, _spriteAnchor[index]._y);
			
			_spriteArr[index].transform.matrix = orgMatrix;
		}
		
		private function Translate(index : Number ,newPos:Vector2D):void 
		{
			var orgMatrix : flash.geom.Matrix = _spriteArr[index].transform.matrix;
			
			//translate
			orgMatrix.translate(newPos._x, newPos._y);
			
			//move anchor
			_spriteAnchor[index] = new Vector2D(_spritePos[index]._x + _spriteBounds[index]._x/2, _spritePos[index]._y + _spriteBounds[index]._y);
			
			
			_spriteArr[index].transform.matrix = orgMatrix;
		}
		
		public function GetForward():Vector2D 
		{
			return _forward;
		}
		
		public function GetPos():Vector2D
		{
			return _pos;
		}
		
		public function Move(newPos : Vector2D):void 
		{
			var i : Number;
			
			for (i = 0; i < NR_OF_SPRITES; i++)
			{
				//for every iteration add to new pos
				var bodyPos : Vector2D = new Vector2D(_spritePos[i]._x, _spritePos[i]._y);
				bodyPos._x += newPos._x;
				bodyPos._y += newPos._y;
				
				bodyPos._x += 400 * i;
				
				Translate(i, newPos);
				_spritePos[i]._x = bodyPos._x;
				_spritePos[i]._y = bodyPos._y;
				
				//update anchor, to the nose of the sprite
				_spriteAnchor[i] = new Vector2D(_spritePos[i]._x + _spriteBounds[i]._x/2, _spritePos[i]._y + _spriteBounds[i]._y);
			}
			
			_pos._x = newPos._x;
			_pos._y = newPos._y;			
		}
		
		public function SetPos(newPos : Vector2D):void 
		{
			var toMove : Vector2D = new Vector2D(0, 0);
			var tempPos :Vector2D = new Vector2D(0, 0);
			
			tempPos = GetPos();
			toMove = tempPos.findVector(newPos);
			
			Move(toMove);
		}
		
		public function GetAnchor(): Vector2D 
		{
			return _spriteAnchor[0];
		}
		
		private function updateDebugPoints():void 
		{
			var i : Number;
			
			for (i = 0; i < NR_OF_SPRITES; i++)
			{
				_dAnchor[i].x = _spriteAnchor[i]._x;
				_dAnchor[i].y = _spriteAnchor[i]._y;
			
				_dPos[i].x = _spritePos[i]._x;
				_dPos[i].y = _spritePos[i]._y;
			}
		}
	}
}