package 
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
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
		[Embed(source = "assets/hud/chrome/bas.png")]
		private static var HUDBottomImg:Class;
		[Embed(source = "assets/hud/chrome/haut.png")]
		private static var HUDTopImg:Class;
		
		[Embed(source = "assets/hud/tips/tip-level.png")]
		private static var HUDTipLevel:Class;
		private static var tipLevel:Bitmap = new HUDTipLevel();
		
		[Embed(source = "assets/hud/tips/tip-links.png")]
		private static var HUDTipLinks:Class;
		private static var tipLinks:Bitmap = new HUDTipLinks();
		
		[Embed(source = "assets/HUD/messages/main.png")]
		private static var HUDMessageTop:Class;
		[Embed(source = "assets/HUD/messages/bottom.png")]
		private static var HUDMessageBottom:Class;
		[Embed(source = "assets/HUD/messages/fleche.png")]
		private static var HUDMessageFleche:Class;
		
		[Embed(source = "assets/hud/chrome/bras.png")]
		private static var HUDArmsImg:Class;
		
		[Embed(source="assets/hud/chrome/Imagine.ttf",
			fontName = "Imagine",
			mimeType = "application/x-font",
			fontWeight="normal",
			fontStyle="normal",
			advancedAntiAliasing="true",
			embedAsCFF="false")]
		private static var EmbedFont:Class;
	   
		private static var Text_Format:TextFormat = new TextFormat();
		{
				Text_Format.font = "Imagine";
				Text_Format.size = 14;
				Text_Format.color = 0xFFFFFF;
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
		
		//Messages
		private static var messagesSprites:Vector.<Sprite> = new Vector.<Sprite>();
		private static var messageText:TextField = new TextField();
		private static var messageFleche:Bitmap = new HUDMessageFleche();
		
		
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
			Container.mouseEnabled = false;
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
			var topHud:Sprite = new Sprite();
			topHud.addChild(TopImg);
			topHud.addChild(TopTxtSprite);
			topHud.mouseChildren = false;
			Container.addChild(topHud);
			TopTxtSprite.addChild(TopTxtLevel);
			TopTxtSprite.addChild(TopTxtLink);
			
			TopImg.y = 0;
			centerX(TopImg);

			
			TopTxtLink.y = TopTxtLevel.y = 5;
			TopTxtLevel.x = 460;
			TopTxtLink.x = 355;
			centerX(BottomTxt);
			Text_Format.size = 22;
			initTextField(TopTxtLevel);
			initTextField(TopTxtLink);
			
			TopTxtSprite.filters = BottomTxtSprite.filters;		
			
			topHud.addEventListener(MouseEvent.MOUSE_MOVE, displayTip);
			topHud.addEventListener(MouseEvent.MOUSE_OUT, hideTip);
			Container.addChild(tipLevel);
			tipLinks.y = 22;
			tipLevel.y = tipLinks.y - 5;
			
			Container.addChild(tipLinks);
			hideTip();
			
			//MESSAGES
			var message:Sprite;
			for (var i:int = 0; i < 5; i++)
			{
				message = new Sprite();
				message.addChild(new HUDMessageBottom());
				message.getChildAt(0).x = -600;
				message.getChildAt(0).y = -100;
				message.rotationY = 90;
				message.y = Main.HAUTEUR2;
				message.x = 1200;
				Container.addChild(message);
				Container.setChildIndex(message, 0);
				
				messagesSprites.push(message);
			}
			message = messagesSprites[0];
			message.removeChildAt(0);
			initTextField(messageText);
			messageText.x = -580;
			messageText.y = -85;
			messageText.filters = [ new GlowFilter(0, 1, 4, 4, 2) ];
			messageText.width = 360;
			messageText.height = 180;
			messageText.multiline = true;
			messageText.wordWrap = true;
			messageFleche.x = -280;
			messageFleche.y = 55;
			
			message.addChild(new HUDMessageTop());
			message.getChildAt(0).x = - 600;
			message.getChildAt(0).y = -100;
			message.addChild(messageFleche);
			message.addChild(messageText);

			message.addEventListener(MouseEvent.CLICK, hideMessage);
			Container.setChildIndex(message, Container.numChildren - 1);
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
		
		public static function showMessage(title:String, message:String):void
		{
			messageText.alpha = 1;
			messageText.htmlText = "   <font size=\"+10\">" + title + "</font><br><br><font size=\"-2\">" + message;
			for (var i:int = 0; i < messagesSprites.length; i++)
			{		
				TweenLite.to(messagesSprites[i], 2, { rotationY : 30 * i, rotationZ: 10 * i, x:800 } );
			}
			
			messageFleche.filters = [ new GlowFilter(0xFFFFFF, 1, 1, 1)];
			TweenLite.to(messageFleche, 5, { delay:5, glowFilter: {color:0xFF5555, blurX:24, blurY:24, strength:2}});
		}
		
		public static function hideMessage(e:Event):void
		{
			TweenLite.to(messageText, 1, { alpha:0 } );
			for (var i:int = 0; i < messagesSprites.length; i++)
			{
				TweenLite.to(messagesSprites[i], 2, { rotationY : 90, rotationZ: 0, x:1200 } );
			}
			
			messageFleche.filters = [];
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
		
		private static function displayTip(e:MouseEvent):void
		{
			if (TopImg.parent.mouseX - TopImg.x < TopImg.width/2)
			{
				tipLinks.visible = true;
				tipLevel.visible = false;
				tipLinks.x = Container.mouseX - 150;
			}
			else
			{
				tipLevel.visible = true;
				tipLinks.visible = false;
				tipLevel.x = Container.mouseX - 52;
			}
		}
		
		private static function hideTip(e:Event = null):void
		{
			tipLevel.visible = tipLinks.visible = false;
		}
	}
	
}