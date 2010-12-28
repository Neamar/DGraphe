package 
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * La frise qui défile en fond
	 * @author Neamar
	 */
	public class Background extends Sprite
	{
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
			Frise.push(F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12, F13, F14, F15, F1);
		}
		
		private static const SCROLL_DURATION:int = 2000;
		
		private var Img1:Bitmap = null;
		private var Img2:Bitmap = null;
		
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
			Pos = 12;
		}
		
		public function set Pos(v:int):void
		{
			TweenLite.to(this, Background.SCROLL_DURATION / 1000 * Math.abs(currentPos - v), { Scroll:v * Main.LARGEUR } );
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
					Img1.bitmapData.dispose();
					Img1 = null;
				}
				if (Img2 != null)
				{
					removeChild(Img2);
					Img2.bitmapData.dispose();
					
					Img2 = null;
				}
				
				Img1 = new Frise[Offset]();
				Img2 = new Frise[Offset + 1]();
				
				addChild(Img1);
				addChild(Img2);
			}
			
			Img1.x = - (v % Main.LARGEUR);
			Img2.x = - (v % Main.LARGEUR) + Main.LARGEUR;
		}
		
		public function get Scroll():int
		{
			return currentScroll;
		}
		
		
	}
	
}