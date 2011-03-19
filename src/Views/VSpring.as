package Views 
{
	import com.oaxoa.fx.Lightning;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import Models.Nodes.Spring;
	/**
	 * Vue pour le niveau
	 * @author Neamar
	 */
	public class VSpring extends View
	{
		/**
		 * Le halo lumineux qui entoure les éclairs
		 */
		private static const GLOW:Array = new Array(new GlowFilter(0xFF0000, .8, 10, 10, 1, 1), new DropShadowFilter());

		/**
		 * L'éclair utilisé pour représenter le ressort
		 */
		private var Eclair:Lightning;
		
		/**
		 * L'objet ressort
		 */
		public var S:Spring;
		
		protected var VL:VLevel;
		
		public function VSpring(S:Spring, VL:VLevel) 
		{
			this.S = S;
			this.VL = VL;
			
			Eclair = new Lightning(0xFF0000, 2);
			Eclair.childrenDetachedEnd=false;
			Eclair.childrenLifeSpanMin=.1;
			Eclair.childrenLifeSpanMax=2;
			Eclair.childrenMaxCount=2;
			Eclair.childrenMaxCountDecay = .5;
			Eclair.amplitude = .3;
			Eclair.steps = 50;
			Eclair.speed = .09;
			Eclair.childrenProbability=.3;
			Eclair.smoothPercentage = 50;
			Eclair.filters = GLOW;

			VL.addChild(Eclair);
			VL.setChildIndex(Eclair, 1);
		}
		
		public final override function destroy():void
		{
			VL.removeView(this);
			Eclair.kill();
			Eclair.graphics.clear();
			super.destroy();
		}
		
		/**
		 * Code appelé pour chaque mise à jour
		 */
		public final override function update():void
		{		
			Eclair.startX = S.Bout.x;
			Eclair.startY = S.Bout.y;
			Eclair.endX = S.AutreBout.x;
			Eclair.endY = S.AutreBout.y;
			Eclair.update();
		}
	}
}