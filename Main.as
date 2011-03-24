package 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	* DGraphe !
	* Un jeu flash sans aucune prétention, basé sur un petit moteur physique.
	* Codage par Neamar (http://neamar.fr)
	* Graphisme par Licoti (http://licoti.fr)
	* 
	* @see http://blog.neamar.fr/component/content/article/18-algorithmie-et-optimisation/107-affichage-graphe-optimise
	* 
	* @author Neamar
	*/
	public class Main extends Sprite 
	{
		/**
		 * Permet de passer en mode débuggage
		 * Sur true, les niveaux ne peuvent pa être perdus, et une carte des déplacements s'affiche.
		 */
		public static const DEBUG_MODE:Boolean = false;
		
		/**
		 * Largeur totale de l'animation
		 */
		public static const LARGEUR:int = 800;
		/**
		 * Hauteur totale de l'animation
		 */
		public static const HAUTEUR:int = 600;
		
		/**
		 * Moitié de la largeur (LARGEUR / 2)
		 */
		public static const LARGEUR2:int = 400;
		
		/**
		 * Moitié de la hauteur (HAUTEUR / 2)
		 */
		public static const HAUTEUR2:int = 300;

		public function Main():void 
		{
			var BG:Background = new Background();
			addChild(BG);

			HUD.init(this)
			HUD.showText('Version de test en développement.');
			
			addChild(new Game(BG));
		}
	}
}