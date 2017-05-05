package Components 
{
	import com.gestureworks.cml.components.Component;
	import com.gestureworks.cml.elements.Container;
	import com.gestureworks.cml.elements.Graphic;
	import com.gestureworks.cml.elements.Text;
	import com.gestureworks.cml.elements.TouchContainer;
	import flash.utils.getTimer;
	import com.gestureworks.cml.utils.DisplayUtils;
	import util.TextContent;
	
	
	/**
	 * A textbox that appears when you hover over a specified object
	 * and then fades out.
	 * @author Adam
	 */
	public class TextBox extends Component
	{
		private var _title:Text;
		private var _updateFrequenzy:Number = 0;
		private var _timeStamp:int = 0;
		private var _currentDescription:Text;
		private var _description:String = "";
		private var _lifeTime:Number = 0;
		private var _timeOfBirth:Number = 0;
		private var _dead:Boolean = true;
		private var _gettingText:Boolean = true;
		private var _frameWidth:uint = 0;
		
		public function TextBox(content:TextContent, frameWidth:uint, updateFrequenzy:Number = 0.1, lifeTime:Number = 10) 
		{
			_title = new Text();
			_title.text = content.title;
			_currentDescription = new Text();
			_description = content.description;
			_updateFrequenzy = updateFrequenzy;
			_lifeTime = lifeTime;
			_frameWidth = frameWidth * 2;
			_dead = true;
			
			super();
		}
		
		override public function init():void 
		{
			super.init();
			this.alpha = 1;
			
			var tc:TouchContainer = createDescription(new TextContent(_title.text, _currentDescription.text), this.width, this.height, 1, 5);
			this.addChild(tc);
		}
		
		public function Update():void
		{
			if (_dead)
			{
				return;
			}
			//this.scale += 0.0005;
			// Logic to keep the box within the screen
			if (this.x + this.width + _frameWidth > stage.stageWidth)
			{
				this.x = stage.stageWidth - this.width - _frameWidth;
			}
			if (this.x - _frameWidth < 0)
			{
				this.x = _frameWidth;
			}
			if (this.y + this.height + _frameWidth > stage.stageHeight)
			{
				this.y = stage.stageHeight - this.height - _frameWidth;
			}
			if (this.y - _frameWidth < 0)
			{
				this.y = _frameWidth;
			}
			
			if (_gettingText)
			{
				if ((getTimer() - _timeStamp) / 1000 > _updateFrequenzy)
				{
					var endIndex:int = _description.indexOf(" ", _currentDescription.text.length + " ".length);
					_currentDescription.text = _description.substring(0, endIndex);
					if (endIndex == -1) 
					{
						// All the content is displayed
						_currentDescription.text = _description;
						_timeOfBirth = getTimer();
						_gettingText = false;
					}
					else
					{
						_currentDescription.text = _description.substring(0, endIndex);
					}
					_timeStamp = getTimer();
				}
			}
			else 
			{
				var age:Number = (getTimer() - _timeOfBirth) / 1000;
				// Fade out the last two seconds
				var timeLeft:Number = _lifeTime - age;
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
					_dead = true;
				}
			}
		}
		
		public function Rebirth():void
		{
			_dead = false;
			_gettingText = true;
			this.scale = 1;
			this.alpha = 1;
			this.rotation = 0;
			this.active = true;
			_currentDescription.text = "";
		}
		
		protected function createDescription(content : TextContent, width:uint, height:uint, alpha:Number, padding:Number=30) :TouchContainer
		{
			var tc:TouchContainer = new TouchContainer();
			tc.width = width;
			tc.height = height;
			tc.alpha = alpha;
			
			var g:Graphic = new Graphic();
			g.shape = "rectangle";
			//g.color = 0x15B011;
			g.color = 0x555555;
			g.width = tc.width;
			g.height = tc.height;
			g.alpha = alpha;
			tc.addChild(g);
			
			var c:Container = new Container();
			c.paddingTop = padding;
			c.paddingLeft = padding;
			c.paddingRight = padding;
			c.width = width;
			c.height = height;
			c.relativeY = true;
			tc.addChild(c);
			
			_title.str = content.title;
			_title.fontSize = 30;
			_title.color = 0xFFFFFF;
			_title.font = "MyFont";
			_title.autosize = true;
			_title.width = width;
			c.addChild(_title);
			
			_currentDescription.str = content.description;
			_currentDescription.fontSize = 20;
			_currentDescription.color = 0xFFFFFF;
			_currentDescription.font = "MyFont";
			_currentDescription.wordWrap = true;
			_currentDescription.autosize = true;
			_currentDescription.multiline = true;
			_currentDescription.width = width;
			c.addChild(_currentDescription);
			
			DisplayUtils.initAll(tc);
			
			return tc;
		}
	}

}