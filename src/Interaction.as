package 
{
	import flash.geom.Point;
	/**
	 * Classe de base pour les interactions, héritée par Ressort et Repulsion.
	 * Définit les duex extrémités sur lesquels la force doit s'appliquer, et deux vecteurs qui représentent lesdites forces (l'un étant l'opposé de l'autre : AttractionBout= - AttractionAutreBout).
	 * @author Neamar
	 */
	public class Interaction
	{
		
		public var Bout:Node;
		public var AutreBout:Node;
		protected var Parent:Level;
		
		protected var AttractionBout:Vecteur = new Vecteur(0, 0);
		protected var AttractionAutreBout:Vecteur = new Vecteur(0,0);
		
		/**
		 * Une force abstraite d'interaction.
		 * @param	A Première extrémité du ressort
		 * @param	B Seconde extrémité du ressort
		 */
		public function Interaction(A:Node, B:Node,Parent:Level)
		{
			Bout = A;
			AutreBout = B;
			this.Parent = Parent;
			
			Parent.Interactions.push(this);
		}
				
		public function destroy():void
		{
			Parent.Interactions.splice(Parent.Interactions.indexOf(this), 1);
			Bout = AutreBout = null;
			Parent = null;
			delete this;
		}
		
		public function apply():void
		{/*Fonction abstraite*/}
	}
	
}