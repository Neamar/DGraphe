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
		[Embed(source = "../assets/Niveaux/1.png")]
		private static var Niveau1:Class;
		[Embed(source = "../assets/Niveaux/2.png")]
		private static var Niveau2:Class;
		
		/**
		 * Niveaux
		 */
		public static var LevelsList:Vector.<Function> = new Vector.<Function>();
		{
			LevelsList.push(
				function():Level
				{
					var Parts:Array = Game.buildNodes('320,120|360,160|400,200|440,240|480,280|520,320|280,160|240,200|200,240|160,280|120,320|320,400:11,10|9,11|11,8|11,7|11,6|11,0|1,11|11,2|11,3|11,4|11,5');
					return new KillNoneLevel(1, Parts[0], Parts[1], 3, (new Niveau1()).bitmapData);
				},
				function():Level
				{
					var Parts:Array = Game.buildNodes('280,300|380,260|420,260|520,300|420,340|380,340:0,1|1,2|2,3|3,4|4,5|5,0|1,4|0,3');
					return new KillAllLevel(1, Parts[0], Parts[1], 8, (new Niveau1()).bitmapData);
				},
				function():Level
				{
					//FONCTIONNEL (et hard !)
					//Couper la croix centrale.
					//Couper le lien horizontal et attendre que les deux noeuds ainsi libérés se retrouvent à la verticale avec les les noeuds juste en dessous
					//Couper alors d'un coup les deux liens au dessus de la partie basse horizontale, on se retrouve avec trois composantes "à deux noeuds".
					//Couper une par une chacune de ces composantes, dans l'ordre le plus logique en fonction de leurs positions.
					var Parts:Array = Game.buildNodes('280,300|380,260|420,260|520,300|420,340|380,340:0,1|1,2|2,3|3,4|4,5|5,0|1,4|0,3');
					return new KillNoneLevel(1, Parts[0], Parts[1], 8, (new Niveau1()).bitmapData);
				},
				function():Level
				{
					//FONCTIONNEL
					//Couper le lien qui amène vers la partie tarabiscotée à droite
					//Couper ensuite les trois liens restants à droite
					//Couper enfin en haut, puis en bas.
					var Parts:Array = Game.buildNodes('400,181|467,198|511,252|518,319|432,416|489,381|333,198|289,252|282,319|368,416|311,381|400,300:11,10|9,11|11,8|11,7|11,6|11,0|1,11|11,2|11,3|11,4|11,5');
					return new KillNoneLevel(1, Parts[0], Parts[1], 7,  (new Niveau2()).bitmapData);
				},
				function():Level
				{
					var Parts:Array = Game.buildNodes('400,222|400,260|400,307|400,350|400,386|400,422|319,300|481,300|400,183|286,191|514,191:0,6|6,1|2,6|6,3|6,4|6,5|5,7|7,4|3,7|2,7|1,7|0,7|6,8|8,7|10,7|9,6|9,8|8,10');
					return new Level(1, Parts[0], Parts[1], 10, (new Niveau1()).bitmapData);
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
		private var LevelNumber:int = 2;
		
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