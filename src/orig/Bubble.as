package  
{
	import org.flixel.*;
	
	/**
	 * Player class.
	 * @author Krelix
	 */
	public class Bubble extends FlxSprite 
	{
		private var _x:uint;
		private var _y:uint;
		
		public var suit:Number;
		public var value:Number;
		public var name:String;
		public var card:String;
		
		[Embed(source="../resources/bubble/bubbles.png")] public var bubbleGIF:Class;
		public function Bubble(val:uint = -1, suit:uint = -1, row:uint = -1, col:uint = -1)
		{
			
			//trace("VAL:" + val);
			//trace("ROW:" + row);
			//trace("COL:" + col);
			loadGraphic(bubbleGIF);
			
			
			if (arguments.length < 2)
			  throw "The set function requires two arguments.";
			  
			this.value = Math.round(Number(val));
			this.suit = Math.round(Number(suit));
			trace("Card suit and value...");
			trace(this.suit);
			checkCardValue();
			
			checkCardSuit();

			this.setName();

			if (val !== -1) {
				this.name = row + "_" + col;
				this.x = 59 + col * 36;
				this.y = 40 + row * 32;
			}
			
		}
		
		private function setName():void {
			if (this.value != -1)
			   
				var s:String = "";
				switch (this.value) {
				   case 1: s += "Ace"; break;
				   case 11: s += "Jack"; break;
				   case 12: s += "Queen"; break;
				   case 13: s += "King"; break;
				   default: s += this.value; break;
				}
				s += " of ";
				switch (this.suit) {
				   case 1: s += "Clubs"; break;
				   case 2: s += "Diamonds"; break;
				   case 3: s += "Hearts"; break;
				   case 4: s += "Spades"; break;
				}
				this.card = s;
		}
		
		private function checkCardValue():void 
		{
			if ( ! (this.value >- 1 && this.value <= 13) )
			  throw "The value of a card must be in the range 1 to 13.";
		}
		
		private function checkCardSuit():void 
		{
			if ( ! (this.suit >= 1 && this.suit <= 4) )
			  throw "The suit of a card must be 1, 2, 3, or 4.";
		}
		
		/*override public function update():void 
		{
			super.update();
			acceleration.x = 0;
			if(FlxG.keys.LEFT)
				acceleration.x = -maxVelocity.x*4;
			if(FlxG.keys.RIGHT)
				acceleration.x = maxVelocity.x*4;
			if(FlxG.keys.SPACE && isTouching(FlxObject.FLOOR))
				velocity.y = -maxVelocity.y/2;
		}*/
		
		
		
		
		
		

		
	}

}