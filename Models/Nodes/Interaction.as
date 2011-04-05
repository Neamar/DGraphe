package Models.Nodes
{
	import flash.geom.Point;
	import Models.Levels.Level;
	
	/**
	 * Classe de base pour les interactions, héritée par Ressort et Repulsion.
	 * Définit les deux extrémités sur lesquels la force doit s'appliquer, et deux vecteurs qui représentent lesdites forces (l'un étant l'opposé de l'autre : AttractionBout= - AttractionAutreBout).
	 * @author Neamar
	 */
	public class Interaction
	{
		
		public var Bout:Node;
		public var AutreBout:Node;
		
		protected var AttractionBout:Vecteur = new Vecteur(0, 0);
		protected var AttractionAutreBout:Vecteur = new Vecteur(0, 0);
		
		protected var Parent:Level;
		
		/**
		 * Une force abstraite d'interaction.
		 * @param	A Première extrémité du ressort
		 * @param	B Seconde extrémité du ressort
		 */
		public function Interaction(A:Node, B:Node)
		{
			Bout = A;
			AutreBout = B;
		}
		
		/**
		 * Définit le parent de cette interaction.
		 * @param	L l'objet Level à utiliser comme parent
		 */
		public function setParent(L:Level):void
		{
			this.Parent = L;
		}
		
		public function destroy():void
		{
			Parent.Interactions.splice(Parent.Interactions.indexOf(this), 1);
			Bout = AutreBout = null;
			Parent = null;
			AttractionAutreBout = null;
			AttractionBout = null;
			
			delete this;
		}
		
		public function apply():void
		{
			throw new Error('Appel méthode abstraite');
		}
	}
}