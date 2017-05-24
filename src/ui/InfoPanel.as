package ui
{
	import com.gestureworks.cml.elements.Container;
	import com.gestureworks.cml.elements.Graphic;
	import com.gestureworks.cml.elements.Text;
	import flash.text.AntiAliasType;
	import util.TextContent;
	
	public class InfoPanel extends Container
	{
		public var bkg:Graphic;
		public var bkgColor:uint = 0x665533;
		public var bkgAlpha:Number = 0.8;
		
		public var title:String;
		public var tFontColor:uint = 0xFFFFFF;
		
		public var descr:String;
		public var descrHTML:String;
		public var dFontColor:uint = 0xFFFFFF;
		
		static public function set TextAllign(val:String):void  { _textAlign = val; }
		static protected var _textAlign:String = "";
		
		static public function set FontSize(val:int):void  { _fontSize = val; }
		static protected var _fontSize:int = 0;
		
		public function InfoPanel()
		{
			visible = false;
			targetParent = true;
		}
		
		override public function init():void
		{
			setupUI();
			super.init();
		}
		
		private function setupUI():void
		{
			addBkg();
			addInfo();
		}
		
		private function addBkg():void
		{
			bkg = new Graphic();
			bkg.color = bkgColor;
			bkg.alpha = bkgAlpha;
			bkg.shape = "rectangle";
			bkg.widthPercent = 100;
			bkg.heightPercent = 100;
			addChild(bkg);
		}
		
		private function addInfo():void
		{
			var info:Container = new Container();
			info.paddingTop = 30;
			info.paddingLeft = 30;
			info.paddingRight = 30;
			info.widthPercent = 100;
			info.heightPercent = 100;
			info.relativeY = true;
			addChild(info);
			
			if (title)
			{
				var t:Text = new Text();
				t.antiAliasType = AntiAliasType.NORMAL;
				t.str = title;
				t.fontSize = _fontSize + 10;
				t.color = tFontColor;
				t.font = "Arial";
				t.autosize = true;
				t.textAlign = _textAlign;
				t.widthPercent = 100;
				info.addChild(t);
			}
			
			if (descr || descrHTML)
			{
				var d:Text = new Text();
				d.fontSize = _fontSize;
				d.antiAliasType = AntiAliasType.NORMAL;
				d.wordWrap = true;
				d.color = dFontColor;
				d.widthPercent = 100;
				d.font = "Arial";
				d.autosize = true;
				d.textAlign = _textAlign;
				d.multiline = true;
				if (descr)
				{
					d.str = descr;
				}
				else
				{
					d.htmlText = descrHTML;
				}
				info.addChild(d);
			}
		}
	
	}

}