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
		
		private var _sprite:Sprite;
		private var _spriteHead:Sprite;
		private var _spriteVisDist:Sprite;
		private var _inPanic : Boolean;
		private var _showVisDist : Boolean;
		
		public function Boid()
		{
			_dir = new Vector2D(0, 0);
		}
		
		
		public function Init(stage:Stage, viewDist : Number, showVisDist : Boolean):void
		{
			_speed = 1;
			_inPanic = false;
			_showVisDist = showVisDist;
			
			_sprite = new Sprite();
			_sprite.graphics.clear();
			_sprite.graphics.beginFill(0xFFCC00);
			_sprite.graphics.drawCircle(0, 0, 20);
			_sprite.graphics.endFill();
			
			spawnAtRandomPoint();
			
			_dir._x = (Math.random());
			_dir._y = (Math.random());
			_dir = _dir.normalize();
			
			_spriteHead = new Sprite();
			_spriteHead.graphics.beginFill(0x000000);
			_spriteHead.graphics.drawCircle(0, 0, 10);
			_spriteHead.x = _sprite.x + (_dir._x * _OFFSET);
			_spriteHead.y = _sprite.y + (_dir._y * _OFFSET);
			_spriteHead.graphics.endFill();
			
			if (showVisDist == true)
			{
				_spriteVisDist = new Sprite();
				_spriteVisDist.graphics.clear();
				_spriteVisDist.graphics.beginFill(0x0000CC);
				_spriteVisDist.graphics.drawCircle(0, 0, viewDist);
				_spriteVisDist.graphics.endFill();
				
				stage.addChild(_spriteVisDist);
			}
			
			stage.addChild(_sprite);
			stage.addChild(_spriteHead);
		}
		
		public function Update():void
		{	
			var pos : Vector2D = this.getPos();
			
			var spawnPoint : Vector2D;
			var center : Vector2D;
			var dirToCenter : Vector2D;
			
			//if the fish escapes the sceen it will reset to a random position from above
			if (pos._x > 1920 || pos._y > 1080)
			{
				//find vector to point
				spawnPoint = new Vector2D(1920 -(Math.random() * 1000), 0);
				center = new Vector2D(1920 / 2, 1080 / 2);
				dirToCenter = spawnPoint.findVector(center);
					
				//respawn boid
				this.setPos(spawnPoint);
				this.setDir(dirToCenter);
			}
			
			if (pos._x < -10 || pos._y < -10)
			{
				spawnPoint = new Vector2D(1920 -(Math.random() * 1000), 0);
				center = new Vector2D(1920 / 2, 1080 / 2);
				dirToCenter = spawnPoint.findVector(center);
				
				this.setPos(spawnPoint);
				this.setDir(dirToCenter);
			}
			
			//temp update head and body
			this._sprite.x += (_dir._x * _speed);
			this._sprite.y += (_dir._y * _speed);
			
			this._spriteHead.x += (_dir._x * _speed);
			this._spriteHead.y += (_dir._y * _speed);
			
			if (_showVisDist == true)
			{
				_spriteVisDist.x = _sprite.x;
				_spriteVisDist.y = _sprite.y;
			}
		}
		
		public function Render():void 
		{
		}
		
		public function setPos(newPos : Vector2D):void
		{
			_sprite.x = newPos._x;
			_sprite.y = newPos._y;
			
			_spriteHead.x = _sprite.x + (_dir._x * _OFFSET);
			_spriteHead.y = _sprite.y + (_dir._y * _OFFSET);
			
			if (_showVisDist == true)
			{
				_spriteVisDist.x = _sprite.x;
				_spriteVisDist.y = _sprite.y;
			}
		}
		
		public function setDir(newDir : Vector2D):void 
		{
			_dir = newDir.normalize();
			
			_spriteHead.x = _sprite.x + (_dir._x * _OFFSET);
			_spriteHead.y = _sprite.y + (_dir._y * _OFFSET);
		}
		
		public function getSprite():Sprite
		{
			return this._sprite;
		}
		
		public function getPos(): Vector2D
		{
			var toReturn : Vector2D = new Vector2D(_sprite.x, _sprite.y);
			return toReturn;
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
			_sprite.x = (Math.random() * 1920);
		    _sprite.y = (Math.random() * 1920);
		}
		
		public function setRed() : void
		{
			_sprite.graphics.beginFill(0xFF0000);
			_sprite.graphics.drawCircle(0, 0, 20);
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