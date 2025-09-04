package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.BPLocale;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.questfm.ICondition;
   
   public class Condition implements ICondition
   {
      
      private static const logger:ILogger = Log.getLogger("Condition");
      
      protected var _id:uint;
      
      protected var _conditions:Array;
      
      protected var _runstate:Boolean;
      
      protected var _mandatory:Boolean;
      
      protected var _current:int;
      
      protected var _target:int;
      
      protected var _target_plain:String = "";
      
      protected var _mandatory_count:uint;
      
      protected var _definition:ConditionTypeDefinition;
      
      protected var _visibility:int;
      
      protected var _description:String;
      
      protected var _children:Array = [];
      
      protected var _isSubCondition:Boolean;
      
      protected var _showLong:Boolean = true;
      
      protected var _helpIconsClipIds:Array;
      
      public function Condition()
      {
         super();
      }
      
      public function init(param1:int, param2:int, param3:int, param4:Boolean, param5:Boolean, param6:int, param7:String) : void
      {
         this._id = param1;
         this._current = param2;
         this._target = param3;
         this._runstate = param4;
         this._mandatory = param5;
         this._visibility = param6;
         this.parseMatches(param7);
      }
      
      public function markAsSubCondition() : void
      {
         this._isSubCondition = true;
      }
      
      protected function parseMatches(param1:String) : void
      {
         this._description = BPLocale.getText("q2_condition_" + this._definition.TRANS_BASE_KEY);
      }
      
      public function toString() : String
      {
         return this._definition.TRANS_BASE_KEY;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function set id(param1:uint) : void
      {
         this._id = param1;
      }
      
      public function get conditions() : Array
      {
         return this._conditions;
      }
      
      public function get runstate() : Boolean
      {
         return this._runstate;
      }
      
      public function set runstate(param1:Boolean) : void
      {
         if(this._runstate != param1)
         {
            this._runstate = param1;
         }
      }
      
      public function get mandatory() : Boolean
      {
         return this._mandatory;
      }
      
      public function set mandatory(param1:Boolean) : void
      {
         this._mandatory = param1;
      }
      
      public function set mandatory_count(param1:uint) : void
      {
         this._mandatory_count = param1;
      }
      
      public function addConditionAt(param1:ICondition, param2:uint) : void
      {
         if(this._conditions == null)
         {
            this._conditions = [];
         }
         this._conditions[param2] = param1;
         this.addQuestChildElement(param1);
      }
      
      public function addCondition(param1:ICondition) : void
      {
         if(this._conditions == null)
         {
            this._conditions = [];
         }
         this.addConditionAt(param1,this._conditions.length);
      }
      
      public function set definition(param1:ConditionTypeDefinition) : void
      {
         this._definition = param1;
      }
      
      public function get definition() : ConditionTypeDefinition
      {
         return this._definition;
      }
      
      public function get description() : String
      {
         return this._description;
      }
      
      public function get targetVerbose() : String
      {
         return this._target_plain;
      }
      
      public function get currentVerbose() : String
      {
         return "";
      }
      
      public function updateCondtition(param1:int, param2:int, param3:int, param4:Boolean) : Boolean
      {
         var _loc5_:* = undefined;
         if(param1 == this._id)
         {
            this._current = param2;
            return true;
         }
         if(this._children.length > 0)
         {
            for(_loc5_ in this._children)
            {
               if(ICondition(_loc5_).updateCondtition(param1,param2,param3,param4))
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function toTextTree() : String
      {
         var _loc1_:* = this._description + "\n";
         var _loc2_:int = 0;
         while(_loc2_ < this._children.length)
         {
            if(this._children[_loc2_] != null)
            {
               _loc1_ += ICondition(this._children[_loc2_]).toTextTree();
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      protected function addQuestChildElement(param1:ICondition) : void
      {
         this._children.push(param1);
      }
      
      public function get children() : Array
      {
         return this._children;
      }
      
      public function isSubcondition() : Boolean
      {
         return this._isSubCondition;
      }
      
      public function get visibility() : int
      {
         return this._visibility;
      }
      
      public function set visibility(param1:int) : void
      {
         if(this._visibility != param1)
         {
            this._visibility = param1;
         }
      }
      
      public function get current() : int
      {
         return this._current;
      }
      
      public function set current(param1:int) : void
      {
         this._current = param1;
      }
      
      public function set showLong(param1:Boolean) : void
      {
         this._showLong = param1;
      }
      
      public function get showLong() : Boolean
      {
         return this._showLong;
      }
      
      public function get helpIconsClipIds() : Array
      {
         return this._helpIconsClipIds;
      }
      
      public function set helpIconsClipIds(param1:Array) : void
      {
         this._helpIconsClipIds = param1;
      }
   }
}

