package Models.Levels 
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import Models.Nodes.Node;
	import Models.Nodes.Spring;
	/**
	 * Un niveau de type "tuez-les tous"
	 * @author Neamar
	 */
	public class KillAllLevel extends Level
	{
		public var NbDead:int = 0;
		
		public function KillAllLevel(Numero:int, Noeuds:Vector.<Node>, Ressorts:Vector.<Spring>, NbChaines:int, Fond:BitmapData) 
		{
			super(Numero, Noeuds, Ressorts, NbChaines, Fond);
			
			for each(var Noeud:Node in Noeuds)
			{
				Noeud.addEventListener(Node.DEAD, decompte);
			}
			
		}
		
		protected function decompte(e:Event):void
		{
			NbDead++;
			if (NbDead == Noeuds.length)
			{
				completed();
			}
		}
	}

}