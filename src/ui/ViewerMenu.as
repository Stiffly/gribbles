package ui
{
	import com.gestureworks.cml.elements.Button;
	import com.gestureworks.cml.elements.Menu;
	import com.gestureworks.cml.utils.DisplayUtils;
	import com.gestureworks.cml.events.StateEvent;
	import Events.MenuEvent;
	
	public class ViewerMenu extends Menu
	{			
		[Embed(source="../../lib/openexhibits_assets.swf",symbol="org.openexhibits.assets.Info")]
		private var infoBtn:Class;
		
		[Embed(source="../../lib/openexhibits_assets.swf",symbol="org.openexhibits.assets.Play")]
		private var playBtn:Class;
		
		[Embed(source="../../lib/openexhibits_assets.swf",symbol="org.openexhibits.assets.Pause")]
		private var pauseBtn:Class;
		
		[Embed(source="../../lib/openexhibits_assets.swf",symbol="org.openexhibits.assets.Close")]
		private var closeBtn:Class;
		
		public var btnColor:uint;
		public var btnLineStroke:Number;
		public var btnLineColor:uint;
				
		public function ViewerMenu(info:Boolean=true, close:Boolean=true, play:Boolean=false, pause:Boolean=false) {
			alpha = 0.6;
			position = "top";
			paddingLeft = 30;
			paddingBottom = 50;
			paddingRight = 20;
			autohide = true;
			visible = false;
			
			if (info)
			{
				addChild(new MenuButton("info", 15, 8, infoBtn));
			}
			if (play)			
				addChild(new MenuButton( "play", 15, 8, playBtn));		
			if(pause)
				addChild(new MenuButton("pause", 14.5, 8.5, pauseBtn));
			if (close)
			{
				var mbc:MenuButton = new MenuButton("close", 11, 11, closeBtn); 
				mbc.addEventListener(StateEvent.CHANGE, Onclose);
				addChild(mbc);
			}
		}
		
		override public function init():void {								
			
			for each(var btn:MenuButton in DisplayUtils.getAllChildrenByType(this, MenuButton)) {
				btn.color = btnColor;
				btn.lineStroke = btnLineStroke;
				btn.lineColor = btnLineColor;
			}
			
			super.init();
		}		
		
		private function Onclose(e:StateEvent):void
		{
			if (e.value == "close")
			{
				// Do not close the component, merely hide it
				e.stopPropagation();
				stage.dispatchEvent(new MenuEvent(MenuEvent.CLOSE, e.target.parent.parent));
			}
		}
	}
}