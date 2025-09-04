package net.bigpoint.darkorbit.questfm
{
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class Case implements ICase
   {
      
      private static const logger:ILogger = Log.getLogger("Case");
      
      public var id:uint;
      
      private var _conditions:Array = [];
      
      private var _cases:Array;
      
      private var _active:Boolean;
      
      private var _mandatory:Boolean;
      
      private var _ordered:Boolean;
      
      private var _mandatory_count:uint = 0;
      
      private var _treeText:String;
      
      private var _children:Array = [];
      
      private var _mandatory_child_count:int;
      
      private var _visibility:int;
      
      private var _showLong:Boolean = true;
      
      public function Case()
      {
         super();
      }
      
      public function updateCondtition(param1:int, param2:int, param3:int, param4:Boolean) : Boolean
      {
         var _loc6_:* = undefined;
         var _loc5_:int = 0;
         while(_loc5_ < this.children.length)
         {
            _loc6_ = this.children[_loc5_];
            if(_loc6_ != null)
            {
               if(_loc6_ is Case)
               {
                  if(Case(_loc6_).updateCondtition(param1,param2,param3,param4))
                  {
                     return true;
                  }
               }
               else if(ICondition(_loc6_).updateCondtition(param1,param2,param3,param4))
               {
                  return true;
               }
            }
            _loc5_++;
         }
         return false;
      }
      
      public function toTextTree() : String
      {
         this._treeText = "Case " + this.id + "\n";
         var _loc1_:int = 0;
         while(_loc1_ < this._children.length)
         {
            if(this._children[_loc1_] != null)
            {
               this._treeText += this._children[_loc1_].toTextTree();
            }
            _loc1_++;
         }
         return this._treeText;
      }
      
      public function get conditions() : Array
      {
         return this._conditions;
      }
      
      public function get cases() : Array
      {
         return this._cases;
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(param1:Boolean) : void
      {
         this._active = param1;
      }
      
      public function get mandatory() : Boolean
      {
         return this._mandatory;
      }
      
      public function set mandatory(param1:Boolean) : void
      {
         this._mandatory = param1;
      }
      
      public function get ordered() : Boolean
      {
         return this._ordered;
      }
      
      public function set ordered(param1:Boolean) : void
      {
         this._ordered = param1;
      }
      
      public function get mandatory_count() : uint
      {
         return this._mandatory_count;
      }
      
      public function set mandatory_count(param1:uint) : void
      {
         this._mandatory_count = param1;
      }
      
      public function addCaseAt(param1:Case, param2:uint) : void
      {
         if(this._cases == null)
         {
            this._cases = [];
         }
         this._cases[param2] = param1;
         ++this._mandatory_child_count;
         this.addQuestChildElement(param1);
      }
      
      public function addCase(param1:Case) : void
      {
         if(this._cases == null)
         {
            this._cases = [];
         }
         this.addCaseAt(param1,this._cases.length);
      }
      
      public function addConditionAt(param1:ICondition, param2:uint) : void
      {
         if(this._conditions == null)
         {
            this._conditions = [];
         }
         if(param1.definition.VALIDATABLE)
         {
            ++this._mandatory_child_count;
         }
         this._conditions[param2] = param1;
         this.addQuestChildElement(param1);
      }
      
      private function addQuestChildElement(param1:*) : void
      {
         this._children.push(param1);
      }
      
      public function addCondition(param1:ICondition) : void
      {
         if(this._conditions == null)
         {
            this._conditions = [];
         }
         this.addConditionAt(param1,this._conditions.length);
      }
      
      public function get children() : Array
      {
         return this._children;
      }
      
      public function get mandatory_child_count() : int
      {
         return this._mandatory_child_count;
      }
      
      public function get visibility() : int
      {
         return this._visibility;
      }
      
      public function set visibility(param1:int) : void
      {
         this._visibility = param1;
      }
      
      public function set showLong(param1:Boolean) : void
      {
         this._showLong = param1;
      }
      
      public function get showLong() : Boolean
      {
         return this._showLong;
      }
   }
}

