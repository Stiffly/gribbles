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
		[Embed(source = "../../bin/images/Carp/b1.png")]
		private var b1Class:Class;
		private var _b1BM:Bitmap = new b1Class();
		private var _spriteHead : Sprite;
		
		private var _forward : Vector2D;
		private var _oldRotation : Number;
		private var _pos : Vector2D;
		private var _anchor : Vector2D;
		
		private var _dPos : Sprite;
		private var _dAnchor : Sprite;
		
		private var _spriteWidth : Number;
		private var _spriteHeight :Number;
		
		/*
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
		*/
		public function BoidBody() 
		{
			
		}
		
		public function Init(stage:Stage) : void
		{
			_spriteHead = new Sprite();
			_spriteHead.graphics.beginBitmapFill(_b1BM.bitmapData, null, true, true);
			_spriteHead.graphics.drawRect(0, 0, _b1BM.bitmapData.width, _b1BM.bitmapData.height);
			_spriteHead.graphics.endFill();
			
			stage.addChild(_spriteHead);
			
			_dPos = new Sprite();
			_dPos.graphics.beginFill(0x0000FF);
			_dPos.graphics.drawRect(0, 0, 5, 5);
			_dPos.graphics.endFill();
			
			stage.addChild(_dPos);
			
			_dAnchor = new Sprite();
			_dAnchor.graphics.beginFill(0x00FF00);
			_dAnchor.graphics.drawRect(0, 0, 5, 5);
			_dAnchor.graphics.endFill();
			
			stage.addChild(_dAnchor);
			//ugly hack to make rotation less of a pain
			_oldRotation = 0;
			

			_forward = new Vector2D(0, 1);
			_forward = _forward.normalize();
			

			_spriteHeight = _spriteHead.height;
			_spriteWidth = _spriteHead.width;
			
			//_anchor = new Vector2D(500, 500);
			_pos =  new Vector2D(0, 0);
			
			SetPos(_pos);
			//ranslate(_pos);
			SetPos(new Vector2D(500, 500));
		}
		
		public function Shutdown():void 
		{
			
		}
		
		public function Update(dir:Vector2D, debugger:TextBox): void
		{	
			var newDir : Vector2D = new Vector2D(0, 0);
			var centerIsh : Vector2D = new Vector2D(0, 0);
			
			//draw vector between anchor and mousePos
			newDir = _anchor.findVector(dir);
			newDir = newDir.normalize();
			
			//find out angle between the vectors
			var angle : Number = 0;
			var cosAngle : Number = 0;
			cosAngle = _forward.dot(newDir);
			
			//cos(angle)
			angle = Math.acos(cosAngle);
			
			if (dir._x > _anchor._x)
			{
				angle *= -1;
			}
			
			var test :Number = (Math.PI / 180) * 1;
	
			debugger.DebugBoid(this, dir, newDir, angle, cosAngle);
			
			RotateAroundCenter(angle);
			
			updateDebugPoints();
			
			//SetPos(new Vector2D(_pos._x +1, _pos._y));
			
			//linear interpolation to this point
			
		}
		
		public function RotateAroundCenter(radian : Number):void 
		{
			var orgMatrix : flash.geom.Matrix = _spriteHead.transform.matrix;
 				
 			//get the rect of the obj
			var rect : Rectangle = _spriteHead.getBounds(_spriteHead.parent);
			
			//translate the anchor point to the middle of the image
			orgMatrix.translate(-1*_anchor._x,-1*_anchor._y);
			
			//rotate back to org pos
			orgMatrix.rotate( -1 * _oldRotation);
			
			// Rotation (note: the parameter is in radian) 
			orgMatrix.rotate(radian); 
			_oldRotation = radian;
			
			// Translating the object back to the original position.
			orgMatrix.translate(_anchor._x, _anchor._y);
			
			_spriteHead.transform.matrix = orgMatrix;
		}
		
		public function Translate(newPos:Vector2D):void 
		{
			var orgMatrix : flash.geom.Matrix = _spriteHead.transform.matrix;
			
			//translate
			orgMatrix.translate(newPos._x, newPos._y); 
			
			_spriteHead.transform.matrix = orgMatrix;
		}
		
		public function GetForward():Vector2D 
		{
			return _forward;
		}
		
		public function GetPos():Vector2D
		{
			return _pos;
		}
		
		public function SetPos(newPos : Vector2D):void 
		{
			Translate(newPos);
			_pos._x = newPos._x;
			_pos._y = newPos._y;
			
			UpdateAnchor();
		}
		
		public function Move(toPoint : Vector2D):void 
		{
			Translate(toPoint);
			_pos._x += toPoint._x;
			_pos._y += toPoint._y;
			
			UpdateAnchor();
		}
		public function GetAnchor(): Vector2D 
		{
			return _anchor;
		}
		
		private function UpdateAnchor():void 
		{
			var rect : Rectangle = _spriteHead.getBounds(_spriteHead.parent);
			
			var a : Number = 0;
			var b : Number = 0;
			
			a = rect.width;
			b = rect.height;
			
			//_anchor = new Vector2D(_pos._x + (rect.width / 2), _pos._y + (rect.height/2));
			_anchor = new Vector2D(_pos._x + _spriteWidth/2, _pos._y + _spriteHeight);
			
		}
		
		private function updateDebugPoints():void 
		{
			_dAnchor.x = _anchor._x;
			_dAnchor.y = _anchor._y;
			
			_dPos.x = _pos._x;
			_dPos.y = _pos._y;
		}
	}
}