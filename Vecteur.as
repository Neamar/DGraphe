package
{
        import flash.geom.Point;

		/**
		 * Un vecteur, qui est en fait un déguisement de Point, mais cela clarifie le code.
		 * Utilisé pour la représentation mathématique des forces appliquées sur un noeud (un élément du niveau)
		 * Implémente quelques fonctions basiques utiles.
		 * Dans l'idéal, cette classe devrait être inlinée pour gagner en performance (trop de construction d'objets inutiles sinon...)
		 */
		
        public class Vecteur extends Point
        {
                public function Vecteur(x:Number=0,y:Number=0)
                {
                    super(x,y);
                }

                public final function ajouter(P:Vecteur):void
                {
					this.x += P.x;
					this.y += P.y;
                }
                public final function scalarMul(k:Number):void
                {
					this.x *= k;
					this.y *= k;
                }
        }
}