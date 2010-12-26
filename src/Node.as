package 
{
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * Permet de représenter un noeud (une boule) et de lui appliquer une liste de contraintes avec applyForce().
	 * @author Neamar
	 */
	public class Node extends Shape
	{
		public static const NODE_RADIUS:int = 10;
		public static const TRACEUR:Boolean = false;
		private static const FROTTEMENTS:Number = .7;
		
		
		/**
		 * Liste des contraintes qui s'appliquent sur le noeud à un moment donné.
		 */
		private var Forces:Vector.<Vecteur> = new Vector.<Vecteur>();
		private var Resultante:Vecteur = new Vecteur();
		private var Vitesse:Vecteur = new Vecteur();
		public var Parent:Level;
		public var isFalling:Boolean = false;

		private const Masse:int = 1;
		
		/**
		 *  Ce noeud est caractérisé par sa position intiale et son nom, ainsi qu'un noeud auquel le nouveau va être rattaché.
		 * @param	x Position x initiale
		 * @param	y Position y initiale
		 * @param	Parent le niveau conteneur
		 */
		public function Node(x:int, y:int,Parent:Level)
		{
			this.x = x;
			this.y = y;
			this.Parent = Parent;
			
			this.graphics.lineStyle(1);
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawCircle(0, 0, NODE_RADIUS);

			//Déteste tout le monde (force de répulsion)
			for each(var Item:Node in Parent.Noeuds)
				new Repulsion(Item, this, Parent);
				;
		}
		
		public function connectTo(Noeud:Node):void
		{
			new Spring(this, Noeud,Parent);
		}
			
		
		/**
		 * Met à jour la position de la particule en lui appliquant le PFD
		 * À chaque appel de la fonction, la simulation de cette particule avance d'une unité de temps.
		 */
		public final function apply():void
		{			
			//Calcul de la somme des forces. On en profite pour vider le tableau.
			while (Forces.length>0)
				Resultante.ajouter(Forces.pop());

			//application du PFD : Somme des forces = masse * Acceleration
			//Resultante.scalarMul(1/this.Masse);//Inutile, masse à 1
			
			//Puis mise à jour de la vitesse. À ce point là, le vecteur Resultante correspond au vecteur accéleration.
			//Il faut noter qu'on fait les calculs à chauqe itération : l'intégration du vecteur accéleration pour obtenir le vecteur vitesse se transforme alors en une simple addition.
			Vitesse.ajouter(Resultante);		
			//Ajouter des frottements pour éviter d'avoir les ressorts qui oscillent à l'infini
			Vitesse.scalarMul(FROTTEMENTS);

			//Calcul de la nouvelle position selon la même logique intégration = addition.
			this.x += Vitesse.x;
			this.y += Vitesse.y;

			
			//Vidage de la liste des forces pour le prochain calcul
			Resultante.x = Resultante.y = 0;
			
			if (Node.TRACEUR)
				Parent.Traceur.draw(this, new Matrix(1, 0, 0, 1, this.x+Main.LARGEUR2, this.y+Main.HAUTEUR2));
			else if (Parent.isEmpty(x+Main.LARGEUR2, y+Main.HAUTEUR2)==0)
			{
				if (!isFalling)
				{
					TweenLite.to(this, 1, { scaleX:0, scaleY:0 } )
					isFalling = true;
					Vitesse.scalarMul(3);
					for (var i:int = 0; i < Parent.Springs.length;i++ )
					{
						if (Parent.Springs[i].Bout == this || Parent.Springs[i].AutreBout == this)
						{
							Parent.Springs[i].Bout.applyForce(Vitesse);
							Parent.Springs[i].AutreBout.applyForce(Vitesse);
							Parent.Springs[i].destroy();
							i--;
						}
					}
				}
			}
		}
		
		/**
		 * Ajoute une force à la liste qui s'applique sur l'élément.
		 * @param	F
		 */
		public final function applyForce(F:Vecteur):void
		{
			Forces.push(F);
		}
	}
	
}