package Systems 
{
	import Components.Audio;
	import Components.TextBox;
	import com.gestureworks.cml.components.Component;
	import com.gestureworks.cml.elements.Button;
	import com.gestureworks.cml.elements.Graphic;
	import com.gestureworks.cml.elements.Image;
	import com.gestureworks.core.GestureWorksAIR;
	import com.gestureworks.objects.DimensionObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import ui.ViewerMenu;
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
		//private var _buttonMap:Object = new Object();
		
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
		public function Load(key:String):void
		{			
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
				var vm:ViewerMenu = addViewerMenu(textBox, true, false, false, false);
				addChild(textBox);
				_textBoxMap[key] = textBox;
				hideComponent(textBox);
				addChild(textBox._Line);
				
				DisplayUtils.initAll(textBox);
				
				textBox.setChildIndex(vm, textBox.numChildren - 1);
			}
		}
		
		override public function Activate():void 
		{
			/*for (var key:String in _buttonMap)
			{
				_buttonMap[key].visible = true;
				_buttonMap[key].touchEnabled = true;
			}*/
		}
		
		override public function Deactivate():void 
		{
			for (var key:String in _textBoxMap)
			{
				hideComponent(_textBoxMap[key]);
				_textBoxMap[key].Kill();
				//_buttonMap[key].visible = false;
				//_buttonMap[key].touchEnabled = false;
			}
		}
		
		override public function Hide():void 
		{
			for each (var tb:TextBox in _textBoxMap)
			{
				hideComponent(tb);
			}
		}
		
		public function GetViewer(key:String):Component
		{
			if (_textBoxMap[key] != null)
			{
				return _textBoxMap[key];
			}
			return null;
		}
		
		public function GetMap():Object
		{
			return _textBoxMap;
		}
		
		// Button handler
		public function onClick(key:String):Function
		{
			return function(e:StateEvent):void
			{
				// On release
				if (e.value != "up")
					return;
				
			}
		}
	}
}