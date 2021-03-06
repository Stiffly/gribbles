package Components 
{
	import com.gestureworks.cml.components.Component;
	import com.gestureworks.cml.components.MP3Player;
	import com.gestureworks.cml.components.WAVPlayer;
	import com.gestureworks.cml.elements.Image;
	import com.gestureworks.cml.elements.MP3;
	import com.gestureworks.cml.elements.WAV;
	import util.FileSystem;
	
	/**
	 * Components.Audio
	 * 
	 * A class used to treat audiofiles as one
	 * 
	 * @author Adam Byléhn
	 * @contact adambylehn@hotmail.com
	 */
	
	public class Audio extends Component 
	{
		private var _type:String = "";
		public var _mp3Viewer:MP3Player;
		public var _wavViewer:WAVPlayer;
		private var _frameWidth:Number = 0;
		public function Audio(type:String, width:int, height:int, frameWidth:Number = 15) 
		{
			super();
			_type = type;
			_frameWidth = frameWidth * 2;
			this.width = width;
			this.height = height;
			if (_type.toUpperCase() == "MP3")
			{
				_mp3Viewer = new MP3Player();
				_mp3Viewer.width = this.width;
				_mp3Viewer.height = this.height;
				_mp3Viewer.clusterBubbling = true;
				_mp3Viewer.mouseChildren = true;
				_mp3Viewer.gestureList = {"n-drag": true, "n-scale": true, "n-rotate": true};
				addChild(_mp3Viewer);
			} 
			else if (_type.toUpperCase() == "WAV")
			{
				_wavViewer = new WAVPlayer();
				_wavViewer.width = this.width;
				_wavViewer.height = this.height;
				_wavViewer.autoTextLayout = false;
				_wavViewer.clusterBubbling = true;
				_wavViewer.mouseChildren = true;
				_wavViewer.gestureList = {"n-drag": true, "n-scale": true, "n-rotate": true};
				addChild(_wavViewer);
			}
		}
		
		public function Update():void
		{
			// Logic to keep the box within the screen
			if (isMP3())
			{
				if (_mp3Viewer.x + _mp3Viewer.width + _frameWidth > stage.stageWidth)
				{
					_mp3Viewer.x = stage.stageWidth - _mp3Viewer.width - _frameWidth;
				}
				if (_mp3Viewer.x - _frameWidth < 0)
				{
					_mp3Viewer.x = _frameWidth;
				}
				if (_mp3Viewer.y + _mp3Viewer.height + _frameWidth > stage.stageHeight)
				{
					_mp3Viewer.y = stage.stageHeight - _mp3Viewer.height - _frameWidth;
				}
				if (_mp3Viewer.y - _frameWidth < 0)
				{
					_mp3Viewer.y = _frameWidth;
				}
			}
			else if (isWAV())
			{
				if (_wavViewer.x + _wavViewer.width + _frameWidth > stage.stageWidth)
				{
					_wavViewer.x = stage.stageWidth - _wavViewer.width - _frameWidth;
				}
				if (_wavViewer.x - _frameWidth < 0)
				{
					_wavViewer.x = _frameWidth;
				}
				if (_wavViewer.y + _wavViewer.height + _frameWidth > stage.stageHeight)
				{
					_wavViewer.y = stage.stageHeight - _wavViewer.height - _frameWidth;
				}
				if (_wavViewer.y - _frameWidth < 0)
				{
					_wavViewer.y = _frameWidth;
				}
			}
		}
		
		public function Open(source:String):void
		{
			if (_type.toUpperCase() == "MP3")
			{
				var mp3:MP3 = new MP3();
				mp3.width = this.width;
				mp3.height = this.height;
				mp3.autoplay = false;
				mp3.className = "mp3-component";
				mp3.src = source;
				mp3.display = "waveform";
				mp3.width = width;
				mp3.height = height;
				mp3.targetParent = true;
				mp3.mouseChildren = false;
				_mp3Viewer.addChild(mp3);
				
				var imageSource:String = source.toUpperCase().replace(FileSystem.GET_EXTENTION(source).toUpperCase(), "PNG");
				if (FileSystem.EXISTS(imageSource))
				{
					var image:Image = new Image();
					image.width = _mp3Viewer.width;
					image.height = _mp3Viewer.height;
					image.open(imageSource);
					image.alpha = 0.5;
					_mp3Viewer.addChild(image);
				}
			}
			else if (_type.toUpperCase() == "WAV")
			{
				var wav:WAV = new WAV();
				wav.width = this.width;
				wav.height = this.height;
				wav.autoplay = false;
				wav.className = "wav-component";
				wav.src = source;
				wav.display = "waveform";
				wav.width = width;
				wav.height = height;
				wav.targetParent = true;
				wav.mouseChildren = false;
				_wavViewer.addChild(wav);
				
				imageSource = source.toUpperCase().replace(FileSystem.GET_EXTENTION(source).toUpperCase(), "PNG");
				if (FileSystem.EXISTS(imageSource))
				{
					image = new Image();
					image.width = _wavViewer.width;
					image.height = _wavViewer.height;
					image.open(imageSource);
					image.alpha = 0.5;
					_wavViewer.addChild(image);
				}
			}
		}
		
		public function Stop():void
		{
			if (isMP3())
			{
				for each (var mp3:* in _mp3Viewer.childList)
				{
					if (mp3 is MP3)
					{
						MP3(mp3).stop();
					}
				}
			}
			else if (isWAV())
			{
				for each (var wav:* in _wavViewer.childList)
				{
					if (wav is WAV)
					{
						WAV(mp3).stop();
					}
				}
			}
		}
		
		public function Play():void
		{
			if (isMP3())
			{
				for each (var mp3:* in _mp3Viewer.childList)
				{
					if (mp3 is MP3)
					{
						MP3(mp3).play();
					}
				}
			}
			else if (isWAV())
			{
				for each (var wav:* in _wavViewer.childList)
				{
					if (wav is WAV)
					{
						WAV(mp3).play();
					}
				}
			}
		}
		
		private function isMP3():Boolean
		{
			return this._type == "MP3";
		}
		
		private function isWAV():Boolean
		{
			return this._type == "WAV";
		}
		
		public function GetAudioViewer():Object
		{
			if (this._type == "MP3") 
			{
				return _mp3Viewer;
			}
			else if (this._type == "WAV")
			{
				return _wavViewer;
			}
			return null;
		}
		
		public function get Type():String 
		{
			return _type;
		}
	}

}