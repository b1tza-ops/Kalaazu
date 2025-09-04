package net.bigpoint.darkorbit.menu
{
   import flash.display.MovieClip;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class RocketLauncherLoadDecorator extends ActionButtonDecorator implements IActionButtonDecorator
   {
      
      public static const logger:ILogger = Log.getLogger("RocketLauncherLoadDecorator");
      
      public var slotRL0:MovieClip;
      
      public var slotRL1:MovieClip;
      
      public var slotRL2:MovieClip;
      
      private var mc:MovieClip;
      
      public var rocketLauncherSlotCount:Array = [0,3,5];
      
      public function RocketLauncherLoadDecorator(param1:MovieClip)
      {
         super();
         this.mc = param1;
         this.mc.visible = false;
         this.mc.mouseChildren = false;
         this.mc.mouseEnabled = false;
         this.slotRL0 = this.mc["slots"]["slotRL0"];
         this.slotRL1 = this.mc["slots"]["slotRL1"];
         this.slotRL2 = this.mc["slots"]["slotRL2"];
         this.slotRL0.visible = false;
         this.slotRL1.visible = false;
         this.slotRL2.visible = false;
         this.update();
      }
      
      override public function update() : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:int = 0;
         this.mc.visible = true;
         this.slotRL0.visible = false;
         this.slotRL1.visible = false;
         this.slotRL2.visible = false;
         var _loc1_:MovieClip = this["slotRL" + Settings.rocketLauncherType];
         _loc1_.visible = true;
         if(Settings.rocketLauncherType != 0)
         {
            _loc2_ = int(this.rocketLauncherSlotCount[Settings.rocketLauncherType]);
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc3_ = _loc1_["filledSlots"]["slot" + (_loc4_ + 1)] as MovieClip;
               if(_loc3_ != null)
               {
                  if(_loc4_ < Settings.rocketLauncherRocketsLoaded)
                  {
                     _loc3_.visible = true;
                     _loc3_.gotoAndStop(Settings.selectedLauncherRocket);
                  }
                  else
                  {
                     _loc3_.visible = false;
                  }
               }
               _loc4_++;
            }
            this.mc["selectedLauncherRocket"].gotoAndStop(Settings.selectedLauncherRocket);
         }
         else
         {
            this.mc["selectedLauncherRocket"].gotoAndStop(1);
         }
      }
   }
}

