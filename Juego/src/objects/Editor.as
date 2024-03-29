package objects 
{
	import flash.ui.Keyboard;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author Borja
	 */
	public class Editor extends Sprite 
	{
		private var _realXpos:int;
		private var _realYpos:int;
		
		private var _Xpos:int;
		private var _Ypos:int;
		
		private var _sectorXPos:int;
		private var _sectorYPos:int;
		
		private var _index:int;
		
		private var _changeMapTile:Boolean;
		private var _sendTrace:Boolean;
		
		private var _tileSelected:int;
		private var _lastTileSelected:int;
		private var _editorDim:int;
		
		private var _maxRowsSector:int;
		private var _maxColumnsSector:int;
		private var _maxXSectors:int;
		private var _maxYSectors:int;
		
		private var _actualXSector:int;
		private var _actualYSector:int;
		private var _layer:int = 1;
		private var _layerName:String = "terrain";
		private var _firstIndexImage:int = 1;
		private var _lastIndexImage:int = 10;
		
		private var _image:Image;
		
		public function Editor(maxRowsSector:int, maxColumnsSector:int, maxXSectors:int, maxYSectors:int) 
		{
			super();
			
			this._realXpos = 0;
			this._realYpos = 0;
			this._Xpos = 0;
			this._Ypos = 0;
			this._index = 0;
			this._actualXSector = 0;
			this._actualYSector = 0;
			this._maxXSectors = maxXSectors;
			this._maxYSectors = maxYSectors;
			this._tileSelected = 2;
			this._changeMapTile = false;
			this._sendTrace = false;
			this._lastTileSelected = this._tileSelected;
			
			this._maxRowsSector = maxRowsSector;
			this._maxColumnsSector = maxColumnsSector;
			
			this.addEventListener(Event.ADDED_TO_STAGE, initializeEditor);
		}
		
		
		
		private function initializeEditor():void {
			this.removeEventListener(Event.ADDED_TO_STAGE, initializeEditor);
			
			this._image = new Image(Assets.getAtlas().getTexture(this._layerName + "_" + _tileSelected));
			this._image.x = _realXpos;
			this._image.y = _realYpos;
			this._image.height = _editorDim;
			this._image.width = _editorDim;
			this.addChild(_image);
			
			this.addEventListener(Event.ENTER_FRAME, update);
			
			this.addEventListener(KeyboardEvent.KEY_DOWN, moveEditor);
		}
		
		private function update():void {
			this.x = _realXpos;
			this.y = _realYpos;
			
			if (this._tileSelected != this._lastTileSelected) 
			{
				this.changeImage();
			}
		}
		
		private function moveEditor(e:KeyboardEvent):void {
			
			if (e.keyCode == Keyboard.W && this._Ypos > 0) 
			{
				this._Ypos -= 1;
			}
			if (e.keyCode == Keyboard.S && this._Ypos < this._maxRowsSector * this._maxYSectors - 1) 
			{
				this._Ypos += 1;
			}
			if (e.keyCode == Keyboard.A && this._Xpos > 0) 
			{
				this._Xpos -= 1;
			}
			if (e.keyCode == Keyboard.D && this._Xpos < this._maxColumnsSector * this._maxXSectors - 1) 
			{
				this._Xpos += 1;
			}
			
			if (e.keyCode == Keyboard.Q) 
			{
				if (this._tileSelected == this._firstIndexImage) this._tileSelected = this._lastIndexImage;
				else this._tileSelected -= 1;
			}
			if (e.keyCode == Keyboard.E) 
			{
				if (this._tileSelected == this._lastIndexImage) this._tileSelected = this._firstIndexImage;
				else this._tileSelected += 1;
			}
			
			if (e.keyCode == Keyboard.R) 
			{
				if (this._layer == 6) this._layer = 1;
				else this._layer += 1;
				this._tileSelected = this._firstIndexImage;
				this._lastTileSelected = this._lastIndexImage;
				this.changeImage();
			}
			if (e.keyCode == Keyboard.F) 
			{
				if (this._layer == 1) this._layer = 6;
				else this._layer -= 1;
				this._tileSelected = this._firstIndexImage;
				this._lastTileSelected = this._lastIndexImage;
				this.changeImage();
			}
			
			if (e.keyCode == Keyboard.P) 
			{
				this._changeMapTile = true;
			}
			if (e.keyCode == Keyboard.O) 
			{
				this._changeMapTile = true;
				this._tileSelected = 0;
			}
			
			if (e.keyCode == Keyboard.T) 
			{
				this._sendTrace = true;
			}
			
			this._sectorXPos = this._Xpos % this._maxColumnsSector;
			this._sectorYPos = this._Ypos % this._maxRowsSector;
			
			this._actualXSector = Math.abs(this._Xpos / this._maxColumnsSector);
			this._actualYSector = Math.abs(this._Ypos / this._maxRowsSector);
			
			this._realXpos = _Xpos * _editorDim;
			this._realYpos = _Ypos * _editorDim;
			
			switch (this._layer) {
				case 1:
					this._layerName = "terrain";
					this._lastIndexImage = 17;
					break;
				case 2:
					this._layerName = "roads";
					this._lastIndexImage = 2;
					break;
				case 3:
					this._layerName = "objectsAndWalls";
					this._lastIndexImage = 10;
					break;
				case 4:
					this._layerName = "objectsAndWalls";
					this._lastIndexImage = 10;
					break;
				case 5:
					this._layerName = "trees";
					this._lastIndexImage = 4;
					break;
				case 6:
					this._layerName = "ceilings";
					this._lastIndexImage = 10;
					break;
				default:
					this._layerName = "terrain";
					this._lastIndexImage = 17;
					break;
			}
		}
		
		private function changeImage():void {
			if (this._tileSelected != 0) 
			{
				this._image.texture = Assets.getAtlas().getTexture(this._layerName + "_" + _tileSelected);
				this._lastTileSelected = this._tileSelected;
			}
			else 
			{
				this._tileSelected = this._lastTileSelected;
				this._image.texture = Assets.getAtlas().getTexture(this._layerName + "_" + _tileSelected);
			}
			
		}
		
		
		public function get changeMapTile():Boolean {
			return this._changeMapTile;
		}
		
		public function set changeMapTile(change:Boolean):void {
			this._changeMapTile = change;
		}
		
		public function get sendTrace():Boolean {
			return this._sendTrace;
		}
		
		public function set sendTrace(sendTrace:Boolean):void {
			this._sendTrace = sendTrace;
		}
		
		public function get tileToChange():int {
			return this._tileSelected;
		}
		
		public function set tileToChange(tile:int):void {
			this._tileSelected = tile;
		}
		
		public function get Xposition():int {
			return this._Xpos;
		}
		
		public function set Xposition(x:int):void {
			this._Xpos = x;
		}
		
		public function get Yposition():int {
			return this._Ypos;
		}
		
		public function set Yposition(y:int):void {
			this._Ypos = y;
		}
		
		public function get image():Image {
			return _image;
		}
		
		public function set image(value:Image):void {
			_image = value;
		}
		
		public function get editorDim():int {
			return _editorDim;
		}
		
		public function set editorDim(value:int):void {
			_editorDim = value;
		}
		
		public function get actualXSector():int {
			return _actualXSector;
		}
		
		public function set actualXSector(value:int):void {
			_actualXSector = value;
		}
		
		public function get actualYSector():int {
			return _actualYSector;
		}
		
		public function set actualYSector(value:int):void {
			_actualYSector = value;
		}
		
		public function get sectorXPos():int 
		{
			return _sectorXPos;
		}
		
		public function set sectorXPos(value:int):void 
		{
			_sectorXPos = value;
		}
		
		public function get sectorYPos():int 
		{
			return _sectorYPos;
		}
		
		public function set sectorYPos(value:int):void 
		{
			_sectorYPos = value;
		}
		
		public function get layer():int 
		{
			return _layer;
		}
		
		public function set layer(value:int):void 
		{
			_layer = value;
		}
		
	}

}