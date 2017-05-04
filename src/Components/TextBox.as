package Components 
{
	import com.gestureworks.cml.components.Component;
	import flash.utils.getTimer;
	
	/**
	 * A textbox that appears when you hover over a specified object
	 * and then fades out.
	 * @author Adam
	 */
	public class TextBox extends Component
	{
		public var _Description:String = "";
		public var _Title:String = "";
		private var _lifeTime:Number = 0;
		private var _timeOfBirth:Number = 0;
		private var _dead:Boolean = true;
		
		public function TextBox(lifeTime:Number = 10) 
		{
			_lifeTime = lifeTime;
			_timeOfBirth = getTimer();
			_dead = false;
			
			super();
		}
		
		override public function init():void 
		{
			super.init();
			this.alpha = 1;
		}
		
		public function Update():void
		{
			if (_dead)
			{
				return;
			}
			var age:Number = (getTimer() - _timeOfBirth) / 1000;
			// Fade out the last two seconds
			var timeLeft:Number = _lifeTime - age;
			this.scale += 0.0005;
			if (timeLeft < 2)
			{
				this.alpha = timeLeft / 2;
			}
			// Hide it
			if (age > _lifeTime) 
			{
				this.x = 13337;
				this.y = 13337;
				this.alpha = 0;
				this.active = false;
			}
		}
		
		public function Rebirth():void
		{
			_timeOfBirth = getTimer();
			_dead = false;
			this.scale = 1;
			this.alpha = 1;
			this.rotation = 0;
			this.active = true;
		}
	}

}