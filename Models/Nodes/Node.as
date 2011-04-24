package Models.Nodes
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import Models.Levels.Level;
	import Models.Model;
	
	/**
	 * Permet de représenter un noeud (une boule) et de lui appliquer une liste de contraintes avec applyForce().
	 * @author Neamar
	 */
	public class Node extends Model
	{		
		/**
		 * Nom de l'évènement envoyé après décès
		 */
		public static const DEAD:String = "dead";
		
		/**
		 * Constante de frottement à appliquer.
		 * @see Spring.FROTTEMENTS
		 */
		private static const FROTTEMENTS:Number = .7;
		
		/**
		 * Définit si le noeud joue un rôle particulier dans le niveau
		 */
		public var Special:Boolean = false;
		
		/**
		 * Définit si le noeud est fixé
		 */
		public var Fixe:Boolean = false;
		
		/**
		 * L'angle "formé" par le noeud.
		 * Il s'agit en soi d'une donnée uniquement utile à l'affichage, mais il paraît cohérent de la calculer ici.
		 */
		public var rotation:int = 0;
		
		/**
		 * Vecteur résultant de ces contraintes
		 */
		private var ResultanteX:Number = 0;
		private var ResultanteY:Number = 0;
		
		
		/**
		 * Vecteur résultant des contraintes de type ressort normalisées
		 * Sert pour calculer l'orientation du noeud
		 */
		private var ResultanteRessortX:Number = 0;
		private var ResultanteRessortY:Number = 0;
		
		
		/**
		 * Vitesse instantanée du noeud
		 */
		private var Vitesse:Vecteur = new Vecteur();
		
		/**
		 * Le noeud est-il en chute ? (mort)
		 */
		private var isFalling:Boolean = false;
		
		/**
		 * Le parent de ce noeud
		 */
		private var Parent:Level;
		
		/**
		 * La fonction à utiliser pour déterminer si un pixel est dans le vide ou non
		 */
		private var isEmpty:Function;
		
		/**
		 *  Ce noeud est caractérisé par sa position intiale et son nom, ainsi qu'un noeud auquel le nouveau va être rattaché.
		 * @param	x Position x initiale
		 * @param	y Position y initiale
		 * @param	Parent le niveau conteneur
		 */
		public function Node(x:int, y:int)
		{
			this.x = x;
			this.y = y;
		}
		
		public function destroy():void
		{
			Vitesse = null;
			Parent = null;
			
			delete this;
		}
		
		/**
		 * Connecte le noeud à un autre noeud par un ressort
		 * @param	Noeud le noeud à connecter
		 * @return le ressort créé pour l'occasion
		 */
		public function connectTo(Noeud:Node):Spring
		{
			return new Spring(this, Noeud);
		}
		
		/**
		 * Détermine la fonction à utiliser pour savoir ce qui est vide et ce qui ne l'est pas
		 * @param	isEmpty
		 */
		public function setIsEmpty(isEmpty:Function):void
		{
			this.isEmpty = isEmpty;
		}
		
		/**
		 * Définit le parent de ce noeud
		 * @param	L l'objet Level à utiliser comme parent
		 */
		public function setParent(L:Level):void
		{
			this.Parent = L;
		}
		
		
		/**
		 * Met à jour la position de la particule en lui appliquant le PFD
		 * À chaque appel de la fonction, la simulation de cette particule avance d'une unité de temps.
		 */
		public final function apply():void
		{			
			//Un noeud fixe est rapidement calculé ;)
			if (Fixe)
			{
				return;
			}
			
			//Calcul de la somme des forces.
			//Ce calcul est effectué en temps réel, lors de l'ajout d'une force

			//application du PFD : Somme des forces = masse * Acceleration
			//Resultante.scalarMul(1/this.Masse);//Inutile, masse à 1
			
			//Puis mise à jour de la vitesse. À ce point là, le vecteur Resultante correspond au vecteur accéleration.
			//Il faut noter qu'on fait les calculs à chaque itération : l'intégration du vecteur accéleration pour obtenir le vecteur vitesse se transforme alors en une simple addition.
			Vitesse.x += ResultanteX;
			Vitesse.y += ResultanteY;
			//Ajouter des frottements pour éviter d'avoir les ressorts qui oscillent à l'infini
			Vitesse.scalarMul(FROTTEMENTS);

			//Calcul de la nouvelle position selon la même logique intégration = addition.
			this.x += Vitesse.x;
			this.y += Vitesse.y;
			
			if (ResultanteRessortX == 0 && ResultanteRessortY == 0)
			{
				//Cas spécial : le noeud n'est plus accroché à aucun ressort, on utilise donc la résultante globale pour calculer la rotation
				//Dans ce cas, on regarde s'il est soumis à une force. Si non, on conserve l'ancienne rotation.
				if (ResultanteX * ResultanteY > 1)
				{
					this.rotation = 180 * Math.atan2( -ResultanteX, -ResultanteY) / Math.PI;
				}
			}
			else
			{
				//Cas standard : le noeud est accroché à un ressort, en déduire l'angle correct
				this.rotation = 180 * Math.atan2(ResultanteRessortX, ResultanteRessortY) / Math.PI;
			}
			
			//Vidage de la liste des forces pour le prochain calcul
			ResultanteX = ResultanteY = 0;
			ResultanteRessortX = ResultanteRessortY = 0;
			
			if(Main.MODE == Main.MODE_GAME && isEmpty(x + Main.LARGEUR2, y + Main.HAUTEUR2) == 0)
			{
				
				//Est-ce la première fois que l'on détecte la chute ?
				if (!isFalling)
				{
					isFalling = true;
					dispatchEvent(new Event(Node.DEAD));
					Vitesse.scalarMul(3);
					
					//Le détacher de ses amis en leur appliquant une pression d'adieu
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
		 * @param	F la force de rappel
		 * @param fromSpring si la force provient d'un ressort, elle est traitée de façon particulière pour déterminer l'angle
		 */
		public final function applyForce(F:Vecteur, fromSpring:Boolean = false):void
		{
			if (!Fixe)
			{
				ResultanteX += F.x;
				ResultanteY += F.y;
				
				if (fromSpring)
				{
					var D:Number = Math.sqrt(F.x * F.x + F.y * F.y);
					ResultanteRessortX += F.x / D;
					ResultanteRessortY += F.y / D;
				}
			}
		}
	}
	
}