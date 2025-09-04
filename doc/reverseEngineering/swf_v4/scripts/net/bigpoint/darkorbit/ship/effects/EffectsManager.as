package net.bigpoint.darkorbit.ship.effects
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.ship.MapObject;
   
   public class EffectsManager
   {
      
      private static var _instance:EffectsManager;
      
      public static const NORMAL_EFFECT:String = "normal_effect";
      
      public static const ROTATION_DEPENDANT_EFFECT:String = "rotation_dependant_effect";
      
      public static const TIMEOUT_EFFECT:String = "timeout_effect";
      
      public static const BEHIND_MAP_OBJECT_EFFECT:String = "behind_ship_effect";
      
      public static var performanceSetting:int = 2;
      
      public var effectControllers:Dictionary = new Dictionary();
      
      public function EffectsManager(param1:Function)
      {
         super();
         if(param1 != hidden)
         {
            throw new Error("EffectsManager is a Singleton and can only be accessed through EffectsManager.getInstance()");
         }
      }
      
      public static function getInstance() : EffectsManager
      {
         if(_instance == null)
         {
            _instance = new EffectsManager(hidden);
         }
         return _instance;
      }
      
      private static function hidden() : void
      {
      }
      
      public function addEffectControllerToObject(param1:MapObject) : void
      {
         var _loc2_:EntityEffectController = new EntityEffectController(param1);
         if(this.effectControllers[param1] == null)
         {
            this.effectControllers[param1] = _loc2_;
         }
      }
      
      public function addEffect(param1:EffectBase, param2:MapObject, param3:String = "normal_effect") : void
      {
         if(this.effectControllers[param2] == null)
         {
            this.effectControllers[param2] = new EntityEffectController(param2);
         }
         var _loc4_:EntityEffectController = this.effectControllers[param2];
         switch(param3)
         {
            case NORMAL_EFFECT:
               _loc4_.addEffect(param1);
               break;
            case ROTATION_DEPENDANT_EFFECT:
               _loc4_.addRotationDependantEffect(param1);
               break;
            case TIMEOUT_EFFECT:
               _loc4_.addEffectWithTimeoutCallback(param1);
               break;
            case BEHIND_MAP_OBJECT_EFFECT:
               _loc4_.addEffectBehindMapObject(param1);
         }
      }
      
      public function removeAllEffects(param1:MapObject) : void
      {
         var _loc2_:EntityEffectController = this.effectControllers[param1];
         if(_loc2_ != null)
         {
            _loc2_.removeAllEffects();
         }
      }
      
      public function getEffectFromEntity(param1:MapObject, param2:int) : EffectBase
      {
         var _loc3_:EntityEffectController = this.effectControllers[param1];
         if(_loc3_ != null)
         {
            return _loc3_.getEffect(param2);
         }
         return null;
      }
      
      public function doesEffectExistOn(param1:MapObject, param2:int, param3:Number = -1) : Boolean
      {
         var _loc4_:EntityEffectController = null;
         if(this.effectControllers[param1] != null)
         {
            _loc4_ = this.effectControllers[param1];
            if(param2 == EffectIDList.HEALBEAM_EFFECT)
            {
               if(_loc4_.getEffect(param3) != null)
               {
                  return true;
               }
               return false;
            }
            if(_loc4_.getEffect(param2) != null)
            {
               return true;
            }
         }
         return false;
      }
      
      public function removeEffectByIdFromEntity(param1:MapObject, param2:int) : void
      {
         var _loc4_:EffectBase = null;
         var _loc3_:EntityEffectController = this.effectControllers[param1];
         if(_loc3_ != null)
         {
            _loc4_ = _loc3_.getEffect(param2);
         }
         if(_loc4_ != null)
         {
            _loc4_.stop();
            _loc3_.removeEffectByID(param2);
         }
      }
      
      public function killAllEffects() : void
      {
         var _loc1_:String = null;
         var _loc2_:EntityEffectController = null;
         for(_loc1_ in this.effectControllers)
         {
            _loc2_ = this.effectControllers[_loc1_];
            _loc2_.removeAllEffects();
         }
      }
      
      public function killAllEffectsBelowThreshold(param1:int) : void
      {
         var _loc2_:String = null;
         var _loc3_:EntityEffectController = null;
         for(_loc2_ in this.effectControllers)
         {
            _loc3_ = this.effectControllers[_loc2_];
            _loc3_.removeAllEffectsBelowThreshold(param1);
         }
      }
   }
}

