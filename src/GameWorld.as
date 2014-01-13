package {
import net.flashpunk.Entity;
import net.flashpunk.World;
import net.flashpunk.FP;
import net.flashpunk.utils.Draw;
import net.flashpunk.utils.Input;
import net.flashpunk.utils.Key;
import net.flashpunk.graphics.Backdrop;

/**
 * ...
 * @author ...
 */
public class GameWorld extends World {
    private const ROT_SPEED:uint = 2;
    private const R:uint = 18;
    private const D:Number = R * Math.sqrt(3);
    private const DEG_TO_RAD:Number = 0.0174532925;
    private const BUBBLE_SPEED:uint = 10;

    private var connArray:Array;
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
    private var bubbleList:Array;
    private var fieldArray:Array;
    private var chainArray:Array;

    [Embed(source='assets/fabric.jpg')]
    public var backgroundImage:Class;

    public function GameWorld() {
        //init
        super();
        var backdrop:Backdrop = new Backdrop(backgroundImage, false, false);
        add(new Entity(0, 0, backdrop));
    }

    private function isNewConnection(row:int, col:int):Boolean {
        return getValue(row, col) > 0 && connArray.indexOf(row + "," + col) == -1;
    }

    private function removeNotConnected():void {
        for (var row:uint = 0; row < bubble_rows; row++) {
            for (var col:uint = 0; col < bubble_columns; col++) {

                if (getValue(row, col) > 0) {
                    // WE HAVE A BUBBLE!
                    //trace("Bubble found.  is it connected?");
                    connArray = [];
                    getConnections(row, col);
                    trace(connArray);
                    var bubble = getInstance(row+","+col);
                    if (connArray[0] != "connected" && connArray[0].split(",")[0] != 0) {

                        trace(bubble.getColorName() + " Bubble -- NOT CONNECTED");


                        trace();
                        remove(getInstance(row + "," + col));
                        fieldArray[row][col] = 0;

                    }else{
                        trace(bubble.getColorName() + " connected");
                    }
                }
            }
        }
    }

    private function getConnections(row:int, col:int):void {
        connArray.push(row + "," + col);
        var odd:uint = row % 2;
        for (var i:int = -1; i <= 1; i++) {
            for (var j:int = -1; j <= 1; j++) {
                if (i != 0 || j != 0) {
                    if (i == 0 || j == 0 || (j == -1 && odd == 0) || (j == 1 && odd == 1)) {
                        if (isNewConnection(row + i, col + j)) {
                            if (row + i == 0) {
                                connArray[0] = "connected";
                            } else {
                                getConnections(row + i, col + j);
                            }
                        }
                    }
                }
            }
        }

    }

    override public function render():void {
        //placeContainer();
        super.render();
    }

    private function getValue(row:int, col:int):int {
        if (fieldArray[row] == null) {
            return -1;
        }
        if (fieldArray[row][col] == null) {
            return -1;
        }
        return fieldArray[row][col];
    }

    private function isNewChain(row:int, col:int, val:uint):Boolean {
        return val == getValue(row, col) && chainArray.indexOf(row + "," + col) == -1;
    }

    private function placeContainer():void {
        fieldArray = [];
        for (var i:uint = 0; i < this.bubble_rows; i++) {
            fieldArray[i] = [];
            for (var j:uint = 0; j < this.bubble_columns; j++) {
                if (i % 2 == 0) {
                    Draw.circle(R + j * R * 2, R + i * D, R, 0xffffff);
                    fieldArray[i][j] = 0;

                }
                else {
                    if (j < this.bubble_columns - 1) {
                        Draw.circle(2 * R + j * R * 2, R + i * D, R, 0xffffff);
                        fieldArray[i][j] = 0;
                    }
                }
            }
        }

    }

    private function getChain(row:int, col:int):void {
        chainArray.push(row + "," + col);
        var odd:uint = row % 2;
        var match:uint = fieldArray[row][col];

        for (var i:int = -1; i <= 1; i++) {
            for (var j:int = -1; j <= 1; j++) {
                if (i != 0 || j != 0) {
                    if (i == 0 || j == 0 || (j == -1 && odd == 0) || (j == 1 && odd == 1)) {
                        if (isNewChain(row + i, col + j, match)) {
                            getChain(row + i, col + j);
                        }
                    }
                }
            }
        }

    }

    private function loadBubble():void {
        this.currentLoadedBubble = new BubbleCard();
        add(this.currentLoadedBubble);

        this.currentBubbleColor = this.currentLoadedBubble.getColorName();

        this.currentLoadedBubble.x = (R * 8) - 2;
        this.currentLoadedBubble.y = cannon.y - 15;
    }

    private function placeCannon():void {

        add(cannon);
        cannon.y = (FP.height - 70);
        cannon.x = (FP.width / 2) - (cannon.width / 2); //R*8;
    }

    override public function update():void {
        super.update();

        if (Input.mouseReleased) {
            if (!fire) {
                fire = true;
                currentAngle = cannon.angle;
                vx = Math.cos(currentAngle * FP.RAD) * BUBBLE_SPEED;
                vy = Math.sin(currentAngle * FP.RAD) * BUBBLE_SPEED;
            }
        }

        if (fire) {
            // The mouse button was released this frame.

            this.currentLoadedBubble.x += vx;
            this.currentLoadedBubble.y += vy;
            if (this.currentLoadedBubble.x < R) {
                this.currentLoadedBubble.x = R;
                vx *= -1;
            }
            if (this.currentLoadedBubble.x > R * 15) {
                this.currentLoadedBubble.x = R * 15;
                vx *= -1;
            }

            if (this.currentLoadedBubble.y < R) {
                parkBubble();
            }
            else {
                bubbleList = [];
                FP.world.getType("bubble", bubbleList);

                for (var i:uint = 0; i < bubbleList.length; i++) {
                    var tmp:BubbleCard = bubbleList[i] as BubbleCard;
                    if (this.currentLoadedBubble.collide("bubble", this.currentLoadedBubble.x, this.currentLoadedBubble.y)) {
                        parkBubble();
                        break;
                    }

                }
            }

            if (this.currentLoadedBubble.x > R * 15) {
                this.currentLoadedBubble.x = R * 15;
                vx *= -1;
            }

        }
    }

    private function parkBubble():void {
        var row:uint = Math.floor(this.currentLoadedBubble.y / D);
        var col:uint;

        if (row % 2 == 0) {
            col = Math.floor(this.currentLoadedBubble.x / (R * 2));
            this.currentLoadedBubble.x = (col * R * 2) + R;
        }
        else {
            col = Math.floor((this.currentLoadedBubble.x - R) / (R * 2));
            this.currentLoadedBubble.x = (col * R * 2) + 2 * R;
        }


        //correct position
        this.currentLoadedBubble.y = (row * D) + R;
        //set name
        this.currentLoadedBubble.name = row + "," + col;

        fieldArray[row][col] = this.currentLoadedBubble.currentIndex(); //this.currentLoadedBubble.getColorName();


        chainArray = [];
        getChain(row, col);


        if ((chainArray.length > 2)) {
            removeBubbleChain();
        }


        fire = false;
        loadBubble();

    }

    private function removeBubbleChain():void {
        var removeBubbleList:Array = [];
        for (var i:uint = 0; i < chainArray.length; i++) {


            for (var list_index:Number = 0; list_index < bubbleList.length; list_index++) {
                var tmp_bubble:BubbleCard = bubbleList[list_index] as BubbleCard;
                var bubble:BubbleCard = getInstance(tmp_bubble.name) as BubbleCard;


                if (bubble.name == chainArray[i]) {
                    trace("====CHAIN DETECTED====");
                    for (var counter:uint = 0; counter < chainArray.length; counter++) {
                        trace(chainArray[counter]);
                        remove(getInstance(chainArray[counter]));
                        var coords:Array = chainArray[counter].split(",");
                        fieldArray[coords[0]][coords[1]] = 0;
                        bubbleList = bubbleList.splice(list_index, 1);
                        removeNotConnected();
                    }




                }

            }



        }
    }

    override public function begin():void {
        // Called when World starts up
        placeCannon();
        loadBubble();
        placeContainer();
    }
}
}