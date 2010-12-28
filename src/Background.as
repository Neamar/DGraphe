package 
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import Levels.KillAllLevel;
	import Levels.Level;
	
	/**
	 * La frise qui défile en fond
	 * @author Neamar
	 */
	public class Background extends Sprite
	{
		/**
		 * Images de fond
		 */
		
		[Embed(source = "../assets/Frise/frise_0.jpg")]
		private static var F1:Class;
		[Embed(source = "../assets/Frise/frise_1.jpg")]
		private static var F2:Class;
		[Embed(source = "../assets/Frise/frise_2.jpg")]
		private static var F3:Class;
		[Embed(source = "../assets/Frise/frise_3.jpg")]
		private static var F4:Class;
		[Embed(source = "../assets/Frise/frise_4.jpg")]
		private static var F5:Class;
		[Embed(source = "../assets/Frise/frise_5.jpg")]
		private static var F6:Class;
		[Embed(source = "../assets/Frise/frise_6.jpg")]
		private static var F7:Class;
		[Embed(source = "../assets/Frise/frise_7.jpg")]
		private static var F8:Class;
		[Embed(source = "../assets/Frise/frise_8.jpg")]
		private static var F9:Class;
		[Embed(source = "../assets/Frise/frise_9.jpg")]
		private static var F10:Class;
		[Embed(source = "../assets/Frise/frise_10.jpg")]
		private static var F11:Class;
		[Embed(source = "../assets/Frise/frise_11.jpg")]
		private static var F12:Class;
		[Embed(source = "../assets/Frise/frise_12.jpg")]
		private static var F13:Class;
		[Embed(source = "../assets/Frise/frise_13.jpg")]
		private static var F14:Class;
		[Embed(source = "../assets/Frise/frise_14.jpg")]
		private static var F15:Class;

		private static var Frise:Vector.<Class> = new Vector.<Class>();
		//Bloc statique d'initalisation du tableau.
		{
			Frise.push(F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12, F13, F14, F15);
		}
		
		/**
		 * Niveaux
		 */
		private static var LevelsList:Vector.<Function> = new Vector.<Function>();
		{
			LevelsList.push(
			function():Level
			{
				return new KillAllLevel(1,'280,300|380,260|420,260|520,300|420,340|380,340:0,1|1,2|2,3|3,4|4,5|5,0|1,4|0,3',10);
			},
			function():Level
			{
				return new Level(1,'360,220|460,220|380,280|440,280|460,340|360,340|280,280|540,280:0,6|6,5|5,0|0,1|1,4|5,4|4,7|7,1|1,3|3,4|3,2|2,5|2,0',8);	
			},
			function():Level
			{
				return new Level(1,'320,120|360,160|400,200|440,240|480,280|520,320|280,160|240,200|200,240|160,280|120,320|320,400:11,10|9,11|11,8|11,7|11,6|11,0|1,11|11,2|11,3|11,4|11,5',10);
			},
			function():Level
			{
				return new Level(1, '360,200|360,240|360,280|360,320|360,360|360,400|240,400|480,400|360,160|240,40|480,40:0,6|6,1|2,6|6,3|6,4|6,5|5,7|7,4|3,7|2,7|1,7|0,7|6,8|8,7|10,7|9,6|9,8|8,10', 10);
			}
			);
		}
		
		private static const SCROLL_DURATION:int = 3000;
		
		private var Img1:Bitmap = null;
		private var Lvl1:Level = null;
		private var Img2:Bitmap = null;
		private var Lvl2:Level = null;
		
		/**
		 * Le défilement (continu) du scroll
		 */
		private var currentScroll:int = -1;
		
		/**
		 * La position de la frise (nombre discret)
		 */
		private var currentPos:int = 0;
		
		public function Background()
		{		
			Pos = 3;
		}
		
		public function raz():void
		{
			trace("raz");
			Pos = 1;
		}
		
		public function set Pos(v:int):void
		{
			TweenLite.to(this, Background.SCROLL_DURATION / 1000 * Math.abs(currentPos - v), { Scroll:v * Main.LARGEUR, onComplete:this.raz } );
			currentPos = v;
		}
		
		public function set Scroll(v:int):void
		{
			//Si changement de décor, mettre à jour les bitmaps.
			if (Math.floor(v / Main.LARGEUR) != Math.floor(currentScroll / Main.LARGEUR))
			{
				var Offset:int = Math.floor(v / Main.LARGEUR);
				if (Img1 != null)
				{
					removeChild(Img1);
					removeChild(Lvl1);
					Img1.bitmapData.dispose();
					Lvl1.destroy();
					Img1 = null;
					Lvl1 = null;
				}
				if (Img2 != null)
				{
					removeChild(Img2);
					Img2.bitmapData.dispose();
					Img2 = null;
				}
				
				Img1 = new Frise[Offset]();
				if (Lvl2 == null)
					Lvl1 = LevelsList[Offset]();
				else
					Lvl1 = Lvl2;
				addChild(Img1);
				addChild(Lvl1);
				
				
				if (v % Main.LARGEUR > 0)
				{
					Img2 = new Frise[Offset + 1]();
					Lvl2 = LevelsList[Offset + 1]();
					addChild(Img2);
					addChild(Lvl2);
				}
			}
			
			Img1.x = - (v % Main.LARGEUR);
			Lvl1.x = Img1.x + Main.LARGEUR2;
			
			if (Img2 != null)
			{
				Img2.x = - (v % Main.LARGEUR) + Main.LARGEUR;
				Lvl2.x = Img2.x + Main.LARGEUR2;
			}
			
			currentScroll = v;
			
		}
		
		public function get Scroll():int
		{
			return currentScroll;
		}
		
		
	}
	
}