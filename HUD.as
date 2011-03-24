package 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * Head Up Display
	 * Affichage d'informations à l'écran via trois panneaux :
	 * - Le haut, qui affiche trois données : le score, le nombre de noeuds restants à couper et le numéro du niveau
	 * - Le milieu qui affiche un message
	 * - Le bas, qui affiche un message de statut
	 * @author Neamar
	 */
	public class HUD extends Sprite
	{
		//Images constituant le HUD
		[Embed(source = "assets/HUD/bas.png")]
		private static var HUDBottomImg:Class;
		[Embed(source = "assets/HUD/haut.png")]
		private static var HUDTopImg:Class;
		[Embed(source = "assets/Imagine.ttf", fontFamily = "Imagine", mimeType="application/x-font-truetype")]
		private static var EmbedFont:String;
	   
		private static var Text_Format:TextFormat = new TextFormat();
		{
				Text_Format.font = "Imagine";
				Text_Format.size = 14;
				//Text_Format.bold = true;
				Text_Format.color = 0xFFFFFF;
		}
		
		private static var Container:Main;
		
		//Bottom
		private static var BottomTxt:TextField = new TextField();
		private static var BottomTxtSprite:Sprite = new Sprite();
		private static var BottomImg:Bitmap = new HUDBottomImg();
		
		//Top
		private static var TopImg:Bitmap = new HUDTopImg();	
		
		
		public static function init(Container:Main):void
		{
			HUD.Container = Container;
			
			//BOTTOM Hud
			Container.addChild(BottomImg);
			Container.addChild(BottomTxtSprite);
			BottomTxtSprite.addChild(BottomTxt);
			
			BottomImg.y = Main.HAUTEUR - BottomImg.height;
			centerX(BottomImg);
			
			BottomTxt.width = BottomImg.width - 40;
			BottomTxt.y = Main.HAUTEUR - BottomImg.height + 10;
			centerX(BottomTxt);
			
			BottomTxt.selectable = false;
			BottomTxt.embedFonts = true;
			BottomTxt.defaultTextFormat = Text_Format;
			
			
			//TOP Hud
			Container.addChild(TopImg);
			TopImg.y = 0;
			centerX(TopImg);
		}
		
		/**
		 * Afficher du texte HTML sur le HUD.
		 * @param	Texte
		 */
		public static function showText(Text:String):void
		{
			BottomTxt.htmlText = Text;
			BottomTxt.x = (Main.LARGEUR - BottomTxt.textWidth) / 2
		}
		
		/**
		 * Centre une image
		 * @param	Img
		 */
		private static function centerX(Img:DisplayObject):void
		{
			Img.x = Main.LARGEUR2 - Img.width / 2
		}
	}
	
}