package
{
	import net.flashpunk.Entity;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GameWorld extends World
	{
		private const ROT_SPEED:uint = 2;
		private const R:uint = 18;
		private const D:Number = R * Math.sqrt(3);
		private const DEG_TO_RAD:Number = 0.0174532925;
		private const BUBBLE_SPEED:uint = 10;
		//private var bubCont:Entity;
		private var cannon:Cannon = new Cannon();
		private var currentBubbleColor:String;
		private var bubble_rows:Number = 11;
		private var bubble_columns:Number = 9;
		private var fire:Boolean = false;
		private var vx:Number;
		private var vy:Number;
		private var currentAngle:Number = 0;
		private var currentLoadedBubble:BubbleCard = new BubbleCard();
		
		public function GameWorld()
		{
			//init
			super();
		}
		
		override public function render():void
		{
			placeContainer();
			super.render();
		}
		
		private function placeContainer():void
		{
			for (var i:uint = 0; i < this.bubble_rows; i++)
			{
				for (var j:uint = 0; j < this.bubble_columns; j++)
				{
					if (i % 2 == 0)
					{
						Draw.circle(R + j * R * 2, R + i * D, R, 0xffffff);
					}
					else
					{
						if (j < this.bubble_columns-1)
						{
							Draw.circle(2 * R + j * R * 2, R + i * D, R, 0xffffff);
						}
					}
				}
			}
		}
		
		private function loadBubble():void
		{
			trace("loading bubble...");
			this.currentLoadedBubble = new BubbleCard();
			add(this.currentLoadedBubble);
			
			this.currentBubbleColor = this.currentLoadedBubble.getColorName();

			this.currentLoadedBubble.x = (R * 8) - 2;
			this.currentLoadedBubble.y = cannon.y - 15;
		}
		
		private function placeCannon():void
		{
			
			add(cannon);
			cannon.y = (FP.height - 70);
			cannon.x = (FP.width / 2) - (cannon.width / 2); //R*8;
		}
		
		override public function update():void
		{
			super.update();
			
			if (Input.mouseReleased)
			{
				if (!fire)
				{
					fire = true;
					currentAngle = cannon.angle;
					vx = Math.cos(currentAngle * FP.RAD) * BUBBLE_SPEED;
					vy = Math.sin(currentAngle * FP.RAD) * BUBBLE_SPEED;
				}
			}
			
			if (fire)
			{
				// The mouse button was released this frame.
				
				this.currentLoadedBubble.x += vx;
				this.currentLoadedBubble.y += vy;
				if (this.currentLoadedBubble.x<R) {
					this.currentLoadedBubble.x=R;
					vx*=-1;
				}
				if (this.currentLoadedBubble.x>R*15) {
					this.currentLoadedBubble.x=R*15;
					vx*=-1;
				}
				
				if (this.currentLoadedBubble.y < R)
				{
					parkBubble();
				}
				else
				{
					var bubbleList:Array = new Array();
					FP.world.getType("bubble", bubbleList);
					
					for (var i:uint = 0; i < bubbleList.length; i++)
					{
						var tmp:BubbleCard = bubbleList[i] as BubbleCard;
						if (this.currentLoadedBubble.collide("bubble", this.currentLoadedBubble.x, this.currentLoadedBubble.y))
						{
							parkBubble();
							break;
						}
						
					}
				}
				
			
				if (this.currentLoadedBubble.x > R * 15)
				{
					this.currentLoadedBubble.x = R * 15;
					vx *= -1;
				}
				
			}
		}
		
		private function parkBubble():void
		{
			var row:uint = Math.floor(this.currentLoadedBubble.y / D);
			var col:uint;
			if (row % 2 == 0)
			{
				col = Math.floor(this.currentLoadedBubble.x / (R * 2));
			}
			else
			{
				col = Math.floor((this.currentLoadedBubble.x - R) / (R * 2));
			}
			
			var placed_bubble:BubbleCard = new BubbleCard(this.currentLoadedBubble.getColorName());
			trace("comparing current: " + this.currentLoadedBubble.getColorName() + " to placed: " + placed_bubble.getColorName());


			add(placed_bubble);
			
			if (row % 2 == 0)
			{
				placed_bubble.x = (col * R * 2) + R;
			}
			else
			{
				placed_bubble.x = (col * R * 2) + 2 * R;
			}
			placed_bubble.y = (row * D) + R;
			//trace("adjusted bubble to fit at column " + col);

			remove(this.currentLoadedBubble);
			fire = false;
			loadBubble();
			
		}
		
		
		override public function begin():void
		{
			// Called when World starts up
			placeCannon();
			loadBubble();
		}
	}
}