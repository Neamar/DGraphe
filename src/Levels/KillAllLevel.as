package Levels 
{
	import flash.events.Event;
	import Nodes.Node;
	/**
	 * Un niveau de type "tuez-les tous"
	 * @author Neamar
	 */
	public class KillAllLevel extends Level
	{
		public var NbDead:int = 0;
		
		public function KillAllLevel(Numero:int, Datas:String, NbChaines:int) 
		{
			super(Numero, Datas, NbChaines);
			
			for each(var Noeud:Node in Noeuds)
			{
				Noeud.addEventListener(Node.DEAD, decompte);
			}
			
		}
		
		protected function decompte(e:Event):void
		{
			trace('DEcompte');
			NbDead++;
			if (NbDead == Noeuds.length)
			{
				completed();
			}
		}
	}

}