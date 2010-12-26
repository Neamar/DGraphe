package 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Neamar
	 */
	public class HUD extends Sprite
	{
		private static var Container:Sprite = new Sprite();
		private static var HUDTxt:TextField = new TextField();
		private static var HUDDisplay:DisplayObject = null;
		public static function init():Sprite
		{
			Container.y = Main.HAUTEUR - 15;
			HUDTxt.selectable = false;
			HUDTxt.autoSize = TextFieldAutoSize.LEFT;
			return Container;
		}
		
		/**
		 * Afficher un objet sur le HUD.
		 * @param	Item
		 */
		public static function display(Item:DisplayObject):void
		{
			if (HUDDisplay != null && Container.contains(HUDDisplay))
				Container.removeChild(HUDDisplay);
				
			Container.addChild(Item);
		}
		
		/**
		 * Afficher du texte HTML sur le HUD.
		 * @param	Texte
		 */
		public static function showText(Texte:String):void
		{
			HUDTxt.htmlText = Texte;
			HUDTxt.x = (Main.LARGEUR - HUDTxt.textWidth) / 2
			HUDTxt.border = true;
			HUD.display(HUDTxt);
		}
	}
	
}