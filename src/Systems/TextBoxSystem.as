package Systems 
{
	import Components.TextBox;
	import com.gestureworks.cml.elements.Button;
	import com.gestureworks.cml.elements.Graphic;
	import com.gestureworks.cml.elements.Image;
	import com.gestureworks.core.GestureWorksAIR;
	import com.gestureworks.objects.DimensionObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import util.TextContent;
	import com.gestureworks.cml.utils.DisplayUtils;
	import com.gestureworks.cml.events.StateEvent;
	/**
	 * ...
	 * @author Adam
	 */
	public class TextBoxSystem extends System 
	{
		
		private var _textBoxMap:Object = new Object();
		private var _buttonMap:Object = new Object();
		
		public function TextBoxSystem()
		{
			super();
		}
		
		override public function Init():void 
		{
		}
		
		override public function Update():void 
		{
			for each (var tb:TextBox in _textBoxMap)
			{
				tb.Update();
			}
		}
		
		// This loads a specified from a .txt file on disk
		public function Load(key:String, bx:int, by:int, bw:int, bh:int):void
		{
			var button:Button = createCustomButton(key, bx, by, bw, bh);
			button.addEventListener(StateEvent.CHANGE, onClick(key));
			// Add tracking of the button by adding it to the button map
			_buttonMap[key] = button;
			addChild(button);
			
			for each (var childPath:String in getFilesInDirectoryRelative(key))
			{
				if (isDirectory(childPath))
				{
					continue;
				}
				// Assures that it is a .txt file
				if (childPath.toUpperCase().search(".txt".toUpperCase()) != -1)
				{
					var loader:URLLoader = new URLLoader(new URLRequest(childPath));
					loader.addEventListener(Event.COMPLETE, FinalizeTextBox(key));
				}
				else
				{
					throw("ERROR: Found file " + childPath + " which does not end with .txt extention. Please make sure that you have specified the correct type in button/properties.xml");
				}
			}
		}
		
		// This handler is triggered when the content for a textbox is loaded
		private function FinalizeTextBox(key:String):Function
		{
			return function(e:Event):void
			{
				var content:String = URLLoader(e.currentTarget).data;
				var index:int = content.search("\n");
				var textContent:TextContent = new TextContent(content.slice(0, index), content.slice(index + 1, content.length));
				
				var textBox:TextBox = new TextBox(textContent, _frameThickness);
				textBox.width = 400;
				textBox.nativeTransform = true;
				textBox.clusterBubbling = true;
				textBox.mouseChildren = true;
				addFrame(textBox);
				addTouchContainer(textBox);
				addChild(textBox);
				_textBoxMap[key] = textBox;
				hideComponent(textBox);
				addChild(textBox._Line);
				
				DisplayUtils.initAll(textBox);
			}
		}
		
		override public function Activate():void 
		{
			for (var key:String in _buttonMap)
			{
				_buttonMap[key].visible = true;
				_buttonMap[key].touchEnabled = true;
			}
		}
		
		override public function Deactivate():void 
		{
			for (var key:String in _buttonMap)
			{
				hideComponent(_textBoxMap[key]);
				_textBoxMap[key].Kill();
				_buttonMap[key].visible = false;
				_buttonMap[key].touchEnabled = false;
			}
		}
		
		override public function Hide():void 
		{
			for each (var tb:TextBox in _textBoxMap)
			{
				hideComponent(tb);
			}
		}
		
		// Button handler
		public function onClick(key:String):Function
		{
			return function(e:StateEvent):void
			{
				// On release
				if (e.value != "up")
					return;
				if (_textBoxMap[key] != null)
				{
					if (_textBoxMap[key].visible)
					{
						_textBoxMap[key].Kill();
						hideComponent(_textBoxMap[key]);
						
					}
					else if (!_textBoxMap[key].visible)
					{
						for each (var tb:TextBox in _textBoxMap)
						{
							if (tb.visible == true)
							{
								tb.Kill();
								hideComponent(tb);
							}
						}
						
						var bOriginX:Number = _buttonMap[key].x + _buttonMap[key].width / 2;
						var bOriginY:Number = _buttonMap[key].y + _buttonMap[key].height / 2;
						var tbWidth:Number = _textBoxMap[key].width;
						var tby:Number = _textBoxMap[key].y;
						var halfBoxHeight:Number = (_textBoxMap[key].height >> 1);
						var verticalOffset:Number = 300;
						
						// Right side of the screen
						if (bOriginX > stage.stageWidth * .5)
						{
							var rx:Number = bOriginX - verticalOffset - tbWidth;
							var ry:Number = bOriginY - halfBoxHeight;
							showComponent(rx, ry, _textBoxMap[key]);
							removeChild(_textBoxMap[key]._Line);
							var rline:Graphic = getLine(0x999999, bOriginX, bOriginY, rx + tbWidth + (_frameThickness << 1), ry + halfBoxHeight, 3, .8);
							_textBoxMap[key]._Line = rline;
							addChild(rline);
							_textBoxMap[key].Rebirth();
						}
						// Left side of the screen
						else
						{
							var lx:Number = bOriginX + verticalOffset;
							var ly:Number = bOriginY - halfBoxHeight;
							showComponent(lx, ly, _textBoxMap[key]);
							removeChild(_textBoxMap[key]._Line);
							var lline:Graphic = getLine(0x999999, bOriginX, bOriginY, lx - (_frameThickness << 1), ly + halfBoxHeight, 3, .8);
							_textBoxMap[key]._Line = lline;
							addChild(lline);
							_textBoxMap[key].Rebirth();
						}
					}
				}
			}
		}
	}
}