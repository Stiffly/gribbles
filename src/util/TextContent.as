package util 
{
	/**
	 * ...
	 * @author Adam
	 */
	final public class TextContent
	{
		[Embed(source="../../bin/fonts/arial.ttf",
        fontName = "EmbeddedArial",
        mimeType = "application/x-font",
        advancedAntiAliasing="true",
        embedAsCFF="false")]
		public var myEmbeddedFont:Class;
		
		public function TextContent(t:String, d:String) { title = t; description = d; };
		public var title:String;
		public var description:String;
	}

}