package net.bigpoint.darkorbit.mine
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class Mine
   {
      
      public var clip:DisplayObject;
      
      public var typeID:int;
      
      public var hash:String;
      
      public var posX:int;
      
      public var posY:int;
      
      public var pulseColorId:int;
      
      public var shockwaveColorID:int;
      
      public var pulseClip:MovieClip;
      
      public var yMov:int;
      
      public var moveSpeed:Number = 1;
      
      public function Mine(param1:int, param2:String, param3:int, param4:int, param5:int = 0, param6:int = 0)
      {
         super();
         this.typeID = param1;
         this.hash = param2;
         this.posX = param3;
         this.posY = param4;
         this.pulseColorId = param5;
         this.shockwaveColorID = param6;
      }
   }
}

