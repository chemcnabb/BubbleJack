package 
{

	import net.flashpunk.Engine;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Krelix
	 */
	//[Frame(factoryClass="Preloader")]
	public class Main extends Engine
	{
		public function Main()
		{
			super(320, 480, 60, false);
			FP.world = new MainMenu();

		}

		override public function init():void
		{
			FP.console.enable();
			FP.console.log("BubbleJack initialized");
			// a dumb little comment
		}
	}
	
}