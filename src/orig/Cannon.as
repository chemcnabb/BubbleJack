package  
{
	import org.flixel.*;
	
	/**
	 * Player class.
	 * @author Krelix
	 */
	public class Cannon extends FlxSprite 
	{
		private var _x:uint;
		private var _y:uint;
		
		public function Cannon(_x:int = 10, _y:int = 20) 
		{

			super(_x, _y);
			
			
			
			
			maxVelocity.x = 80;
			maxVelocity.y = 200;
			acceleration.y = 200;
			drag.x = maxVelocity.x * 4;
		}
		
		override public function update():void 
		{
			super.update();
			acceleration.x = 0;
			if(FlxG.keys.LEFT)
				acceleration.x = -maxVelocity.x*4;
			if(FlxG.keys.RIGHT)
				acceleration.x = maxVelocity.x*4;
			if(FlxG.keys.SPACE && isTouching(FlxObject.FLOOR))
				velocity.y = -maxVelocity.y/2;
		}
		
	}

}