package Systems 
{
	/**
	 * ...
	 * @author sebMax
	 * this class is made for ease of debugging
	 * 
	 */
	import flash.display.Sprite;
	import flash.text.*;
	import flash.display.Stage;

	 
	public class TextBox extends Sprite
	{
		private var _debugTextBox : TextField;
        private var _debugText:String = "<p>This is <b>some</b> content to <i>test</i> and <i>see</i></p><p><img src='eye.jpg' width='20' height='20'></p><p>what can be rendered.</p><p>You should see an eye image and some <u>HTML</u> text.</p>"; 		
		
		public function TextBox() 
		{	
		}
		
		public function Init(stage:Stage):void 
		{
			
			_debugTextBox = new TextField();
			_debugText = "Derp"
			
			_debugTextBox.width = 200;
			_debugTextBox.height = 200;
			_debugTextBox.multiline = true;
			_debugTextBox.border = false;
			
			_debugTextBox.text = _debugText;
			_debugTextBox.textColor = 0xFFFFFF;
			
			stage.addChild(_debugTextBox);
		}
		
		public function Update():void 
		{
			_debugTextBox.text = _debugText;
		}
		
		public function SetDebugText(toPrint : Number):void 
		{
			var str : String = "Angle: ";
			str = str + toPrint;
			
			_debugText = str;
		}
		
		public function DebugAngle(angle : Number):void 
		{
			var str : String = "Radians: " + angle + "\n";
			str = str + "Degree: " + (180 / Math.PI) * angle;
			
			_debugText = str;
		}
	}

}