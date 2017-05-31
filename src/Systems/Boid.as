package Systems 
{
	import Systems.Vector2D;
	import flash.display.Sprite;
	import flash.display.Stage;
	import Math;
	/**
	 * ...
	 * @author Sebastian Lundgren and Max Larsson
	 */
	public class Boid
	{
		private var _OFFSET : uint = 20;
		// Embed an image which will be used as a background
		private var _dir:Vector2D;
		private var _speed : Number;
		private var _inPanic : Boolean;
		
		private var _fishSprite:BoidBody;
		
		public function Boid()
		{
			_dir = new Vector2D(0, 0);
			_fishSprite = new BoidBody();
		}
		
		
		public function Init(stage:Stage, viewDist : Number, showVisDist : Boolean):void
		{
			_speed = 1;
			_inPanic = false;
			_fishSprite.Init(stage);
		}
		
		public function Update(mousePos : Vector2D, debugger:TextBox ):void
		{	
			var pos : Vector2D = this.getPos();
			
			var spawnPoint : Vector2D;
			var center : Vector2D;
			var dirToCenter : Vector2D;
			
			//if the fish escapes the sceen it will reset to a random position from above
			/*
			if (pos._x > 1920 || pos._y > 1080)
			{
				//find vector to point
				spawnPoint = new Vector2D(1920 -(Math.random() * 1000), 0);
				center = new Vector2D(1920 / 2, 1080 / 2);
				dirToCenter = spawnPoint.findVector(center);
				dirToCenter = dirToCenter.normalize();
					
				//respawn boid
				this.setPos(spawnPoint);
				this.setDir(dirToCenter);
			}
			
			if (pos._x < -10 || pos._y < -10)
			{
				spawnPoint = new Vector2D(1920 -(Math.random() * 1000), 0);
				center = new Vector2D(1920 / 2, 1080 / 2);
				dirToCenter = spawnPoint.findVector(center);
				dirToCenter = dirToCenter.normalize();
				
				this.setPos(spawnPoint);
				this.setDir(dirToCenter);
			}
			*/
			_fishSprite.Update(mousePos, debugger);
		}
		
		public function Render():void 
		{
		}
		
		public function setPos(newPos : Vector2D):void
		{
			//translate
			_fishSprite.Translate(newPos);
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