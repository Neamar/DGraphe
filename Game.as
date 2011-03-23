package 
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import Models.Levels.*;
	import Models.Nodes.Node;
	import Models.Nodes.Spring;
	import Views.View;
	import Views.VLevel;
	import Views.VSpring;
	
	/**
	 * Objet représentant le jeu dans son intégralité;
	 * Instancié une fois les initialisations de base terminées et le jeu prêt à démarrer.
	 * @author Neamar
	 */
	public class Game extends Sprite
	{
		/**
		 * Liste des images pour les niveaux.
		 * Chargées en Embed.
		 */
		[Embed(source = "assets/Niveaux/1.png")]
		private static var Niveau1:Class;
		[Embed(source = "assets/Niveaux/3.png")]
		private static var Niveau3:Class;
		[Embed(source = "assets/Niveaux/4.png")]
		private static var Niveau4:Class;
		[Embed(source = "assets/Niveaux/5.png")]
		private static var Niveau5:Class;
		[Embed(source = "assets/Niveaux/6.png")]
		private static var Niveau6:Class;
		
		/**
		 * Niveaux
		 */
		public static var LevelsList:Vector.<Function> = new Vector.<Function>();
		{
			LevelsList.push(
				function():Level
				{
					//FONCTIONNEL (et hard !)
					//Couper la croix centrale.
					//Couper le lien horizontal et attendre que les deux noeuds ainsi libérés se retrouvent à la verticale avec les les noeuds juste en dessous
					//Couper alors d'un coup les deux liens au dessus de la partie basse horizontale, on se retrouve avec trois composantes "à deux noeuds".
					//Couper une par une chacune de ces composantes, dans l'ordre le plus logique en fonction de leurs positions.
					var Parts:Array = Game.buildNodes('280,300|380,260|420,260|520,300|420,340|380,340:0,1|1,2|2,3|3,4|4,5|5,0|1,4|0,3');
					return new KillNoneLevel(Parts[0], Parts[1], 8, (new Niveau1()).bitmapData);
				},
				function():Level
				{
					//FONCTIONNEL
					//Couper les trois liens du haut
					//Couper ensuite les deux liens du bas
					//Couper enfin à gauche, puis à droite.
					var Parts:Array = Game.buildNodes('400,181|467,198|511,252|518,319|432,416|489,381|333,198|289,252|282,319|368,416|311,381|400,300:11,10|9,11|11,8|11,7|11,6|11,0|1,11|11,2|11,3|11,4|11,5|2,5|2,7|7,10|10,5');
					return new KillNoneLevel(Parts[0], Parts[1], 11,  (new Niveau4()).bitmapData);
				},
				function():Level
				{
					//FONCTIONNEL
					//Attendre quelques secondes la résolution des contraintes : deux noeuds tombent direct
					//Couper en bas, deux noeuds sont expulsés (sans tomber pour l'instant)
					//En haut, deux noeuds attendent d'être catapultés (structure instable) : les virer
					//Ouvrir enfin la structure obtenue en X, puis couper. Adios !
					var Parts:Array = Game.buildNodes('400,222|400,260|400,307|400,350|400,386|400,422|319,300|481,300|400,183|286,191|514,191:0,6|6,1|2,6|6,3|6,4|6,5|5,7|7,4|3,7|2,7|1,7|0,7|6,8|8,7|10,7|9,6|9,8|8,10');
					return new KillButOneLevel(Parts[0], Parts[1], 14, Parts[0][8], (new Niveau3()).bitmapData);
				},
				function():Level
				{
					//FONCTIONNEL
					//Couper selon les axes :p
					//Attention : verticalement central, ne pas couper le lien le plus en bas
					var Parts:Array = Game.buildNodes('170,154|274,152|272,250|167,272|355,150|359,245|441,245|445,150|526,152|528,250|633,272|630,154|250,363|354,341|446,341|550,363|342,448|458,448:3,0|0,1|1,2|2,3|7,4|4,5|5,6|6,7|11,8|8,9|9,10|10,11|7,9|6,8|1,5|2,4|15,9|9,6|6,14|14,15|14,5|13,6|12,13|13,5|5,2|2,12|17,14|14,13|13,16|16,17|1,4|7,8');
					return new KillNoneLevel(Parts[0], Parts[1], 29, (new Niveau5()).bitmapData);
				},
				function():Level
				{
					//Fonctionnel
					//Dans la structure du bas, couper d'un coup les deux liens sud sud est (liant le noeud "jointure entre deux bras fixes" et le bras de droite).
					var Parts:Array = Game.buildNodes('400,320|320,260|240,200|300,340|200,360|480,380|560,440|400,400|400,480|300,440|340,380|460,260|500,180:2,1|1,0|4,3|3,0|6,5|5,0|8,7|7,0|4,9|0,11|11,12|9,3|9,8|9,7');
					Parts[0][0].Fixe = true;
					return new KillOneLevel(Parts[0], Parts[1], 25, Parts[0][10], (new Niveau6()).bitmapData);
				}

			);
		}
		
		/**
		 * Construit un tableau d'objets à partir d'un string descriptif
		 * @param	datas la chaîne en entrée
		 * @return un tableau avec deux paramètres : la liste des noeuds, et la liste des ressorts
		 */
		public static function buildNodes(datas:String):Array
		{
			var Composants:Array;
			var Part:Array=datas.split(":");
			var strNoeuds_Array:Array=Part[0].split("|");
			var strArc_Array:Array = Part[1].split("|");
			
			var Noeuds:Vector.<Node> = new Vector.<Node>();
			var Ressorts:Vector.<Spring> = new Vector.<Spring>();
			/**
			 * Construire la liste des noeuds
			 */
			for each(var Noeud:String in strNoeuds_Array)
			{
				Composants = Noeud.split(",");
				var NouveauNoeud:Node = new Node(Composants[0] - Main.LARGEUR2, Composants[1] - Main.HAUTEUR2);
				Noeuds.push(NouveauNoeud);
			}
			
			/**
			 * Construire la liste des ressorts
			 */
			for each(var Arete:String in strArc_Array)
			{
				Composants = Arete.split(",");
				var NouveauRessort:Spring = Noeuds[Composants[0]].connectTo(Noeuds[Composants[1]])
				Ressorts.push(NouveauRessort);
			}
			
			return [Noeuds, Ressorts];
		}
		
		
		
		
				
		/**
		 * Le numéro du niveau actuel
		 */
		private var LevelNumber:int = -1;
		/**
		 * L'objet niveau chargé
		 */
		private var LevelObject:Level = null;
		
		/**
		 * La vue associée au niveau
		 */
		private var VLevelObject:VLevel;
		
		private var BG:Background;
		
		/**
		 * Lancement du jeu !
		 * @param BG l'objet background à utiliser
		 */
		public function Game(BG:Background)
		{
			this.BG = BG;
			nextLevel();
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		/**
		 * Passe au niveau suivant
		 * @param	e évènement Level.WIN
		 */
		protected function nextLevel(e:Event = null):void
		{
			if (LevelObject != null)
			{
				LevelObject.removeEventListener(Level.LOST, retryLevel);
				LevelObject.removeEventListener(Level.WIN, nextLevel);
				
				var OldLevel:Level = LevelObject;
				var OldVLevel:VLevel = VLevelObject;
				var G:Game = this;
				TweenLite.to(
					VLevelObject,
					.5,
					{
						alpha:0,
						onComplete:function():void
						{
							G.removeChild(OldVLevel);
							OldLevel.destroy();
							OldVLevel.destroy();
						}
					}
				);
			}
			
			//Afficher le nouveau niveau
			LevelNumber++;
			this.loadLevel();
		}
		
		/**
		 * Recommence le niveau actuel
		 * @param	e
		 */
		protected function retryLevel(e:Event = null):void
		{
			var OldLevel:Level = LevelObject;
			var OldVLevel:VLevel = VLevelObject;
			var G:Game = this;
			//BG.reverse();
			TweenLite.to(
				VLevelObject,
				.5,
				{
					alpha:0,
					onComplete:function():void
					{
						G.removeChild(OldVLevel);
						OldLevel.destroy();
						OldVLevel.destroy();
					}
				}
			);
			
			LevelObject.removeEventListener(Level.LOST, retryLevel);
			LevelObject.removeEventListener(Level.WIN, nextLevel);
			
			LevelObject = null;
			VLevelObject = null;
			
			this.loadLevel();
		}
		
		/**
		 * Charge le niveau actuel.
		 * Consdère que les opérations de nettoyage ont été effectuées !
		 */
		protected function loadLevel():void
		{
			/**
			 * Charger...
			 */
			LevelObject = new Game.LevelsList[LevelNumber];
			VLevelObject = new VLevel(LevelObject);
			LevelObject.addEventListener(Level.LOST, retryLevel);
			LevelObject.addEventListener(Level.WIN, nextLevel);
			
			/**
			 * ...et afficher
			 */
			VLevelObject.alpha = 0;
			addChild(VLevelObject);
			TweenLite.to(
				VLevelObject,
				1,
				{
					alpha:1
				}
			);
			
			BG.moveTo(LevelNumber);
		}
		
		protected final function update(e:Event = null):void
		{
			if (LevelObject != null)
			{
				//Mettre à jour le niveau
				LevelObject.update();
			}
			
			if (VLevelObject != null)
			{
				//Mettre à jour les vues
				VLevelObject.update();
			}
		}
	}
}