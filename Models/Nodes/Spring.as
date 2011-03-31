package Models.Nodes
{
	import Models.Levels.Level;
	/**
	 * Un ressort au sens mécanique du terme.
	 * Réagit proportionnellement à son étirement : -k * DeltaL.
	 * @author Neamar
	 */
	public class Spring extends Interaction
	{
		/**
		 * Les frottements à appliquer à chaque itération
		 */
		private static const FROTTEMENTS:Number = .5;

		/**
		 * Constante de raideur du ressort
		 */
		private var k:Number;
		
		/**
		 * Longueur à vide du ressort
		 */
		private var Longueur:int;
		
		/**
		 * Crée un ressort, dont les extrémités sont A et B. Les paramètres du ressort doivent aussi être spécifiés.
		 * @param	A Première extrémité du ressort
		 * @param	B Seconde extrémité du ressort
		 * @param	ConstanteRessort La constante k du ressort.
		 * @param	LongueurAVide La longueur à vide du ressort (pour lequel il n'y a aucune force)
		 */
		public function Spring(A:Node, B:Node, ConstanteRessort:Number=.15, LongueurAVide:int=100)
		{
			super(A, B);
			k = ConstanteRessort;
			Longueur = LongueurAVide;
		}
		
		public override final function destroy():void
		{
			Parent.Springs.splice(Parent.Springs.indexOf(this), 1);
			Bout.Springs.splice(Bout.Springs.indexOf(this), 1);
			AutreBout.Springs.splice(AutreBout.Springs.indexOf(this), 1);
			super.destroy();
		}

		/**
		 * Calculer la force et l'appliquer à chaque extrémité.
		 */
		public override final function apply():void
		{			
			//Mettre à jour la force.
			var Distance:int = Math.max(1,Math.sqrt(Math.pow(Bout.x - AutreBout.x, 2) + Math.pow(Bout.y - AutreBout.y, 2)));//penser à éviter la division par zéro
			
			//Calculer la valeur absolue (scalaire, pas un vecteur)
			var absForce:Number = k * (Longueur - Distance);
			
			//Puis la projeter sur l'axe défini par les deux points
			AttractionBout.x = absForce * (Bout.x - AutreBout.x) / Distance;
			AttractionBout.y = absForce * (Bout.y - AutreBout.y) / Distance;
			
			//Calculer la force inverse (une force s'applique sur A, l'autre sur B)
			AttractionAutreBout.x = - AttractionBout.x;
			AttractionAutreBout.y = - AttractionBout.y;
			
			//Et appliquer la force aux objets pour le prochain calcul du PFD
			Bout.applyForce(AttractionBout);
			AutreBout.applyForce(AttractionAutreBout);	
		}
		
		/**
		 * Renvoie l'angle formé par les deux noeuds composant l'interaction.
		 * à proprement parler il s'agirait plutôt d'une inclinaison, parler d'angle entre deux points étant incohérent.
		 * 
		 * @param	Origine par rapport à quel noeud exprimer l'angle (variation de Pi)
		 */
		public function angle(Origine:Node):int
		{
			//Un peu de mathématiques
			var Angle:Number = -Math.atan2(AutreBout.y - Bout.y, AutreBout.x - Bout.x);
			
			//Inversion de Pi en fonction du centre
			if (Origine == AutreBout)
			{
				Angle += Math.PI;
			}
			
			//Valeur négative
			if (Angle < 0)
				Angle += 2 * Math.PI;
			return 180 * Angle / Math.PI;
		}
	}
}