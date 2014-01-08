package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.globalization.NumberFormatter;
	
	[Frame(factoryClass="Preloader")]
	/**
	 * ...
	 * @author Krelix
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{

			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			var game:BubbleJack = new BubbleJack(320, 480);
			
			addChild(game);
		}
		
	}
	
}