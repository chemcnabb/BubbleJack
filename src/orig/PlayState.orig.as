package  
{
	import org.flixel.*;
	import org.flixel.system.FlxTile;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.display.Sprite;

	
	/**
	 * The game state, where the player is actually gonna play !
	 * @author Krelix
	 */
	public class PlayState extends FlxState
	{

		private var level:FlxTilemap;
		private var player:Bubble;
		private var camera:FlxCamera;
		
		private const ROT_SPEED:uint=2;
		private const R:uint=18;
		private const DEG_TO_RAD:Number=0.0174532925;
		private const BUBBLE_SPEED:uint=10;
		private var bubbleArr:Array=new Array();
		private var loadArr:Array=new Array();
		private var cannon:Cannon;
		private var bubble:Bubble;
		private var row:uint=0;
		private var col:uint=0;
		private var left:Boolean=false;
		private var right:Boolean=false;
		public var bubCont:FlxGroup;
		private var loadCont:FlxSprite;
		private var fire:Boolean=false;
		private var vx:Number,vy:Number;
		
		public function PlayState() 
		{
			// player = new Bubble();
			// level = new FlxTilemap();
			trace("place container....");
			placeContainer();
			trace("place cannon....");
			placeCannon();
			trace("load bubble....");
			loadBubble();
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKDown);
			FlxG.stage.addEventListener(KeyboardEvent.KEY_UP,onKUp);
			FlxG.stage.addEventListener(Event.ENTER_FRAME,onEFrame);
			trace("row= "+row+" , col= "+col);
		}
		private function placeCannon():void {
			cannon=new Cannon();
			add(cannon);
			cannon.y=385.5;
			cannon.x=320;
		}
		
		private function parkBubble(bubble:Bubble, row:int, col:int):void {
				//var bubbleArr = new Array();
				var iRow:Boolean=false;
				for (var j:uint=0; j<col; j++) {
					trace("first for loop ");
					for (var i:uint=row; i>0; i--) {
						trace("second for loop ");
						if (bubbleArr[i][j]!=null) {
							trace("first if loop ");
							if (! iRow) {
								trace("second if loop ");
								bubbleArr[i+1]=new Array();
								bubbleArr[i+1][j]=Math.floor(Math.random()*6);
								bubble = new Bubble(bubbleArr[i+1][j],(i+1),j);
								bubCont.add(bubble);
								iRow=true;
								row++;
								col++;
							} else {
								trace("first for loop after else ");
								bubbleArr[i+1]=new Array();
								bubbleArr[i+1][j]=Math.floor(Math.random()*6);
								bubble = new Bubble(bubbleArr[i+1][j],(i+1),j);
								bubble.x=77+j*2*R;
								bubCont.add(bubble);
								iRow=false;
								row++;
								col++;
							}
						}
					}
				}
				bubCont.remove(bubble);
				fire=false;
				loadBubble();
				trace("slutet av parkBubble ");
			}
		
		private function onKDown(e:KeyboardEvent):void {
			trace("KEY PRESSED!");
			trace(e.keyCode);
			switch(e.keyCode) {
				case 37 :
					left=true;
					break;
				case 39 :
					right=true;
					break;
				case 38 :
					if (! fire) {
						fire=true;
						var radians:Number=(cannon.angle-90)*DEG_TO_RAD;
						vx=BUBBLE_SPEED*Math.cos(radians);
						vy=BUBBLE_SPEED*Math.sin(radians);
					}
					break;
			}
		}
		private function onKUp(e:KeyboardEvent):void {
			switch(e.keyCode) {
				case 37 :
					left=false;
					break;
				case 39 :
					right=false;
					break;
			}
		}
		private function onEFrame(e:Event):void {
			if (left) {
				cannon.angle-=ROT_SPEED;
			}
			if (right) {
				cannon.angle+=ROT_SPEED;
			}
			if (fire) {
				bubble.x+=vx;
				bubble.y+=vy;
				if (bubble.x<59) {
					bubble.x=59;
					vx*=-1;
				}
				if (bubble.x>(59+R*R)) {
					bubble.x=59+R*R;
					vx*=-1;
				}
				if (bubble.y<(40)) {
					bubble.y=40;
				} 
			}
		}
		private function collide(bub:Bubble):Boolean {
				var dist_x:Number=bub.x-bubble.x;
				var dist_y:Number=bub.y-bubble.y;
				return Math.sqrt(dist_x*dist_x+dist_y*dist_y)<=2*R-4;
	
		}

		public function placeContainer():void {
			
			var iRow:Boolean=false;
			bubCont=new FlxGroup();
			add(bubCont);
			for (var i:uint=0; i<4; i++) {
				if (! iRow) {
					for (var j:uint=0; j<15; j++) {
						bubbleArr[i]=new Array();
						bubbleArr[i][j]=Math.floor(Math.random()*6);
						bubble = new Bubble(bubbleArr[i][j],i,j);
						bubCont.add(bubble);
						iRow=true;
						row++;
						col++;
					}
				} else {
					for (j=0; j<15; j++) {
						bubbleArr[i]=new Array();
						bubbleArr[i][j]=Math.floor(Math.random()*6);
						bubble = new Bubble(bubbleArr[i][j],i,j);
						bubble.x=77+j*2*R;
						bubCont.add(bubble);
						iRow=false;
						row++;
						col++;
					}
				}
			}
		}
		private function loadBubble():void {
			//var bubble:Bubble = new Bubble();
			bubCont.add(new Bubble(0, 0, 0));
			//bubble.gotoAndStop(Math.floor(Math.random()*6))+1;
			bubble.x=320;
			bubble.y=410;
		}
		/*override public function create():void
		{
			level.loadMap(new csv_level1, allTilesPNG, 16, 16, 0, 0, 1, 5);
			add(level);
			add(player);
			FlxG.worldBounds = new FlxRect(0, 0, level.width, level.height);
			FlxG.camera.setBounds(0, 0, level.width, level.height);
			FlxG.camera.follow(player, FlxCamera.STYLE_PLATFORMER);
		}*/
		
		/*override public function update():void 
		{
			super.update();
			player.update();
			FlxG.collide(level, player);
			if (FlxG.keys.ESCAPE)
				FlxG.switchState(new PlayState());
		}*/
	}
}