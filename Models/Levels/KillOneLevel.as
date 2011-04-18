package Models.Levels 
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import Models.Nodes.Node;
	import Models.Nodes.Spring;
	/**
	 * Un niveau de type "ne tuez que lui"
	 * @author Neamar
	 */
	public class KillOneLevel extends Level
	{
		/**
		 * 
		 * @param	Numero
		 * @param	Datas
		 * @param	NbChaines
		 * @param	TheOne Le noeud à tuer
		 * @param	Fond
		 */
		public function KillOneLevel(Noeuds:Vector.<Node>, Ressorts:Vector.<Spring>, NbChaines:int, TheOne:Node, Fond:BitmapData) 
		{
			super(Noeuds, Ressorts, NbChaines, Fond);
			
			for each(var Noeud:Node in Noeuds)
			{
				Noeud.addEventListener(Node.DEAD, failed);
			}
			
			TheOne.removeEventListener(Node.DEAD, failed);
			TheOne.addEventListener(Node.DEAD, nearlyCompleted);
			TheOne.Special = true;
		}
	}

}