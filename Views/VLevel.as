package Views 
{
	import com.greensock.plugins.TintPlugin;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
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
				var Influence:BitmapData = new BitmapData(Main.LARGEUR, Main.HAUTEUR, false, 0x0000FF);

				var Degrade:Matrix = new Matrix();
				Degrade.rotate(Math.PI / 2);
				var CercleInfluence:Shape = new Shape();
				CercleInfluence.graphics.beginGradientFill("linear", [0xFF0000, 0x00FF00], [1, 1], [0, 255], Degrade);
				CercleInfluence.graphics.drawCircle(0, 0, 200);
				
				var Translation:Matrix = new Matrix();
				
				Translation.translate(Main.LARGEUR2, Main.HAUTEUR2);
				Influence.draw(CercleInfluence, Translation);
				for each(var N:Node in L.Noeuds)
				{
					break;
					Translation.tx = N.x + Main.LARGEUR2;
					Translation.ty = N.y + Main.HAUTEUR2;
					this.Debug.draw(CercleInfluence, Translation, null, BlendMode.ADD);
				}
				
				this.Debug.fillRect(this.Debug.rect, 0xFFFFFFFF);
				const Resolution:int = 10;
				for (var i:int = 0; i < Main.LARGEUR; i += Resolution)
				{
					for (var j:int = 0; j < Main.LARGEUR; j++)
					{
						Debug.setPixel32(i, j, 0xFF000000);
						Debug.setPixel32(j, i, 0xFF000000);
					}
				}
				
				Debug.draw(Influence);
				/*Debug.applyFilter(
					Debug,
					Debug.rect,
					new Point(),
					new DisplacementMapFilter(
						Influence,
						new Point(),
						BitmapDataChannel.RED,
						BitmapDataChannel.GREEN,
						35,
						35
					)
				);*/
				
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