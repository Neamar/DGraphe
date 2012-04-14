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
		[Embed(source = "assets/niveaux/niveaux/1.png")] private static var Niveau1:Class;
		[Embed(source = "assets/niveaux/niveaux/3.png")] private static var Niveau3:Class;
		[Embed(source = "assets/niveaux/niveaux/4.png")] private static var Niveau4:Class;
		[Embed(source = "assets/niveaux/niveaux/5.png")] private static var Niveau5:Class;
		[Embed(source = "assets/niveaux/niveaux/6.png")] private static var Niveau6:Class;
		[Embed(source = "assets/niveaux/niveaux/7.png")] private static var Niveau7:Class;		
		[Embed(source = "assets/niveaux/niveaux/8.png")] private static var Niveau8:Class;	
		[Embed(source = "assets/niveaux/niveaux/9.png")] private static var Niveau9:Class;
		[Embed(source = "assets/niveaux/niveaux/10.png")] private static var Niveau10:Class;	
		[Embed(source = "assets/niveaux/niveaux/11.png")] private static var Niveau11:Class;
		[Embed(source = "assets/niveaux/niveaux/12.png")] private static var Niveau12:Class;
		
		/**
		 * Niveaux
		 */
		public static var LevelsList:Vector.<Function> = new Vector.<Function>();
		{
			LevelsList.push(
				function():Level
				{
					HUD.showMessage("Welcome", "Click and drag to cut <font color=\"#AACCAA\">nine (9)</font> red ropes.<br>Make sure no one falls over the edge.<br><br>Once free, a prisoner will try to get as far as possible from the others.");
					/**
					 * @state FONCTIONNEL
					 * @type didacticiel
					 * @brief Présentation du jeu et du comportement des noeuds
					 * @difficulty 1
					 * @solution
					 * - Tout... les coups perdants sont vraiment durs à trouver !
					 */
					var Parts:Array = Game.buildNodes('106,106|214,106|214,214|106,214|567,116|673,116|620,208|221,405|221,495|312,403|420,395|528,403|619,405|619,495|528,497|420,505|312,497:3,0|0,1|1,2|2,3|6,4|4,5|5,6|8,7|7,9|9,10|10,11|11,12|12,13|13,14|14,15|15,16|16,8|16,9|10,15|14,11|14,12|11,13|8,9|7,16');
					return new KillNoneLevel(Parts[0], Parts[1], 9, (new Niveau10()).bitmapData);
				},
				function():Level
				{
					HUD.showMessage("Well done!", "New mission: kill the <font color=\"#FF5555\">red one</font> by pushing him over the edge.<br>You may use up to <font color=\"#AACCAA\">three (3)</font> cuts.<br><br>When stuck, double click to start over.");

					/**
					 * @state FONCTIONNEL
					 * @type didacticiel
					 * @brief présentation des noeuds spéciaux
					 * @difficulty 1
					 * @solution
					 * - Facile à faire pleurer une truie trisomique handicapée moteur... (couper les horizontaux)
					 */
					var Parts:Array = Game.buildNodes('342,243|459,244|457,359|342,358|400,300|347,135|455,136:3,0|0,1|1,2|2,3|6,1|5,0|5,6');
					return new KillOneLevel(Parts[0], Parts[1], 3, Parts[0][4], (new Niveau8()).bitmapData);
				},
				function():Level
				{
					/**
					 * @state FONCTIONNEL
					 * @type didacticiel
					 * @brief coupes multiples
					 * @difficulty 2
					 * @solution
					 * - couper les 4 ressorts d'un unique trait
					 */
					var Parts:Array = Game.buildNodes('351,251|400,230|449,251|330,300|351,349|449,349|400,370|470,300:3,7|0,5|6,1|2,4');
					return new KillAllLevel(Parts[0], Parts[1], 4, (new Niveau9()).bitmapData);
				},
				function():Level
				{
					/**
					 * @state FONCTIONNEL
					 * @brief Premier niveau Mossad sur grand cercle union petit cercle
					 * @difficulty 3
					 * @solution
					 * - Dans la structure du bas, couper d'un coup les deux liens sud sud est (liant le noeud "jointure entre deux bras fixes" et le bras de droite).
					 * @note Plusieurs solutions
					 */
					var Parts:Array = Game.buildNodes('400,320|320,260|240,200|300,340|200,360|480,380|560,440|400,400|400,480|300,440|340,380|460,260|500,180:2,1|1,0|4,3|3,0|6,5|5,0|8,7|7,0|4,9|0,11|11,12|9,3|9,8|9,7');
					Parts[0][0].Fixe = true;
					return new KillOneLevel(Parts[0], Parts[1], 25, Parts[0][10], (new Niveau6()).bitmapData);
				},
				function():Level
				{
					/**
					 * @state FONCTIONNEL
					 * @brief Niveau "quadrillage de morpion"
					 * @difficulty 4
					 * @solution
					 * - Couper les deux liens de la croix centrale.
					 * - Couper les deux extrémités verticales
					 */
					var Parts:Array = Game.buildNodes('336,125|485,128|466,238|342,236|342,364|466,362|232,246|232,354|336,475|485,472|577,354|577,246|400,300:5,2|2,1|0,3|3,4|3,2|4,5|7,4|7,6|6,3|9,5|4,8|11,2|5,10|10,11|4,12|3,12|5,12|12,2');
					return new KillNoneLevel(Parts[0], Parts[1], 6, (new Niveau11()).bitmapData);
				},
				function():Level
				{
					/**
					 * @state FONCTIONNEL
					 * @brief Reprise d'un niveau du didacticiel en plus difficile !
					 * @difficulty 4
					 * @solution
					 * - Dans le groupe du bas, couper verticalement d'un coup les 9 ressorts pour séparer en deux bandes distinctes
					 * - Séparer encore ces deux bandes en coupant les ressorts intérieurs (4, de façon à avoir au milieu de chaque ancienne bande un noeud esseulé
					 * - Couper tous les liens du carré sans réfléchir, ça tient
					 * - Couper un des liens du bas du triangle. Au bon moment, couper l'autre lien du bas de façon à anvoyer le noeud du bas (du triangle) sur la passerelle
					 *  - Couper le dernier lien de l'ancien triangle
					 */
					var Parts:Array = Game.buildNodes('106,106|214,106|214,214|106,214|567,116|673,116|620,208|221,405|221,495|312,403|420,395|528,403|619,405|619,495|528,497|420,505|312,497:3,0|0,1|1,2|2,3|6,4|4,5|5,6|8,7|7,9|9,10|10,11|11,12|12,13|13,14|14,15|15,16|16,8|16,9|10,15|14,11|14,12|11,13|8,9|7,16');
					return new KillNoneLevel(Parts[0], Parts[1], 20, (new Niveau10()).bitmapData);
				},
				function():Level
				{
					/**
					 * @state FONCTIONNEL
					 * @brief Niveau très large à multiples plateformes
					 * @difficulty 5
					 * @solution
					 * - Couper selon les axes
					 * - Ne pas couper le dernier lien central vertical !
					 * - Couper ce qui reste pour atteindre l'objectif
					 */
					var Parts:Array = Game.buildNodes('170,154|274,152|272,250|167,272|355,150|359,245|441,245|445,150|526,152|528,250|633,272|630,154|250,363|354,341|446,341|550,363|342,448|458,448:3,0|0,1|1,2|2,3|7,4|4,5|5,6|6,7|11,8|8,9|9,10|10,11|7,9|6,8|1,5|2,4|15,9|9,6|6,14|14,15|14,5|13,6|12,13|13,5|5,2|2,12|17,14|14,13|13,16|16,17|1,4|7,8');
					return new KillNoneLevel(Parts[0], Parts[1], 29, (new Niveau5()).bitmapData);
				},
				function():Level
				{
					/**
					 * @state FONCTIONNEL
					 * @brief Niveau à protubérances (cercle radioactif central)
					 * @difficulty 5
					 * @solution
					 * - Couper les trois liens du haut
					 * - Couper ensuite les deux liens du bas
					 * - Couper enfin à gauche, puis à droite.
					 */
					var Parts:Array = Game.buildNodes('400,181|467,198|511,252|518,319|432,416|489,381|333,198|289,252|282,319|368,416|311,381|400,300:11,10|9,11|11,8|11,7|11,6|11,0|1,11|11,2|11,3|11,4|11,5|2,5|2,7|7,10|10,5');
					return new KillNoneLevel(Parts[0], Parts[1], 11,  (new Niveau4()).bitmapData);
				},
				function():Level
				{
					/**
					 * @state FONCTIONNEL
					 * @brief Niveau sur faible superficie sur rectangle union petit rectangle en bas
					 * @difficulty 6
					 * @solution
					 * - Couper le lien central sur le noeud en haut à droite, attendre la résolution ;)
					 * - Couper ce qui reste (un ou deux noeuds)
					 * @note Faisable en deux coups si on joue bien (même mouvement, vitesse modulée)
					 */
					var Parts:Array = Game.buildNodes('561,246|476,340|561,434|520,340|470,271|379,340|470,409|588,340:3,0|0,1|1,2|2,3|4,0|5,1|6,2|7,3|5,4|4,7|7,6|6,5');
					return new KillButOneLevel(Parts[0], Parts[1], 10, Parts[0][3], (new Niveau7()).bitmapData);
					//return new Level(Parts[0], Parts[1], 3, (new Niveau7()).bitmapData);
				},
				function():Level
				{
					/**
					 * @state FONCTIONNEL
					 * @brief HELP
					 * @difficulty 7 (spécial)
					 * @solution
					 * - Aller vite :D
					 * - Avant que les noeuds se coupent seuls, les trancher manuellement pour faire du score
					 * - Accorder une attention particulière au haut du E et du P, et à la partie gauche du H.
					 * 
					 * @note Les très bons peuvent couper 17 liens... 14 semble raisonnable cependant pour cibler les gens modérément doués à la souris.
					 */
					var Parts:Array = Game.buildNodes('110,180|110,280|110,380|210,280|210,180|210,380|290,180|390,180|390,280|290,280|290,380|390,380|470,180|470,280|470,430|550,380|630,380|630,280|630,180|730,180|730,280:5,3|3,4|3,1|1,0|1,2|11,10|10,9|9,6|6,7|9,8|15,14|14,13|13,12|20,17|17,18|18,19|19,20|17,16');
					return new CutAllLevel(Parts[0], Parts[1], 14, (new Niveau12()).bitmapData);
				},
				function():Level
				{
					/**
					 * @state FONCTIONNEL
					 * @brief Niveau en grand cercle
					 * @difficulty 8
					 * @solution
					 * - Couper la croix centrale.
					 * - Couper le lien horizontal-haut et attendre que les deux noeuds ainsi libérés se retrouvent à la verticale avec les les noeuds juste en dessous
					 * - Couper alors d'un coup les deux liens au dessus de la partie basse horizontale, on se retrouve avec trois composantes "à deux noeuds".
					 * - Couper une par une chacune de ces composantes, dans l'ordre le plus logique en fonction de leurs positions.
					 */
					var Parts:Array = Game.buildNodes('280,300|380,260|420,260|520,300|420,340|380,340:0,1|1,2|2,3|3,4|4,5|5,0|1,4|0,3');
					return new KillNoneLevel(Parts[0], Parts[1], 8, (new Niveau1()).bitmapData);
				},
				function():Level
				{
					/**
					 * @state FONCTIONNEL
					 * @brief Niveau "en croix à petit battant horizontal", deux rectangles arrondis placés perpendiculairement l'un à l'autre
					 * @difficulty 9
					 * @solution
					 * - Attendre quelques secondes la résolution des contraintes : deux noeuds tombent direct
					 * - Couper en bas, deux noeuds sont expulsés (sans tomber pour l'instant)
					 * - En haut, deux noeuds attendent d'être catapultés (structure instable) : les virer
					 * - Ouvrir enfin la structure obtenue en X, puis couper. Adios !
					 */
					var Parts:Array = Game.buildNodes('400,222|400,260|400,307|400,350|400,386|400,422|319,300|481,300|400,183|286,191|514,191:0,6|6,1|2,6|6,3|6,4|6,5|5,7|7,4|3,7|2,7|1,7|0,7|6,8|8,7|10,7|9,6|9,8|8,10');
					return new KillButOneLevel(Parts[0], Parts[1], 14, Parts[0][8], (new Niveau3()).bitmapData);
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
		 * Faut-il mettre à jour le niveau ?
		 */
		private var UpdateLevel:Boolean = true;
		
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
					Background.SCROLL_DURATION / 4000,
					{
						x: - Main.LARGEUR2,
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
				Background.SCROLL_DURATION / 4000,
				{
					x: - Main.LARGEUR2,
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
		 * Considère que les opérations de nettoyage ont été effectuées !
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
			
			if(LevelObject is KillAllLevel)
			{
				HUD.showText('Kill them all.');
			}
			else if(LevelObject is KillButOneLevel)
			{
				HUD.showText('Save him, kill the others.');
			}
			else if(LevelObject is KillOneLevel)
			{
				HUD.showText('Kill him.');
			}
			else if(LevelObject is KillNoneLevel)
			{
				HUD.showText('Do not kill anyone.');
			}
			else if (LevelObject is CutAllLevel)
			{
				HUD.showText('Remove all links.');
			}
			
			/**
			 * ...et afficher
			 */
			VLevelObject.x = Main.LARGEUR + Main.LARGEUR2;
			addChild(VLevelObject);
			
			UpdateLevel = false;
			TweenLite.to(
				VLevelObject,
				3 * Background.SCROLL_DURATION / 4000,
				{
					delay:Background.SCROLL_DURATION / 4000,
					onInit:function():void{UpdateLevel = true},
					x:Main.LARGEUR2
				}
			);
			
			BG.moveTo(LevelNumber);
			
			//Mettre à jour le tableau de bord
			HUD.showLevel(LevelNumber);
			HUD.showLink(LevelObject.getChainesACouper());
			HUD.onTop();
		}
		
		protected final function update(e:Event = null):void
		{
			if (LevelObject != null && UpdateLevel)
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