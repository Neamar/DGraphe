package Models.Levels 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import Models.Nodes.Node;
	import Models.Nodes.Spring;
	
	/**
	 * Un niveau de type "coupez ce nombre de chaines" (RP : pour récupérer de l'énergie par exemple :D)
	 * @author Neamar
	 */
	public class CutAllLevel extends Level
	{
		/**
		 * 
		 * @param	Noeuds
		 * @param	Ressorts
		 * @param	NbChaines
		 * @param	Fond
		 */
		public function CutAllLevel(Noeuds:Vector.<Node>, Ressorts:Vector.<Spring>, NbChaines:int, Fond:BitmapData)
		{
			super(Noeuds, Ressorts, NbChaines, Fond);
		}
				
		/**
		 * Teste la condition de victoire
		 * @param	Start point de début
		 * @param	End point de fin
		 * @return les objets supprimés
		 */
		public override function cut(Start:Point, End:Point):Vector.<Spring>
		{
			var Retour:Vector.<Spring> = super.cut(Start, End);
			
			HUD.showText("Remove <font color=\"#AACCAA\">" + ChainesACouper + "</font> link" + (ChainesACouper > 1?'s':''));
			if (ChainesACouper == 0)
			{
				completed();
			}
			
			return Retour;
		}
	}

}