package net.bigpoint.darkorbit.ship.effects
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.ship.MapObject;
   
   public class EntityEffectController
   {
      
      public var effectList:Dictionary = new Dictionary();
      
      public var effects:Array = [];
      
      public var mapObject:MapObject;
      
      public function EntityEffectController(param1:MapObject)
      {
         super();
         this.mapObject = param1;
      }
      
      public function addEffect(param1:EffectBase) : void
      {
         this.effects.push(param1);
         this.mapObject.getClipContainer().addChild(param1.getEffect());
      }
      
      public function addEffectBehindMapObject(param1:EffectBase) : void
      {
         this.effects.push(param1);
         EffectBase(param1).associatedMapObject = this.mapObject;
         param1.addEventListener(EntityEffectEvent.EFFECT_TIMEOUT,this.handleEffectTimeout);
         this.mapObject.getClipContainer().addChild(param1.getEffect());
         this.mapObject.getClipContainer().setChildIndex(param1.getEffect(),0);
      }
      
      public function addRotationDependantEffect(param1:EffectBase) : void
      {
         this.effects.push(param1);
         EffectBase(param1).associatedMapObject = this.mapObject;
         this.mapObject.getClipContainer().addChild(param1.getEffect());
      }
      
      public function addEffectWithTimeoutCallback(param1:EffectBase) : void
      {
         this.effects.push(param1);
         this.mapObject.getClipContainer().addChild(param1.getEffect());
         param1.addEventListener(EntityEffectEvent.EFFECT_TIMEOUT,this.handleEffectTimeout);
      }
      
      private function handleEffectTimeout(param1:EntityEffectEvent) : void
      {
         this.removeEffectByID(param1.effectID);
      }
      
      private function handleFullRemove(param1:EffectBase) : void
      {
         this.removeEffectByID(param1.id);
      }
      
      public function removeEffectByID(param1:int) : void
      {
         var _loc3_:EffectBase = null;
         var _loc2_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < this.effects.length)
         {
            _loc3_ = this.effects[_loc4_] as EffectBase;
            if(_loc3_.id == param1)
            {
               _loc3_.cleanup();
               if(this.mapObject.getClipContainer().contains(_loc3_.getEffect()))
               {
                  this.mapObject.getClipContainer().removeChild(_loc3_.getEffect());
               }
               _loc2_.push(_loc4_);
               _loc3_ = null;
            }
            _loc4_++;
         }
         this.removeAllEffectsFromList(_loc2_);
      }
      
      private function removeAllEffectsFromList(param1:Array) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this.effects.splice(param1[_loc2_],1);
            _loc2_++;
         }
      }
      
      private function removeEffect(param1:EffectBase) : void
      {
         param1.cleanup();
         this.mapObject.getClipContainer().removeChild(param1.getEffect());
      }
      
      public function removeAllEffects() : void
      {
         var _loc1_:EffectBase = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.effects.length)
         {
            _loc1_ = this.effects[_loc2_];
            if(_loc1_ != null)
            {
               this.removeEffect(_loc1_);
            }
            delete this.effects[_loc2_];
            _loc2_++;
         }
         this.effects = [];
      }
      
      public function removeAllEffectsBelowThreshold(param1:int) : void
      {
         var _loc2_:EffectBase = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.effects.length)
         {
            _loc2_ = this.effects[_loc3_];
            if(_loc2_ != null && _loc2_.performanceRating > param1)
            {
               this.removeEffect(_loc2_);
            }
            delete this.effects[_loc3_];
            _loc3_++;
         }
         this.effects = [];
      }
      
      public function getLastStackedEffect() : EffectBase
      {
         return this.effects[this.effects.length - 1] as EffectBase;
      }
      
      public function getEffect(param1:int) : EffectBase
      {
         var _loc2_:EffectBase = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.effects.length)
         {
            _loc2_ = this.effects[_loc3_] as EffectBase;
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
            _loc3_++;
         }
         return null;
      }
   }
}

