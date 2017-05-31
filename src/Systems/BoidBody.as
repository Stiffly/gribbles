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
			
			//ugly hack to make rotation less of a pain
			_oldRotation = 0;
			
			_forward = new Vector2D(0, 1);
			_forward = _forward.normalize();
		}
		
		public function Shutdown():void 
		{
			
		}
		
		public function Update(dir:Vector2D, debugger:TextBox): void
		{
			var spritePos : Vector2D = new Vector2D(0, 0);
			spritePos._x = _spriteHead.x;
			spritePos._y = _spriteHead.y;
			
			var newDir : Vector2D = new Vector2D(0, 0);
			var centerIsh : Vector2D = new Vector2D(0, 0);
			
			newDir = spritePos.findVector(dir);
			
			newDir = newDir.normalize();
			
			//find out angle between the vectors
			var angle : Number = 0;
			angle = _forward.dot(newDir);
			
			//var angle2 :Number = newDir.dot(_forward);
			
			//cos(angle)
			angle = Math.acos(angle);
			angle = Math.atan2(newDir._x, -newDir._y);
			
			var test :Number = (Math.PI / 180) * -90;
			
			RotateAroundCenter(test);
			debugger.DebugAngle(test);
			
			
			
			
			//linear interpolation to this point
			
		}
		
		public function RotateAroundCenter(radian : Number):void 
		{
			var orgMatrix : flash.geom.Matrix = _spriteHead.transform.matrix;
 				
 			//get the rect of the obj
			var rect : Rectangle = _spriteHead.getBounds(_spriteHead.parent);
			
			//translate the anchor point to the middle of the image
			orgMatrix.translate(- (rect.left + (rect.width/2)), - (rect.top + (rect.height/2)));
			
			//rotate back to org pos
			orgMatrix.rotate( -1 * _oldRotation);
			
			// Rotation (note: the parameter is in radian) 
			orgMatrix.rotate(radian); 
			_oldRotation = radian;
			
			// Translating the object back to the original position.
			orgMatrix.translate(rect.left + (rect.width/2), rect.top + (rect.height/2)); 
			
			_spriteHead.transform.matrix = orgMatrix;
		}
		
		public function Translate(newPos:Vector2D):void 
		{
			var orgMatrix : flash.geom.Matrix = _spriteHead.transform.matrix;
			
			//get the rect of the obj
			var rect : Rectangle = _spriteHead.getBounds(_spriteHead.parent);
			
			//translate
			orgMatrix.translate(newPos._x, newPos._y); 
			
			_spriteHead.transform.matrix = orgMatrix;
		}
	}
}