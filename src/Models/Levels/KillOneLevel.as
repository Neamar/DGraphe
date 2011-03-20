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
		 */
		public function KillOneLevel(Numero:int, Noeuds:Vector.<Node>, Ressorts:Vector.<Spring>, NbChaines:int, Fond:BitmapData, TheOne:int) 
		{
			super(Numero, Noeuds, Ressorts, NbChaines, Fond);
			
			for each(var Noeud:Node in Noeuds)
			{
				Noeud.addEventListener(Node.DEAD, failed);
			}
			
			Noeuds[TheOne].removeEventListener(Node.DEAD, failed);
			Noeuds[TheOne].addEventListener(Node.DEAD, completed);
			//Noeuds[TheOne].filters = [new BlurFilter(8, 8)];
		}
	}

}