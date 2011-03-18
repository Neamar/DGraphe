package Models.Levels 
{
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import Nodes.Node;
	/**
	 * Un niveau de type "tuez-les tous sauf lui"
	 * @author Neamar
	 */
	public class KillButOneLevel extends Level
	{
		public var NbDead:int = 0;
		
		/**
		 * 
		 * @param	Numero
		 * @param	Datas
		 * @param	NbChaines
		 * @param	TheOne Le noeud à sauver
		 */
		public function KillButOneLevel(Numero:int, Datas:String, NbChaines:int, TheOne:int) 
		{
			super(Numero, Datas, NbChaines);
			
			for each(var Noeud:Node in Noeuds)
			{
				Noeud.addEventListener(Node.DEAD, decompte);
			}
			
			Noeuds[TheOne].removeEventListener(Node.DEAD, decompte);
			Noeuds[TheOne].addEventListener(Node.DEAD, failed);
			Noeuds[TheOne].filters = [new BlurFilter(8, 8)];
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