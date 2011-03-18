package Views 
{
	import flash.display.Bitmap;
	import flash.filters.GlowFilter;
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
		 * La liste des vues utiles à l'affichage du niveau
		 */
		private var Vs:Vector.<View> = new Vector.<View>();
		
		public function VLevel(L:Level) 
		{
			this.L = L;
			
			//Récupérer le fond
			this.Fond = new Bitmap(L.getFond());
			this.Fond.filters = [new GlowFilter(0, 1, 100, 100)];
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
		}
		
		public final override function destroy():void
		{
			for each(var V:View in Vs)
			{
				V.destroy();
			}
			
			this.L = null;
			
			super.destroy();
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
		}
	}

}