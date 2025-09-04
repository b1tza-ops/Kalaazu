package net.bigpoint.darkorbit.alienmothership
{
   import com.greensock.TweenLite;
   import net.bigpoint.darkorbit.ScreenManager;
   import net.bigpoint.darkorbit.audio.AudioManager;
   
   public class AlienMothershipManager
   {
      
      public var alienMotherships:Array = [];
      
      public var screenManager:ScreenManager;
      
      public function AlienMothershipManager(param1:ScreenManager)
      {
         super();
         this.screenManager = param1;
      }
      
      public function rotateAlienMothership(param1:int, param2:int) : void
      {
         var _loc3_:AlienMothership = this.alienMotherships[param1];
         if(_loc3_ != null && _loc3_.clipLoaded)
         {
            _loc3_.startRotation(param2);
         }
      }
      
      public function prepareAttack(param1:int, param2:int) : void
      {
         var _loc3_:AlienMothership = this.alienMotherships[param1];
         if(_loc3_ != null && _loc3_.clipLoaded)
         {
            _loc3_.prepareAttack(param2);
         }
      }
      
      public function prepareBigAttack(param1:int, param2:int) : void
      {
         var _loc3_:AlienMothership = this.alienMotherships[param1];
         if(_loc3_ != null && _loc3_.clipLoaded)
         {
            _loc3_.prepareBigAttack(param2);
         }
      }
      
      public function cloak(param1:int, param2:int) : void
      {
         var _loc3_:AlienMothership = this.alienMotherships[param1];
         if(_loc3_ != null)
         {
            if(_loc3_.clipLoaded)
            {
               _loc3_.cloak(param2);
            }
            else if(param2 == 0)
            {
               _loc3_.visible = false;
            }
            else
            {
               _loc3_.visible = true;
            }
         }
      }
      
      public function idle(param1:int) : void
      {
         var _loc2_:AlienMothership = this.alienMotherships[param1];
         if(_loc2_ != null && _loc2_.clipLoaded)
         {
            _loc2_.startIdle();
         }
      }
      
      public function kill(param1:int) : void
      {
         var _loc2_:AlienMothership = this.alienMotherships[param1];
         this.screenManager.map.getMain().screenManager.flashScreen(16777215,0.75,0.25,2);
         AudioManager.playSoundEffect(18,false,false,_loc2_.x,_loc2_.y);
         this.screenManager.map.getCombatManager().showShockwave(0,_loc2_.x,_loc2_.y,true);
         this.screenManager.map.getMain().screenManager.shakeScreen();
         this.screenManager.getShipLayer().removeChild(_loc2_);
         _loc2_.stopAnimations();
         delete this.alienMotherships[param1];
      }
      
      public function move(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:AlienMothership = this.alienMotherships[param1];
         if(_loc5_ != null)
         {
            TweenLite.to(_loc5_,param4,{
               "x":param2,
               "y":param3
            });
         }
      }
      
      public function createAlienMothership(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:AlienMothership = new AlienMothership(param1,this.screenManager);
         _loc4_.x = param2;
         _loc4_.y = param3;
         this.screenManager.getShipLayer().addChild(_loc4_);
         _loc4_.init();
         this.alienMotherships[param1] = _loc4_;
      }
   }
}

