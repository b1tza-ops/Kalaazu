package net.bigpoint.darkorbit.questfm
{
   public class QuestParser
   {
      
      private var element_count:int;
      
      private var condition_count:int;
      
      private var case_count:int;
      
      private var conditionFactory:ConditionFactory;
      
      private var flat_conditions:Array;
      
      public function QuestParser()
      {
         super();
         this.conditionFactory = new ConditionFactory();
      }
      
      public function parse(param1:XML) : Quest
      {
         var _loc4_:ICondition = null;
         this.initCounts();
         var _loc2_:Case = this.parseCase(param1);
         if(_loc2_.id == 10000)
         {
            _loc4_ = this.parseCondition(<cond id="10000" k="10000" cur="0" t="0" on="1" do="1" viz="1"/>);
            _loc2_.addCondition(_loc4_);
         }
         var _loc3_:Quest = new Quest(_loc2_.id,_loc2_);
         _loc3_.flatConditions = this.flat_conditions;
         return _loc3_;
      }
      
      private function initCounts() : void
      {
         this.element_count = 0;
         this.case_count = 0;
         this.condition_count = 0;
         this.flat_conditions = [];
      }
      
      private function parseCondition(param1:XML) : ICondition
      {
         var _loc13_:ICondition = null;
         ++this.condition_count;
         ++this.element_count;
         var _loc2_:int = int(param1.@id);
         var _loc3_:int = int(param1.@k);
         var _loc4_:String = param1.@m;
         var _loc5_:int = int(param1.@cur);
         var _loc6_:int = int(param1.@t);
         var _loc7_:Boolean = Boolean(int(param1.@on));
         var _loc8_:Boolean = Boolean(param1["do"]);
         var _loc9_:int = int(param1.@viz);
         var _loc10_:ICondition = this.conditionFactory.createCondition(_loc3_,_loc2_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc4_);
         this.flat_conditions[_loc2_] = _loc10_;
         var _loc11_:XMLList = param1.children();
         var _loc12_:int = 0;
         while(_loc12_ < _loc11_.length())
         {
            _loc13_ = this.parseCondition(XML(_loc11_[_loc12_]));
            _loc13_.runstate = _loc7_;
            _loc13_.visibility = _loc9_;
            _loc10_.addCondition(_loc13_);
            _loc13_.markAsSubCondition();
            _loc12_++;
         }
         return _loc10_;
      }
      
      private function parseCase(param1:XML) : Case
      {
         var _loc5_:XML = null;
         var _loc6_:String = null;
         var _loc7_:Case = null;
         var _loc8_:ICondition = null;
         var _loc2_:Case = new Case();
         ++this.case_count;
         ++this.element_count;
         _loc2_.id = int(param1.@id);
         _loc2_.active = Boolean(param1.@on);
         _loc2_.mandatory = Boolean(int(param1["do"]));
         _loc2_.ordered = Boolean(int(param1.@ord));
         _loc2_.mandatory_count = uint(param1.@td);
         var _loc3_:XMLList = param1.children();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length())
         {
            _loc5_ = XML(_loc3_[_loc4_]);
            _loc6_ = _loc5_.name();
            switch(_loc6_)
            {
               case "case":
                  _loc7_ = Case(this.parseCase(_loc5_));
                  _loc2_.addCase(_loc7_);
                  break;
               case "cond":
                  _loc8_ = this.parseCondition(_loc5_);
                  _loc2_.addCondition(_loc8_);
                  break;
            }
            _loc4_++;
         }
         return _loc2_;
      }
   }
}

