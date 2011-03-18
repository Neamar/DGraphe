package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import Models.Levels.*;
	import Models.Nodes.Spring;
	import Views.View;
	import Views.VLevel;
	import Views.VSpring;
	
	/**
	 * OBjet représentant le jeu dans son intégralité;
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
		
		/**
		 * Niveaux
		 */
		public static var LevelsList:Vector.<Function> = new Vector.<Function>();
		{
			LevelsList.push(
				function():Level
				{
					return new KillNoneLevel(1,'320,120|360,160|400,200|440,240|480,280|520,320|280,160|240,200|200,240|160,280|120,320|320,400:11,10|9,11|11,8|11,7|11,6|11,0|1,11|11,2|11,3|11,4|11,5', 3, (new Niveau1()).bitmapData);
				},
				function():Level
				{
					//NIVEAU FONCTIONNEL
					return new KillAllLevel(1, '280,300|380,260|420,260|520,300|420,340|380,340:0,1|1,2|2,3|3,4|4,5|5,0|1,4|0,3', 8, (new Niveau1()).bitmapData);
				},
				function():Level
				{
					return new KillOneLevel(1, '280,300|380,260|420,260|520,300|420,340|380,340:0,1|1,2|2,3|3,4|4,5|5,0|1,4|0,3', 8, new Niveau1(), 1);
				},
				function():Level
				{
					return new Level(1, '320,120|360,160|400,200|440,240|480,280|520,320|280,160|240,200|200,240|160,280|120,320|320,400:11,10|9,11|11,8|11,7|11,6|11,0|1,11|11,2|11,3|11,4|11,5', 10, new Niveau1());
				},
				function():Level
				{
					return new Level(1, '360,200|360,240|360,280|360,320|360,360|360,400|240,400|480,400|360,160|240,40|480,40:0,6|6,1|2,6|6,3|6,4|6,5|5,7|7,4|3,7|2,7|1,7|0,7|6,8|8,7|10,7|9,6|9,8|8,10', 10, new Niveau1());
				}
			);
		}
		
		/**
		 * Le numéro du niveau actuel
		 */
		public var LevelNumber:int = 0;
		
		/**
		 * L'objet niveau chargé
		 */
		public var LevelObject:Level = null;
		
		/**
		 * La vue associée au niveau
		 */
		public var VLevelObject:VLevel;
		
		/**
		 * Lancement du jeu !
		 */
		public function Game()
		{
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
				//Supprimer l'ancienne référence
				removeChild(VLevelObject);
				LevelObject.destroy();
				VLevelObject.destroy();
			}
			
			//Afficher le nouveau niveau
			LevelNumber++;
			LevelObject = new Game.LevelsList[LevelNumber];
			VLevelObject = new VLevel(LevelObject);
			
			/**
			 * Et enfin, afficher le niveau !
			 */
			addChild(VLevelObject);	
		}
		
		protected final function update(e:Event = null):void
		{
			//Mettre à jour le niveau
			LevelObject.update();
			
			//Mettre à jour les vues
			VLevelObject.update();
		}
	}
}