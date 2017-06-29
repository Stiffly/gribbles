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
	import util.LayerHandler;
	
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
		

		private var _pos : Vector2D;
		
		private var origRefMatrix:Matrix;
		
		public function BoidBody() 
		{
			
		}
		
		public function Init(stage:Stage, bitmapIn:Bitmap) : void
		{
			
			_sprite= new Sprite();
			_sprite.graphics.beginBitmapFill(bitmapIn.bitmapData, null, true, true);
			_sprite.graphics.drawRect(0, 0, bitmapIn.bitmapData.width, bitmapIn.bitmapData.height);
			_sprite.graphics.endFill();
			_sprite.scaleX = 0.5;
			_sprite.scaleY = 0.5;
			
			
			stage.addChild(_sprite);

			_oldRotation = 0;
			_spritePos = new Vector2D(0, 0);
			_spriteBounds = new Vector2D(_sprite.width, _sprite.height);
			_spriteAnchor = new Vector2D(_sprite.width/2, _sprite.height);
			
			_pos = new Vector2D(0, 0);
			
			//Move(new Vector2D(0, 700));
			origRefMatrix = _sprite.transform.matrix.clone();
			SetPos(new Vector2D(0, 0));
		
			origRefMatrix = _sprite.transform.matrix.clone();
		}
		
		public function Activate():void
		{
			_sprite.visible = true;
			LayerHandler.BRING_TO_FRONT(_sprite);
		}
		
		public function Deactivate():void
		{
			_sprite.visible = false;
		}
		
		public function Shutdown():void 
		{
			
		}
		
		public function SuperUpdateMatrix():void
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
		
	
	}
}
