package  
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Cannon extends Entity 
	{
		public var angle:int;
		
		[Embed(source = 'assets/cannon.png')] private const CANNON:Class;
		public function Cannon() 
		{
			
			graphic = new Image(CANNON);
			
			
		}
		public function currentAngle():Number {
			return Image(graphic).angle;
		}
		
		override public function update():void
		{
			super.update();
			angle = FP.angle(this.x, this.y, world.mouseX, world.mouseY)
			Image(graphic).centerOrigin();
			Image(graphic).angle = angle-90;
			
		}
		
	}

}