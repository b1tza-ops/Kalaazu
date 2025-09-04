package net.bigpoint.darkorbit.gui
{
   public class BarStatus
   {
      
      private var id:int;
      
      public var status:int;
      
      public function BarStatus(param1:int, param2:int)
      {
         super();
         this.id = param1;
         this.status = param2;
      }
      
      public function getID() : int
      {
         return this.id;
      }
   }
}

