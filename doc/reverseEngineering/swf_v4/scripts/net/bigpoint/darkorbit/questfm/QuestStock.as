package net.bigpoint.darkorbit.questfm
{
   public class QuestStock
   {
      
      private var _quests:Array;
      
      private var _questIDs:Array;
      
      private var _stock:int;
      
      public function QuestStock()
      {
         super();
         this._quests = [];
         this._questIDs = [];
         this._stock = 0;
      }
      
      public function getQuestByID(param1:int) : Quest
      {
         if(this._quests[param1] != undefined)
         {
            return this._quests[param1];
         }
         return null;
      }
      
      public function addQuest(param1:Quest, param2:int) : void
      {
         if(this._quests[param2] == undefined)
         {
            this._quests[param2] = param1;
            this._questIDs.push(param2);
            ++this._stock;
         }
      }
      
      public function deleteQuestByID(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this._quests[param1] is Quest)
         {
            delete this._quests[param1];
            _loc2_ = int(this._questIDs.indexOf(param1));
            this._questIDs.splice(_loc2_,1);
            --this._stock;
         }
      }
      
      public function getNextQuestID() : int
      {
         var _loc1_:int = 0;
         for each(_loc1_ in this._questIDs)
         {
            if(this._quests[_loc1_] != undefined)
            {
               return _loc1_;
            }
         }
         return -1;
      }
      
      public function get stock() : int
      {
         return this._stock;
      }
   }
}

