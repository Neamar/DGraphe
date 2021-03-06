package 
{
	import com.greensock.OverwriteManager;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
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
		[Embed(source = "assets/HUD/messages/second.png")]
		private static var HUDMessageSecond:Class;
		[Embed(source = "assets/HUD/messages/fleche.png")]
		private static var HUDMessageFleche:Class;
		[Embed(source = "assets/HUD/messages/bottom.png")]
		private static var HUDMessageBottom:Class;
		
		[Embed(source = "assets/hud/chrome/bras.png")]
		private static var HUDArmsImg:Class;
		[Embed(source = "assets/HUD/fleches/next.png")]
		private static var HUDArmsNext:Class;
		[Embed(source = "assets/HUD/fleches/previous.png")]
		private static var HUDArmsPrevious:Class;
		
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
		
		public static var Container:Sprite;
		
		//Bottom
		private static var BottomArms:Bitmap = new HUDArmsImg();
		public static var NextButton:Bitmap = new HUDArmsNext();
		public static var PreviousButton:Bitmap = new HUDArmsPrevious();
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
		private static var messageModal:Bitmap = new HUDMessageBottom();
		
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
			var nextButtonSprite:Sprite = new Sprite();
			nextButtonSprite.addChild(NextButton);
			var previousButtonSprite:Sprite = new Sprite();
			previousButtonSprite.addChild(PreviousButton);
			
			Container.addChild(BottomArms);
			Container.addChild(nextButtonSprite);
			Container.addChild(previousButtonSprite);
			Container.addChild(BottomImg);
			Container.addChild(BottomTxtSprite);
			BottomTxtSprite.addChild(BottomTxt);
			
			NextButton.x = 675;
			NextButton.y = 560; 
			NextButton.rotation = -20;
			NextButton.smoothing = true;
			nextButtonSprite.buttonMode = true;
			nextButtonSprite.addEventListener(MouseEvent.CLICK, gotoNextLevel);
			
			PreviousButton.x = 15;
			PreviousButton.y = 513; 
			PreviousButton.rotation = 16;
			PreviousButton.smoothing = true;
			previousButtonSprite.buttonMode = true;
			previousButtonSprite.addEventListener(MouseEvent.CLICK, gotoPreviousLevel);
			
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
			TopTxtLevel.height = TopTxtLink.height = 21;
			TopTxtLevel.width = TopTxtLink.width = 40;
			centerX(BottomTxt);
			Text_Format.size = 22;
			initTextField(TopTxtLevel);
			initTextField(TopTxtLink);
			
			TopTxtSprite.filters = BottomTxtSprite.filters;		
			
			topHud.mouseChildren = false;
			topHud.addEventListener(MouseEvent.MOUSE_MOVE, displayTip);
			topHud.addEventListener(MouseEvent.MOUSE_OUT, hideTip);
			Container.addChild(tipLevel);
			Container.addChild(tipLinks);
			tipLinks.y = 22;
			tipLevel.y = tipLinks.y - 5;
			hideTip();
			
			//MESSAGES
			var message:Sprite;
			for (var i:int = 0; i < 5; i++)
			{
				message = new Sprite();
				message.addChild(new HUDMessageSecond());
				message.getChildAt(0).x = -600;
				message.getChildAt(0).y = -100;
				message.rotationY = 90;
				message.mouseEnabled = message.mouseChildren = false;
				message.y = Main.HAUTEUR2;
				message.x = 1200;
				Container.addChild(message);
				Container.setChildIndex(message, 0);
				
				messagesSprites.push(message);
			}
			message = messagesSprites[0];
			message.mouseEnabled = message.mouseChildren = true;
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
		public static function showText(Text:String, important:Boolean = true):void
		{
			BottomTxt.htmlText = Text;
			BottomTxt.x = (Main.LARGEUR - BottomTxt.textWidth) / 2;
			
			if (important)
			{
				TweenLite.to(BottomTxt, 1, { glowFilter: { color:0x00FF00, blurX:40, blurY:40, strength:10, alpha:.7 }} );
				TweenLite.to(BottomTxt, 1, { delay:1.5, glowFilter: { color:0x000000, blurX:0, blurY:0, strength:0, alpha:0, remove:true }, overwrite:OverwriteManager.AUTO} );
			}
		}
		
		/**
		 * Met à jour le nombre de liens restants
		 * @param	Liens
		 */
		public static function showLink(Liens:int):void
		{
			TopTxtLink.text = Liens.toString();
		}
		
		public static function glowLink():void
		{
			TweenLite.to(TopTxtLink, .5, { glowFilter: { color:0xFF0000, blurX:40, blurY:40, strength:30, alpha:.9 }} );
			TweenLite.to(TopTxtLink, 1, { delay:1.5, glowFilter: { color:0x000000, blurX:0, blurY:0, strength:0, alpha:0, remove:true }, overwrite:OverwriteManager.AUTO} );
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
			Container.addChild(messageModal);
			Container.setChildIndex(messageModal, messagesSprites.length);
			messageModal.alpha = 0;
			TweenLite.to(messageModal, 5, { delay:2, alpha:1 } );
			
			TweenLite.to(messageText, 1, { alpha:1 } );
			messageText.htmlText = "   <font size=\"+10\">" + title + "</font><br><br><font size=\"-2\">" + message + "</font>";
			for (var i:int = 0; i < messagesSprites.length; i++)
			{		
				TweenLite.to(messagesSprites[i], 2, { rotationY : 30 * i, rotationZ: 10 * i, x:800 } );
			}
			
			messageFleche.filters = [ new GlowFilter(0xFFFFFF, 1, 1, 1)];
			TweenLite.to(messageFleche, 5, { delay:5, glowFilter: {color:0xFF5555, blurX:24, blurY:24, strength:2}});
		}
		
		public static function hideMessage(e:Event = null):void
		{
			if (Container.contains(messageModal))
			{
				Container.removeChild(messageModal);
				
				TweenLite.to(messageText, 1, { alpha:0 } );
				for (var i:int = 0; i < messagesSprites.length; i++)
				{
					TweenLite.to(messagesSprites[i], 2, { rotationY : 90, rotationZ: 0, x:1200 } );
				}
				
				messageFleche.filters = [];
			}
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
			if (TopImg.parent.mouseX - TopImg.x < TopImg.width/2 && TopImg.parent.mouseX - TopImg.x > 45 && TopImg.parent.mouseY <= 30)
			{
				tipLevel.x = -500;
				tipLinks.x = Container.mouseX - 150;
			}
			else if (TopImg.parent.mouseX - TopImg.x > TopImg.width/2 && TopImg.parent.mouseX - TopImg.x < 275 && TopImg.parent.mouseY <= 30)
			{
				tipLinks.x = -500;
				tipLevel.x = Container.mouseX - 52;
			}
			

		}

		
		private static function hideTip(e:Event = null):void
		{
			tipLevel.x = tipLinks.x = -500;
		}
		
		private static function gotoNextLevel(e:Event):void
		{
			hideMessage();
			(Container.parent as Main).game.nextLevel();
		}
		
		private static function gotoPreviousLevel(e:Event):void
		{
			hideMessage();
			(Container.parent as Main).game.previousLevel();
		}
	}
	
}