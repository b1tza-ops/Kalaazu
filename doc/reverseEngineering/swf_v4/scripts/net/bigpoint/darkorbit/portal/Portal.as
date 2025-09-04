package net.bigpoint.darkorbit.portal
{
   import flash.display.MovieClip;
   import net.bigpoint.darkorbit.pattern.DynamicResource;
   
   public class Portal extends DynamicResource
   {
      
      private var id:int;
      
      public var factionID:int;
      
      private var posX:int;
      
      private var posY:int;
      
      private var activeClip:MovieClip;
      
      public var visibleOnMiniMap:Boolean;
      
      public var assetIDs:Vector.<int>;
      
      public function Portal(param1:int, param2:int, param3:int, param4:int, param5:int, param6:Boolean, param7:Vector.<int>)
      {
         super(param3);
         this.posX = param4;
         this.posY = param5;
         this.id = param1;
         this.factionID = param2;
         this.visibleOnMiniMap = param6;
         this.assetIDs = param7;
      }
      
      public function setActiveClip(param1:MovieClip) : void
      {
         this.activeClip = param1;
      }
      
      public function getID() : int
      {
         return this.id;
      }
      
      public function getPosX() : int
      {
         return this.posX;
      }
      
      public function getPosY() : int
      {
         return this.posY;
      }
      
      public function getActiveClip() : MovieClip
      {
         return this.activeClip;
      }
      
      public function cleanup() : void
      {
         removeClip();
         this.activeClip = null;
      }
   }
}

