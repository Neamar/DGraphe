package Views 
{
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import Models.Nodes.Node;
	/**
	 * Vue pour le niveau
	 * @author Neamar
	 */
	public class VNode extends View
	{
		/**
		 * Rayon d'un noeud
		 */
		private static const NODE_RADIUS:int = 10;
		
		/**
		 * L'objet représenté par cette vue
		 */
		public var N:Node;
		
		/**
		 * Le niveau sur lequel on est
		 */
		private var VL:VLevel;
		
		public function VNode(N:Node, VL:VLevel) 
		{
			this.mouseEnabled = false;
			this.N = N;
			this.VL = VL;
			
			this.graphics.lineStyle(1);
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawCircle(0, 0, NODE_RADIUS);
			this.graphics.endFill();
			this.graphics.lineStyle(2);
			this.graphics.moveTo(0, 0);
			this.graphics.lineTo(0, -NODE_RADIUS);
			
			if (N.Special)
			{
				this.filters = [new BlurFilter(8, 8)];
			}
			
			if (N.Fixe)
			{
				this.graphics.clear();
			}
			
			N.addEventListener(Node.DEAD, onDeath);
			
			VL.addChild(this);
		}
		
		public final override function destroy():void
		{
			this.graphics.clear();
			VL.removeView(this);
			super.destroy();
		}
		
		/**
		 * Code appelé pour chaque mise à jour
		 */
		public final override function update():void
		{
			this.x = N.x;
			this.y = N.y;
			this.rotation = -N.rotation;
			
			if (Main.MODE == Main.MODE_CREATOR)
			{
				VL.Debug.draw(this, new Matrix(1, 0, 0, 1, this.x + Main.LARGEUR2, this.y + Main.HAUTEUR2));
			}
		}
		
		/**
		 * Code appelé à la mort du noeud
		 * @param	e non utilisé
		 */
		private final function onDeath(e:Event):void
		{
			this.parent.setChildIndex(this, 0);
			TweenLite.to(this, 1, { scaleX:0, scaleY:0, onComplete: destroy } );
			VL.removeVNodeSpring(this);
		}
	}

}