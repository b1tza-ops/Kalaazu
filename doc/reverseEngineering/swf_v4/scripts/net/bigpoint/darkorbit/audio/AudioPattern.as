package net.bigpoint.darkorbit.audio
{
   import net.bigpoint.darkorbit.pattern.ResourcePattern;
   
   public class AudioPattern extends ResourcePattern
   {
      
      private var loop:Boolean;
      
      private var volume:Number = 1;
      
      private var _soundbank:String;
      
      public function AudioPattern(param1:int, param2:String, param3:String = null)
      {
         super(param1,param2);
         this._soundbank = param3;
      }
      
      public function isLoop() : Boolean
      {
         return this.loop;
      }
      
      public function setLoop(param1:Boolean) : void
      {
         this.loop = param1;
      }
      
      public function getVolume() : Number
      {
         return this.volume;
      }
      
      public function setVolume(param1:Number) : void
      {
         this.volume = param1;
      }
      
      public function get soundbank() : String
      {
         return this._soundbank;
      }
   }
}

