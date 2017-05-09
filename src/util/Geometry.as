package util 
{
	import com.gestureworks.cml.elements.Graphic;
	
	/**
	 * A util class that contains static functions generating simple geometry
	 * @author Adam
	 */
	public class Geometry extends Graphic 
	{
		
		public function Geometry() 
		{
			super();
		}
		
		// Create a circle
		static public function GET_CIRCLE(color:uint, x:uint, y:uint, radius:Number, alpha:Number):Graphic
		{
			var circle:Graphic = new Graphic();
			circle.x = x;
			circle.y = y;
			circle.shape = "circle";
			circle.radius = radius;
			circle.color = color;
			circle.alpha = alpha;
			circle.lineStroke = 0;
			return circle;
		}
		
		// Creates a rectangle
		static public function GET_RECTANGLE(color:uint, x:uint, y:uint, width:uint, height:uint, alpha:Number):Graphic
		{
			var rectangle:Graphic = new Graphic;
			rectangle.x = x;
			rectangle.y = y;
			rectangle.shape = "rectangle";
			rectangle.width = width;
			rectangle.height = height;
			rectangle.alpha = alpha;
			return rectangle;
		}
		
		static public function GET_LINE(color:uint, startX:int, startY:int, goalX:int, goalY:int, lineWidth:Number, alpha:Number):Graphic
		{
			var line:Graphic = new Graphic();
			line.graphics.beginFill(color);
			line.graphics.lineStyle(lineWidth, color, alpha);
			line.graphics.moveTo(startX, startY);
			line.graphics.lineTo(goalX, goalY);
			line.graphics.endFill();
			return line;
		}
	}
}
