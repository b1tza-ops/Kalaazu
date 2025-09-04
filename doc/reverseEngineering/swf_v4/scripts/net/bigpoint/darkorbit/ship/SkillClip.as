package net.bigpoint.darkorbit.ship
{
   public class SkillClip extends TweenClip
   {
      
      public function SkillClip()
      {
         super();
      }
      
      public function playSkillAnimation() : void
      {
         this.playAnimation();
      }
      
      public function setPosition(param1:int, param2:int) : void
      {
         this.clip.x = param1;
         this.clip.y = param2;
      }
      
      public function setScale(param1:Number) : void
      {
         this.clip.scaleX = param1;
         this.clip.scaleY = param1;
      }
   }
}

