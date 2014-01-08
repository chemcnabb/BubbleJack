package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.graphics.Text;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MainMenu extends World 
	{
		
		public function MainMenu() 
		{
			//add(new BubbleCard());
			setGameTitle("Bubble Jack!");
			setStartText("Press X to Start");
            
        }
        
		override public function update():void
		{
			super.update();
			if (Input.mouseReleased)
			{
                FP.screen.color = 0x222233;
                FP.world=new GameWorld();
            }
		}
		
		override public function begin():void
		{
			// Called when World starts up
		}
		
		private function setGameTitle(title:String):void 
		{
			var gameTitle:Text = new Text(title);
			gameTitle.color = 0x00ff00;
			gameTitle.size = 32;
			
			var titleEntity:Entity = new Entity(0,0,gameTitle);
			titleEntity.x = horizontalCenter(gameTitle);
			titleEntity.y = 100;
			add(titleEntity);
		}
		
		private function setStartText(text:String):void 
		{
			var titleText:Text = new Text(text);
			var textEntity:Entity = new Entity(0, 0, titleText);
			
			textEntity.x = horizontalCenter(titleText);
			textEntity.y = verticalCenter(titleText);
			add(textEntity);
		}
		
		private function horizontalCenter(elem:Text):Number
		{
			return (FP.width/2)-(elem.width/2)
		}
		
		private function verticalCenter(elem:Text):Number 
		{
			return (FP.height / 2) - (elem.height / 2)
		}
		
	
    }
}