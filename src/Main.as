package 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	* Permet de mettre en forme un arbre.
	* @author Neamar
	*/
	public class Main extends Sprite 
	{
		public static const LARGEUR:int = 800;
		public static const HAUTEUR:int = 600;
		public static const LARGEUR2:int = 400;
		public static const HAUTEUR2:int = 300;

		private var Conteneur:Sprite = new Sprite();

		public function Main():void 
		{
			addChild(new Level(1,'280,300|380,260|420,260|520,300|420,340|380,340:0,1|1,2|2,3|3,4|4,5|5,0|1,4|0,3',10));
			//addChild(new Level(1,'360,220|460,220|380,280|440,280|460,340|360,340|280,280|540,280:0,6|6,5|5,0|0,1|1,4|5,4|4,7|7,1|1,3|3,4|3,2|2,5|2,0',8));
			//addChild(new Level('320,120|360,160|400,200|440,240|480,280|520,320|280,160|240,200|200,240|160,280|120,320|320,400:11,10|9,11|11,8|11,7|11,6|11,0|1,11|11,2|11,3|11,4|11,5',10));
			//addChild(new Level(1,'360,200|360,240|360,280|360,320|360,360|360,400|240,400|480,400|360,160|240,40|480,40:0,6|6,1|2,6|6,3|6,4|6,5|5,7|7,4|3,7|2,7|1,7|0,7|6,8|8,7|10,7|9,6|9,8|8,10',10));

			addChild(HUD.init());
			HUD.showText('Version de test en développement.');
		}
	}
}