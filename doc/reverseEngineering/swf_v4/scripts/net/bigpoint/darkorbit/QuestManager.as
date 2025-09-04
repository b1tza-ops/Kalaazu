package net.bigpoint.darkorbit
{
   import com.bigpoint.utils.BPLocale;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.external.ExternalInterface;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.windows.SimpleWindow;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.questfm.ICondition;
   import net.bigpoint.darkorbit.questfm.Quest;
   import net.bigpoint.darkorbit.questfm.QuestParser;
   import net.bigpoint.darkorbit.questfm.QuestStock;
   import net.bigpoint.darkorbit.questfm.QuestTree;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class QuestManager
   {
      
      public static const QUESTFM_INI_FMT_XML:String = "XML";
      
      public static const QUESTFM_INI_FMT_HOMEBREW:String = "DOHB";
      
      private static const logger:ILogger = Log.getLogger("QuestManager");
      
      private var questStock:QuestStock;
      
      private var _privilegedQuest:Quest;
      
      private var main:Main;
      
      private var parser:QuestParser;
      
      public var iniFormat:String = "DOHB";
      
      public function QuestManager(param1:Main)
      {
         super();
         this.main = param1;
         this.questStock = new QuestStock();
         this.parser = new QuestParser();
      }
      
      public function setQuestAccomplished(param1:int, param2:int) : void
      {
         var _loc3_:Quest = this.questStock.getQuestByID(param1);
         if(_loc3_ != null)
         {
            this.main.getGuiManager().writeToLog(BPLocale.getText("q2_accomplished_quest").replace(/%quest_name%/,_loc3_.title));
            if(ExternalInterface.available)
            {
               ExternalInterface.call("clientEvent","questCompleteFinished");
            }
            this.removeQuest(param1);
         }
      }
      
      public function setQuestFailed(param1:int) : void
      {
         var _loc2_:Quest = this.questStock.getQuestByID(param1);
         if(_loc2_ != null)
         {
            this.main.getGuiManager().writeToLog(BPLocale.getText("q2_failed_quest").replace(/%quest_name%/,_loc2_.title));
            this.removeQuest(param1);
         }
      }
      
      public function setQuestCancelled(param1:int) : void
      {
         var _loc2_:Quest = this.questStock.getQuestByID(param1);
         if(_loc2_ != null)
         {
            this.main.getGuiManager().writeToLog(BPLocale.getText("q2_cancelled_quest").replace(/%quest_name%/,_loc2_.title));
            this.removeQuest(param1);
         }
      }
      
      private function removeQuest(param1:int) : void
      {
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc2_:Quest = this.questStock.getQuestByID(param1);
         if(_loc2_ != null)
         {
            if(this._privilegedQuest.id == param1)
            {
               _loc5_ = true;
            }
            this.questStock.deleteQuestByID(param1);
            if(_loc5_)
            {
               this.main.getGuiManager().clearQuestWindow();
               _loc6_ = this.questStock.getNextQuestID();
               if(_loc6_ >= 0)
               {
                  this.main.getConnectionManager().sendCommand(ServerCommands.QUESTFM_INFO,[ServerCommands.QUESTFM_PRIVILEGE_QUEST,_loc6_]);
               }
            }
            this.main.getGuiManager().removeQuestDot(param1);
         }
         var _loc3_:int = this.questStock.stock;
         var _loc4_:SimpleWindow = this.main.getGuiManager().getWindow(SimpleWindow.WINDOW_CLASS_QUEST_SYSTEM);
         if(_loc3_ == 0)
         {
            if(_loc4_ != null)
            {
               QuestTree(_loc4_.getContainer(SimpleContainer.CLASS_QUEST_TREE)).isDefaultVisible = true;
            }
         }
         else if(_loc4_ != null)
         {
            QuestTree(_loc4_.getContainer(SimpleContainer.CLASS_QUEST_TREE)).isDefaultVisible = false;
         }
      }
      
      public function initQuest(param1:String, param2:String) : void
      {
         var _loc3_:Quest = this.parser.parse(new XML(param1));
         _loc3_.category = param2;
         this.requestTitle(_loc3_.id);
         this.setQuest(_loc3_,_loc3_.id);
         if(this._privilegedQuest == null)
         {
            this.privilegeQuestByID(_loc3_.id);
         }
         this.main.getGuiManager().addQuestDot(_loc3_.id);
      }
      
      public function setQuest(param1:Quest, param2:int) : void
      {
         this.questStock.addQuest(param1,param2);
      }
      
      public function getQuest(param1:int) : Quest
      {
         return this.questStock.getQuestByID(param1);
      }
      
      public function get privilegedQuest() : Quest
      {
         return this._privilegedQuest;
      }
      
      public function privilegeQuestByID(param1:int) : void
      {
         var _loc2_:Quest = this.questStock.getQuestByID(param1);
         if(_loc2_ != null && this._privilegedQuest != _loc2_)
         {
            this._privilegedQuest = _loc2_;
            this.main.getGuiManager().updateQuestWindow();
            this.main.getGuiManager().updateQuestDotList();
         }
      }
      
      public function updateQuest(param1:int, param2:int, param3:int, param4:int, param5:Boolean) : void
      {
         var _loc6_:Quest = this.questStock.getQuestByID(param1);
         _loc6_.updateCondition(param2,param3,param4,param5);
      }
      
      public function updateCondition(param1:int, param2:int, param3:int, param4:int, param5:Boolean) : void
      {
         var _loc8_:int = 0;
         var _loc9_:ICondition = null;
         var _loc6_:Quest = this.questStock.getQuestByID(param1);
         if(_loc6_ == null)
         {
            this.main.getConnectionManager().sendCommand(ServerCommands.QUESTFM_INFO,["g"]);
            return;
         }
         if(_loc6_.flatConditions[param2] == null)
         {
            return;
         }
         var _loc7_:ICondition = ICondition(_loc6_.flatConditions[param2]);
         _loc7_.current = param3;
         _loc7_.runstate = param5;
         _loc7_.visibility = param4;
         if(_loc7_.children.length > 0)
         {
            _loc8_ = 0;
            while(_loc8_ < _loc7_.children.length)
            {
               _loc9_ = _loc7_.children[_loc8_] as ICondition;
               _loc9_.runstate = param5;
               _loc9_.visibility = param4;
               _loc8_++;
            }
         }
         if(param1 == this._privilegedQuest.id)
         {
            this.main.getGuiManager().updateQuestConditionInWindow(param2);
         }
      }
      
      private function requestTitle(param1:int) : void
      {
         var _loc2_:String = Settings.dynamicHost + "flashinput/quest.php?action=questTitle&questCaseID=" + param1 + "&lang=" + Settings.language;
         var _loc3_:URLRequest = new URLRequest(_loc2_);
         var _loc4_:URLLoader = new URLLoader(_loc3_);
         _loc4_.addEventListener(Event.COMPLETE,this.handleTitleLoaded);
         _loc4_.addEventListener(IOErrorEvent.IO_ERROR,this.handleTitleLoadingError);
         _loc4_.load(_loc3_);
      }
      
      private function handleTitleLoadingError(param1:IOErrorEvent) : void
      {
      }
      
      private function handleTitleLoaded(param1:Event) : void
      {
         var questID:int;
         var affectedQuest:Quest;
         var titleResponse:XML = null;
         var event:Event = param1;
         try
         {
            titleResponse = new XML((event.target as URLLoader).data);
         }
         catch(e:Error)
         {
            return;
         }
         questID = parseInt(titleResponse.quest.@questCaseID);
         affectedQuest = this.questStock.getQuestByID(questID);
         if(affectedQuest != null)
         {
            affectedQuest.title = titleResponse.quest[0];
            if(questID == this._privilegedQuest.id)
            {
               this.main.getGuiManager().updateQuestTitle();
            }
         }
      }
   }
}

