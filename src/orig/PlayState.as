package {
	import org.flixel.*;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.display.Graphics;

	
	
	public class PlayState extends FlxState {
		private const ROT_SPEED:uint=2;
		private const R:uint=18;
		private const D:Number=R*Math.sqrt(3);
		private const DEG_TO_RAD:Number=0.0174532925;
		private const BUBBLE_SPEED:uint=10;
		private var cannon:Cannon;
		private var left:Boolean=false;
		private var right:Boolean=false;
		private var bubCont:FlxGroup;
		private var bubble:Bubble;
		private var fire:Boolean=false;
		private var vx:Number;
		private var vy:Number;
		private var fieldArray:Array;
		private var chainArray:Array;
		private var connArray:Array;
		

		private var deck:Array;
		private var count:Number;
		
		
		
		public function PlayState() {
			trace("building deck...");
			Deck();
			trace("placing container of initial bubbles");
			placeContainer();
			trace("placing cannon");
			//placeCannon();
			trace("loading bubble");
			//loadBubble();
			
			
			
			trace("adding keyboard event listeners");
			//FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKDown);
			//FlxG.stage.addEventListener(KeyboardEvent.KEY_UP,onKUp);
			//FlxG.stage.addEventListener(Event.ENTER_FRAME,onEFrame);
		}
		private function loadBubble():void {
			// to do: build cards, assign to Bubble
			var num:Number = Math.round(Math.random() * (this.count - 1));
			trace("NUMBER:" + num);
			bubble = this.deck[num];
			trace("BUBBLE:");
			trace(bubble);
			bubCont.add(bubble);
			//bubble.gotoAndStop(Math.floor(Math.random()*6))+1;
			bubble.x=R*8;
			bubble.y=450;
		}
		private function placeContainer():void {
			var Sprite:FlxSprite = new FlxSprite();
			var gfx:Graphics = FlxG.flashGfx;
			//gfx.clear();
			
			trace("initializing fieldArray...");
			this.fieldArray = new Array();
			trace("initializing bubCont group...");
			bubCont = new FlxGroup();
			trace("adding group to display list");
			add(bubCont);
			trace("setting line style...");
			gfx.lineStyle(1, 0xffffff, 0.2);
			trace("starting for loop");
			for (var i:uint = 0; i < 11; i++) {
				trace("initializing fieldArray element " + i);
				fieldArray[i] = new Array();
				
				for (var j:uint = 0; j < 8; j++) {
					trace("initializing fieldArray second element " + i + " " + j);
					if (i % 2 == 0) {
						trace("drawing circle");
						gfx.drawCircle(R + j * R * 2, R + i * D, R);
						
						fieldArray[i][j]=0;
					} else {
						if (j<7) {
							//with (bubCont.members) {
								gfx.drawCircle(2*R+j*R*2,R+i*D,R);
								fieldArray[i][j]=0;
							//}
						}
					}
					Sprite.pixels.draw(FlxG.flashGfxSprite);
					Sprite.dirty = true;
					add(Sprite);
				}
			}
			
		}
		private function placeCannon():void {
			cannon=new Cannon();
			add(cannon);
			cannon.y=450;
			cannon.x=R*8;
		}
		private function onKDown(e:KeyboardEvent):void {
			switch (e.keyCode) {
				case 37 :
					left=true;
					break;
				case 39 :
					right=true;
					break;
				case 38 :
					trace("FIIIIRE");
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
			switch (e.keyCode) {
				case 37 :
					left=false;
					break;
				case 39 :
					right=false;
					break;
			}
		}
		private function onEFrame(e:Event):void {
			trace("ENTER_FRAME");
			if (left) {
				//cannon.rotation-=ROT_SPEED;
			}
			if (right) {
				//cannon.rotation+=ROT_SPEED;
			}
			if (fire) {
				bubble.x+=vx;
				bubble.y+=vy;
				if (bubble.x<R) {
					bubble.x=R;
					vx*=-1;
				}
				if (bubble.x>R*15) {
					bubble.x=R*15;
					vx*=-1;
				}
				if (bubble.y<R) {
					parkBubble();
				} else {
					trace("starting loop");
					for (var i:uint = 0; i < bubCont.members.length; i++) {
						trace(bubCont.members[i]);
						
						var tmp:Bubble;
						tmp = bubCont.members[i];
						
						trace(tmp);
						if (collide(tmp)) {
							parkBubble();
							break;
						}
					}
				}
			}
		}
		private function collide(bub:Bubble):Boolean {
			
			var dist_x:Number=bub.x-bubble.x;
			var dist_y:Number=bub.y-bubble.y;
			return Math.sqrt(dist_x*dist_x+dist_y*dist_y)<=2*R;
		}
		
		private function Deck():void {
		   this.deck = new Array(52);
		   this.count = 52;
		   var c:Number = 0;
		   for (var i:Number = 1; i <= 4; i++)
			  for (var j:Number = 1; j <= 13; j++)
				 this.deck[c++] = new Bubble(j,i);
		}
		
		private function shuffle():void {
		   for (var i:Number = 51; i > 0; i--) {
			   //trace((i+1)*Math.random());
			   var r:Number = Math.floor((i+1)*Math.random());
			   var temp:Bubble = this.deck[r];
			   this.deck[r] = this.deck[i];
			   this.deck[i] = temp;
		   }
		   this.count = 52;
		}

		private function parkBubble():void {
			var row:uint=Math.floor(bubble.y/D);
			var col:uint;
			//var fieldArray = new Array();
			
			
			
			
			
			
			if (row%2==0) {
				col=Math.floor(bubble.x/(R*2));
			} else {
				col=Math.floor((bubble.x-R)/(R*2));
			}
			
			var placedBubble:Bubble = bubble;
			bubCont.add(placedBubble);
			
			if (row%2==0) {
				placedBubble.x=(col*R*2)+R;
			} else {
				placedBubble.x=(col*R*2)+2*R;
			}
			placedBubble.y=(row*D)+R;
			//placedBubble.gotoAndStop(bubble.currentFrame);
			placedBubble.name = row + "_" + col;
			trace(placedBubble.card);
			fieldArray[row][col] = placedBubble.name;
			
			
			chainArray=new Array();
			getChain(row,col);
			if (chainArray.length>2) {
				for (var i:uint=0; i<chainArray.length; i++) {
					with (bubCont.members) {
						remove(getChildByName(chainArray[i]));
					}
					var coords:Array=chainArray[i].split("_");
					fieldArray[coords[0]][coords[1]]=0;
				}
				removeNotConnected();
			}
			remove(bubble);
			fire=false;
			loadBubble();
		}
		private function getValue(row:int,col:int):int {
			if (fieldArray[row]==null) {
				return -1;
			}
			if (fieldArray[row][col]==null) {
				return -1;
			}
			return fieldArray[row][col];
		}
		private function getChain(row:int,col:int):void {
			chainArray.push(row+"_"+col);
			var odd:uint=row%2;
			var match:uint=fieldArray[row][col];
			for (var i:int=-1; i<=1; i++) {
				for (var j:int=-1; j<=1; j++) {
					if (i!=0||j!=0) {
						if (i==0||j==0||(j==-1&&odd==0)||(j==1&&odd==1)) {
							if (isNewChain(row+i,col+j,match)) {
								getChain(row+i,col+j);
							}
						}
					}
				}
			}
		}
		private function isNewChain(row:int,col:int,val:uint):Boolean {
			return val == getValue(row,col)&&chainArray.indexOf(row+"_"+col)==-1;
		}
		private function removeNotConnected():void {
			for (var i:uint=1; i<11; i++) {
				for (var j:uint=0; j<8; j++) {
					if (getValue(i,j)>0) {
						connArray=new Array();
						getConnections(i,j);
						if (connArray[0]!="connected") {
							with (bubCont) {
								removeChild(getChildByName(i+"_"+j));
							}
							fieldArray[i][j]=0;
						}
					}
				}
			}
		}
		private function getConnections(row:int,col:int):void {
			connArray.push(row+","+col);
			var odd:uint=row%2;
			for (var i:int=-1; i<=1; i++) {
				for (var j:int=-1; j<=1; j++) {
					if (i!=0||j!=0) {
						if (i==0||j==0||(j==-1&&odd==0)||(j==1&&odd==1)) {
							if (isNewConnection(row+i,col+j)) {
								if (row+i==0) {
									connArray[0]="connected";
								} else {
									getConnections(row+i,col+j);
								}
							}
						}
					}
				}
			}
		}
		private function isNewConnection(row:int,col:int):Boolean {
			return getValue(row,col)>0&&connArray.indexOf(row+","+col)==-1;
		}
	}
}