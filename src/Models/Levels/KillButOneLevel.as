package Models.Levels 
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import Models.Nodes.Node;
	import Models.Nodes.Spring;
	/**
	 * Un niveau de type "tuez-les tous sauf lui"
	 * @author Neamar
	 */
	public class KillButOneLevel extends Level
	{
		public var NbDead:int = 0;
		public var TheOne:Node;
		/**
		 * 
		 * @param	Numero
		 * @param	Datas
		 * @param	NbChaines
		 * @param	TheOne Le noeud à sauver
		 */
		public function KillButOneLevel(Noeuds:Vector.<Node>, Ressorts:Vector.<Spring>, NbChaines:int, TheOne:Node, Fond:BitmapData)
		{
			super(Noeuds, Ressorts, NbChaines, Fond);
			
			for each(var Noeud:Node in Noeuds)
			{
				Noeud.addEventListener(Node.DEAD, decompte);
			}
			
			TheOne.removeEventListener(Node.DEAD, decompte);
			TheOne.addEventListener(Node.DEAD, failed);
			TheOne.Special = true;
		}
		
		protected function decompte(e:Event):void
		{
			trace('Décompte');
			NbDead++;
			if (NbDead + 1 == Noeuds.length)
			{
				//Ils sont tous morts sauf un, bien joué !
				completed();
			}
		}
	}

}