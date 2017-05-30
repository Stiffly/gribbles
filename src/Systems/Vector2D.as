package Systems 
{
	/**
	 * ...
	 * @author Sebastian Lundgren and Max Larsson
	 */
	public class Vector2D 
	{
		public var _x:Number;
		public var _y:Number;
		
		
		public function Vector2D(x:Number, y:Number):void 
		{
			this._x = x;
			this._y = y;
		}
		
		public function setVector(newVec:Vector2D):void 
		{
			this._x = newVec._x;
			this._y = newVec._y;
		}
		
		public function normalize():Vector2D
        {
            const nf:Number = 1 / Math.sqrt(_x * _x + _y * _y);
            return new Vector2D(_x * nf, _y * nf);
        }
		
		public function length() : Number
		{
			return Math.sqrt(_x * _x + _y * _y);
		}
		
		public function rescale(newLength : Number): Vector2D 
		{
			const nf:Number = newLength / Math.sqrt(_x * _x + _y * _y);
			return (new Vector2D(_x * nf, _y * nf));
		}
		
		public function findVector(toPoint:Vector2D) : Vector2D
		{
			var result : Vector2D = new Vector2D(0, 0);
			
			result._x = toPoint._x - _x;
			result._y = toPoint._y - _y;
			
			return result;
		}
		
		public function dot(vec : Vector2D): Number 
		{ 
			return (_x * vec._x + _y * vec._y);
		}
		
		public function addition(value : Vector2D) : void
		{
			_x += value._x;
			_y += value._y;
		}
		
		public function subtraction(value : Vector2D) : void
		{
			_x -= value._x;
			_x -= value._y;
		}
		
		public function multiplyNormVec(value : Number) : void
		{
			_x *= value;
			_y *= value;
		}
		
		public function dividePoint(value : Number) : void
		{
			_x /= value;
			_y /= value;
		}
		
		
		public function isEqvivalentTo(toComp : Vector2D): Boolean 
		{
			var toReturn : Boolean = false;
			
			if (_x == toComp._x && _y == toComp._y)
			{
				toReturn = true;
			}
			
			return toReturn;
		}
	}
}