package Views 
{
	import flash.display.Sprite;
	
	/**
	 * Objet générique pour les vues
	 * @author Neamar
	 */
	public class View extends Sprite
	{
		public function View() 
		{
			super();
		}
		
		/**
		 * Méthode à overrider pour nettoyer proprement l'objet.
		 */
		public function destroy():void
		{
			delete this;
		}
		
		public function update():void
		{
			throw new Error('Appel méthode abstraite');
		}
	}

}