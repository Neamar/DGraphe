package Views 
{
	import com.greensock.TweenLite;
	import flash.events.Event;
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
		private var N:Node;
		
		public function VNode(N:Node, VL:VLevel) 
		{
			this.N = N;
			
			this.graphics.lineStyle(1);
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawCircle(0, 0, NODE_RADIUS);
			
			N.addEventListener(Node.DEAD, onDeath);
			
			VL.addChild(this);
		}
		
		public final override function destroy():void
		{
			this.graphics.clear();
			super.destroy();
		}
		
		/**
		 * Code appelé pour chaque mise à jour
		 */
		public final override function update():void
		{
			this.x = N.x;
			this.y = N.y;
		}
		
		/**
		 * Code appelé à la mort du noeud
		 * @param	e non utilisé
		 */
		private final function onDeath(e:Event):void
		{
			TweenLite.to(N, 1, { scaleX:0, scaleY:0 } )
		}
	}

}