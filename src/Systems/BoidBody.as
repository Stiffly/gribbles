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
		private var _sprite :Sprite;
		private var _spritePos : Vector2D;
		private var _spriteBounds :Vector2D;
		private var _spriteAnchor : Vector2D;
		private var _oldRotation : Number;
	
		private var _rotationRadians : Number;
		
		private var _spriteWidth : Number;
		private var _spriteHeight :Number;
		
		private var _forward : Vector2D;

		private var _pos : Vector2D;
		//private var _dPos : Sprite;
		//private var _dAnchor : Sprite;
		
		private var _dPos : Sprite;
		private var _dAnchor :Sprite;
		
		private var origRefMatrix:Matrix;
		
		public function BoidBody() 
		{
			
		}
		
		public function Init(stage:Stage, bitmapIn:Bitmap) : void
		{
			_dPos = new Sprite();
			_dAnchor = new Sprite();
			
			
			_sprite= new Sprite();
			_sprite.graphics.beginBitmapFill(bitmapIn.bitmapData, null, true, true);
			_sprite.graphics.drawRect(0, 0, bitmapIn.bitmapData.width, bitmapIn.bitmapData.height);
			_sprite.graphics.endFill();
			
			stage.addChild(_sprite);
			
			_rotationRadians = 0;

			_dPos = new Sprite();
			_dPos.graphics.beginFill(0x0000FF);
			_dPos.graphics.drawRect(0, 0, 5, 5);
			stage.addChild(_dPos);
				
			_dAnchor = new Sprite();
			_dAnchor.graphics.beginFill(0x00FF00);
			_dAnchor.graphics.drawRect(0, 0, 5, 5);
			_dAnchor.graphics.endFill();
				
			stage.addChild(_dAnchor);
			//ugly hack to make rotation less of a pain

			//_spritePos = new Vector2D();
			//_oldRotation = new Number();
			//_spriteBounds = new Vector2D();
			//_spriteAnchor = new Vector2D();
			

			_oldRotation = 0;
			_spritePos = new Vector2D(0, 0);
			_spriteBounds = new Vector2D(_sprite.width, _sprite.height);
			_spriteAnchor = new Vector2D(_sprite.width/2, _sprite.height);
			
			_pos = new Vector2D(0, 0);
			
			_forward = new Vector2D(0, 1);
			_forward = _forward.normalize();
			
			//Move(new Vector2D(0, 700));
			origRefMatrix = _sprite.transform.matrix.clone();
			SetPos(new Vector2D(0, 0));
		
			origRefMatrix = _sprite.transform.matrix.clone();
		}
		
		public function Shutdown():void 
		{
			
		}
		
		public function Update(dir:Vector2D, debugger:TextBox): void
		{	
			var newDir : Vector2D = new Vector2D(0, 0);
			var centerIsh : Vector2D = new Vector2D(0, 0);
			
			//SetPos(new Vector2D(200, 0));
			
			
			//draw vector between anchor and mousePos
			newDir = _spriteAnchor.findVector(dir);
			newDir = newDir.normalize();
			
			//find out angle between the vectors
			var angle : Number = 0;
			var cosAngle : Number = 0;
			cosAngle = _forward.dot(newDir);
			
			//cos(angle)
			angle = Math.acos(cosAngle);
			
			if (dir._x > _spriteAnchor._x)
			{
				angle *= -1.0;
			}
	
			debugger.DebugBoid(this, dir, newDir, angle, cosAngle);
			//updateDebugPoints();
			
		}
		public function SuperUpdateMatrix()
		{
			var radian:Number = _rotationRadians;
			var orgMatrix : flash.geom.Matrix = origRefMatrix.clone();
 			
			
 			//get the rect of the obj
			var rect : Rectangle = _sprite.getBounds(_sprite.parent);
			
			//translate the anchor point to the middle of the image
			orgMatrix.translate(-1.0*_spriteAnchor._x,-1.0*_spriteAnchor._y);
			
			//rotate back to org pos
			//orgMatrix.rotate( -1.0 * _oldRotation);
			
			// Rotation (note: the parameter is in radian) 
			orgMatrix.rotate(radian); 
			_oldRotation = radian;
			
			// Translating the object back to the original position.
			orgMatrix.translate(_spriteAnchor._x, _spriteAnchor._y);
			
			
			orgMatrix.translate(_spritePos._x - _spriteAnchor._x, _spritePos._y- _spriteAnchor._y);
			
			_sprite.transform.matrix = orgMatrix;
		}
		public function GetForward():Vector2D 
		{
			return _forward;
		}
		
		public function GetPos():Vector2D
		{
			return _spritePos;
		}
		
		public function Move(newPos : Vector2D):void 
		{
			//for every iteration add to new pos
			var bodyPos : Vector2D = new Vector2D(_spritePos._x, _spritePos._y);
			bodyPos._x += newPos._x ;// - _spriteBounds._x / 2;
			bodyPos._y += newPos._y;// - _spriteBounds._y;
			
			
			
			//Translate(bodyPos);
			
			_spritePos._x = bodyPos._x;
			_spritePos._y = bodyPos._y;
			
			
			
			//update anchor, to the nose of the sprite
			//_spriteAnchor = new Vector2D(bodyPos._x - (_spriteBounds._x/2) , bodyPos._y- (_spriteBounds._x/2));
			
		
		}
		
		public function SetPos(newPos : Vector2D):void 
		{
			var toMove : Vector2D = new Vector2D(0, 0);
			var tempPos :Vector2D = new Vector2D(0, 0);
			
			//newPos._x -= _spriteBounds._x/2;
			//newPos._y -= _spriteBounds._y;
			
			tempPos = GetPos();
			toMove = tempPos.findVector(newPos);
			
			Move(toMove);
		}
		
		public function SetRoation(inRot:Number):void
		{
			_rotationRadians = inRot;
		}
		
		public function GetAnchor(): Vector2D 
		{
			return _spriteAnchor;
		}
		
		public function updateDebugPoints():void 
		{
			var i : Number;
			
			
			_dAnchor.x = _spriteAnchor._x;
			_dAnchor.y = _spriteAnchor._y;
			
			_dPos.x = _spritePos._x;
			_dPos.y = _spritePos._y;
		}
	}
}
