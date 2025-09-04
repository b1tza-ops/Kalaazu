package net.bigpoint.darkorbit.ship
{
   import net.bigpoint.darkorbit.pattern.ResourcePattern;
   
   public class ShipPattern extends ResourcePattern
   {
      
      public var playLoop:Boolean;
      
      private var laserClassID:int;
      
      private var rocketClassID:int;
      
      private var expansionClassID:int = -1;
      
      private var labelVisible:Boolean = true;
      
      private var labelYOffset:int;
      
      private var energyVisible:Boolean = true;
      
      private var energyYOffset:int;
      
      private var selectionYOffset:int;
      
      private var explodeTypeID:int;
      
      private var laserDamageTypeID:int;
      
      private var rocketDamageTypeID:int;
      
      private var engineTypeID:int;
      
      private var engineSmokeID:int;
      
      public var enginePositionClassID:int = -1;
      
      private var glowID:int = -1;
      
      public var moveRadiusSquared:int = 100;
      
      private var seekInterval:int = 200;
      
      private var clickRadius:int = 45;
      
      private var clickOffsetX:int;
      
      private var clickOffsetY:int;
      
      private var spaceball:Boolean;
      
      public var megaExplosion:Boolean;
      
      public var showCrap:Boolean;
      
      public var showPilot:int;
      
      public var pilotDistance:int;
      
      public var rotatable:Boolean = true;
      
      public var iconClassID:int;
      
      public var shockwaveID:int = 0;
      
      public function ShipPattern(param1:int, param2:String)
      {
         super(param1,param2);
      }
      
      public function getSeekInterval() : int
      {
         return this.seekInterval;
      }
      
      public function setPlayLoop(param1:Boolean) : void
      {
         this.playLoop = param1;
      }
      
      public function setLaserClassID(param1:int) : void
      {
         this.laserClassID = param1;
      }
      
      public function getLaserClassID() : int
      {
         return this.laserClassID;
      }
      
      public function setRocketClassID(param1:int) : void
      {
         this.rocketClassID = param1;
      }
      
      public function getRocketClass() : int
      {
         return this.rocketClassID;
      }
      
      public function setExpansionClassID(param1:int) : void
      {
         this.expansionClassID = param1;
      }
      
      public function getExpansionClassID() : int
      {
         return this.expansionClassID;
      }
      
      public function hasExpansion() : Boolean
      {
         if(this.expansionClassID == -1)
         {
            return false;
         }
         return true;
      }
      
      public function setLabelVisibility(param1:Boolean) : void
      {
         this.labelVisible = param1;
      }
      
      public function isLabelVisible() : Boolean
      {
         return this.labelVisible;
      }
      
      public function setLabelYOffset(param1:int) : void
      {
         this.labelYOffset = param1;
      }
      
      public function getLabelYOffset() : int
      {
         return this.labelYOffset;
      }
      
      public function setEnergyVisibility(param1:Boolean) : void
      {
         this.energyVisible = param1;
      }
      
      public function isEnergyVisible() : Boolean
      {
         return this.energyVisible;
      }
      
      public function setEnergyYOffset(param1:int) : void
      {
         this.energyYOffset = param1;
      }
      
      public function getEnergyYOffset() : int
      {
         return this.energyYOffset;
      }
      
      public function setSelectionYOffset(param1:int) : void
      {
         this.selectionYOffset = param1;
      }
      
      public function getSelectionYOffset() : int
      {
         return this.selectionYOffset;
      }
      
      public function setExplodeTypeID(param1:int) : void
      {
         this.explodeTypeID = param1;
      }
      
      public function getExplodeTypeID() : int
      {
         return this.explodeTypeID;
      }
      
      public function setLaserDamageType(param1:int) : void
      {
         this.laserDamageTypeID = param1;
      }
      
      public function getLaserDamageTypeID() : int
      {
         return this.laserDamageTypeID;
      }
      
      public function setRocketDamageTypeID(param1:int) : void
      {
         this.rocketDamageTypeID = param1;
      }
      
      public function getRocketDamageTypeID() : int
      {
         return this.rocketDamageTypeID;
      }
      
      public function setEngineTypeID(param1:int) : void
      {
         this.engineTypeID = param1;
      }
      
      public function getEngineTypeID() : int
      {
         return this.engineTypeID;
      }
      
      public function setEnginePositionClassID(param1:int) : void
      {
         this.enginePositionClassID = param1;
      }
      
      public function getEnginePositionClassID() : int
      {
         return this.enginePositionClassID;
      }
      
      public function getEngineSmokeID() : int
      {
         return this.engineSmokeID;
      }
      
      public function setEngineSmokeID(param1:int) : void
      {
         this.engineSmokeID = param1;
      }
      
      public function getGlowID() : int
      {
         return this.glowID;
      }
      
      public function setGlowID(param1:int) : void
      {
         this.glowID = param1;
      }
      
      public function setMoveRadius(param1:int) : void
      {
         this.moveRadiusSquared = param1 * param1;
      }
      
      public function getClickRadius() : int
      {
         return this.clickRadius;
      }
      
      public function setClickRadius(param1:int) : void
      {
         this.clickRadius = param1;
      }
      
      public function getClickOffsetX() : int
      {
         return this.clickOffsetX;
      }
      
      public function setClickOffsetX(param1:int) : void
      {
         this.clickOffsetX = param1;
      }
      
      public function getClickOffsetY() : int
      {
         return this.clickOffsetY;
      }
      
      public function setClickOffsetY(param1:int) : void
      {
         this.clickOffsetY = param1;
      }
      
      public function isSpaceball() : Boolean
      {
         return this.spaceball;
      }
      
      public function setSpaceball(param1:Boolean) : void
      {
         this.spaceball = param1;
      }
      
      public function setSeekInterval(param1:int) : void
      {
         this.seekInterval = param1;
      }
   }
}

