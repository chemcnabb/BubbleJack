package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Krelix
	 */
	public class BubbleJack extends FlxGame
	{
		private static var _instance:BubbleJack
		
		public function BubbleJack(width:int = 320, height:int = 240) 
		{
			// Create a new Game, with the state MenuState.
			// Set the width and height to half of the actual SWF size
			// And the pixel size to 2
			
			super(width, height, MenuState, 1);
			_instance = this;
		}
		
		public static function get instance():BubbleJack {
			return _instance;
		}
		
	}

}