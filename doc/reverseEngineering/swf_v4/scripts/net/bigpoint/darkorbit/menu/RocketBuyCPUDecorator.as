package net.bigpoint.darkorbit.menu
{
   import flash.display.MovieClip;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.gui.CPUItem;
   
   public class RocketBuyCPUDecorator implements IActionButtonDecorator
   {
      
      public static const logger:ILogger = Log.getLogger("RocketBuyCPUDecorator");
      
      public var rocketsClip:MovieClip;
      
      private var mc:MovieClip;
      
      public function RocketBuyCPUDecorator(param1:MovieClip)
      {
         super();
         this.mc = param1;
         this.rocketsClip = this.mc["rocketsSlot"];
         this.update();
      }
      
      public function update() : void
      {
         if(CPUItem(Hero.cpuItems[CPUItem.TYPE_ROCKETBUY]) != null)
         {
            this.rocketsClip.gotoAndStop("rockettype_" + CPUItem(Hero.cpuItems[CPUItem.TYPE_ROCKETBUY]).level);
         }
      }
   }
}

