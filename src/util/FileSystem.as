package util
{
	import flash.filesystem.File;
	
	import com.gestureworks.core.GestureWorksAIR;
	
	/**
	 * util.FilSystem
	 *
	 * A util class to interact with the filesystem
	 *
	 * @author Adam Byléhn
	 * @contact adambylehn@hotmail.com
	 */
	
	final public class FileSystem extends GestureWorksAIR
	{
		
		public function FileSystem()
		{
			super();
		}
		
		static public function GET_FILES_IN_DIRECTORY_RELATIVE(directory:String):Array
		{
			var root:File = File.applicationDirectory;
			var subDirectory:File = root.resolvePath(directory);
			var relativePaths:Array = new Array();
			for each (var file:File in subDirectory.getDirectoryListing())
			{
				relativePaths.push(root.getRelativePath(file, true));
			}
			return relativePaths;
		}
		
		static public function IS_DIRECTORY(path:String):Boolean
		{
			var root:File = File.applicationDirectory;
			return root.resolvePath(path).isDirectory;
		}
		
		static public function GET_EXTENTION(file:String):String
		{
			var root:File = File.applicationDirectory;
			return root.resolvePath(file).extension;
		}
		
		static public function EXISTS(file:String):Boolean
		{
			var root:File = File.applicationDirectory;
			if (root.resolvePath(file).exists) 
			{
				return true;
			}
			return false;
		}
	}
}