package net.bigpoint.darkorbit.ship.effects
{
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   
   public class EffectFactory
   {
      
      private static var instance:EffectFactory;
      
      public static const logger:ILogger = Log.getLogger("EffectFactory");
      
      public function EffectFactory(param1:Function)
      {
         super();
         if(param1 !== hidden)
         {
            throw new Error("PetAssembly is a Singleton and can only be accessed through EffectFactory.getInstance()");
         }
      }
      
      public static function getInstance() : EffectFactory
      {
         if(instance == null)
         {
            instance = new EffectFactory(hidden);
         }
         return instance;
      }
      
      private static function hidden() : void
      {
      }
      
      public function createEffect(param1:int, param2:Array) : EffectBase
      {
         var _loc3_:EffectBase = null;
         var _loc4_:EffectPattern = PatternManager.effectPatterns[param1];
         if(_loc4_ != null)
         {
            if(param1 == EffectIDList.LOCATOR)
            {
               _loc3_ = new LocatorGearEffect(param1,_loc4_,false,param2);
            }
            else
            {
               _loc3_ = new PetEffect(param1,_loc4_,false,param2);
            }
         }
         return _loc3_;
      }
   }
}

