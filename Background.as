package 
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import Models.Levels.*;
	
	/**
	 * La frise qui défile en fond
	 * @author Neamar
	 */
	public class Background extends Sprite
	{
		/**
		 * Images de fond
		 */
		[Embed(source = "assets/Frise/frise_0.jpg")] private static var F1:Class;
		[Embed(source = "assets/Frise/frise_1.jpg")] private static var F2:Class;
		[Embed(source = "assets/Frise/frise_2.jpg")] private static var F3:Class;
		[Embed(source = "assets/Frise/frise_3.jpg")] private static var F4:Class;
		[Embed(source = "assets/Frise/frise_4.jpg")] private static var F5:Class;
		[Embed(source = "assets/Frise/frise_5.jpg")] private static var F6:Class;
		[Embed(source = "assets/Frise/frise_6.jpg")] private static var F7:Class;
		[Embed(source = "assets/Frise/frise_7.jpg")] private static var F8:Class;
		[Embed(source = "assets/Frise/frise_8.jpg")] private static var F9:Class;
		[Embed(source = "assets/Frise/frise_9.jpg")] private static var F10:Class;
		[Embed(source = "assets/Frise/frise_10.jpg")] private static var F11:Class;
		[Embed(source = "assets/Frise/frise_11.jpg")] private static var F12:Class;
		[Embed(source = "assets/Frise/frise_12.jpg")] private static var F13:Class;
		[Embed(source = "assets/Frise/frise_13.jpg")] private static var F14:Class;
		[Embed(source = "assets/Frise/frise_14.jpg")] private static var F15:Class;

		private static var Frise:Vector.<Class> = new Vector.<Class>();
		{
			//Bloc statique d'initalisation du tableau.
			Frise.push(F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12, F13, F14, F15);
		}
		
		public static const SCROLL_DURATION:int = 3000;
		
		/**
		 * Chaque image fait 800px de largeur. Pour avoir des défilements corrects, il suffit donc d'en avoir deux pendant les transitions.
		 */
		private var Img1:Bitmap = null;
		private var Img2:Bitmap = null;
		
		/**
		 * Le défilement (continu) du scroll selon l'axe X
		 */
		private var currentScrollX:int = -1;
		
		/**
		 * Le défilement (continu) du scroll selon l'axe Y
		 */
		private var currentScrollY:int = -1;
		
		/**
		 * La position de la frise (nombre discret)
		 */
		private var currentPos:int = 0;
		
		/**
		 * Le nombre de .reverse() effectué (modulo 2)
		 */
		private var currentReverse:int = 0;
		
		public function Background()
		{
			moveTo(0);
		}
		
		/**
		 * Décaler la frise vers la position V
		 * @param	v position à atteindre
		 */
		public function moveTo(v:int):void
		{
			TweenLite.to(this, Background.SCROLL_DURATION / 1000 * Math.abs(currentPos - v), { ScrollX:v * Main.LARGEUR} );
			currentPos = v;
		}
		
		/**
		 * Inverse le sens de la frise
		 */
		public function reverse():void
		{
			var Img2D:BitmapData = new BitmapData(Main.LARGEUR, Main.HAUTEUR);
			var Transform:Matrix = new Matrix();
			Transform.scale(1, -1);
			Transform.translate(0, Main.HAUTEUR);
			Img2D.draw(Img1.bitmapData, Transform);
			Img2 = new Bitmap(Img2D);
			addChild(Img2);
			TweenLite.to(this, Background.SCROLL_DURATION / 200, { ScrollY:-Main.HAUTEUR} );
		}
		
		/**
		 * Fonction utilisée pour le défilement continu
		 * Publique car TweenLite doit pouvoir y accéder
		 */
		public function set ScrollX(v:int):void
		{
			//Si changement de décor, mettre à jour les bitmaps.
			if (Math.floor(v / Main.LARGEUR) != Math.floor(currentScrollX / Main.LARGEUR))
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
				addChild(Img1);
			}
			
			Img1.x = - (v % Main.LARGEUR);
			
			if (Img2 == null && v % Main.LARGEUR > 0)
			{
				Img2 = new Frise[Math.floor(v / Main.LARGEUR) + 1]();
				addChild(Img2);
			}
			
			if (v % Main.LARGEUR > 0)
			{
				Img2.x = - (v % Main.LARGEUR) + Main.LARGEUR;
			}
			
			currentScrollX = v;
		}
		
		public function get ScrollX():int
		{
			return currentScrollX;
		}
		
		public function set ScrollY(v:int):void
		{
			Img1.y = - (v % Main.HAUTEUR);
			Img2.y = - (v % Main.HAUTEUR) - Main.HAUTEUR;
			
			currentScrollY = v;
		}
		
		public function get ScrollY():int
		{
			return currentScrollY;
		}
	}
	
}