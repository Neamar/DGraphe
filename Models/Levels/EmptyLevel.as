package Models.Levels 
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import Models.Nodes.Node;
	import Models.Nodes.Spring;
	
	/**
	 * Un niveau de type "coupez ce nombre de chaines" (RP : pour récupérer de l'énergie par exemple :D)
	 * @author Neamar
	 */
	public final class EmptyLevel extends Level
	{
		public function EmptyLevel()
		{
			super(new Vector.<Node>, new Vector.<Spring>, 0, new BitmapData(Main.LARGEUR, Main.HAUTEUR, true, 0));
			
			HUD.Container.addEventListener(MouseEvent.CLICK, completed);
		}
		
		public override function destroy():void
		{
			HUD.Container.removeEventListener(MouseEvent.CLICK, completed);
		}
	}

}