package net.bigpoint.darkorbit.gui
{
   import com.bigpoint.utils.BPLocale;
   import com.bigpoint.utils.ui.tooltip.ToolTipHook;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.gui.windows.components.buff.BuffItem;
   
   public class BuffCoolDown
   {
      
      private var target:BuffItem;
      
      private var seconds:int;
      
      private var completeCallBack:Function;
      
      private var tooltip:ToolTipHook;
      
      private var tooltipKey:String;
      
      private var tween:TweenLite;
      
      private var cooldown:MovieClip;
      
      public function BuffCoolDown(param1:BuffItem, param2:int, param3:ToolTipHook, param4:String, param5:Function = null)
      {
         super();
         this.tooltip = param3;
         this.tooltipKey = param4;
         this.completeCallBack = param5;
         this.seconds = param2;
         this.target = param1;
      }
      
      public function addCoolDown() : void
      {
         this.cooldown = ResourceManager.getMovieClip("actionMenu","cooldown");
         this.cooldown.alpha = 0.6;
         this.cooldown.x = this.cooldown.y = -2;
         this.target.addChild(this.cooldown);
         this.tween = TweenLite.to(this.cooldown,this.seconds,{
            "onUpdate":this.onUpdate,
            "frame":this.cooldown.totalFrames,
            "ease":Linear.easeNone,
            "onComplete":this.onComplete
         });
      }
      
      private function onUpdate(param1:Array = null) : void
      {
         var _loc2_:String = BPLocale.getText(this.tooltipKey) + " " + (this.seconds - Math.round(this.tween.currentTime));
         this.tooltip.updateText(_loc2_);
      }
      
      private function onComplete(param1:Array = null) : void
      {
         this.tooltip.updateText(BPLocale.getText(this.tooltipKey));
         this.target.removeChild(this.cooldown);
         if(this.completeCallBack != null)
         {
            this.completeCallBack(this.target);
         }
      }
   }
}

