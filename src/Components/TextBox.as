package Components
{
	import flash.utils.getTimer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import com.gestureworks.cml.components.Component;
	import com.gestureworks.cml.elements.Container;
	import com.gestureworks.cml.elements.Graphic;
	import com.gestureworks.cml.elements.Text;
	import com.gestureworks.cml.elements.TouchContainer;
	import com.gestureworks.cml.utils.DisplayUtils;
	import flash.events.Event;
	
	import util.TextContent;
	
	/**
	 * Components.TextBox
	 * 
	 * A textbox that appears when you hover over a specified object
	 * and then fades out. The TextBox extends Component.
	 * @author Adam
	 */
	public class TextBox extends Component
	{
		// The title of the content, the title is present from the start
		private var _title:Text;
		// The update frequenzy determines when it is time to add another word to the final text
		private var _updateFrequenzy:Number = 0;
		// The timestamp is used to calculate when a word was latest added to the final text
		private var _timestamp:int = 0;
		// The current description is the text that is present
		private var _currentDescription:Text;
		// This is the goal descriptions that will be shown when all the text has loaded
		private var _description:String = "";
		// How long the textbox will be visible. (the total time = _lifeTime + time it takes to show all text)
		private var _lifeTime:Number = 0;
		// Checks time when the textbox is considered born (which is when all text is loaded)
		private var _timeOfBirth:int = 0;
		// Keeps track of wether to update the textbox or not
		private var _dead:Boolean = true;
		// This is true while the texbox is working on presenting the final description
		private var _gettingText:Boolean = true;
		// Used to keep the textboxes inside the stage screen
		private var _frameWidth:uint = 0;
		
		public function TextBox(content:TextContent, frameWidth:uint, updateFrequenzy:Number = 0.2, lifeTime:Number = 10)
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
			
			// Initiated the textbox, with font, size etc.
			// 50 char per line
			
			var tf:TextField = new TextField();
			tf.height = 400;
			tf.width = 400;
			tf.text = _description;
			
			var tc:TouchContainer = createDescription(new TextContent(_title.text, _currentDescription.text), this.width , tf.textHeight * 20 , 1, 5);
			this.addChild(tc);
		}
		
		public function Update():void
		{
			// Do not update dead textbox
			if (_dead)
			{
				return;
			}
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
			// The texbox is working on getting the final text
			if (_gettingText)
			{
				// Update words only each _updateFrequenzy seconds
				if ((getTimer() - _timestamp) / 1000 > _updateFrequenzy)
				{
					var wordSeparator:String = " ";
					// Start index equals length of current text plus separator length
					var startIndex:int = _currentDescription.text.length;
					// Find the index of the next word using the current description length as index. Words must be separated by " "
					var endIndex:int = _description.indexOf(wordSeparator, startIndex + wordSeparator.length);
					// There were no more separators to be found
					if (endIndex == -1)
					{
						// Add the last content.
						_currentDescription.text += _description.substring(startIndex, _description.length);
						// All the content is displayed
						_timeOfBirth = getTimer();
						_gettingText = false;
					}
					else
					{
						// Find and add the new word to the current description
						_currentDescription.text += _description.substring(startIndex, endIndex);
					}
					_timestamp = getTimer();
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
		
		// The texbox is considered reborn, reset everything
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
		
		// This is used to create the actual text content
		protected function createDescription(content:TextContent, width:uint, height:uint, alpha:Number, padding:Number = 30):TouchContainer
		{
			var tc:TouchContainer = new TouchContainer();
			tc.width = width;
			tc.height = height;
			tc.alpha = alpha;
			
			var g:Graphic = new Graphic();
			g.shape = "rectangle";
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
			
			var t:Text  = new Text();
			t.text = content.title;
			t.fontSize = 30;
			t.color = 0xFFFFFF;
			t.font = "MyFont";
			t.autosize = true;
			t.width = width;
			c.addChild(t);
			
			_currentDescription.str = content.description;
			_currentDescription.fontSize = 20;
			_currentDescription.color = 0xFFFFFF;
			_currentDescription.font = "MyFont";
			_currentDescription.wordWrap = true;
			_currentDescription.autosize = true;
			_currentDescription.multiline = true;
			_currentDescription.width = width;
			_currentDescription.autoSize = TextFieldAutoSize.LEFT;
			c.addChild(_currentDescription);
			
			DisplayUtils.initAll(tc);
			
			return tc;
		}
	}
}