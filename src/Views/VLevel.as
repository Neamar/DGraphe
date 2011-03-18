package Views 
{
	import Models.Levels.Level;
	import Models.Nodes.Node;
	import Models.Nodes.Spring;
	/**
	 * Vue pour le niveau
	 * @author Neamar
	 */
	public class VLevel extends View
	{
		public var L:Level;
		
		public var Vs:Vector.<View> = new Vector.<View>();
		
		public function VLevel(L:Level) 
		{
			this.L = L;
			
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
			this.L = null;
		}
		
		/**
		 * Code appelé pour chaque mise à jour
		 */
		public final override function update():void
		{
			trace(Vs.length);
			for each(var V:View in Vs)
			{
				V.update();
			}
		}
	}

}