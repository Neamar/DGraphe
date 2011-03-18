package Models.Levels
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Models.Model;
	import Models.Nodes.Interaction;
	import Models.Nodes.Node;
	import Models.Nodes.Spring;

	/**
	* Un niveau de jeu.
	* @author Neamar
	*/
	public class Level extends Model
	{		
		public static const WIN:String = 'win';
		public static const LOST:String = 'lost';
		
		public var Noeuds:Vector.<Node> = new Vector.<Node>();
		public var Interactions:Vector.<Interaction> = new Vector.<Interaction>();
		public var Springs:Vector.<Spring> = new Vector.<Spring>();
		public var ChainesACouper:int;
		
		private var Cutter:Shape = new Shape();
		private var CutterStart:Point = new Point();
		private var CutterEnd:Point = new Point();
		
		public var Fond:BitmapData;
		public var isEmpty:Function;


		public function Level(Numero:int, Datas:String, NbChaines:int, Fond:BitmapData):void 
		{
			ChainesACouper = NbChaines;
			
			this.Fond = Fond;


			isEmpty = Fond.getPixel;
			
			var Niv_String:String=Datas;
			var Composants:Array;
			var Part:Array=Niv_String.split(":");
			var strNoeuds_Array:Array=Part[0].split("|");
			var strArc_Array:Array = Part[1].split("|");
			
			for each(var Noeud:String in strNoeuds_Array)
			{
				Composants = Noeud.split(",");
				var NouveauNoeud:Node = new Node(Composants[0]-Main.LARGEUR2, Composants[1]-Main.HAUTEUR2,this);
				Noeuds.push(NouveauNoeud);
			}
			for each(var Arete:String in strArc_Array)
			{
				Composants=Arete.split(",");
				Noeuds[Composants[0]].connectTo(Noeuds[Composants[1]]);
			}
			
			addEventListener(MouseEvent.MOUSE_DOWN, lancerCoupure);
			
		}
		
		public function destroy():void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN, lancerCoupure);
			removeEventListener(MouseEvent.MOUSE_MOVE, continuerCoupure);
			removeEventListener(MouseEvent.MOUSE_UP, terminerCoupure);
			
			while (Interactions.length > 0)
			{
				Interactions.shift().destroy();
			}
			
			for each(var Item:Node in Noeuds)
			{
				Item.destroy();
			}
			
			Noeuds = null;
			
			for each(var Obj:Interaction in Interactions)
			{
				Obj.destroy();
			}
			
			Interactions = null;
			
			Fond.dispose();
			Fond = null;
			
			delete this;
		}
		
		public function completed(e:Event = null):void
		{
			dispatchEvent(new Event(Level.WIN));
		}
		
		public function failed(e:Event = null):void
		{
			dispatchEvent(new Event(Level.LOST));
		}
	  
		/**
		* Met à jour la simulation d'une unité de temps : applique le PFD aux noeuds puis calcule les interactions pour la prochaine étape via les méthodes statiques fournies par les classes.
		* On choisit cet ordre pour avoir des ressorts dessinés correctement, sans avoir à refaire une boucle supplémentaire.
		* @param	e non utilisé.
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
		
		protected final function lancerCoupure(e:MouseEvent):void
		{
			CutterStart.x = e.localX;
			CutterStart.y = e.localY;
			removeEventListener(MouseEvent.MOUSE_DOWN, lancerCoupure);
			addEventListener(MouseEvent.MOUSE_MOVE, continuerCoupure);
			addEventListener(MouseEvent.MOUSE_UP, terminerCoupure);
		}
		
		protected final function continuerCoupure(e:MouseEvent):void
		{
			Cutter.graphics.clear();
			Cutter.graphics.lineStyle(1, 0xFF);
			Cutter.graphics.moveTo(CutterStart.x, CutterStart.y);
			Cutter.graphics.lineTo(e.localX - Cutter.x, e.localY - Cutter.y);
			
			CutterEnd.x = e.localX;
			CutterEnd.y = e.localY;
			
			for each(var S:Spring in Springs)
			{
				if (intersectionCoupure(S))
				{
					Cutter.graphics.moveTo(S.Bout.x, S.Bout.y+5);
					Cutter.graphics.lineTo(S.AutreBout.x, S.AutreBout.y + 5);
				}
			}
		}
		
		protected function terminerCoupure(e:MouseEvent):void
		{
			CutterEnd.x = e.localX;
			CutterEnd.y = e.localY;
			var ToDelete:Vector.<Spring> = new Vector.<Spring>();
			var S:Spring
			for each(S in Springs)
			{
				if (intersectionCoupure(S))
					ToDelete.push(S);
			}
			
			for each(S in ToDelete)
			{
				S.destroy();
				ChainesACouper--;
				if (ChainesACouper == 0)
				{
					break;
				}
			}
			
			Cutter.graphics.clear();
			removeEventListener(MouseEvent.MOUSE_MOVE, continuerCoupure);
			removeEventListener(MouseEvent.MOUSE_UP, terminerCoupure);

			if (ChainesACouper > 0)
				addEventListener(MouseEvent.MOUSE_DOWN, lancerCoupure);
		}

		/**
		 * Renvoie true si les deux droites intersectent.
		 * @param	Lien Le lien avec lequel on fait le test.
		 * @param	D Le dernier point de la deuxième droite
		 * @return
		 */
		private function intersectionCoupure(Lien:Spring):Boolean
		{//Renvoie true si une intersection existe entre les deux segments.
			var A:Node = Lien.Bout;
			var B:Node = Lien.AutreBout;
			var C:Point = CutterStart;
			var D:Point = CutterEnd;
			var r_num:Number = (A.y-C.y)*(D.x-C.x)-(A.x-C.x)*(D.y-C.y);
			var r_den:Number = (B.x-A.x)*(D.y-C.y)-(B.y-A.y)*(D.x-C.x);

			if (r_den==0) return false;     // Pas d'interesection
			var r:Number = r_num/r_den;
			if (r<=0 || r>=1) return false; // Intersection en dehors du segment [AB]

			var s_num:Number = (A.y-C.y)*(B.x-A.x)-(A.x-C.x)*(B.y-A.y);
			var s_den:Number = (B.x-A.x)*(D.y-C.y)-(B.y-A.y)*(D.x-C.x);
			if (s_den==0) return false;     // Pas d'interesection
			var s:Number = s_num/s_den;
			if (s<=0 || s>=1) return false; // Intersection en dehors du segment [CD]

			//Si on est encore là, il y a intersection...
			return true;
		}

	}
}