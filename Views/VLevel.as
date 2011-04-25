package Views 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Models.Levels.Level;
	import Models.Nodes.Node;
	import Models.Nodes.Spring;
	/**
	 * Vue pour le niveau
	 * @author Neamar
	 */
	public class VLevel extends View
	{
		/**
		 * Le niveau représenté par cet objet
		 */
		private var L:Level;
		
		/**
		 * L'image de fond du niveau (à ne pas confondre avec le background)
		 */
		private var Fond:Bitmap;
		
		/**
		 * Données pour le debug
		 */
		public var Debug:BitmapData;
		
		/**
		 * La liste des vues utiles à l'affichage du niveau
		 */
		private var Vs:Vector.<View> = new Vector.<View>();
		
		/**
		 * La forme qui s'affiche quand la souris est draggée d'un point à un autre pour couper des chaines
		 */
		private var Cutter:Shape = new Shape();
		private var CutterStart:Point = new Point();
		private var CutterEnd:Point = new Point();
		
		public function VLevel(L:Level) 
		{
			this.L = L;
			
			//Récupérer le fond
			if (Main.MODE == Main.MODE_GAME)
			{
				this.Fond = new Bitmap(L.getFond());
				this.Fond.filters = [new GlowFilter(0xFFFFFF, 1, 4, 4, 2, 1, true), new GlowFilter(0, 1, 100, 100)];
			}
			else
			{
				this.Debug = new BitmapData(Main.LARGEUR, Main.HAUTEUR);
				this.Fond = new Bitmap(this.Debug);
				
				this.addEventListener(MouseEvent.CLICK, function():void { trace(L.export()) } );
			}
			addChild(this.Fond);
			setChildIndex(this.Fond, 0);
			Fond.x = -Main.LARGEUR2;
			Fond.y = -Main.HAUTEUR2;
			
			x = Main.LARGEUR2
			y = Main.HAUTEUR2;
			
			//Construire les vues descendantes
			for each(var S:Spring in L.Springs)
			{
				Vs.push(new VSpring(S, this));
			}
			
			for each(var N:Node in L.Noeuds)
			{
				Vs.push(new VNode(N, this));
			}
			
			addChild(Cutter);
			addEventListener(MouseEvent.MOUSE_DOWN, lancerCoupure);
			
			this.doubleClickEnabled = true;
			this.addEventListener(MouseEvent.DOUBLE_CLICK, L.failed);
		}
		
		public final override function destroy():void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN, lancerCoupure);
			removeEventListener(MouseEvent.MOUSE_MOVE, continuerCoupure);
			removeEventListener(MouseEvent.MOUSE_UP, terminerCoupure);
			
			for each(var V:View in Vs)
			{
				V.destroy();
			}
			
			this.L = null;
			Cutter.graphics.clear();
			Cutter = null;
			CutterEnd = CutterStart = null;
			
			super.destroy();
		}
		
		/**
		 * Supprime une vue
		 * @param	V
		 */
		public function removeView(V:View):void
		{
			Vs.splice(Vs.indexOf(V), 1);
		}
		
		/**
		 * Supprime toutes les vues ressorts associées au noeud
		 * @param	V
		 */
		public function removeVNodeSpring(V:VNode):void
		{
			var VToDelete:Vector.<VSpring> = new Vector.<VSpring>();
			
			for each(var V1:View in Vs)
			{
				if (V1 is VSpring && ((V1 as VSpring).S.Bout == V.N || (V1 as VSpring).S.AutreBout == V.N))
				{
					VToDelete.push(V1 as VSpring);
				}
			}
			
			for each(var V2:VSpring in VToDelete)
			{
				V2.destroy();
			}
		}
		
		/**
		 * Code appelé pour chaque mise à jour
		 */
		public final override function update():void
		{
			for each(var V:View in Vs)
			{
				V.update();
			}
			
			if (Main.MODE == Main.MODE_INFLUENCE)
			{
				const Resolution:int = 2;
				var Carre:Rectangle = new Rectangle(0, 0, Resolution, Resolution);
				
				for (var i:int = 0; i < Main.LARGEUR; i += Resolution)
				{	
					for (var j:int = 0; j < Main.HAUTEUR; j += Resolution)
					{
						//Calculer le champ résiduel à l'emplacement désigné
						//Seule la valeur numérique est intéressante, la direction importe peu.
						var absRepulsion:Number = 0;
						var Distance:int;
						var x:int = i + Resolution / 2 - Main.LARGEUR2;
						var y:int = j + Resolution / 2 - Main.HAUTEUR2;
						for each(var N:Node in L.Noeuds)
						{
							Distance = Math.max(5, Math.sqrt(Math.pow(N.x - x, 2) + Math.pow(N.y - y, 2)));
							absRepulsion += 1 / Math.pow(Distance, 2);
						}
						Carre.x = i;
						Carre.y = j;
						var Pixels:Vector.<uint> = Debug.getVector(Carre);
						for (var k:int = 0; k < Pixels.length; k++)
						{
							Pixels[k] = 0xFF000000 + absRepulsion*0xFFFFFF;
						}
						
						Debug.setVector(Carre, Pixels);
					}
				}
			}
		}
		
		/**
		 * Lance une coupure quand la souris est cliquée
		 * @param	e
		 */
		protected final function lancerCoupure(e:MouseEvent):void
		{
			CutterStart.x = e.localX;
			CutterStart.y = e.localY;
			removeEventListener(MouseEvent.MOUSE_DOWN, lancerCoupure);
			addEventListener(MouseEvent.MOUSE_MOVE, continuerCoupure);
			addEventListener(MouseEvent.MOUSE_UP, terminerCoupure);
		}
		
		/**
		 * Met à jour l'image de la coupure
		 * @param	e
		 */
		protected final function continuerCoupure(e:MouseEvent):void
		{
			Cutter.graphics.clear();
			Cutter.graphics.lineStyle(1, 0xFF);
			Cutter.graphics.moveTo(CutterStart.x, CutterStart.y);
			Cutter.graphics.lineTo(e.localX - Cutter.x, e.localY - Cutter.y);
			
			CutterEnd.x = e.localX;
			CutterEnd.y = e.localY;
			
			var Intersection:Vector.<Spring> = L.getIntersection(CutterStart, CutterEnd);
			for each(var S:Spring in Intersection)
			{
				Cutter.graphics.moveTo(S.Bout.x, S.Bout.y+5);
				Cutter.graphics.lineTo(S.AutreBout.x, S.AutreBout.y + 5);
			}
		}
		
		/**
		 * Souris relachée, terminer la coupure
		 * @param	e
		 */
		protected function terminerCoupure(e:MouseEvent):void
		{
			CutterEnd.x = e.localX;
			CutterEnd.y = e.localY;
			
			//Transmettre l'évènement au niveau
			var Supprimes:Vector.<Spring> = L.cut(CutterStart, CutterEnd);
			var VToDelete:Vector.<VSpring> = new Vector.<VSpring>();
			
			for each(var V:View in Vs)
			{
				if (V is VSpring && Supprimes.indexOf((V as VSpring).S) != -1)
				{
					VToDelete.push(V as VSpring);
				}
			}
			
			for each(var V2:VSpring in VToDelete)
			{
				V2.destroy();
			}
			
			Cutter.graphics.clear();
			removeEventListener(MouseEvent.MOUSE_MOVE, continuerCoupure);
			removeEventListener(MouseEvent.MOUSE_UP, terminerCoupure);

			if (L.getChainesACouper() > 0)
				addEventListener(MouseEvent.MOUSE_DOWN, lancerCoupure);
		}
	}

}