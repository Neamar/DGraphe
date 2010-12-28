package Nodes
{
	import com.oaxoa.fx.Lightning;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import Levels.Level;
	/**
	 * Un ressort au sens mécanique du terme.
	 * Réagit proportionnellement à son étirement : -k * DeltaL.
	 * @author Neamar
	 */
	public class Spring extends Interaction
	{
		private static const NODE_RADIUS:int = 10;
		private static const FROTTEMENTS:Number = .5;
		private static const GLOW:Array = new Array(new GlowFilter(0xFF0000, .8, 10, 10, 1, 1), new DropShadowFilter());

		private var k:Number;
		private var Longueur:int;
		private var Eclair:Lightning;
		/**
		 * Crée un ressort, dont les extrémités sont A et B. Les paramètres du ressort doivent aussi être spécifiés.
		 * @param	A Première extrémité du ressort
		 * @param	B Seconde extrémité du ressort
		 * @param	ConstanteRessort La constante k du ressort.
		 * @param	LongueurAVide La longueur à vide du ressort (pour lequel il n'y a aucune force)
		 */
		public function Spring(A:Node, B:Node, Parent:Level, ConstanteRessort:Number=.15, LongueurAVide:int=100)
		{
			super(A, B, Parent);
			k = ConstanteRessort;
			Longueur = LongueurAVide;
			Parent.Springs.push(this);
			
			Eclair = new Lightning(0xFF0000, 2);
			//Eclair.blendMode=BlendMode.ADD;
			Eclair.childrenDetachedEnd=false;
			Eclair.childrenLifeSpanMin=.1;
			Eclair.childrenLifeSpanMax=2;
			Eclair.childrenMaxCount=2;
			Eclair.childrenMaxCountDecay = .5;
			Eclair.amplitude = .3;
			Eclair.steps = 50;
			Eclair.speed = .09;
			Eclair.childrenProbability=.3;
			Eclair.smoothPercentage = 50;
			Eclair.filters = GLOW;

			Parent.addChild(Eclair);
			Parent.setChildIndex(Eclair, 1);
			
		}
		
		public override final function destroy():void
		{
			Parent.Springs.splice(Parent.Springs.indexOf(this), 1);
			Eclair.kill();
			Eclair.graphics.clear();
			super.destroy();
		}
			
		/**
		 * Calculer la force et l'appliquer à chaque extrémité.
		 */
		public override final function apply():void
		{
			Eclair.startX = Bout.x;
			Eclair.startY = Bout.y;
			Eclair.endX = AutreBout.x;
			Eclair.endY = AutreBout.y;
			Eclair.update();
			
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
	}
	
}