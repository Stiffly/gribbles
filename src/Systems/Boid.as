package Systems 
{
	import Systems.Vector2D;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import Math;
	/**
	 * ...
	 * @author Sebastian Lundgren and Max Larsson
	 */
	public class Boid
	{
		[Embed(source="../../bin/images/Carp/head.png")]
		private var headSpriteBit:Class;

		var headBitmap:Bitmap = new headSpriteBit();

		// Embed an image which will be used as a background
		private var _pos:Vector2D;
		private var _dir:Vector2D;
		private var _speed : Number;
		private var _inPanic : Boolean;
		
		private var _fishSprite:BoidBody;
		
		public function Boid()
		{
			_dir = new Vector2D(0, 0);
			_fishSprite = new BoidBody();
			_pos = new Vector2D(0, 0);
		}
		
		
		public function Init(stage:Stage, viewDist : Number, showVisDist : Boolean):void
		{
			_speed = 1;
			_inPanic = false;
			_fishSprite.Init(stage,headBitmap);
		}
		
		public function Update(mousePos : Vector2D, debugger:TextBox ):void
		{	
			var spawnPoint : Vector2D;
			var center : Vector2D;
			var dirToCenter : Vector2D;

			CalculateDir();
			
			_fishSprite.Update(mousePos, debugger);
			
		}
		
		public function CalculateDir():void 
		{
			
		}
		
		public function setPos(newPos : Vector2D):void
		{
			//translate
			//_fishSprite.SetPos(newPos);
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
		/*
		public function getSprite():Sprite
		{
		}
		*/
		public function getPos(): Vector2D
		{
			//var toReturn : Vector2D = new Vector2D(_sprite.x, _sprite.y);
			return new Vector2D(0,0);
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
			spawnPoint = new Vector2D(1920 -(Math.random() * 1000), 1080 -(Math.random() * 1000));
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
	}

}