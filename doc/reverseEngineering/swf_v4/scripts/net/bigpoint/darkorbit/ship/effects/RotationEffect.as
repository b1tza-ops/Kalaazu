package net.bigpoint.darkorbit.ship.effects
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class RotationEffect extends EffectBase
   {
      
      public function RotationEffect(param1:int, param2:EffectPattern, param3:Boolean = false, param4:Array = null, param5:Boolean = true)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function initEffectVisuals() : void
      {
         this.addRotationTick();
      }
      
      public function addRotationTick() : void
      {
         addEventListener(Event.ENTER_FRAME,this.mapObjectRotationCallback);
      }
      
      public function mapObjectRotationCallback(param1:Event) : void
      {
         if(associatedMapObject != null)
         {
            if(associatedMapObject.currentlyMoving)
            {
               this.actionOnMovingRotation();
            }
            else
            {
               this.actionOnStationaryRotation();
            }
         }
      }
      
      public function actionOnMovingRotation() : void
      {
      }
      
      public function actionOnStationaryRotation() : void
      {
      }
      
      override public function cleanup() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.mapObjectRotationCallback);
         associatedMapObject = null;
      }
   }
}

