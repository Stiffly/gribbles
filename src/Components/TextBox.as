package Components
{
	import flash.text.TextFormat;
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
	 *
	 * @author Adam Byléhn
	 * @contact adambylehn@hotmail.com
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
		private var _lifeTime:Number = .0;
		// Checks time when the textbox is considered born (which is when all text is loaded)
		private var _timeOfBirth:int = 0;
		// Keeps track of wether to update the textbox or not
		private var _dead:Boolean = true;
		// This is true while the texbox is working on presenting the final description
		private var _gettingText:Boolean = true;
		// Used to keep the textboxes inside the stage screen
		private var _frameWidth:uint = 0;
		// Decides if the text will allign to the center, left or right
		private var _allign:String = "";
		private var _fontSize:int = 0;
		public var _Line:Graphic = new Graphic();
		private var _bgAlpha:Number;
		
		public function TextBox(content:TextContent, frameWidth:uint, updateFrequenzy:Number = .2, lifeTime:Number = 10, textAllign:String = "left", fontSize:int = 16, bgAlpha:Number = 1)
		{
			_fontSize = fontSize;
			_bgAlpha = bgAlpha;
			_title = new Text();
			_allign = textAllign;
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
			// Initiates the textbox, with font, size etc.
			var padding:Number = 5;
			var textHeight:Number = 4 * padding + getTextHeightInPixels(_title.text, padding, 30) + getTextHeightInPixels(_description, padding, 16) + 20;
			this.height = textHeight;
			var tc:TouchContainer = createDescription(new TextContent(_title.text, _currentDescription.text), this.width, this.height, .8, padding);
			this.addChild(tc);
			
			super.init();
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
				if (timeLeft < 2.0)
				{
					this.alpha = timeLeft / 2;
					this._Line.alpha = timeLeft / 2;
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
			this.scale = 1.0;
			this.alpha = 1.0;
			this.rotation = .0;
			this.active = true;
			_currentDescription.text = "";
		}
		
		// This function gets the height of the text in pixels by creating a temporary TextField variable
		// that can calculate this.
		private function getTextHeightInPixels(text:String, padding:Number, fontSize:int):Number
		{
			var tf:TextField = new TextField();
			tf.x += (padding << 1);
			tf.width = 400 - 2 * padding;
			tf.text = text;
			var myFormat:TextFormat = new TextFormat("Arial", fontSize);
			myFormat.align = "center";
			tf.setTextFormat(myFormat);
			tf.autoSize = TextFieldAutoSize.CENTER;
			tf.wordWrap = true;
			tf.multiline = true;
			return tf.textHeight;
		}
		
		public function Kill():void
		{
			_dead = true;
			_Line.visible = false;
		}
		
		// This is used to create the actual text content
		private function createDescription(content:TextContent, width:uint, height:uint, alpha:Number, padding:Number = 30):TouchContainer
		{
			var tc:TouchContainer = new TouchContainer();
			tc.width = width;
			tc.height = height;
			//tc.alpha = alpha;
			
			var g:Graphic = new Graphic();
			g.shape = "rectangle";
			g.color = 0x000000;
			g.width = tc.width;
			g.height = tc.height;
			g.alpha = alpha * _bgAlpha;
			tc.addChild(g);
			
			var c:Container = new Container();
			c.paddingTop = padding;
			c.paddingLeft = padding;
			c.paddingRight = padding;
			c.width = width;
			c.height = height;
			c.relativeY = true;
			tc.addChild(c);
			
			var t:Text = new Text();
			t.text = content.title;
			t.fontSize = _fontSize + 10;
			t.color = 0xFFFFFF;
			t.font = "Arial";
			t.autosize = true;
			t.autosize = true;
			t.multiline = true;
			t.width = c.width;
			t.wordWrap = true;
			t.textAlign = _allign;
			c.addChild(t);
			
			_currentDescription.str = content.description;
			_currentDescription.fontSize = _fontSize;
			_currentDescription.color = 0xFFFFFF;
			_currentDescription.font = "Arial";
			_currentDescription.wordWrap = true;
			_currentDescription.autosize = true;
			_currentDescription.multiline = true;
			_currentDescription.width = c.width;
			_currentDescription.textAlign = _allign;
			c.addChild(_currentDescription);
			
			DisplayUtils.initAll(tc);
			
			return tc;
		}
	}
}