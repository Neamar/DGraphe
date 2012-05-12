package 
{
	import com.greensock.OverwriteManager;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

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
		 * Les différents mode.
		 * En version "release", seul MODE_GAME est intéressant
		 */
		public static const MODE_GAME:String = "game"; //Jeu classique
		public static const MODE_CREATOR:String = "creator"; //Pour la création de niveaux
		public static const MODE_INFLUENCE:String = "influence"; //Pour comprendre les répartitions des contraintes

		public static const MODE:String = MODE_GAME;
		
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
		
		public var game:Game;

		public function Main():void 
		{
			addChild(new Monitor());
		
			
			TweenPlugin.activate([GlowFilterPlugin]);
			OverwriteManager.init(OverwriteManager.ALL_IMMEDIATE)
			
			var BG:Background = new Background();
			addChild(BG);

			HUD.init(this);
			HUD.showText('github.com/Neamar/Dgraphe', false);
			
			game = new Game(BG);
			addChild(game);
			
			HUD.onTop();
			
			scrollRect = new Rectangle(0, 0, Main.LARGEUR, Main.HAUTEUR);
		}
	}
}