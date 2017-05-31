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
        private var _debugText:String;
		
		public function TextBox() 
		{	
		}
		
		public function Init(stage:Stage):void 
		{
			
			_debugTextBox = new TextField();
			_debugText = "Derp"
			
			_debugTextBox.width = 500;
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
		
		private function DebugAngle(angle : Number, cosAngle : Number):String 
		{
			var str : String = "Radians: " + angle + "\n";
			str += "Degree: " + (180 / Math.PI) * angle + "\n";
			str += "cosAngle: " + cosAngle;
			
			
			return str;
		}
		
		public function DebugBoid(body:BoidBody, targetPoint : Vector2D, targetVec: Vector2D, angle:Number, cosAngle:Number):void 
		{
			var str : String = "";
			
			str += "Sprite Pos: : (" + body.GetPos()._x + ", " + body.GetPos()._y + ")\n";
			str += "Anchor Pos: : (" + body.GetAnchor()._x + ", " + body.GetAnchor()._y + ")\n";
			str += "Sprite Forward: (" + body.GetForward()._x + ", " + body.GetForward()._y + ")\n";
			str += "************\n";
			str += "Target Point: (" + targetPoint._x + ", " + targetPoint._y + ")\n";
			str += "Target Norm Vec: (" + targetVec._x + ", " + targetVec._y + ")\n";
			str += "************\n";
			str += DebugAngle(angle, cosAngle);
			
			_debugText = str;
		}
	}

}