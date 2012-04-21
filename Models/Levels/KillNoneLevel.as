package Models.Levels 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import Models.Nodes.Node;
	import Models.Nodes.Spring;
	/**
	 * Un niveau où il faut couper tous les liens sans tuer personne.
	 * @author Neamar
	 */
	public class KillNoneLevel extends Level
	{
		
		public function KillNoneLevel(Noeuds:Vector.<Node>, Ressorts:Vector.<Spring>, NbChaines:int, Fond:BitmapData)
		{
			super(Noeuds, Ressorts, NbChaines, Fond);
			
			for each(var Noeud:Node in Noeuds)
			{
				Noeud.addEventListener(Node.DEAD, failed);
			}
		}
		
		/**
		 * Détruit tous les liens entre Start et End
		 * @param	Start point de début
		 * @param	End point de fin
		 * @return les ressorts supprimés
		 */
		public final override function cut(Start:Point, End:Point):Vector.<Spring>
		{
			var R:Vector.<Spring> = super.cut(Start, End);
			
			HUD.showText("Save everyone. Cut <font color=\"#AACCAA\">" + ChainesACouper + "</font> links");
			
			if (ChainesACouper == 0)
			{
				nearlyCompleted();
			}
			return R;
		}
	}

}