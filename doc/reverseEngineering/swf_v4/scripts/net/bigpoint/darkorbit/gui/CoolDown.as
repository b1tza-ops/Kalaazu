package net.bigpoint.darkorbit.gui
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.menu.ActionButton;
   
   public class CoolDown
   {
      
      public static const logger:ILogger = Log.getLogger("Cooldown");
      
      private var guiManager:GuiManager;
      
      private var buttonID:int;
      
      public var frameIndex:int = 1;
      
      public function CoolDown(param1:GuiManager, param2:int, param3:Number)
      {
         super();
         this.guiManager = param1;
         this.buttonID = param2;
         var _loc4_:MovieClip = ResourceManager.getMovieClip("actionMenu","cooldown");
         TweenLite.to(this,param3,{
            "ease":Linear.easeNone,
            "frameIndex":_loc4_.framesLoaded,
            "onUpdate":this.check,
            "onComplete":this.onComplete
         });
      }
      
      public function check() : void
      {
         var _loc3_:ActionButton = null;
         var _loc1_:Array = this.guiManager.getMenuManager().getActionButtons();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_];
            if(_loc3_.getActionID() == this.buttonID)
            {
               _loc3_.setRocketCooldown(this.frameIndex);
            }
            _loc2_++;
         }
      }
      
      public function getButtonID() : int
      {
         return this.buttonID;
      }
      
      private function onComplete() : void
      {
         var _loc3_:ActionButton = null;
         this.guiManager.removeCooldown(this);
         var _loc1_:Array = this.guiManager.getMenuManager().getActionButtons();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_];
            if(_loc3_.getActionID() == this.buttonID)
            {
               _loc3_.cooldownCompleted();
            }
            _loc2_++;
         }
      }
      
      public function cleanup() : void
      {
      }
   }
}

