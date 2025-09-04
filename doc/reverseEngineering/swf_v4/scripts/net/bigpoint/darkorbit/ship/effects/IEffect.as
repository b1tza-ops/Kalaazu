package net.bigpoint.darkorbit.ship.effects
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.Main;
   
   public interface IEffect
   {
      
      function getEffect() : Sprite;
      
      function start() : void;
      
      function stop() : void;
      
      function update(param1:Main, param2:Array) : void;
   }
}

