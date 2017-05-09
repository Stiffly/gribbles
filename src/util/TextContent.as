package util
{
	import com.gestureworks.cml.elements.Container;
	import com.gestureworks.cml.elements.Graphic;
	import com.gestureworks.cml.elements.Text;
	import com.gestureworks.cml.elements.TouchContainer;
	import com.gestureworks.cml.utils.DisplayUtils;
	
	/**
	 * util.TexContent
	 *
	 * A class that contains two strings - title and description - along with a method
	 * for creating a description container.
	 *
	 * @author Adam Byléhn
	 * @contact adambylehn@hotmail.com
	 */
	
	final public class TextContent
	{
		public function TextContent(t:String, d:String)  { title = t; description = d; }
		;
		public var title:String;
		public var description:String;
		
		static public function CREATE_DESCRIPTION(content:TextContent, width:uint, height:uint, alpha:Number, padding:Number = 30, fontSize:Number = 20):TouchContainer
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
			
			var t:Text = new Text();
			t.str = content.title;
			t.fontSize = fontSize + 10;
			t.color = 0xFFFFFF;
			t.font = "Arial";
			t.autosize = true;
			t.width = width;
			c.addChild(t);
			
			var d:Text = new Text();
			d.str = content.description;
			d.fontSize = fontSize;
			d.color = 0xFFFFFF;
			d.font = "Arial";
			d.wordWrap = true;
			d.autosize = true;
			d.multiline = true;
			d.width = width;
			c.addChild(d);
			
			DisplayUtils.initAll(tc);
			
			return tc;
		}
	}
}