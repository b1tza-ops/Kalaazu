package net.bigpoint.darkorbit.questfm
{
   public class Quest
   {
      
      private var _id:uint;
      
      private var _case:Case;
      
      private var _flatConditions:Array = [];
      
      private var _category:String = "std";
      
      private var _title:String = "";
      
      public function Quest(param1:uint, param2:Case)
      {
         super();
         this._id = param1;
         this._case = param2;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function updateCondition(param1:int, param2:int, param3:int, param4:Boolean) : void
      {
         this._case.updateCondtition(param1,param2,param3,param4);
      }
      
      public function toTextTree() : String
      {
         return this._case.toTextTree();
      }
      
      public function getCase() : Case
      {
         return this._case;
      }
      
      public function get category() : String
      {
         return this._category;
      }
      
      public function set category(param1:String) : void
      {
         this._category = param1;
      }
      
      public function get flatConditions() : Array
      {
         return this._flatConditions;
      }
      
      public function set flatConditions(param1:Array) : void
      {
         this._flatConditions = param1;
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function set title(param1:String) : void
      {
         this._title = param1;
      }
   }
}

