package Nodes
{
	import flash.geom.Point;
	import Levels.Level;
	/**
	 * Modélise une attraction (ou répulsion) entre deux objets selon une loi inversement proportionnelle au carré de la distance (type attraction des planètes).
	 * Formule : G / d^2
	 * @author Neamar
	 */
	public class Repulsion extends Interaction
	{

		private var G:int;
		private var minDistance:int;

		/**
		 * Crée une force de répulsion entre les deux entités.
		 * Pour éviter de traiter des forces trop grandes, on impose une distance minimale : si les deux objets sont plus proches que cela, on prendra alors la distance minimale spécifiée et pas la distance réelle (accessoirement, on évite ainsi la division par zéro)
		 * @param	A Première extrémité qui subit la force de répulsion
		 * @param	B Seconde extrémité.
		 * @param	ForceRepulsion L'intensité de la force à appliquer
		 * @param	minDistance La distance minimale.
		 */
		public function Repulsion(A:Node, B:Node, Parent:Level, ForceRepulsion:int=10000, minDistance:int=20)
		{
			super(A, B, Parent);
			
			G = ForceRepulsion;
			this.minDistance = minDistance;
		}		
		
		/**
		 * Met à jour une force de répulsion et l'applique aux deux extrémités.
		 */
		public override final function apply():void
		{
			var dX:int = Math.abs(Bout.x - AutreBout.x);
			var dY:int = Math.abs(Bout.y - AutreBout.y);
			if (dX < 200 && dY < 200)
			{
				//Mettre à jour la force.
				var Distance:int = Math.max(minDistance,Math.sqrt(Math.pow(dX, 2) + Math.pow(dY, 2)));
				
				var absRepulsion:Number = G / Math.pow(Distance, 2);
				AttractionBout.x = absRepulsion * (Bout.x - AutreBout.x) / Distance;
				AttractionBout.y = absRepulsion * (Bout.y - AutreBout.y) / Distance;
				
				AttractionAutreBout.x = - AttractionBout.x;
				AttractionAutreBout.y = - AttractionBout.y;
				
				Bout.applyForce(AttractionBout);
				AutreBout.applyForce(AttractionAutreBout);
			}
		}
		
	}
	
}