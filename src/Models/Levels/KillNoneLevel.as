package Models.Levels 
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import Models.Nodes.Node;
	/**
	 * Un niveau où il faut couper tous les liens sans tuer personne.
	 * @author Neamar
	 */
	public class KillNoneLevel extends Level
	{
		
		public function KillNoneLevel(Numero:int, Datas:String, NbChaines:int, Fond:BitmapData)
		{
			super(Numero, Datas, NbChaines, Fond);
			
			for each(var Noeud:Node in Noeuds)
			{
				Noeud.addEventListener(Node.DEAD, failed);
			}
		}
		
		protected override function terminerCoupure(e:MouseEvent):void
		{
			super.terminerCoupure(e);
			
			if (ChainesACouper == 0)
			{
				completed();
			}
		}
	}

}