package 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
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
		
		[Embed(source = "assets/HUD/bras.png")]
		private static var HUDArmsImg:Class;
		
		[Embed(source = "assets/Imagine.ttf", fontFamily = "Imagine", mimeType="application/x-font-truetype")]
		private static var EmbedFont:String;
	   
		private static var Text_Format:TextFormat = new TextFormat();
		{
				Text_Format.font = "Imagine";
				Text_Format.size = 14;
				//Text_Format.bold = true;
				Text_Format.color = 0xFF0000;
		}
		
		private static var Container:Sprite;
		
		//Bottom
		private static var BottomArms:Bitmap = new HUDArmsImg();
		private static var BottomTxt:TextField = new TextField();
		private static var BottomTxtSprite:Sprite = new Sprite();
		private static var BottomImg:Bitmap = new HUDBottomImg();
		
		//Top
		private static var TopImg:Bitmap = new HUDTopImg();
		private static var TopTxtLink:TextField = new TextField();
		private static var TopTxtLevel:TextField = new TextField();
		private static var TopTxtSprite:Sprite = new Sprite();
		
		//Message
		private static var MsgBack1:Shape = new Shape();
		private static var MsgBack2:Shape = new Shape();
		private static var MsgSprite:Shape = new Shape();
		
		
		
		public static function init(Stage:Main):void
		{
			/**
			 * Initialise un champ de texte pour son affichage dans le HUD
			 * @param	TF
			 */
			function initTextField(TF:TextField):void
			{
				TF.selectable = false;
				TF.embedFonts = true;
				TF.defaultTextFormat = Text_Format;
			}
			
			Container = new Sprite();
			Stage.addChild(Container);
			
			//BOTTOM Hud
			Container.addChild(BottomArms);
			Container.addChild(BottomImg);
			Container.addChild(BottomTxtSprite);
			BottomTxtSprite.addChild(BottomTxt);
			
			BottomArms.y = Main.HAUTEUR - BottomArms.height;
			centerX(BottomArms);
			BottomImg.y = Main.HAUTEUR - BottomImg.height;
			centerX(BottomImg);
			
			BottomTxt.width = BottomImg.width - 40;
			BottomTxt.y = Main.HAUTEUR - BottomImg.height + 21;
			centerX(BottomTxt);
			initTextField(BottomTxt);
			
			BottomTxtSprite.filters = [ new GlowFilter(0xCCCCCC, 1, 4, 4, 1) ];
			
			
			
			//TOP Hud
			Container.addChild(TopImg);
			Container.addChild(TopTxtSprite);
			TopTxtSprite.addChild(TopTxtLevel);
			TopTxtSprite.addChild(TopTxtLink);
			
			TopImg.y = 0;
			centerX(TopImg);
			
			TopTxtLink.y = TopTxtLevel.y = 5;
			TopTxtLevel.x = 485;
			TopTxtLink.x = 310;
			centerX(BottomTxt);
			Text_Format.size = 22;
			initTextField(TopTxtLevel);
			initTextField(TopTxtLink);
			
			TopTxtSprite.filters = BottomTxtSprite.filters;
			
			
			//Messages
			function drawMsgBottom(MsgBack:Shape):void
			{
				MsgBack.graphics.clear();
				MsgBack.graphics.beginFill(0xDDDDDD);
				MsgBack.graphics.lineStyle(1, 0xFFFFFF);
				MsgBack.graphics.drawRoundRect(-600, -100, 400, 200, 25, 25);
				MsgBack.graphics.endFill();
				MsgBack.alpha = .3;
				MsgBack.y = Main.HAUTEUR2;
			}
			//Container.addChild(MsgBack1);
			//Container.addChild(MsgBack2);
			
			drawMsgBottom(MsgBack1);
			MsgBack1.x = 800;
			MsgBack1.rotationY = 20;
			//MsgBack1.rotationZ = 20;
			MsgBack1.z = 20;
			
			drawMsgBottom(MsgBack2);
			MsgBack2.x = 800;
			MsgBack2.rotationY = 40;
			//MsgBack2.rotationZ = 40;
			MsgBack2.z = 40;
			
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
		 * Met à jour le nombre de liens restants
		 * @param	Liens
		 */
		public static function showLink(Liens:int):void
		{
			TopTxtLink.text = Liens.toString();
		}
		
		/**
		 * Met à jour le numéro du niveau en cours
		 * @param	Niveau
		 */
		public static function showLevel(Niveau:int):void
		{
			TopTxtLevel.text = Niveau.toString();
		}
		
		/**
		 * Remet le HUD au dessus de tous les élèments
		 */
		public static function onTop():void
		{
			Container.parent.setChildIndex(Container, Container.parent.numChildren - 1);
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