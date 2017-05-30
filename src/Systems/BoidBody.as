package Systems 
{
	/**
	 * ...
	 * @author sebMax
	 */
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage
	
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class BoidBody 
	{
		[Embed(source = "../../bin/images/Carp/b1.png")]
		private var b1Class:Class;
		private var _b1BM:Bitmap = new b1Class();
		private var _spriteHead : Sprite;
		
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
		}
		
		public function Shutdown():void 
		{
			
		}
		
		public function Update(dir:Vector2D): void
		{
			RotateAroundCenter(0.01);
		}
		
		public function RotateAroundCenter(degree : Number):void 
		{
			var orgMatrix : flash.geom.Matrix = _spriteHead.transform.matrix;
 				
 			//get the rect of the obj
			var rect : Rectangle = _spriteHead.getBounds(_spriteHead.parent);
			
			//translate
			orgMatrix.translate(- (rect.left + (rect.width/2)), - (rect.top + (rect.height/2)));
			
			// Rotation (note: the parameter is in radian) 
			orgMatrix.rotate(degree); 
			
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