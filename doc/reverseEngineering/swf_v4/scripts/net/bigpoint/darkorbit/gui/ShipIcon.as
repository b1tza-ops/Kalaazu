package net.bigpoint.darkorbit.gui
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.geom.Rectangle;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class ShipIcon extends Sprite
   {
      
      public static const STATE_STD:int = 1;
      
      public static const STATE_FOGGY:int = 2;
      
      public static const STATE_ACTIVE:int = 3;
      
      private static const logger:ILogger = Log.getLogger("ShipIcon");
      
      private var _baseGraphic:Bitmap;
      
      private var _baseGraphicFull:Bitmap;
      
      private var _shutterGraphic:Bitmap;
      
      private var _cloaked:Boolean;
      
      private var _state:int = 1;
      
      private var _foggy:Boolean = true;
      
      private var _inFight:Boolean;
      
      private var _colors:Array = [];
      
      private var _isOffline:Boolean;
      
      public function ShipIcon()
      {
         super();
         this._colors[STATE_ACTIVE] = 14102062;
         this._colors[STATE_FOGGY] = 10066329;
         this._colors[STATE_STD] = 16777215;
         this.createShutterGraphic();
      }
      
      private function createShutterGraphic() : void
      {
         this._shutterGraphic = new Bitmap(new BitmapData(20,20,true,0));
         this._shutterGraphic.bitmapData.fillRect(new Rectangle(0,0,20,1),4294967295);
         this._shutterGraphic.bitmapData.fillRect(new Rectangle(0,2,20,1),4294967295);
         this._shutterGraphic.bitmapData.fillRect(new Rectangle(0,4,20,1),4294967295);
         this._shutterGraphic.bitmapData.fillRect(new Rectangle(0,6,20,1),4294967295);
         this._shutterGraphic.bitmapData.fillRect(new Rectangle(0,8,20,1),4294967295);
         this._shutterGraphic.bitmapData.fillRect(new Rectangle(0,10,20,1),4294967295);
         this._shutterGraphic.bitmapData.fillRect(new Rectangle(0,12,20,1),4294967295);
         this._shutterGraphic.bitmapData.fillRect(new Rectangle(0,14,20,1),4294967295);
         this._shutterGraphic.bitmapData.fillRect(new Rectangle(0,16,20,1),4294967295);
         this._shutterGraphic.bitmapData.fillRect(new Rectangle(0,18,20,1),4294967295);
      }
      
      public function get baseGraphic() : Bitmap
      {
         return this._baseGraphicFull;
      }
      
      public function set baseGraphic(param1:Bitmap) : void
      {
         if(this._baseGraphic != null && contains(this._baseGraphic))
         {
            removeChild(this._baseGraphic);
         }
         this._baseGraphicFull = param1;
         this._baseGraphic = new Bitmap(this._baseGraphicFull.bitmapData.clone());
         addChild(this._baseGraphic);
         this.updateColor();
      }
      
      public function set cloaked(param1:Boolean) : void
      {
         if(this._cloaked != param1)
         {
            this._cloaked = param1;
            if(this._isOffline)
            {
               return;
            }
            removeChild(this._baseGraphic);
            this._baseGraphic = new Bitmap(this._baseGraphicFull.bitmapData.clone());
            addChild(this._baseGraphic);
            if(this._cloaked)
            {
               this._baseGraphic.bitmapData.draw(this._shutterGraphic,null,null,BlendMode.ERASE);
            }
            this.updateColor();
         }
      }
      
      public function get cloaked() : Boolean
      {
         return this._cloaked;
      }
      
      public function get state() : int
      {
         return this._state;
      }
      
      public function set state(param1:int) : void
      {
         if(this._state != param1)
         {
            this._state = param1;
         }
      }
      
      public function get foggy() : Boolean
      {
         return this._foggy;
      }
      
      public function set foggy(param1:Boolean) : void
      {
         if(this._foggy != param1)
         {
            this._foggy = param1;
            if(this._isOffline)
            {
               return;
            }
            this.updateColor();
         }
      }
      
      private function updateColor() : void
      {
         if(this._isOffline)
         {
            return;
         }
         var _loc1_:ColorTransform = new ColorTransform();
         if(this._inFight)
         {
            _loc1_.color = this._colors[STATE_ACTIVE];
         }
         else if(this._foggy)
         {
            _loc1_.color = this._colors[STATE_FOGGY];
         }
         else
         {
            _loc1_.color = this._colors[STATE_STD];
         }
         this._baseGraphic.transform.colorTransform = _loc1_;
      }
      
      public function get inFight() : Boolean
      {
         return this._inFight;
      }
      
      public function set inFight(param1:Boolean) : void
      {
         if(this._inFight != param1)
         {
            this._inFight = param1;
            this.updateColor();
         }
      }
      
      public function get isOffline() : Boolean
      {
         return this._isOffline;
      }
      
      public function set isOffline(param1:Boolean) : void
      {
         if(this._isOffline != param1)
         {
            this._isOffline = param1;
         }
      }
   }
}

