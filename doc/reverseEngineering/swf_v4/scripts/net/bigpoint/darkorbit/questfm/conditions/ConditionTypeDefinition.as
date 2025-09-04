package net.bigpoint.darkorbit.questfm.conditions
{
   public class ConditionTypeDefinition
   {
      
      private var _ID:int;
      
      private var _TRANS_BASE_KEY:String;
      
      private var _CLASS:Class;
      
      private var _VALIDATABLE:Boolean;
      
      public function ConditionTypeDefinition(param1:int, param2:String, param3:Class, param4:Boolean)
      {
         super();
         this._ID = param1;
         this._TRANS_BASE_KEY = param2;
         this._CLASS = param3;
         this._VALIDATABLE = param4;
      }
      
      public function get ID() : int
      {
         return this._ID;
      }
      
      public function get TRANS_BASE_KEY() : String
      {
         return this._TRANS_BASE_KEY;
      }
      
      public function get CLASS() : Class
      {
         return this._CLASS;
      }
      
      public function get VALIDATABLE() : Boolean
      {
         return this._VALIDATABLE;
      }
   }
}

