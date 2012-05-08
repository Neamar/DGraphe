package Views 
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix;
	import Models.Nodes.Node;
	/**
	 * Vue pour le niveau
	 * @author Neamar
	 */
	public class VNode extends View
	{
		[Embed(source = "../assets/niveaux/humains/normal.png")]
		private static var NormalHumanClass:Class;
		private static var NormalHuman:BitmapData = (new NormalHumanClass()).bitmapData;
		[Embed(source = "../assets/niveaux/humains/special.png")]
		private static var SpecialHumanClass:Class;
		private static var SpecialHuman:BitmapData = (new SpecialHumanClass()).bitmapData;
		[Embed(source = "../assets/niveaux/humains/pylone.png")]
		private static var FixedHumanClass:Class;
		private static var FixedHuman:BitmapData = (new FixedHumanClass()).bitmapData;
		
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
			
			if (N.Special)
				setImage(SpecialHuman);
			else if(!N.Fixe)
				setImage(NormalHuman);
			else
				setImage(FixedHuman);
			
			N.addEventListener(Node.DEAD, onDeath);
			
			VL.addChild(this);
		}
		
		public final override function destroy():void
		{
			this.graphics.clear();
			VL.removeView(this);
			super.destroy();
		}
		
		public function setImage(bd:BitmapData):void
		{
			if (numChildren > 0)
				removeChildAt(0);

			var img:Bitmap = new Bitmap(bd);
			img.smoothing = true;
			img.x = -img.width / 2;
			img.y = -img.height / 2;
			
			addChild(img);
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