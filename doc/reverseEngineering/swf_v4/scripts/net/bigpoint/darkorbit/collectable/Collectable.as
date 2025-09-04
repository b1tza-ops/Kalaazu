package net.bigpoint.darkorbit.collectable
{
   import com.bigpoint.utils.ui.tooltip.StickyToolTipHook;
   import flash.display.DisplayObject;
   
   public class Collectable
   {
      
      private var _collectableClass:int;
      
      protected var typeID:int;
      
      private var _clip:DisplayObject;
      
      private var hash:String;
      
      private var posX:int;
      
      private var posY:int;
      
      public var collectablePattern:CollectablePattern;
      
      public var tooltipHook:StickyToolTipHook;
      
      public function Collectable(param1:int, param2:CollectablePattern, param3:int, param4:String, param5:int, param6:int)
      {
         super();
         this._collectableClass = param1;
         this.collectablePattern = param2;
         this.typeID = param3;
         this.hash = param4;
         this.posX = param5;
         this.posY = param6;
      }
      
      public function getHash() : String
      {
         return this.hash;
      }
      
      public function getPosX() : int
      {
         return this.posX;
      }
      
      public function getPosY() : int
      {
         return this.posY;
      }
      
      public function getTypeID() : int
      {
         return this.typeID;
      }
      
      public function getCollectablePattern() : CollectablePattern
      {
         return this.collectablePattern;
      }
      
      public function removeClip() : void
      {
         this._clip = null;
      }
      
      public function get clip() : DisplayObject
      {
         return this._clip;
      }
      
      public function set clip(param1:DisplayObject) : void
      {
         this._clip = param1;
      }
      
      public function get collectableClass() : int
      {
         return this._collectableClass;
      }
   }
}

