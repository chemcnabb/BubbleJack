
package
{
	import net.flashpunk.Entity;
	import flash.display.BitmapData;
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.geom.Matrix;
    import net.flashpunk.FP;
    import net.flashpunk.graphics.Stamp;
    import net.flashpunk.World;
     
	
	public class BubbleCard extends Entity
	{
		
		private var random_select:Number;
		private var set_color:String;
		private var blue:Array = [0x6ACFFF, 0x005F8C];
		private var red:Array = [0xFFA5B3, 0xA60000];
		private var yellow:Array = [0xFFFEA5, 0xA6A600];
		private var green:Array = [0x62FF62, 0x00AE0B];
		private var purple:Array = [0xDE68FF, 0x750092];
		
		public var color_array:Array = [blue, red, yellow, green, purple]; //, yellow, green, purple
		public var color_name_array:Array = ["blue", "red", "yellow", "green", "purple"]; //, yellow, green, purple
		public var current_color_array:Array;
        public var time:int = 0;
        public var totaltime:int = 0;

		public function BubbleCard(set_color:String = "")
		{
			//graphic = new Image(BUBBLE);
			this.set_color = set_color;
			//trace("INIT COLOR: " + this.set_color);
			this.random_select = Math.floor(Math.random() * this.color_array.length);
			setColor();
			setHitbox(23, 23);
			type = "bubble";
			drawBubble();
		}

        public function currentIndex():Number{
            return this.random_select+1;
        }
		
		public function getColorName():String {
			return this.color_name_array[this.random_select];
		}
		
		public function getColorArray():Array {
				var array_color:Array = this.color_array[this.color_name_array.indexOf(this.set_color)];
				return array_color;
		}

        override public function update():void
        {
            time ++;
            totaltime ++;
            if (time == 60)
            {
                // Reset the counter after 60 frames has elapsed.
                time = 0;
            }
        }
		
		public function drawBubble():void
		{
			var sprite:Sprite = new Sprite;
            var g:Graphics = sprite.graphics;
             
            var gradientMatrix:Matrix = new Matrix();
            gradientMatrix.createGradientBox(18, 18, 270 * FP.RAD, 0, 0);

            g.beginGradientFill("linear", this.current_color_array, [1, 1], [0, 255], gradientMatrix);
			
            g.drawCircle(18, 18, 18);
            g.endFill();
             
            var bd:BitmapData = new BitmapData(36, 36, true, 0);
            bd.draw(sprite);
             
            addGraphic(new Stamp(bd));
		}

		
		override public function render():void
		{
			super.render();
		}

		
		override public function added():void
		{
			// Called when added to the world
		}
		
		public function setColor():void 
		{
			trace("SET COLOR: " + this.set_color);
			if (this.set_color != "") {
				this.current_color_array = this.getColorArray();
			}else{
				this.current_color_array = this.color_array[this.random_select];
				this.set_color = this.color_name_array[this.random_select];
			}
			
		}
	}
}