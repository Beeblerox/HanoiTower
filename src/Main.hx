package;

import openfl.events.Event;
import openfl.display.Sprite;
import openfl.Lib;

class Move
{
	public var disk:Int;
	public var from:Int;
	public var to:Int;
	
	public function new(disk:Int, from:Int, to:Int)
	{
		this.disk = disk;
		this.from = from;
		this.to = to;
	}
	
	public function toString():String
	{
		return "Moving " + disk + " from " + from + " to " + to;
	}
}

class PoleStack extends Sprite
{
	public var stack:Array<Sprite> = [];
	
	public function new(width:Float, height:Float, color:Int)
	{
		super();
		
		graphics.beginFill(color);
		graphics.drawRect(-0.5 * width, -height, width, height);
		graphics.endFill();
	}
	
	public function redraw():Void
	{
		removeChildren();
		
		var posY:Float = 0;
		for (sprite in stack)
		{
			sprite.y = posY;
			addChild(sprite);
			posY -= sprite.height;
		}
	}
}

class Main extends Sprite 
{
	var poles:Array<PoleStack>;
	
	var moves:Array<Move> = [];
	
	var moveIndex:Int = 0;
	var animationCounter:Int = 0;
	
	public function new() 
	{
		super();
		
		var poleDiameter:Float = 20;
		
		var startX:Float = 0.25 * Lib.current.stage.stageWidth;
		var startY:Float = 0.9 * Lib.current.stage.stageHeight;
		
		var poleColor:Int = 0xFFE97F;
		var poleHeight:Float = 0.5 * Lib.current.stage.stageHeight;
		
		var ground:Sprite = new Sprite();
		ground.x = 0;
		ground.y = startY;
		addChild(ground);
		
		ground.graphics.beginFill(poleColor);
		ground.graphics.drawRect(0, 0, Lib.current.stage.stageWidth, 20);
		ground.graphics.endFill();
		
		var startPole:PoleStack = new PoleStack(poleDiameter, poleHeight, poleColor);
		startPole.x = startX;
		startPole.y = startY;
		addChild(startPole);
		
		var middleX:Float = 0.5 * Lib.current.stage.stageWidth;
		var middleY:Float = startY;
		
		var middlePole:PoleStack = new PoleStack(poleDiameter, poleHeight, poleColor);
		middlePole.x = middleX;
		middlePole.y = middleY;
		addChild(middlePole);
		
		var destinationX:Float = 0.75 * Lib.current.stage.stageWidth;
		var destinationY:Float = startY;
		
		var destinationPole:PoleStack = new PoleStack(poleDiameter, poleHeight, poleColor);
		destinationPole.x = destinationX;
		destinationPole.y = destinationY;
		addChild(destinationPole);
		
		poles = [startPole, middlePole, destinationPole];
		
		var colors:Array<Int> = [0x0026FF, 0xFF0000, 0xFF6A00, 0x00FFFF, 0xFF00DC];
		var numDisks:Int = colors.length;
		var diameter:Float = 150;
		var diameterStep:Float = (diameter - poleDiameter - 20) / numDisks;
		var diskHeight:Float = 20;
		
		for (i in 0...numDisks)
		{
			var disk:Sprite = new Sprite();
			disk.graphics.beginFill(colors[i]);
			disk.graphics.drawRect( -0.5 * diameter, -diskHeight, diameter, diskHeight);
			disk.graphics.endFill();
			
			poles[0].stack.push(disk);
			
			diameter -= diameterStep;
		}
		
		redraw();
		
		hanoi(numDisks - 1, 0, 2, 1);
		trace("Number of steps to solve the tower is: " + moves.length);
		
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	function hanoi(n:Int, start:Int, destination:Int, open:Int):Void
	{
		if (n < 0) return;
		
		hanoi(n - 1, start, open, destination);
		move(n, start, destination);
		hanoi(n - 1, open, destination, start);
	}
	
	function move(n:Int, from:Int, to:Int):Void
	{
		moves.push(new Move(n, from, to));
	}
	
	function onEnterFrame(e:Event):Void 
	{
		animationCounter++;
		
		if (animationCounter >= 60)
		{
			animationCounter = 0;
			if (moveIndex < moves.length)
			{
				var move = moves[moveIndex];
				visualizeStep(move);
				moveIndex++;
			}
		}
	}
	
	function visualizeStep(move:Move):Void
	{
		var disk:Sprite = poles[move.from].stack.pop();
		poles[move.to].stack.push(disk);
		
		poles[move.from].redraw();
		poles[move.to].redraw();
	}
	
	function redraw():Void
	{
		for (pole in poles)
		{
			pole.redraw();
		}
	}
}
