package 
{
	import com.greensock.OverwriteManager;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.net.sendToURL;
	import flash.net.URLRequest;
	import mochi.as3.MochiEvents;
	import mochi.as3.MochiServices;

	/**
	* LightningMagnet !
	* Un jeu flash sans aucune prétention, basé sur un petit moteur physique.
	* Codage par Neamar (http://neamar.fr)
	* Graphisme par Licoti (http://licoti.fr)
	* 
	* @see http://blog.neamar.fr/component/content/article/18-algorithmie-et-optimisation/107-affichage-graphe-optimise
	* 
	* @author Neamar
	*/
	public final dynamic class Main extends Sprite 
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
			CONFIG::debug
			{
				addChild(new Monitor());
			}
		
			
			TweenPlugin.activate([GlowFilterPlugin]);
			OverwriteManager.init(OverwriteManager.ALL_IMMEDIATE)
			
			var BG:Background = new Background();
			addChild(BG);

			HUD.init(this);
			HUD.showText('neamar.fr/Res/LightningMagnet', false);
			
			game = new Game(BG);
			addChild(game);
			
			HUD.onTop();
			
			scrollRect = new Rectangle(0, 0, Main.LARGEUR, Main.HAUTEUR);
			
			//Enregistrer le nouveau joueur de façon asynchrone :
			sendToURL(new URLRequest("http://neamar.fr/Res/LightningMagnet/Player.php"));
			
			//Connexion à Mochi :
			MochiServices.connect("f4d0cb239bef731e", this);
			MochiEvents.startPlay();
		}
	}
}