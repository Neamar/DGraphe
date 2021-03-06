package Models.Levels
{
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import Models.Model;
	import Models.Nodes.Interaction;
	import Models.Nodes.Node;
	import Models.Nodes.Repulsion;
	import Models.Nodes.Spring;
	
	/**
	* Un niveau de jeu.
	* @author Neamar
	*/
	public class Level extends Model
	{
		/**
		 * Evènement dispatché pour un niveau gagné
		 */
		public static const WIN:String = 'win';
		
		/**
		 * Evènement dispatché pour un niveau perdu
		 */
		public static const LOST:String = 'lost';
		
		/**
		 * Liste des noeuds composant le niveau
		 */
		public var Noeuds:Vector.<Node>;
		
		/**
		 * Liste des interactions (ressorts et répulsion) composant le niveau
		 */
		public var Interactions:Vector.<Interaction>;
		
		/**
		 * Liste des ressorts composant le niveau
		 */
		public var Springs:Vector.<Spring>;
		
		/**
		 * Nombre maximal de chaines que l'on peut couper
		 */
		protected var ChainesACouper:int;
		
		/**
		 * Les données de l'image de fond
		 */
		protected var Fond:BitmapData;

		/**
		 * Crée un nouveau niveau
		 * 
		 * @param	Noeuds la liste des noeuds constituant le niveau
		 * @param	Ressorts la liste des ressorts liant les noeuds entre eux
		 * @param	NbChaines le nombre de chaînes imparti
		 * @param	Fond l'image à utiliser pour faire les tests de collision.
		 */
		public function Level(Noeuds:Vector.<Node>, Ressorts:Vector.<Spring>, NbChaines:int, Fond:BitmapData):void 
		{
			ChainesACouper = NbChaines;
			
			this.Fond = Fond;

			this.Noeuds = Noeuds;
			this.Springs = Ressorts;
			this.Interactions = new Vector.<Interaction>();
			
			//Recopier tous les ressorts dans les interactions, indiquer son parent
			for each(var S:Spring in Springs)
			{
				S.setParent(this);
				Interactions.push(S);
			}
			
			//Indiquer aux noeuds la fonction à utiliser pour déterminer le vide, leur indiquer leur parent et leur mettre des forces de répulsion entre eux
			var isEmpty:Function = Fond.getPixel32;
			for (var i:int = 0; i < Noeuds.length; i++ )
			{
				var N:Node = Noeuds[i];
				N.setParent(this);
				N.setIsEmpty(isEmpty);
				for (var j:int = i + 1; j < Noeuds.length; j++)
				{
					var R:Repulsion = new Repulsion(N, Noeuds[j]);
					R.setParent(this);
					Interactions.push(R);
				}
			}
		}
		
		/**
		 * Renvoie le niveau sous forme exportée (chaine de caractères)
		 * 
		 * @return string
		 */
		public function export():String
		{
			var R:String = "";
			for each(var N:Node in Noeuds)
			{
				R += Math.round(N.x + Main.LARGEUR2) + ',' + Math.round(N.y + Main.HAUTEUR2) + '|';
			}
			
			R = R.substr(0, R.length - 1) + ':';
			
			for each(var S:Spring in Springs)
			{
				R += Noeuds.indexOf(S.Bout) + ',' + Noeuds.indexOf(S.AutreBout) + '|';
			}
			
			return R.substr(0, R.length - 1);
		}
		
		/**
		 * Nettoie au maximum la mémoire utilisée par le niveau pour faciliter le travail du GC
		 */
		public function destroy():void
		{		
			while (Interactions.length > 0)
			{
				Interactions[0].destroy();
			}
			
			for each(var Item:Node in Noeuds)
			{
				Item.destroy();
			}
			
			Noeuds = null;
			
			Interactions = null;
			
			Fond.dispose();
			Fond = null;
			
			delete this;
		}
		
		/**
		 * Récupèrer les données constituant l'image de fond
		 * @return un bitmapdata avec les données
		 */
		public function getFond():BitmapData
		{
			return this.Fond;
		}
		
		/**
		 * Nombre maximal de chaines à couper
		 * @return
		 */
		public function getChainesACouper():int
		{
			return ChainesACouper;
		}
		
		/**
		 * Helper pour envoyer l'évènement gagné.
		 * @param	e
		 */
		protected function completed(e:Event = null):void
		{			
			if (Main.MODE != Main.MODE_CREATOR)
			{
				dispatchEvent(new Event(Level.WIN));
			}
		}
		
		/**
		 * Déclenche l'évènement réussite si un échec ne se produit pas dans les deux secondes
		 * @param	e
		 */
		protected function nearlyCompleted(e:Event = null):void
		{
			HUD.showText('Hold for two seconds');
			TweenLite.delayedCall(2, completed);
		}
		
		/**
		 * Helper pour envoyer l'évènement perdu.
		 * @param	e
		 */
		public function failed(e:Event = null):void
		{
			dispatchEvent(new Event(Level.LOST));
		}
	  
		/**
		* Met à jour la simulation d'une unité de temps : applique le PFD aux noeuds puis calcule les interactions pour la prochaine étape via les méthodes statiques fournies par les classes.
		* On choisit cet ordre pour avoir des ressorts dessinés correctement, sans avoir à refaire une boucle supplémentaire.
		*/
		public final function update():void
		{
			for each(var Item:Node in Noeuds)
			{
				Item.apply();
			}

			for each(var Obj:Interaction in Interactions)
			{
				Obj.apply();
			}
		}
		
		/**
		 * Détruit tous les liens entre Start et End
		 * @param	Start point de début
		 * @param	End point de fin
		 * @return les objets supprimés
		 */
		public function cut(Start:Point, End:Point):Vector.<Spring>
		{
			var ToDelete:Vector.<Spring> = getIntersection(Start, End);
			var Deleted:Vector.<Spring> = new Vector.<Spring>();
			for each(var S:Spring in ToDelete)
			{
				S.destroy();
				ChainesACouper--;
				Deleted.push(S);
				if (ChainesACouper == 0)
				{
					break;
				}
			}
			
			HUD.showLink(this.ChainesACouper);
			return Deleted;
		}
		
		/**
		 * Renvoie une liste de ressorts qui sont
		 * @param	Start le premier point
		 * @param	End le deuxième point
		 * @return la liste des ressorts passant entre les deux points
		 */
		public final function getIntersection(Start:Point, End:Point):Vector.<Spring>
		{
			var Intersections:Vector.<Spring> = new Vector.<Spring>();
			
			var C:Point = Start;
			var D:Point = End;
			
			for each(var S:Spring in Springs)
			{
				var A:Node = S.Bout;
				var B:Node = S.AutreBout;

				var r_num:Number = (A.y - C.y) * (D.x - C.x) - (A.x - C.x) * (D.y - C.y);
				var r_den:Number = (B.x - A.x) * (D.y - C.y) - (B.y - A.y) * (D.x - C.x);

				if (r_den==0) continue;     // Pas d'interesection
				var r:Number = r_num/r_den;
				if (r<=0 || r>=1) continue; // Intersection en dehors du segment [AB]

				var s_num:Number = (A.y - C.y) * (B.x - A.x) - (A.x - C.x) * (B.y - A.y);
				var s_den:Number = (B.x - A.x) * (D.y - C.y) - (B.y - A.y) * (D.x - C.x);
				if (s_den==0) continue;     // Pas d'interesection
				var s:Number = s_num / s_den;
				if (s<=0 || s>=1) continue; // Intersection en dehors du segment [CD]

				//Si on est encore là, il y a intersection...
				Intersections.push(S);
			}
			
			return Intersections;
		}
	}
}